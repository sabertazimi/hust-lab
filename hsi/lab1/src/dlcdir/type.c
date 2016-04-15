/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  type.c,v
 * Revision 1.24  1995/05/11  18:54:37  rcm
 * Added gcc extension __attribute__.
 *
 * Revision 1.23  1995/04/21  05:44:58  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.22  1995/04/09  21:31:00  rcm
 * Added Analysis phase to perform all analysis at one place in pipeline.
 * Also added checking for functions without return values and unreachable
 * code.  Added tests of live-variable analysis.
 *
 * Revision 1.21  1995/03/23  15:31:38  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.20  1995/03/01  16:23:26  rcm
 * Various type-checking bug fixes; added T_REDUNDANT_EXTERNAL_DECL.
 *
 * Revision 1.19  1995/02/13  02:00:29  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.18  1995/02/01  23:02:08  rcm
 * Added Text node and #pragma collection
 *
 * Revision 1.17  1995/02/01  21:07:43  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.16  1995/02/01  07:38:55  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.15  1995/02/01  04:35:13  rcm
 * Fixed bug in MergeTypeQuals
 *
 * Revision 1.14  1995/01/27  01:39:17  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.13  1995/01/25  21:38:28  rcm
 * Added TypeSpecifiers to make type modifiers extensible
 *
 * Revision 1.12  1995/01/25  02:16:26  rcm
 * Changed how Prim types are created and merged.
 *
 * Revision 1.11  1995/01/20  05:10:24  rcm
 * Minor bug fixes
 *
 * Revision 1.10  1995/01/20  03:38:24  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.9  1995/01/11  17:18:23  rcm
 * Anonymous struct/union/enums now given arbitrary unique tag.
 *
 * Revision 1.8  1995/01/06  16:49:15  rcm
 * added copyright message
 *
 * Revision 1.7  1994/12/23  09:18:48  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.6  1994/12/20  09:24:26  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.5  1994/11/22  01:54:53  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.4  1994/11/10  03:13:44  rcm
 * Fixed line numbers on AST nodes.
 *
 * Revision 1.3  1994/11/03  07:39:06  rcm
 * Added code to output C from the parse tree.
 *
 * Revision 1.2  1994/10/28  18:53:19  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Mon Apr 26 15:27:31 EDT 1993
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
#pragma ident "type.c,v 1.24 1995/05/11 18:54:37 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"

PRIVATE Bool IsLvalue_Local(Node *node, Bool modifiablep);
PRIVATE void UnwindTdefs(Node **pnode, TypeQual *ptq);
PRIVATE const char *TypeSpecifierName(TypeSpecifier tm); 

GLOBAL Bool TrackIds = FALSE;

GLOBAL Node *EllipsisNode;
GLOBAL Node *Undeclared;  /* used for undeclared variables */

/* Global Type constants */
GLOBAL Node *PrimVoid,  *PrimChar, *PrimSchar, *PrimUchar, 
            *PrimSshort, *PrimUshort, 
            *PrimSint,  *PrimUint,  *PrimSlong, *PrimUlong, 
            *PrimSlonglong, *PrimUlonglong,
            *PrimFloat, *PrimDouble, *PrimLongdouble;

GLOBAL Node *StaticString;

GLOBAL Node *SintZero,  *UintZero, 
            *SlongZero, *UlongZero, 
            *FloatZero, *DoubleZero;

GLOBAL Node *PtrVoid, *PtrNull;

GLOBAL Node *SintOne,   *UintOne, 
            *SlongOne,  *UlongOne, 
            *FloatOne,  *DoubleOne;

PRIVATE const char *TypeNames[MaxBasicType];

GLOBAL void InitTypes()
{ 
  TypeNames[Uchar] = "unsigned char";
  TypeNames[Schar] = "signed char";
  TypeNames[Char] = "char";
  TypeNames[Sshort] = "short";
  TypeNames[Ushort] = "unsigned short";
  TypeNames[Sint] = "int";
  TypeNames[Uint] = "unsigned";
  TypeNames[Int_ParseOnly] = "int";
  TypeNames[Slong] = "long";
  TypeNames[Ulong] = "unsigned long";
  TypeNames[Slonglong] = "long long";
  TypeNames[Ulonglong] = "unsigned long long";
  TypeNames[Float] = "float";
  TypeNames[Double] = "double";
  TypeNames[Longdouble] = "long double";
  TypeNames[Void] = "void";
  TypeNames[Ellipsis] = "...";

  EllipsisNode = MakePrim(EMPTY_TQ, Ellipsis);
  Undeclared   = MakeDecl("undeclared!", EMPTY_TQ, NULL, NULL, NULL);

  PrimVoid     = MakePrim(EMPTY_TQ, Void);
  PrimChar     = MakePrim(EMPTY_TQ, Char);
  PrimSchar    = MakePrim(EMPTY_TQ, Schar);
  PrimUchar    = MakePrim(EMPTY_TQ, Uchar);
  PrimSshort   = MakePrim(EMPTY_TQ, Sshort);
  PrimUshort   = MakePrim(EMPTY_TQ, Ushort);
  PrimSint     = MakePrim(EMPTY_TQ, Sint);
  PrimUint     = MakePrim(EMPTY_TQ, Uint);
  PrimSlong    = MakePrim(EMPTY_TQ, Slong);
  PrimUlong    = MakePrim(EMPTY_TQ, Ulong);
  PrimSlonglong= MakePrim(EMPTY_TQ, Slonglong);
  PrimUlonglong= MakePrim(EMPTY_TQ, Ulonglong);
  PrimFloat    = MakePrim(EMPTY_TQ, Float);
  PrimDouble   = MakePrim(EMPTY_TQ, Double);
  PrimLongdouble= MakePrim(EMPTY_TQ, Longdouble);
  StaticString = MakePtr(EMPTY_TQ, MakePrim(T_STATIC, Char));

  /* Make some standard zeros */
  SintZero   = MakeConstSint(0);
  UintZero   = MakeConstUint(0);
  SlongZero  = MakeConstSlong(0);
  UlongZero  = MakeConstUlong(0);
  FloatZero  = MakeConstFloat(0.0);
  DoubleZero = MakeConstDouble(0.0);

  /* Make some standard ones */
  SintOne    = MakeConstSint(1);
  UintOne    = MakeConstUint(1);
  SlongOne   = MakeConstSlong(1);
  UlongOne   = MakeConstUlong(1);
  FloatOne   = MakeConstFloat(1.0);
  DoubleOne  = MakeConstDouble(1.0);

  PtrVoid = MakePtr(EMPTY_TQ, PrimVoid);
  PtrNull = MakeConstPtr(0);
}



/*************************************************************************/
/*                                                                       */
/*         Type qualifiers, storage classes, decl qualifiers             */
/*                                                                       */
/*************************************************************************/



