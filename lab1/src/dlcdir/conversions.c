/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  conversions.c,v
 * Revision 1.10  1995/04/21  05:44:15  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.9  1995/03/23  15:31:04  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.8  1995/03/01  16:23:15  rcm
 * Various type-checking bug fixes; added T_REDUNDANT_EXTERNAL_DECL.
 *
 * Revision 1.7  1995/02/01  21:07:16  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.6  1995/01/27  01:38:58  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.5  1995/01/25  02:16:19  rcm
 * Changed how Prim types are created and merged.
 *
 * Revision 1.4  1995/01/20  03:38:06  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.3  1995/01/06  16:48:43  rcm
 * added copyright message
 *
 * Revision 1.2  1994/12/23  09:18:25  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.1  1994/12/20  09:20:23  rcm
 * Created
 *
 * Revision 1.5  1994/11/22  01:54:46  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.4  1994/11/10  03:13:34  rcm
 * Fixed line numbers on AST nodes.
 *
 * Revision 1.3  1994/11/03  07:38:57  rcm
 * Added code to output C from the parse tree.
 *
 * Revision 1.2  1994/10/28  18:52:57  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Sun May 30 14:00:45 EDT 1993
 *
 *
 *
 * Copyright (c) 1994 MIT Laboratory for Computer Science
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE MIT LABORATORY FOR COMPUTER SCIENCE BE LIABLE
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * Except as contained in this notice, the name of the MIT Laboratory for
 * Computer Science shall not be used in advertising or otherwise to
 * promote the sale, use or other dealings in this Software without prior
 * written authorization from the MIT Laboratory for Computer Science.
 * 
 *************************************************************************/
#if 0
#pragma ident "conversions.c,v 1.10 1995/04/21 05:44:15 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"
#include "conversions.h"

#define UCHAR_TO_INT_OVF    0
#define USHORT_TO_INT_OVF   0

PRIVATE Bool IsCoercible(Node *rhs, Node *ltype, 
			Bool ptr2intp, Bool ptr2ptrp);
PRIVATE Bool TypeEqualModuloConstVolatile(Node *ltype, Node *rtype);
PRIVATE Bool IsMemberTypeOfUnion(Node *type, Node *unode);


/***************************************************************************/
/*		          C O N V E R S I O N S                            */
/***************************************************************************/


GLOBAL Node *AssignmentConversions(Node *expr, Node *to_type)
{
  Node *from_type = NodeDataType(expr);
  Node *node;

  assert(to_type);
  if (TypeEqual(from_type, to_type))
    return expr;

  if (!IsCoercible(expr, to_type, FALSE, FALSE))
    return expr;
    
  node = MakeImplicitCastCoord(to_type, expr, expr->coord);

  ConstFoldCast(node);

  return node;
}

GLOBAL Node *CallConversions(Node *expr, Node *to_type)
{
  return AssignmentConversions(expr, to_type);
}

GLOBAL Node *ReturnConversions(Node *expr, Node *to_type)
{
  return AssignmentConversions(expr, to_type);
}

GLOBAL Node *CastConversions(Node *expr, Node *to_type)
{
  if (!IsVoidType(to_type))
    (void)IsCoercible(expr, to_type, TRUE, TRUE);

  return expr;
}

GLOBAL Node *ImplicitConversions(Node *expr, Node *to_type)
{
  /* assume that this conversion is legal (since it was
     chosen by the semantic-checker based on the type of expr --
     see UsualUnaryConversions and UsualBinaryConversions, below) */
  Node *node = MakeImplicitCastCoord(to_type, expr, expr->coord);

  ConstFoldCast(node);

  return node;
}
  