GLOBAL int TQtoText(char array[], TypeQual tq)
{
  array[0] = '\0';

  switch(STORAGE_CLASS(tq)) {
  case T_TYPEDEF:   strcat(array, "typedef "); break;
  case T_EXTERN:	strcat(array, "extern "); break;
  case T_STATIC:    strcat(array, "static "); break;
  case T_AUTO:      strcat(array, "auto "); break;
  case T_REGISTER:  strcat(array, "register "); break;
  case 0: /* no explicit storage class */ break;
  default: UNREACHABLE;
  }
  
  switch(DECL_LOCATION(tq)) {
  case T_TOP_DECL:    strcat(array, "top_decl "); break;
  case T_BLOCK_DECL:  strcat(array, "block_decl "); break;
  case T_FORMAL_DECL: strcat(array, "formal_decl "); break;
  case T_SU_DECL:     strcat(array, "su_decl "); break;
  case T_ENUM_DECL:   strcat(array, "enum_decl "); break;
  case 0: break;
  default: UNREACHABLE;
  }


  if (tq & T_REDUNDANT_EXTERNAL_DECL)
    strcat(array, "redundant_external_decl ");

  if (tq & T_INLINE) 
    strcat(array, "inline ");
  if (tq & T_CONST)
    strcat(array, "const ");
  if (tq & T_VOLATILE)
    strcat(array, "volatile ");
  if (tq & T_SUE_ELABORATED)
    strcat(array, "sue_elaborated ");
  
  return strlen(array);
}



GLOBAL int PrintTQ(FILE *out, TypeQual tq)
{
    char tmp[256];

    TQtoText(tmp, tq);
    fputs(tmp, out);
    return strlen(tmp);
}


GLOBAL TypeQual MergeTypeQuals(TypeQual left, TypeQual right, Coord coord)
{
    TypeQual scl, scr, dql, dqr, tql, tqr;
    TypeQual result = 0;

    scl = STORAGE_CLASS(left);
    scr = STORAGE_CLASS(right);

    if (scl != 0 && scr != 0) {
      if (scl == scr) { /* scl == scr == single storage class */
	WarningCoord(4, coord, "redundant storage class");
      } 
      else {
	char namel[20], namer[20];
	TQtoText(namel, scl);
	TQtoText(namer, scr);
	SyntaxErrorCoord(coord,"conflicting storage classes `%s' and `%s'",
			 namel, namer);
      }
      result |= scl;
    }
    else {
      result |= scl | scr;
    }

    dql = DECL_QUALS(left) & ~scl;
    dqr = DECL_QUALS(right) & ~scr;
    result |= (dql | dqr);

    tql = TYPE_QUALS(left);
    tqr = TYPE_QUALS(right);

    if ((tql & tqr) != 0) {
	WarningCoord(4, coord, "redundant type qualifier");
    }
    result |= (tql | tqr);
    return(result);
}


GLOBAL Node *TypeQualifyNode(Node *node, TypeQual tq)
{
    switch(node->typ) {
      case Prim:
	node->u.prim.tq = MergeTypeQuals(node->u.prim.tq, tq, node->coord);
	break;
      case Tdef:
	node->u.tdef.tq = MergeTypeQuals(node->u.tdef.tq, tq, node->coord);
	break;
      case Ptr:
	node->u.ptr.tq  = MergeTypeQuals(node->u.ptr.tq,  tq, node->coord);
	break;
      case Adcl:
	node->u.adcl.tq = MergeTypeQuals(node->u.adcl.tq, tq, node->coord);
	break;
      case Sdcl:
	node->u.sdcl.tq = MergeTypeQuals(node->u.sdcl.tq, tq, node->coord);
	break;
      case Udcl:
	node->u.udcl.tq = MergeTypeQuals(node->u.udcl.tq, tq, node->coord);
	break;
      case Edcl:
	node->u.edcl.tq = MergeTypeQuals(node->u.edcl.tq, tq, node->coord);
	break;

/* added by Manish 1/31/94 */
      case Fdcl:
	node->u.fdcl.tq = MergeTypeQuals(node->u.fdcl.tq,tq, node->coord);  
	break; 
      default:
	PrintNode(stdout, node, 0);
	printf("\n");

	/* this assertion always fails */
	/*assert(("Unexpected node type", FALSE));*/
	assert(FALSE);
	break;
    }
    return(node);
}

/* Make a type that is merged from <type1> and quals of <qual2> */
GLOBAL Node *MakeMergedType(Node *type1, Node *qual2)
{
  return TypeQualifyNode(NodeCopy(type1, NodeOnly), NodeTypeQuals(qual2));
}


GLOBAL TypeQual NodeTq(Node *node)
{
  assert(node);

  switch (node->typ) {
  case Prim:
    return node->u.prim.tq;
  case Tdef:
    return node->u.tdef.tq;
  case Ptr:
    return node->u.ptr.tq;
  case Adcl:
    return node->u.adcl.tq;
  case Sdcl:
    return node->u.sdcl.tq;
  case Udcl:
    return node->u.udcl.tq;
  case Edcl:
    return node->u.edcl.tq;
  case Decl:
    return node->u.decl.tq;
  case Fdcl:
    return node->u.fdcl.tq;
  default:
    fprintf(stderr, "Internal Error! Unrecognized type\n");
    PrintNode(stderr, node, 0);
    fprintf(stderr, "\n");
    assert(FALSE);
  }
  return(EMPTY_TQ); /* unreachable */
}

GLOBAL void NodeSetTq(Node *node, TypeQual mask, TypeQual tq)
{
  switch (node->typ) {
  case Prim:
    node->u.prim.tq &= ~mask;
    node->u.prim.tq |= tq;
    break;
  case Tdef:
    node->u.tdef.tq &= ~mask;
    node->u.tdef.tq |= tq;
    break;
  case Ptr:
    node->u.ptr.tq &= ~mask;
    node->u.ptr.tq |= tq;
    break;
  case Adcl:
    node->u.adcl.tq &= ~mask;
    node->u.adcl.tq |= tq;
    break;
  case Sdcl:
    node->u.sdcl.tq &= ~mask;
    node->u.sdcl.tq |= tq;
    break;
  case Udcl:
    node->u.udcl.tq &= ~mask;
    node->u.udcl.tq |= tq;
    break;
  case Edcl:
    node->u.edcl.tq &= ~mask;
    node->u.edcl.tq |= tq;
    break;
  case Decl:
    node->u.decl.tq &= ~mask;
    node->u.decl.tq |= tq;
    break;
  case Fdcl:
    node->u.fdcl.tq &= ~mask;
    node->u.fdcl.tq |= tq;
    break;
  default:
    fprintf(stderr, "Internal Error! Unrecognized type\n");
    PrintNode(stderr, node, 0);
    fprintf(stderr, "\n");
    assert(FALSE);
  }
}

GLOBAL void NodeAddTq(Node *node, TypeQual tq)
{
  NodeSetTq(node, 0, tq);
}

GLOBAL void NodeRemoveTq(Node *node, TypeQual tq)
{
  NodeSetTq(node, tq, 0);
}



/* 
   NodeTypeQuals, NodeStorageClass, and NodeDeclQuals only work
   properly AFTER the parse is over, when storage class and
   decl qualifiers have been moved to the decl.
*/
GLOBAL TypeQual NodeTypeQuals(Node *node)
{ return TYPE_QUALS(NodeTq(node)); }

GLOBAL TypeQual NodeStorageClass(Node *node)
{
  assert(node->typ == Decl);
  return STORAGE_CLASS(node->u.decl.tq);
}

GLOBAL void NodeSetStorageClass(Node *node, TypeQual sc)
{
  NodeSetTq(node, T_STORAGE_CLASSES, sc);
}

GLOBAL TypeQual NodeDeclQuals(Node *node)
{
  assert(node->typ == Decl);
  return DECL_QUALS(node->u.decl.tq);
}

GLOBAL TypeQual NodeDeclLocation(Node *node)
{
  assert(node->typ == Decl);
  return DECL_LOCATION(node->u.decl.tq);
}

GLOBAL void NodeSetDeclLocation(Node *node, TypeQual dl)
{
  NodeSetTq(node, T_DECL_LOCATIONS, dl);
}




/*************************************************************************/
/*                                                                       */
/*                      Primitive types                                  */
/*                                                                       */
/*************************************************************************/



GLOBAL Node *StartPrimType(BasicType basic, Coord coord)
{
    return MakePrimCoord(EMPTY_TQ, basic, coord);
}



/*
   requires: node and n2 be partial Prim types (created by StartPrimType and
             not yet finished with FinishPrimType).
   changes: node
*/
GLOBAL Node *MergePrimTypes(Node *node, Node *n2)
{
  ExplodedType et1, et2;

    /* note: memory leak of *n2 */

    assert(node != NULL && node->typ == Prim);
    assert(node != NULL && n2->typ == Prim);

    BASIC2EXPLODED(node->u.prim.basic, et1);
    BASIC2EXPLODED(n2->u.prim.basic,   et2);

     /*
      * First merge base type (int, char, float, double, ...).
      * At most one base type may be specified. 
      */
    if (et1.base && et2.base) 
      SyntaxErrorCoord(node->coord,
		       "conflicting type specifiers: `%s' and `%s'",
		       TypeSpecifierName(et1.base),
		       TypeSpecifierName(et2.base));
    else et1.base |= et2.base;

     /*
      * Now merge signs.  At most one sign may be specified; it appears to
      * be legal in ANSI to repeat the same sign (as in 
      * "unsigned unsigned int"), but a warning is generated.
      */
    if (et1.sign && et2.sign) {
      if (et1.sign != et2.sign)
	SyntaxErrorCoord(node->coord,
			 "conflicting type specifiers: `%s' and `%s'",
			 TypeSpecifierName(et1.sign),
			 TypeSpecifierName(et2.sign));
      else
	WarningCoord(3, node->coord,
		     "repeated type specifier: `%s'",
		     TypeSpecifierName(et1.sign));
    }
    else et1.sign |= et2.sign;
    
     /*
      * Check that the resulting sign is compatible with the resulting
      * base type.
      * Only int and char may have a sign specifier.
      */
    if (et1.sign && et1.base) {
      if (et1.base != Int_ParseOnly && et1.base != Char) {
	SyntaxErrorCoord(node->coord,
			 "conflicting type specifiers: `%s' and `%s'",
			 TypeSpecifierName(et1.base),
			 TypeSpecifierName(et1.sign));
	et1.sign = 0;
      }
    }

     /*
      * Merge lengths (short, long, long long).
      */
    if (et1.length && et2.length) {
      if (et1.length == Long && et2.length == Long
	  && !ANSIOnly)
	et1.length = Longlong;
      else
	SyntaxErrorCoord(node->coord,
			 "conflicting type specifiers: `%s' and `%s'",
			 TypeSpecifierName(et1.length),
			 TypeSpecifierName(et2.length));
    }
    else et1.length |= et2.length;
    
     /*
      * Check that the resulting length is compatible with the resulting
      * base type.
      * Only int may have any length specifier; double may have long.
      */
    if (et1.length && et1.base) {
      if (et1.base != Int_ParseOnly && !(et1.base == Double && et1.length == Long)) {
	SyntaxErrorCoord(node->coord,
			 "conflicting type specifiers: `%s' and `%s'",
			 TypeSpecifierName(et1.base),
			 TypeSpecifierName(et1.length));
	et1.length = 0;
      }
    }

    EXPLODED2BASIC(et1, node->u.prim.basic);

    return(node);
}



GLOBAL Node *FinishPrimType(Node *node)
{
  BasicType bt;
  ExplodedType et;

  assert(node);
  assert(node->typ == Prim);

  BASIC2EXPLODED(node->u.prim.basic, et);

  bt = et.base;

  switch (et.base) {
  case 0:
  case Int_ParseOnly:
    switch (et.length) {
    case Short: 
      bt = (et.sign == Unsigned) ? Ushort : Sshort; break;
    case Long:  
      bt = (et.sign == Unsigned) ? Ulong : Slong; break;
    case Longlong:  
      bt = (et.sign == Unsigned) ? Ulonglong : Slonglong; break;
    case 0:
      bt = (et.sign == Unsigned) ? Uint : Sint; break;
    default: 
      UNREACHABLE;
    }
    break;

  case Char:
    assert(et.length == 0);
    switch (et.sign) {
    case Unsigned:
      bt = Uchar; break;
    case Signed:
      bt = Schar; break;
    case 0:
      bt = Char; break;
    default:
      UNREACHABLE;
    }
    break;

  case Double:
    assert(et.sign == 0);
    assert(et.length == 0 || et.length == Long);
    bt = (et.length == Long) ? Longdouble : Double;
    break;

  default:
    assert(et.sign == 0);
    assert(et.length == 0);
  }

  node->u.prim.basic = bt;
  return node;

#if 0
/* this code is obsoleted by the new version of MergeBasicTypes,
   which makes sure that basic types are always "cleaned up", with
   signs fully specified.  -- rcm */

/* FinishType cleans up the passed in BasicType, making sure that
   all of the possibly signed types are explictly specified.  This
   simplifies the type-checking phase */

    assert(node->typ == Prim);

    switch(node->u.prim.basic) {
      case Unsigned:
	node->u.prim.basic = Uint;
	return(node);
      case Signed:
	node->u.prim.basic = Sint;
	return(node);
      case Long:
	node->u.prim.basic = DEFAULT_LONG;
	return(node);
      case Short:
	node->u.prim.basic = DEFAULT_SHORT;
	return(node);
#if 0
      case Char: /* char defaults to signed char */
	node->u.prim.basic = DEFAULT_CHAR;
	return(node);
/* this was non-ANSI standard -- "char" and "signed char" are
   explicitly different, incompatible types.  Thus:

   signed char *psch;
   char *pch;

   if (pch == psch) {...}

   should generate a diagnostic message, because the pointers
   are incompatible. So we can't simply fold char into signed char.
   We do treat Char identically with Schar for the purposes of
   conversion, however, so only TypeEqual notices the difference
   between them. -- rcm
*/
#endif
      case Int:
	node->u.prim.basic = DEFAULT_INT;
	return(node);
      default:
	return(node);
    }
#endif

}