GLOBAL Node *UsualUnaryConversions(Node *node, Bool f_to_d)
{ Node *type;
  
  assert(node);
#if 0
  printf("UsualUnary\n");
  PrintNode(stdout, node, 0);
  printf("\n");
#endif
  
  type = NodeDataType(node);
  
  assert(type);
  
  /* not sure why type->typ == Const is checked here, since
     NodeDataType only returns type nodes (Prim, Ptr, S/U/E/F/Adcl) -- rcm */
  if (type->typ == Prim || type->typ == Const) {
    BasicType btype;
    
    if (type->typ == Prim)
      btype = type->u.prim.basic;
    else
      btype = type->u.Const.type->u.prim.basic;

    switch (btype) {
    case Char:
    case Schar:
    case Sshort:
      return ImplicitConversions(node, PrimSint);
    case Uchar:
      return ImplicitConversions(node, 
				 (UCHAR_TO_INT_OVF) ? PrimUint : PrimSint);
    case Ushort:
      return ImplicitConversions(node, 
				 (USHORT_TO_INT_OVF) ? PrimUint : PrimSint);
    case Float:
      return f_to_d ? ImplicitConversions(node, PrimDouble) : node;
    default:
      return node;
    }
  }
  else if (type->typ == Adcl) {
    Node *ptype = MakePtr(EMPTY_TQ, type->u.adcl.type);

    return MakeImplicitCastCoord(ptype, node, node->coord);
  }
  else if (type->typ == Fdcl) {
    Node *ptype = MakePtr(EMPTY_TQ, type);

    return MakeImplicitCastCoord(ptype, node, node->coord);
  }
  else
    return node;
}


/* UsualUnaryConversionType is used by parser to check that
   old-style function decls contain only "usual unary conversions"
   types -- in particular, float and char won't be allowed as
   parameter types. */
GLOBAL Node *UsualUnaryConversionType(Node *type)
{
  assert(type);

  if (type->typ == Prim || type->typ == Const) {
    BasicType btype;

    if (type->typ == Prim)
      btype = type->u.prim.basic;
    else
      btype = type->u.Const.type->u.prim.basic;

    switch (btype) {
    case Char:
    case Schar:
      return PrimSint;
    case Sshort:
      return PrimSint;
    case Uchar:
      return (UCHAR_TO_INT_OVF) ? PrimUint : PrimSint;
    case Ushort:
      return (USHORT_TO_INT_OVF) ? PrimUint : PrimSint;
    case Float:
      return PrimDouble;
    default:
      return type;
    }
  }
  else
    return type;
}