/* construct a primitive type with unspecified BasicType */
GLOBAL Node *MakeDefaultPrimType(TypeQual tq, Coord coord)
{
    Node *create = StartPrimType(0, coord);
    create->u.prim.tq = tq;
    return FinishPrimType(create);
}

PRIVATE const char *TypeSpecifierName(TypeSpecifier ts)
{
  if ((ts & BasicTypeMask) != 0)
    return TypeNames[ts];

  switch (ts) {
  case Signed:     return "signed";
  case Unsigned:   return "unsigned";

  case Short:      return "short";
  case Long:       return "long";
  case Longlong:   return "long long";

  /* INSERT EXTENSIONS HERE */

  default:  UNREACHABLE;  return NULL;
  }
}

/* SansSign folds signed types into unsigned types of the same length. */
GLOBAL Node *SansSign(Node *type)
{
  Node *new;
  TypeQual tq;

  if (type->typ != Prim)
    return type;

  switch (type->u.prim.basic) {
  case Uchar:
  case Schar:
  case Char:
    new = PrimChar;
    break;

  case Ushort:
  case Sshort:
    new = PrimUshort;
    break;

  case Ulong:
  case Slong:
    new = PrimUlong;
    break;

  case Ulonglong:
  case Slonglong:
    new = PrimUlonglong;
    break;

  case Uint:
  case Sint:
    new = PrimUint;
    break;

  default:
    return type;
  }

  if ((tq = NodeTq(type)) != EMPTY_TQ) {
    new = NodeCopy(new, NodeOnly);
    NodeAddTq(new, tq);
  }
  return new;
}



GLOBAL void PrimToText(char array[], Node *type)
{
    char *ptr = array;
    int len;

    assert(type);
    assert(type->typ == Prim);

    len = TQtoText(ptr, type->u.prim.tq);
    ptr += len;

    strcpy(ptr, TypeNames[type->u.prim.basic]);
}


GLOBAL int PrintPrimType(FILE *out, Node *type)
{
    char tmp[256];

    PrimToText(tmp, type);
    fputs(tmp, out);
    return strlen(tmp);
}



/*************************************************************************/
/*                                                                       */
/*         Resolving identifiers through the symbol table                */
/*                                                                       */
/*************************************************************************/

PRIVATE Node *lookup_identifier(Node *id)
{
    Node *var;
    const char *name;

    assert(id && id->typ == Id);
    name = id->u.id.text;

    if (!LookupSymbol(Identifiers,name,
		      (GenericREF) &var)) {
	var = Undeclared;
	SyntaxErrorCoord(id->coord, "undeclared variable `%s'", name);
    } else {
	REFERENCE(var);
	if (TrackIds) {
	    fprintf(stderr, "=== `%s' = ", name);
	    PrintNode(stderr, var, 0);
	    printf("\n");
	}
    }
    return(var);
}


GLOBAL Bool IsAType(const char *name)
{
  Node *var;
  return (LookupSymbol(Identifiers, name, (GenericREF) &var)
	  && DeclIsTypedef(var));
}

GLOBAL Node *GetTypedefType(Node *id)
{
    Node *var = lookup_identifier(id);

    assert(var);
    assert(var->typ == Decl);
    return(var->u.decl.type);    
}


GLOBAL Node *LookupFunction(Node *call)
{
    Node *id, *var;

    assert(call != NULL  &&  call->typ == Call);
    id = call->u.call.name;
    assert(id->typ == Id);

    if (!LookupSymbol(Identifiers, id->u.id.text, (GenericREF)&var)) {
      if (!LookupSymbol(Externals, id->u.id.text, (GenericREF)&var)) {
	WarningCoord(2, id->coord,
		     "implicitly declaring function to return int: %s()",
		     id->u.id.text);

	var = MakeDeclCoord(id->u.id.text,
		       T_TOP_DECL,
		       MakeFdclCoord(EMPTY_TQ, NULL, MakeDefaultPrimType(EMPTY_TQ, id->coord),
				id->coord),
		       NULL,
		       NULL,
		       id->coord);
	REFERENCE(var);
	id->u.id.decl = var;
	InsertSymbol(Identifiers, id->u.id.text, var, NULL);
	InsertSymbol(Externals, id->u.id.text, var, NULL);
      } else  { /* only in Externals */
	id->u.id.decl = var;
	/* already referenced => no REFERENCE(var) */
	InsertSymbol(Identifiers, id->u.id.text, var, NULL);
      }
    } else {
	id->u.id.decl = var;
	REFERENCE(var);
	if (TrackIds) {
	    fprintf(stderr, "=== `%s' = ", id->u.id.text);
	    PrintNode(stderr, var, 0);
	}
    }
    return(call);
}


GLOBAL Node *LookupPostfixExpression(Node *post)
{
    switch (post->typ) {
      case Const:
      case Comma:
      case Block:
      case Ternary:
      case Cast:
	break;
      case Id:
	post->u.id.decl = lookup_identifier(post);
	break;
      case Binop:  /* structure reference */
	if (post->u.binop.op == '.'  ||  post->u.binop.op == ARROW)
	  LookupPostfixExpression(post->u.binop.left);
	break;
      case Unary:  /* post inc/dec */
	if (post->u.unary.op == POSTINC  ||  post->u.unary.op == POSTDEC)
	  LookupPostfixExpression(post->u.unary.expr);
	break;
      case Array:
	LookupPostfixExpression(post->u.array.name);
	return(post);
      case Call:
	if (post->u.call.name->typ == Id) {
	    LookupFunction(post);
	} else {
	    LookupPostfixExpression(post->u.call.name);
	}
	break;
      default:
	Warning(1, "Internal Error!");
	fprintf(stderr, "\tLookupPostfixExpression: unexpected node:\n");
	PrintNode(stderr, post, 2);
	exit(10);
    }
    return(post);
}




GLOBAL void OutOfScope(Node *var)
{ Node *type;
  
  assert(var);
  assert(var->typ == Decl);

  type = var->u.decl.type;
  assert(type);

#if 0
  printf("OutOfScope\n");
  PrintNode(stdout, var,  0); printf("\n");
  PrintNode(stdout, type, 0); printf("\n");
#endif

  if (var->u.decl.references == 0 && type->typ != Fdcl) {
    /* give warning only if unused local variable */
    if (NodeDeclLocation(var) == T_BLOCK_DECL &&
	NodeStorageClass(var) != T_EXTERN)
      WarningCoord(2, var->coord, "unused variable `%s'", VAR_NAME(var));
  }
}



/*************************************************************************/
/*                                                                       */
/*             Size and alignment calculations                           */
/*                                                                       */
/*************************************************************************/