GLOBAL void UsualBinaryConversions(Node **node1p, Node **node2p)
{ Node *type1, *type2;

  assert(*node1p);
  assert(*node2p);
  type1  = NodeDataType(*node1p),
  type2  = NodeDataType(*node2p);

  if ((type1->typ == Prim || type1->typ == Const) &&
      (type2->typ == Prim || type2->typ == Const)) {
    BasicType btype1, btype2;

    if (type1->typ == Prim)
      btype1 = type1->u.prim.basic;
    else
      btype1 = type1->u.Const.type->u.prim.basic;

    if (type2->typ == Prim)
      btype2 = type2->u.prim.basic;
    else
      btype2 = type2->u.Const.type->u.prim.basic;
    
    switch (btype1) {
    case Sint:
      switch (btype2) {
	case Sint:
	  return;
	case Uint:
	  *node1p = ImplicitConversions(*node1p, PrimUint);
	  return;
	case Slong:
	  *node1p = ImplicitConversions(*node1p, PrimSlong);
	  return;
	case Ulong:
	  *node1p = ImplicitConversions(*node1p, PrimUlong);
	  return;
	case Slonglong:
	  *node1p = ImplicitConversions(*node1p, PrimSlonglong);
	  return;
	case Ulonglong:
	  *node1p = ImplicitConversions(*node1p, PrimUlonglong);
	  return;
	case Float:
	  *node1p = ImplicitConversions(*node1p, PrimFloat);
	  return;
	case Double:
	  *node1p = ImplicitConversions(*node1p, PrimDouble);
	  return;
	case Longdouble:
	  *node1p = ImplicitConversions(*node1p, PrimLongdouble);
	  return;
	default:
	    /*assert(("Unrecognized to type", FALSE));*/
	  assert(FALSE);
	  return;
      }
    case Uint:
      switch (btype2) {
	case Sint:
	  *node2p = ImplicitConversions(*node2p, PrimUint);
	  return;
	case Uint:
	  return;
	case Slong:
	  *node1p = ImplicitConversions(*node1p, PrimSlong);
	  return;
	case Ulong:
	  *node1p = ImplicitConversions(*node1p, PrimUlong);
	  return;
	case Slonglong:
	  *node1p = ImplicitConversions(*node1p, PrimSlonglong);
	  return;
	case Ulonglong:
	  *node1p = ImplicitConversions(*node1p, PrimUlonglong);
	  return;
	case Float:
	  *node1p = ImplicitConversions(*node1p, PrimFloat);
	  return;
	case Double:
	  *node1p = ImplicitConversions(*node1p, PrimDouble);
	  return;
	case Longdouble:
	  *node1p = ImplicitConversions(*node1p, PrimLongdouble);
	  return;
	default:
	    /*assert(("Unrecognized to type", FALSE));*/
	  assert(FALSE);
	  return;
      }
    case Slong:
      switch (btype2) {
	case Sint:
	  *node2p = ImplicitConversions(*node2p, PrimSlong);
	  return;
	case Uint:
	  *node2p = ImplicitConversions(*node2p, PrimSlong);
	  return;
	case Slong:
	  return;
	case Ulong:
	  *node1p = ImplicitConversions(*node1p, PrimUlong);
	  return;
	case Slonglong:
	  *node1p = ImplicitConversions(*node1p, PrimSlonglong);
	  return;
	case Ulonglong:
	  *node1p = ImplicitConversions(*node1p, PrimUlonglong);
	  return;
	case Float:
	  *node1p = ImplicitConversions(*node1p, PrimFloat);
	  return;
	case Double:
	  *node1p = ImplicitConversions(*node1p, PrimDouble);
	  return;
	case Longdouble:
	  *node1p = ImplicitConversions(*node1p, PrimLongdouble);
	  return;
	default:
	    /*assert(("Unrecognized to type", FALSE));*/
	  assert(FALSE);
	  return;
      }
    case Ulong:
      switch (btype2) {
	case Sint:
	  *node2p = ImplicitConversions(*node2p, PrimUlong);
	  return;
	case Uint:
	  *node2p = ImplicitConversions(*node2p, PrimUlong);
	  return;
	case Slong:
	  *node2p = ImplicitConversions(*node2p, PrimUlong);
	  return;
	case Ulong:
	  return;
	case Slonglong:
	  *node1p = ImplicitConversions(*node1p, PrimSlonglong);
	  return;
	case Ulonglong:
	  *node1p = ImplicitConversions(*node1p, PrimUlonglong);
	  return;
	case Float:
	  *node1p = ImplicitConversions(*node1p, PrimFloat);
	  return;
	case Double:
	  *node1p = ImplicitConversions(*node1p, PrimDouble);
	  return;
	case Longdouble:
	  *node1p = ImplicitConversions(*node1p, PrimLongdouble);
	  return;
	default:
	    /*assert(("Unrecognized to type", FALSE));*/
	  assert(FALSE);
	  return;
      }
    case Slonglong:
      switch (btype2) {
	case Sint:
	  *node2p = ImplicitConversions(*node2p, PrimSlonglong);
	  return;
	case Uint:
	  *node2p = ImplicitConversions(*node2p, PrimSlonglong);
	  return;
	case Slong:
	  *node2p = ImplicitConversions(*node2p, PrimSlonglong);
	  return;
	case Ulong:
	  *node2p = ImplicitConversions(*node2p, PrimSlonglong);
	  return;
	case Slonglong:
	  return;
	case Ulonglong:
	  *node1p = ImplicitConversions(*node1p, PrimUlonglong);
	  return;
	case Float:
	  *node1p = ImplicitConversions(*node1p, PrimFloat);
	  return;
	case Double:
	  *node1p = ImplicitConversions(*node1p, PrimDouble);
	  return;
	case Longdouble:
	  *node1p = ImplicitConversions(*node1p, PrimLongdouble);
	  return;
	default:
	    /*assert(("Unrecognized to type", FALSE));*/
	  assert(FALSE);
	  return;
      }
    case Ulonglong:
      switch (btype2) {
	case Sint:
	  *node2p = ImplicitConversions(*node2p, PrimUlonglong);
	  return;
	case Uint:
	  *node2p = ImplicitConversions(*node2p, PrimUlonglong);
	  return;
	case Slong:
	  *node2p = ImplicitConversions(*node2p, PrimUlonglong);
	  return;
	case Ulong:
	  *node2p = ImplicitConversions(*node1p, PrimUlonglong);
	  return;
	case Slonglong:
	  *node2p = ImplicitConversions(*node1p, PrimUlonglong);
	  return;
	case Ulonglong:
	  return;
	case Float:
	  *node1p = ImplicitConversions(*node1p, PrimFloat);
	  return;
	case Double:
	  *node1p = ImplicitConversions(*node1p, PrimDouble);
	  return;
	case Longdouble:
	  *node1p = ImplicitConversions(*node1p, PrimLongdouble);
	  return;
	default:
	    /*assert(("Unrecognized to type", FALSE));*/
	  assert(FALSE);
	  return;
      }
    case Float:
      switch (btype2) {
	case Sint:
	  *node2p = ImplicitConversions(*node2p, PrimFloat);
	  return;
	case Uint:
	  *node2p = ImplicitConversions(*node2p, PrimFloat);
	  return;
	case Slong:
	  *node2p = ImplicitConversions(*node2p, PrimFloat);
	  return;
	case Ulong:
	  *node2p = ImplicitConversions(*node2p, PrimFloat);
	  return;
	case Slonglong:
	  *node2p = ImplicitConversions(*node1p, PrimFloat);
	  return;
	case Ulonglong:
	  *node2p = ImplicitConversions(*node1p, PrimFloat);
	  return;
	case Float:
	  return;
	case Double:
	  *node1p = ImplicitConversions(*node1p, PrimDouble);
	  return;
	case Longdouble:
	  *node1p = ImplicitConversions(*node1p, PrimLongdouble);
	  return;
	default:
	    /*assert(("Unrecognized to type", FALSE));*/
	  assert(FALSE);
	  return;
      }
    case Double:
      switch (btype2) {
	case Sint:
	  *node2p = ImplicitConversions(*node2p, PrimDouble);
	  return;
	case Uint:
	  *node2p = ImplicitConversions(*node2p, PrimDouble);
	  return;
	case Slong:
	  *node2p = ImplicitConversions(*node2p, PrimDouble);
	  return;
	case Ulong:
	  *node2p = ImplicitConversions(*node2p, PrimDouble);
	  return;
	case Slonglong:
	  *node2p = ImplicitConversions(*node1p, PrimDouble);
	  return;
	case Ulonglong:
	  *node2p = ImplicitConversions(*node1p, PrimDouble);
	  return;
	case Float:
	  *node2p = ImplicitConversions(*node2p, PrimDouble);
	  return;
	case Double:
	  return;
	case Longdouble:
	  *node1p = ImplicitConversions(*node1p, PrimLongdouble);
	  return;
	default:
	  printf("Unrecognized to type\n");
	  PrintNode(stdout, *node2p, 0); printf("\n");
	  PrintNode(stdout, type2,   0); printf("\n");
	  assert(FALSE);
      }
    case Longdouble:
      switch (btype2) {
	case Sint:
	  *node2p = ImplicitConversions(*node2p, PrimLongdouble);
	  return;
	case Uint:
	  *node2p = ImplicitConversions(*node2p, PrimLongdouble);
	  return;
	case Slong:
	  *node2p = ImplicitConversions(*node2p, PrimLongdouble);
	  return;
	case Ulong:
	  *node2p = ImplicitConversions(*node2p, PrimLongdouble);
	  return;
	case Slonglong:
	  *node2p = ImplicitConversions(*node1p, PrimLongdouble);
	  return;
	case Ulonglong:
	  *node2p = ImplicitConversions(*node1p, PrimLongdouble);
	  return;
	case Float:
	  *node2p = ImplicitConversions(*node2p, PrimLongdouble);
	  return;
	case Double:
	  *node2p = ImplicitConversions(*node1p, PrimLongdouble);
	  return;
	case Longdouble:
	  return;
	default:
	  printf("Unrecognized to type\n");
	  PrintNode(stdout, *node2p, 0); printf("\n");
	  PrintNode(stdout, type2,   0); printf("\n");
	  assert(FALSE);
      }
    default:
      printf("Unrecognized from type\n");
      PrintNode(stdout, *node1p, 0); printf("\n");
      PrintNode(stdout, type1,   0); printf("\n");
      assert(FALSE);
    }
  }
#if 0
  /* Ptr + integral offset */
  else if (type1->typ == Ptr && (type2->typ == Prim || type2->typ == Const)) {
    BasicType btype2;

    if (type2->typ == Prim)
      btype2 = type2->u.prim.basic;
    else
      btype2 = type2->u.Const.value->typ;
    
    switch (btype2) {
    case Sint:
      *node2p = ImplicitConversions(*node2p, PrimSlong);
      return;
    case Uint:
      *node2p = ImplicitConversions(*node2p, PrimUlong);
      return;
    case Slong:
      return;
    case Ulong:
      return;
    default:
	/*assert(("Unrecognized offset type", FALSE));*/
      assert(FALSE);
      return;
    }
  }

  /* integral offset + Ptr */
  else if ((type1->typ == Prim || type1->typ == Const) && type2->typ == Ptr) {
    BasicType btype1;

    if (type1->typ == Prim)
      btype1 = type1->u.prim.basic;
    else
      btype1 = type1->u.Const.value->typ;
    
    switch (btype1) {
    case Sint:
      *node1p = ImplicitConversions(*node1p, PrimSlong);
      return;
    case Uint:
      *node1p = ImplicitConversions(*node1p, PrimUlong);
      return;
    case Slong:
      return;
    case Ulong:
      return;
    default:
	/*assert(("Unrecognized offset type", FALSE));*/
      assert(FALSE);
      return;
    }
  }
#endif

  else 
    return;
}