GLOBAL int NodeSizeof(Node *node, Node *node_type)
{ Node *type;

  if (!node) {
    Warning(1, "Internal Error!");
    fprintf(stderr, "NodeSizeof called with nil\n");
    return 0;
  }

  type = (node_type) ? NodeDataType(node_type) : NodeDataType(node);

  switch (type->typ) {
  case Prim:
    switch (type->u.prim.basic) {
    case Char:
    case Schar:
    case Uchar:
      return CHAR_SIZE;
    case Sshort:
    case Ushort:
      return SHORT_SIZE;
    case Sint:
    case Uint:
      return INT_SIZE;
    case Slong:
    case Ulong:
      return LONG_SIZE;
    case Slonglong:
    case Ulonglong:
      return LONGLONG_SIZE;
    case Float:
      return FLOAT_SIZE;
    case Double:
      return DOUBLE_SIZE;
    case Longdouble:
      return LONGDOUBLE_SIZE;
    case Void:
      SyntaxErrorCoord(node->coord, "Can't compute size of type void");
      return 1;
    default:
      WarningCoord(1, node->coord, 
		   "NodeSizeof(): Unrecognized primitive type %d", 
		   type->u.prim.basic);
      PrintNode(stderr, node, 0);
      fputc('\n', stderr);
      return 1;
    }
  
  case Ptr:
    return POINTER_SIZE;

  case Sdcl:
    if (!IsStructComplete(type)) {
      SyntaxErrorCoord(node->coord, 
		       "Can't compute size of incomplete structure type");
      return 1;
    }
    else return SUE_Sizeof(type->u.sdcl.type);
  
  case Udcl:
    if (!IsUnionComplete(type)) {
      SyntaxErrorCoord(node->coord, 
		       "Can't compute size of incomplete union type");
      return 1;
    }
    else return SUE_Sizeof(type->u.udcl.type);
  
  case Edcl:
    return INT_SIZE;
  
  case Adcl:
    if (IsStringConstant(node)) {
      return strlen(NodeConstantStringValue(node)) + 1 /* for null terminator */;
    }
    else if (IsUnsizedArray(type)) {
      SyntaxErrorCoord(node->coord, 
		       "Can't compute size of undimensioned array");
      return 1;
    }
    else return type->u.adcl.size;

  default:
    WarningCoord(1, node->coord, 
		 "NodeSizeof(): Unrecognized node type %d", 
		 type->typ);
    PrintNode(stderr, node, 0);
    fputc('\n', stderr);
    return 1;
  }
}

GLOBAL int NodeAlignment(Node *node, Node *node_type)
{ Node *type = (node_type) ? node_type : NodeDataType(node);

  switch (type->typ) {
  case Prim:
    switch (type->u.prim.basic) {
    case Char:
    case Schar:
    case Uchar:
      return CHAR_ALIGN;
    case Sshort:
    case Ushort:
      return SHORT_ALIGN;
    case Sint:
    case Uint:
      return INT_ALIGN;
    case Slong:
    case Ulong:
      return LONG_ALIGN;
    case Slonglong:
    case Ulonglong:
      return LONGLONG_ALIGN;
    case Float:
      return FLOAT_ALIGN;
    case Double:
      return DOUBLE_ALIGN;
    case Longdouble:
      return LONGDOUBLE_ALIGN;
    case Void:
      SyntaxErrorCoord(node->coord, "Can't find alignment for type void");
      return 1;
    default:
      WarningCoord(1, node->coord, 
		   "NodeAlignment(): Unrecognized primitive type %d", 
		   type->u.prim.basic);
      return 1;
    }

  case Ptr:
    return POINTER_ALIGN;

  case Adcl:
    return NodeAlignment(node, NodeDataType(type->u.adcl.type));

  case Sdcl:
    if (!IsStructComplete(type)) {
      SyntaxErrorCoord(node->coord, 
		       "Can't compute size of incomplete structure type");
      return 1;
    }
    else return SUE_Alignment(type->u.sdcl.type);
  
  case Udcl:
    if (!IsUnionComplete(type)) {
      SyntaxErrorCoord(node->coord, 
		       "Can't compute size of incomplete union type");
      return 1;
    }
    else return SUE_Alignment(type->u.sdcl.type);
  
  case Edcl:
    return INT_ALIGN;
  

  default:
    WarningCoord(1, node->coord, 
		 "NodeAlignment(): Unrecognized node type %d",
		 type->typ);
    return 1;
  }
}



/*************************************************************************/
/*                                                                       */
/*             Various predicates and selectors for types                */
/*                                                                       */
/*************************************************************************/

GLOBAL Bool DeclIsExtern(Node *node)
{ return (NodeStorageClass(node) == T_EXTERN); }

GLOBAL Bool NodeIsConstQual(Node *node)
{ return (NodeTypeQuals(node) & T_CONST) != 0; }

GLOBAL Bool DeclIsEnumConst(Node *node)
{ return NodeDeclLocation(node) == T_ENUM_DECL; }

GLOBAL Bool DeclIsTypedef(Node *node)
{ return (NodeStorageClass(node) == T_TYPEDEF); }

GLOBAL Bool DeclIsStatic(Node *node)
{ return (NodeStorageClass(node) == T_STATIC); }

GLOBAL Bool DeclIsExternal(Node *node)
{ TypeQual sc = NodeStorageClass(node);
  TypeQual dl = NodeDeclLocation(node);

  return sc == T_EXTERN || dl == T_TOP_DECL;
}



GLOBAL Node *PtrSubtype(Node *ptr)
{
  assert(ptr->typ == Ptr);
  return ptr->u.ptr.type;
}


GLOBAL Node *ArrayRefType(Node *atype, List *dims)
{ ListMarker marker;
  Node *dim;

  IterateList(&marker, dims);
  while (NextOnList(&marker, (GenericREF) &dim))
    if (atype->typ == Adcl)
      atype = NodeDataType(atype->u.adcl.type);
    else if (atype->typ == Ptr)
      atype = NodeDataType(atype->u.ptr.type);
    else
      assert(FALSE);

  return atype;
}



GLOBAL Bool IsObjectType(Node *node)
{ return !(IsFunctionType(node) || IsIncompleteType(node)); }

GLOBAL Bool IsFunctionType(Node *node)
{
  assert(node);
  return node->typ == Fdcl;
}

GLOBAL Bool IsIncompleteType(Node *node)
{ 
  if (IsArrayType(node))
    return IsUnsizedArray(node);
  else if (IsStructType(node))
    return !IsStructComplete(node);
  else if (IsUnionType(node))
    return !IsUnionComplete(node);
  else
    return FALSE; 
}

GLOBAL Bool IsUnsizedArray(Node *node)
{
  assert(node);
  assert(node->typ == Adcl);
  return node->u.adcl.dim == NULL;
}

GLOBAL Bool IsStructComplete(Node *node)
{ 
  assert(node);
  assert(node->typ == Sdcl);
  return node->u.sdcl.type->complete;
}

GLOBAL Bool IsUnionComplete(Node *node)
{ 
  assert(node);
  assert(node->typ == Udcl);
  return node->u.udcl.type->complete;
}

GLOBAL Bool IsVoidType(Node *node)
{ 
  assert(node);
  node = NodeDataType(node);
  return node->typ == Prim && node->u.prim.basic == Void; 
}

GLOBAL Bool IsArrayType(Node *node)
{
  assert(node);
  return node->typ == Adcl;
}

GLOBAL Bool IsSueType(Node *node)
{ 
  assert(node);
  return node->typ == Sdcl || node->typ == Udcl || node->typ == Edcl; 
}

GLOBAL Bool IsStructType(Node *node)
{
  assert(node);
  return node->typ == Sdcl;
}

GLOBAL Bool IsUnionType(Node *node)
{
  assert(node);
  return node->typ == Udcl;
}

GLOBAL Bool IsEnumType(Node *node)
{
  assert(node);
  return node->typ == Edcl;
}

GLOBAL Bool IsPointerType(Node *node)
{ 
  assert(node);
  return NodeDataType(node)->typ == Ptr; 
}

GLOBAL Bool IsScalarType(Node *node)
{ 
  assert(node);
  return IsArithmeticType(node) || IsPointerType(node); 
}

GLOBAL Bool IsArithmeticType(Node *node)
{ 
  assert(node);
  return IsIntegralType(node) || IsFloatingType(node);
}

GLOBAL Bool IsIntegralType(Node *node)
{
  assert(node);

  switch (node->typ) {
  case Prim:
    { 
      switch (node->u.prim.basic) {
      case Uchar: case Schar: case Char:
      case Ushort: case Sshort:
      case Uint: case Sint:
      case Ulong: case Slong:
      case Ulonglong: case Slonglong:
	return TRUE;
      default:
	return FALSE;
      }
      break;
    }
#if 0
/* don't see why this is necessary! when can a Const be a type node? -- rcm */
  case Const:
    if (node->u.Const.type->typ == Prim) {
      BasicType typ = node->u.Const.type->u.prim.basic;

      if (typ == Void || typ == Ellipsis || typ == Double || typ == Float)
	return FALSE;
      else
	return TRUE;
    }
    else
      return FALSE;
#endif

  case Ptr:
    return FALSE;

#if 0
/* why is an array an integral type, just because its elements are? -- rcm */
  case Array:
    { Node *atype = NodeDataType(node->u.array.name);

      if (atype->typ == Adcl)
	return IsIntegralType(atype->u.adcl.type);
      else
	return FALSE;
    }
#endif
  case Edcl:
    return TRUE;
  default:
    return FALSE;
  }
}

GLOBAL Bool IsFloatingType(Node *node)
{
  assert(node);

  /* WCH: changed because of potential bug */
  return
      (node->typ == Prim &&
       (node->u.prim.basic == Float || 
	node->u.prim.basic == Double ||
	node->u.prim.basic == Longdouble));
#if 0
/* why allow Const? -- rcm */
	  || (node->typ == Const &&
	      node->u.Const.type->typ == Prim &&
	      (node->u.Const.type->u.prim.basic == Double ||
	      node->u.Const.type->u.prim.basic == Float));
#endif
}

GLOBAL Bool IsModifiableLvalue(Node *node)
{ return IsLvalue_Local(node, TRUE); }

GLOBAL Bool IsLvalue(Node *node)
{ return IsLvalue_Local(node, FALSE); }


PRIVATE Bool IsLvalue_Local(Node *node, Bool modifiablep)
{
  TypeQual tq;
  Node *type = NodeDataTypeSuperior(node);

  UnwindTdefs(&type, &tq);

  /* test first for modifiability, if required by caller */
  if (modifiablep && (tq & T_CONST) != 0)
    return FALSE;

  /* now test whether node is an lvalue */
  switch (node->typ) {
  case Id:
    /* an identifier is an lvalue if its type is arithmetic,
       structure, union, or pointer */
    switch (type->typ) {
    case Prim:
    case Sdcl:
    case Udcl:
    case Edcl:
    case Ptr:
      return TRUE;
    default:
      return FALSE;
    }

    /* *p is an lvalue */
  case Unary:
    if (node->u.unary.op == INDIR)
      return TRUE;
    else return FALSE;

    /* a[i] is equivalent to *(a+i), hence is an lvalue */
  case Array:
    return TRUE;

  case Binop:
    /* s.f and ps->f are lvalues if s is an lvalue and f is not an array */
    if ((    (node->u.binop.op == '.' && 
	      IsLvalue_Local(node->u.binop.left, modifiablep))
	      ||
	      node->u.binop.op == ARROW)
	&&
	type->typ != Adcl)
      return TRUE;
    else return FALSE;

  default:
    return FALSE;
  }
}



#if 0
/* this code obsoleted by new IsLvalue_Local, above -- rcm */
GLOBAL Bool IsLvalueExpr(Node *node, Bool modifiablep)
{
#if 0
  printf("\nIsLvalueExpr(node, %d)\n", modifiablep);
  PrintNode(stdout, node, 0);
  printf("\n");
#endif

  switch (node->typ) {
  case Id:
    if (node->u.id.decl) {
      Node *type = NodeDataType(node->u.id.decl);

      switch (type->typ) {
      case Prim:
      case Ptr:
      case Adcl:
      case Edcl:
	if (modifiablep) 
	  return !(NodeTypeQuals(type) & T_CONST);
	else
	  return TRUE;
      case Sdcl:
      case Udcl:
	return TRUE;
      default:
	return FALSE;
      }
    }
    else {
      fprintf(stderr, "IsLvalue: unexpected node");
      PrintNode(stderr, node, 0);
      fputc('\n', stderr);
      assert(FALSE);
    }
  case Decl:
    return IsLvalueExpr(node->u.decl.type, modifiablep);
#if 0
    switch (NodeDataType(node->u.decl.type)->typ) {
    case Prim:
    case Ptr:
    case Adcl:
    case Sdcl:
      if (modifiablep)
	return !(NodeTypeQuals(node) & T_CONST);
      else
	return TRUE;
    default:
      return FALSE;
    }
#endif
  case Array:
    return IsLvalueExpr(node->u.array.type, modifiablep);
  case Unary:
    return node->u.unary.op == INDIR;
  case Binop:
    return ((node->u.binop.op == '.' && IsLvalue(node->u.binop.left)) ||
	    node->u.binop.op == ARROW);
  default:
    return FALSE;
  }
}
#endif





GLOBAL Bool IsVoidArglist(List *arglist)
{ return (ListLength(arglist) == 1) && IsVoidType(FirstItem(arglist)); }

GLOBAL Bool IsEllipsis(Node *node)
{ return node->typ == Prim && node->u.prim.basic == Ellipsis; }




GLOBAL Bool IsLogicalOrRelationalExpression(Node *node)
{ return IsLogicalExpression(node) || IsRelationalExpression(node); }

GLOBAL Bool IsRelationalExpression(Node *node)
{ 
  if (node->typ == Binop) 
    { OpType opcode = node->u.binop.op;

      if (opcode == EQ || opcode == NE  ||
	  opcode == GE || opcode == '>' ||
	  opcode == LE || opcode == '<')
	return TRUE;
    }

  return FALSE;
}

GLOBAL Bool IsLogicalExpression(Node *node)
{ 
  if (node->typ == Binop) 
    { OpType opcode = node->u.binop.op;

      return (opcode == ANDAND || opcode == OROR);
    }
  else if (node->typ == Unary)
    return node->u.unary.op == '!';
  else
    return FALSE;
}