/* Conditional Expression conversions.    6.3.15 */
GLOBAL Node *ConditionalConversions(Node **truep, Node **falsep)
{ Node *type1, *type2;

  assert(*truep);
  assert(*falsep);

  type1 = NodeDataType(*truep),
  type2 = NodeDataType(*falsep);

#if 0
  printf("ConditionalConv\n");
  PrintNode(stdout, *truep,  0); printf("\n");
  PrintNode(stdout, *falsep, 0); printf("\n");
  PrintNode(stdout, type1,   0); printf("\n");
  PrintNode(stdout, type2,   0); printf("\n");
#endif

  /* One of the following shall hold for second and third operands */

  /* both operands have arithmetic types */
  assert(type1);
  assert(type2);
  if (IsArithmeticType(type1) && IsArithmeticType(type2))
    UsualBinaryConversions(truep, falsep);

  /* both operands have compatible structure or union types */
  else if (((IsUnionType(type1)  && IsUnionType(type2)) ||
	    (IsStructType(type1) && IsStructType(type2)))
	   && TypeEqualQualified(type1, type2, FALSE, FALSE))
      ;

  /* both operands have void type */
  else if (IsVoidType(type1) && IsVoidType(type2))
    ;

  /* 
     both operands are compatible pointers (or constant zero)
  */
  else if (IsPointerType(type1) || IsPointerType(type2))
    UsualPointerConversions(truep, falsep, TRUE);

  else
    SyntaxErrorCoord((*truep)->coord,
		     "cons and alt clauses must have compatible types");

  return NodeDataType(*truep);
}