GLOBAL Bool IsPtrToObject(Node *node)
{
  if (IsPointerType(node))
    return IsObjectType(NodeDataType(node->u.ptr.type));
  else
    return FALSE;
}

GLOBAL Bool IsPtrToFunction(Node *node)
{
  if (IsPointerType(node))
    return IsFunctionType(NodeDataType(node->u.ptr.type));
  else
    return FALSE;
}

GLOBAL Bool IsPtrToVoid(Node *node)
{
  if (IsPointerType(node))
    return IsVoidType(NodeDataType(node->u.ptr.type));
  else
    return FALSE;
}



GLOBAL Node *FunctionReturnType(Node *node)
{ Node *ret;

  assert(node->typ == Proc);
  ret = node->u.proc.decl;
  assert(ret->typ == Decl);
  ret = ret->u.decl.type;
  assert(ret->typ == Fdcl);
  return ret->u.fdcl.returns;
}

GLOBAL void FunctionSetReturnType(Node *node, Node *new_type)
{ Node *ret;

  assert(node->typ == Proc);
  ret = node->u.proc.decl;
  assert(ret->typ == Decl);
  ret = ret->u.decl.type;
  assert(ret->typ == Fdcl);

  ret->u.fdcl.returns = new_type;
}

GLOBAL void FunctionPushArglist(Node *node, Node *new_arg)
{ Node *ret;

  assert(node->typ == Proc);
  ret = node->u.proc.decl;
  assert(ret->typ == Decl);
  ret = ret->u.decl.type;
  assert(ret->typ == Fdcl);

  ret->u.fdcl.args = ConsItem(new_arg, ret->u.fdcl.args);
}


/* IsPrimitiveStmt() is true for expressions and statements which
   never contain other statements */
GLOBAL Bool IsPrimitiveStmt(Node *node)
{
  assert(node);

  if (node->typ == Block)
    return FALSE;
  else if (IsExpr(node))
    return TRUE;
  else 
    switch (node->typ) {
    case Goto:
    case Continue:
    case Break:
    case Return:
      return TRUE;

    default:
      return FALSE;
    }
}



GLOBAL Bool TypeIsChar(Node *type)
{
  assert(type);
  return type->typ == Prim && type->u.prim.basic == Char;
}


GLOBAL Bool TypeIsSint(Node *type)
{
  assert(type);
  return type->typ == Prim && type->u.prim.basic == Sint;
}

GLOBAL Bool TypeIsUint(Node *type)
{
  assert(type);
  return type->typ == Prim && type->u.prim.basic == Uint;
}

GLOBAL Bool TypeIsSlong(Node *type)
{
  assert(type);
  return type->typ == Prim && type->u.prim.basic == Slong;
}

GLOBAL Bool TypeIsUlong(Node *type)
{
  assert(type);
  return type->typ == Prim && type->u.prim.basic == Ulong;
}

GLOBAL Bool TypeIsFloat(Node *type)
{
  assert(type);
  return type->typ == Prim && type->u.prim.basic == Float;
}

GLOBAL Bool TypeIsDouble(Node *type)
{
  assert(type);
  return type->typ == Prim && type->u.prim.basic == Double;
}

GLOBAL Bool TypeIsString(Node *type)
{
  Node *elementtype;

  assert(type);
  if (type->typ != Adcl)
    return FALSE;

  elementtype = type->u.adcl.type;

  return (elementtype->typ == Prim && elementtype->u.prim.basic == Char);
}


GLOBAL Bool NodeTypeIsSint(Node *node)
{ return TypeIsSint(NodeDataType(node)); }

GLOBAL Bool NodeTypeIsChar(Node *node)
{ return TypeIsChar(NodeDataType(node)); }

GLOBAL Bool NodeTypeIsUint(Node *node)
{ return TypeIsUint(NodeDataType(node)); }

GLOBAL Bool NodeTypeIsSlong(Node *node)
{ return TypeIsSlong(NodeDataType(node)); }

GLOBAL Bool NodeTypeIsUlong(Node *node)
{ return TypeIsUlong(NodeDataType(node)); }

GLOBAL Bool NodeTypeIsFloat(Node *node)
{ return TypeIsFloat(NodeDataType(node)); }

GLOBAL Bool NodeTypeIsDouble(Node *node)
{ return TypeIsDouble(NodeDataType(node)); }

GLOBAL Bool NodeTypeIsString(Node *node)
{ return TypeIsString(NodeDataType(node)); }

GLOBAL Bool NodeTypeIsIntegral(Node *node)
{ return IsIntegralType(NodeDataType(node)); }

GLOBAL Bool IsPrimChar(Node *node)
{
  assert(node);

  if (node->typ == Prim)
    return (node->u.prim.basic == Char);
  else
    return FALSE;
}

GLOBAL Bool IsArrayOfChar(Node *node)
{
  assert(node);

  if (node->typ == Adcl)
    return IsPrimChar(node->u.adcl.type);
  else
    return FALSE;
}

GLOBAL Bool IsStringConstant(Node *node)
{
  assert(node);

  if (node->typ == Const)
    {
      assert(node->u.Const.type);
      assert(node->u.Const.type->typ == Adcl);
      return IsPrimChar(node->u.Const.type->u.adcl.type);
    }
  else
    return FALSE;
}

GLOBAL Bool IsAggregateType(Node *node)
{
  assert(node);
  return node->typ == Adcl || node->typ == Sdcl;
}


/*************************************************************************/
/*                                                                       */
/*             Type compatibility and equality                           */
/*                                                                       */
/*************************************************************************/

#if 0
/* DEAD CODE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */
GLOBAL Bool  IsCompatibleStrict(Node *node1, Node *node2)
{ return IsCompatible(node1, node2, IsTqEqual, 0) == TRUE; }

GLOBAL Bool  IsCompatibleModuloConstVolatile(Node *node1, Node *node2)
{ return IsCompatible(node1, node2, IsTqEqualModuloConstVolatile, 0) == TRUE; }

GLOBAL Bool IsTqEqual(TypeQual tq1, TypeQual tq2, int nesting_level)
{
  int mask = ~TQ_ALWAYS_COMPATIBLE;

  return (tq1 & mask) == (tq2 & mask);
}

GLOBAL Bool IsTqEqualModuloConstVolatile(TypeQual tq1, TypeQual tq2, 
					 int nesting_level)
{
  int mask = ~(TQ_ALWAYS_COMPATIBLE | T_CONST | T_VOLATILE);
  return (tq1 & mask) == (tq2 & mask);
}


/* returns TRUE, FALSE, or TRUE_MODULO_SIGN */  
GLOBAL int IsCompatible(Node *node1, Node *node2, 
			 TypeQualCompare tqcmp, int nesting_level)
{
  TypeQual tq1, tq2;

  assert(node1);
  assert(node2);


  /* unwind typedefs and gather up type qualifiers */
  UnwindTdefs(&node1, &tq1);
  UnwindTdefs(&node2, &tq2);
  if (!tqcmp(tq1, tq2, nesting_level))
    return FALSE;

  switch (node1->typ) {
  case Prim: {
    BasicType bt1 = node1->u.prim.basic;
    BasicType bt2;

    if (node2->typ == Edcl)
      bt2 = Sint;
    else if (node2->typ != Prim)
      return FALSE;
    else
      bt2 = node2->u.prim.basic;

    if (bt1 == bt2)
      return TRUE;
    else if (SansSign(bt1) == SansSign(bt2))
      return TRUE_MODULO_SIGN;
    else return FALSE;
  }    
  case Fdcl:
    if (node2->typ != Fdcl)
      return FALSE;
    else
      return IsCompatibleFdcls(node1, node2);
  case Sdcl:
    if (node2->typ != Sdcl)
      return FALSE;
    else if (node1 == node2)
      return TRUE;
    else 
      return node1->u.sdcl.type == node2->u.sdcl.type;
  case Udcl:
    if (node2->typ != Udcl)
      return FALSE;
    else if (node1 == node2)
      return TRUE;
    else
      return node1->u.udcl.type == node2->u.udcl.type;
  case Edcl:
    return node2->typ == Edcl ||
      (node2->typ == Prim && node2->u.prim.basic == Sint);
  case Ptr:
    if (node2->typ == Ptr)
      if (IsPtrToVoid(node1) || IsPtrToVoid(node2))
	return TRUE;
      else
	return IsCompatible(node1->u.ptr.type, node2->u.ptr.type, 
			    tqcmp, nesting_level + 1);
    else if (node2->typ == Adcl)
      if (IsPtrToVoid(node1))
	return TRUE;
      else
	return IsCompatible(node1->u.ptr.type, node2->u.adcl.type, 
			    tqcmp, nesting_level + 1);
    else
      return FALSE;
  case Adcl:
    if (node2->typ == Ptr)
      if (IsPtrToVoid(node2))
	return TRUE;
      else
	return IsCompatible(node1->u.adcl.type, node2->u.ptr.type, 
			    tqcmp, nesting_level + 1);
    else if (node2->typ == Adcl) {
      Node *size1 = node1->u.adcl.dim,
           *size2 = node2->u.adcl.dim;

      return (size1 == NULL || 
	      size2 == NULL || 
	      IntegralConstEqual(size1, size2)) &&
	     IsCompatible(node1->u.adcl.type, node2->u.adcl.type, 
			  tqcmp, nesting_level + 1);
    }
    else
      return FALSE;
  default:
    return FALSE;
  }
}

/* end DEAD CODE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */
#endif




/*******************************************************************

  TypeEqual -- implements type equivalence according to K&R2 section
               A8.10 (fix: what section in ANSI standard?)

     strict_toplevel and strict_recursive control whether 
        const and volatile (and other type qualifiers specified
	in TQ_COMPATIBLE) are ignored:

	!strict_toplevel ==> type quals are ignored when comparing
	                     roots of type1 and type2
        !strict_recursive => type quals are ignored when comparing
	                     children of type1 and type2
	
*******************************************************************/

PRIVATE void UnwindTdefs(Node **pnode, TypeQual *ptq)
{
  *ptq = NodeTypeQuals(*pnode);
  while ((*pnode)->typ == Tdef) {
    *pnode = (*pnode)->u.tdef.type;
    *ptq |= NodeTypeQuals(*pnode);
  }
}

GLOBAL Bool TypeEqual(Node *node1, Node *node2)
{
  return TypeEqualQualified(node1, node2, TRUE, TRUE);
}


GLOBAL Bool TypeEqualQualified(Node *node1, Node *node2, Bool strict_toplevel, Bool strict_recursive)
{
  TypeQual tq1, tq2;

  assert(node1 && node2);

  UnwindTdefs(&node1, &tq1);
  UnwindTdefs(&node2, &tq2);

  if (!strict_toplevel) {
    tq1 &= ~TQ_COMPATIBLE;
    tq2 &= ~TQ_COMPATIBLE;
  }
    
  if (tq1 != tq2)
    return FALSE;

  if (node1->typ != node2->typ) return FALSE;

  switch (node1->typ) {
  case Prim:
    return (node1->u.prim.basic == node2->u.prim.basic);
  case Ptr:
    return TypeEqualQualified(node1->u.ptr.type, node2->u.ptr.type, strict_recursive, strict_recursive);

  case Adcl:
    if (!TypeEqualQualified(node1->u.adcl.type, node2->u.adcl.type, strict_recursive, strict_recursive))
      return FALSE;

    /* Either both dims are specified and the same or neither is */

    if (node1->u.adcl.dim)	/* original */
      if (node2->u.adcl.dim) {
	if (NodeIsConstant(node1->u.adcl.dim) &&
	    NodeIsConstant(node2->u.adcl.dim))
	  return IntegralConstEqual(node1->u.adcl.dim, node2->u.adcl.dim);
	else
	  return TRUE;  /* fix: what do we do if constant expressions
			   haven't been computed yet? */
      }
      else 
	return FALSE;
    else {
      node1->u.adcl.dim = node2->u.adcl.dim; /* set real dim in original */
      node1->u.adcl.type = node2->u.adcl.type; /* set real dim in original */
    }
    return TRUE;
  case Sdcl:
    /* This is the normal case */
    if (node1 == node2) return TRUE;

    /* Check the tags also in case we are still just scanning */
    return SUE_SameTagp(node1->u.sdcl.type, node2->u.sdcl.type);
  case Udcl:
    /* This is the normal case */
    if (node1 == node2) return TRUE;

    /* Check the tags also in case we are still just scanning */
    return SUE_SameTagp(node1->u.udcl.type, node2->u.udcl.type);
  case Edcl:
    /* This is the normal case */
    if (node1 == node2) return TRUE;

    /* Check the tags also in case we are still just scanning */
    return SUE_SameTagp(node1->u.edcl.type, node2->u.edcl.type);
  case Tdef:
    UNREACHABLE;  /* UnwindTdefs already removed this */
  case Fdcl:
    if (!TypeEqualQualified(node1->u.fdcl.returns, node2->u.fdcl.returns, strict_recursive, strict_recursive))
      return FALSE;
    
    /* if either list is "unspecified" (indicated by NULL value),
       assume comparison is successful */
    if (node1->u.fdcl.args == NULL || node2->u.fdcl.args == NULL)
      return TRUE;

    if (ListLength(node1->u.fdcl.args) != ListLength(node2->u.fdcl.args))
      return FALSE;

    {
      ListMarker marker1; Node *arg1;
      ListMarker marker2; Node *arg2;
      
      IterateList(&marker1, node1->u.fdcl.args);
      IterateList(&marker2, node2->u.fdcl.args);
      while (NextOnList(&marker1, (GenericREF) &arg1) 
	     && NextOnList(&marker2, (GenericREF) &arg2)) {
	if (arg1->typ == Decl) arg1 = arg1->u.decl.type;
	if (arg2->typ == Decl) arg2 = arg2->u.decl.type;
	if (!TypeEqualQualified(arg1, arg2, strict_recursive, strict_recursive))
	  return FALSE;
      }
    }
    return TRUE;

  default:
    FAIL("TypeEqual(): Unrecognized type");
  }
  return FALSE; /* eliminates warning */
}