GLOBAL void UsualPointerConversions(Node **node1p, Node **node2p, 
				    Bool allow_void_or_zero)
{ Node *type1, *type2;
  Node *basetype1, *basetype2;

  assert(*node1p);
  assert(*node2p);
  type1  = NodeDataType(*node1p),
  type2  = NodeDataType(*node2p);

  if (IsPointerType(type1) && IsPointerType(type2)) {
    basetype1 = NodeDataType(PtrSubtype(type1)),
    basetype2 = NodeDataType(PtrSubtype(type2));

    if (TypeEqual(basetype1, basetype2))
      ;
    else if (TypeEqualQualified(basetype1, basetype2, FALSE, FALSE)) {
      /* K&R A7.16: "any type qualifiers in the type to which the
	 pointer points are insignificant, but the result type inherits
	 qualifiers from both arms of the conditional."
	 K&R A7.2: "pointers to objects of the same type (ignoring 
	 qualifiers) may be compared; ..." */
      goto Merge;
    }
    else if (!ANSIOnly && 
	     TypeEqualQualified(basetype1 = SansSign(basetype1),
		       basetype2 = SansSign(basetype2), FALSE, FALSE)) {
      /* common non-ANSI extension: allow comparing (e.g.) "int *" and
	 "unsigned *", with warning. */
      WarningCoord(4, (*node1p)->coord, "pointer base types have different sign");
      goto Merge;
    }
    else if (allow_void_or_zero && IsVoidType(basetype1))
      goto Convert2;
    else if (allow_void_or_zero && IsVoidType(basetype2))
      goto Convert1;
    else 
      SyntaxErrorCoord((*node1p)->coord,
		       "operands have incompatible pointer types");

  }
  else if (allow_void_or_zero && 
	   IsPointerType(type1) && IsConstantZero(*node2p))
    goto Convert2;
  else if (allow_void_or_zero && 
	   IsPointerType(type2) && IsConstantZero(*node1p))
    goto Convert1;
  else
    SyntaxErrorCoord((*node1p)->coord,
		     "operands have incompatible types");
  return;

 Merge:
  {
    Node *newtype = MakePtr(EMPTY_TQ, MakeMergedType(basetype1, basetype2));
    *node1p = ImplicitConversions(*node1p, newtype);
    *node2p = ImplicitConversions(*node2p, newtype);
  }
  return;

 Convert1:
  *node1p = ImplicitConversions(*node1p, type2);
  return;

 Convert2:
  *node2p = ImplicitConversions(*node2p, type1);
  return;
}



/***************************************************************************/
/*		          I S    C O E R C I B L E                         */
/***************************************************************************/

/*
  IsCoercible() tests whether assigning rhs to an object of ltype
  is legal. 

  Pointer/pointer and int/pointer coercions (except for constant 0) 
  are disallowed unless the caller explicitly specifies that they are
  allowable:

      ptr2intp == true  implies that pointers can be coerced to integral types
                                and back.
      ptr2ptrp == true  implies that pointers can be coerced regardless of
                                their base type.

  ltype is restricted to types which make sense in a cast.  In particular,
  ltype may not be an array or function type (though it may be a pointer
  to an array or function).
*/
PRIVATE Bool IsCoercible(Node *rhs, Node *ltype, 
			Bool ptr2intp, Bool ptr2ptrp)
{
  Node *rtype = NodeDataType(rhs);


  /* First we massage rtype and ltype slightly to make them comparable */

  switch (rtype->typ) {
  case Tdef:
    /* Get rid of top-level typedef indirections */
    rtype = NodeDataType(rtype);
    break;

  case Edcl:
     /* Treat enums as signed int */
    ltype = PrimSint;
    break;

  case Adcl:
    /* Convert array of X to pointer to X */
    rtype = MakePtr(EMPTY_TQ, rtype->u.adcl.type);
    break;

  case Fdcl:
     /* Convert function objects to pointer to function */
    rtype = MakePtr(EMPTY_TQ, rtype);
    break;
   
  default:
    break;
  }


  switch (ltype->typ) {
  case Tdef:
    /* Get rid of top-level typedef indirections */
    ltype = NodeDataType(ltype);
    break;

  case Edcl:
     /* Treat enums as signed int */
    ltype = PrimSint;
    break;

  default:
    break;
  }


  /* Now check for legality of coercion */

  if (IsArithmeticType(rtype) && IsArithmeticType(ltype))
    return TRUE;

  else if (IsPointerType(rtype) && IsPointerType(ltype)) {
    if (ptr2ptrp)
      return TRUE;
    else {
      Node *lbasetype = NodeDataType(PtrSubtype(ltype)),
           *rbasetype = NodeDataType(PtrSubtype(rtype));

      if (IsVoidType(lbasetype) || IsVoidType(rbasetype))
	return TRUE;
      else if (TypeEqual(lbasetype, rbasetype))
	return TRUE;
      else if (TypeEqualModuloConstVolatile(lbasetype, rbasetype))
	return TRUE;
      else if (!ANSIOnly && 
	       TypeEqualModuloConstVolatile(SansSign(lbasetype),
					    SansSign(rbasetype))) {
	WarningCoord(4, rhs->coord, "pointer base types have different sign");
	return TRUE;
      }
      else {
	SyntaxErrorCoord(rhs->coord,
			 "cannot assign pointers with different base types");
	return FALSE;
      }
    }
  }
  else if (IsIntegralType(rtype) && IsPointerType(ltype))
    if (ptr2intp || IsConstantZero(rhs))
      return TRUE;
    else {
      SyntaxErrorCoord(rhs->coord,
		       "cannot assign integer value to pointer");
      return FALSE;
    }

  else if (IsPointerType(rtype) && IsIntegralType(ltype))
    if (ptr2intp)
      return TRUE;
    else {
      SyntaxErrorCoord(rhs->coord,
		       "cannot assign pointer value to integer");
      return FALSE;
    }

  /* handles structures and unions */
  else if (IsUnionType(ltype) || IsStructType(ltype)) {
    if (TypeEqualQualified(rtype, ltype, FALSE, FALSE))
      return TRUE;
    else if (IsUnionType(ltype) && IsMemberTypeOfUnion(rtype, ltype)
	     && !ANSIOnly /* casting to union is a GNU extension */)
      return TRUE;
    else {
      SyntaxErrorCoord(rhs->coord,
		       "cannot assign to incompatible struct/union");
      return FALSE;
    }
  }

  else {
    /* default error message */
    SyntaxErrorCoord(rhs->coord, "operands have incompatible types");
    return FALSE;
  }
}

PRIVATE Bool TypeEqualModuloConstVolatile(Node *ltype, Node *rtype)
{
  /* K&R2 A7.17: "... or both operands are pointers to functions
     or objects whose types are the same except for the possible
     absence of const or volatile in the right operand." 
     So qualifiers on left must include all qualifiers on right.  */
  TypeQual lcv = NodeTypeQuals(ltype) & (T_CONST | T_VOLATILE),
  rcv = NodeTypeQuals(rtype) & (T_CONST | T_VOLATILE);

  if ((lcv | rcv) != lcv)
    return FALSE;

  /* type qualifiers okay at top-level;  remove them and test entire
     type */
  return TypeEqualQualified(ltype, rtype, FALSE, TRUE);
}

PRIVATE Bool IsMemberTypeOfUnion(Node *type, Node *unode)
{
  ListMarker marker;
  Node *field;
  
  assert(IsUnionType(unode));
  assert(IsType(type));
  
  IterateList(&marker, unode->u.udcl.type->fields);
  while (NextOnList(&marker, (GenericREF) &field)) {
    if (TypeEqual(type, NodeDataType(field)))
      return TRUE;
  }
  
  return FALSE;
}


