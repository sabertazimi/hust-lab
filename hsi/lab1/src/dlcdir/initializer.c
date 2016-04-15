/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  initializer.c,v
 * Revision 1.9  1995/04/21  05:44:23  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.8  1995/03/01  16:23:17  rcm
 * Various type-checking bug fixes; added T_REDUNDANT_EXTERNAL_DECL.
 *
 * Revision 1.7  1995/02/13  02:00:09  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.6  1995/02/01  21:07:18  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.5  1995/02/01  07:37:11  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.4  1995/01/27  01:39:00  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.3  1995/01/06  16:48:46  rcm
 * added copyright message
 *
 * Revision 1.2  1994/12/23  09:18:27  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.1  1994/12/20  09:20:27  rcm
 * Created
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
#pragma ident "initializer.c,v 1.9 1995/04/21 05:44:23 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"
#include "conversions.h"
#include "initializer.h"

PRIVATE Node *SemCheckInitList(Node *decl, Node *dtype, Node *init, Bool top_p);
PRIVATE void RequireConstantInitializer(Node *node);
PRIVATE Bool IsLinktimeConstant(Node *node);
PRIVATE Bool HasConstantAddress(Node *node);
PRIVATE Node *EnsureInitializerExpr(Node *init, Node *decl);



/*
   SemCheckDeclInit:  requires that decl->u.decl.init has already been 
                      SemCheck'ed.
*/

/* Initialization.  Section 6.5.7 */
GLOBAL void SemCheckDeclInit(Node *decl, Bool blockp)
{ Node *dtype = NodeDataType(decl->u.decl.type),
       *init  = decl->u.decl.init;

#if 0
  printf("\nSemCheckDeclInit\n");
  PrintNode(stdout, decl,  0); printf("\n");
  PrintNode(stdout, dtype, 0); printf("\n");
  PrintNode(stdout, init,  0); printf("\n");
#endif
 
  /* 
    The type of the entity to be initialized shall be an object 
    type or or an array of unknown size
  */
  if (IsObjectType(dtype) || IsUnsizedArray(dtype))
    ;
  else
    SyntaxErrorCoord(decl->coord,
		     "must be an Object or an incomplete array \"%s\"",
		     decl->u.decl.name);

 
  /* 
    The initializer for any variable at top-level or with block scope
    and static storage duration shall be a constant expression 
  */
  if (!blockp || DeclIsStatic(decl))
    RequireConstantInitializer(init);
  /*
    All the expressions in an initializer list for an object that
    has aggregate or union type shall be constant expressions.
  */
  else if ((IsAggregateType(dtype) || IsUnionType(dtype))
	   && init->typ == Initializer)
    RequireConstantInitializer(init);

  /*
    If the declaration of an identifier has block scope, and the identifier has
    external or internal linkage, the declaration shall have no initializer for
    the identifier
  */
  if (DeclIsExtern(decl)) {
      if (blockp){ 
	  SyntaxErrorCoord(decl->coord,
			   "cannot initialize \"extern\" declaration: \"%s\"",
			   decl->u.decl.name);
      }
      else {
	  WarningCoord(2, decl->coord,
		       "inadvisable to initialize \"extern\" declaration: \"%s\"",
		       decl->u.decl.name);
      }
  }

  /* Recursively walk the initialization list */
  if (IsInitializer(init))
    decl->u.decl.init = SemCheckInitList(decl, dtype, InitializerCopy(init), TRUE);
  else
    decl->u.decl.init = SemCheckInitList(decl, dtype, init, TRUE);

}



/****************************************************************************

  SemCheckInitList(Node *decl, Node *dtype, Node *init, Bool top_p)

  Recursively walk the initialization list 
       A) Verify that its shape matches the LHS
       B) Infer the size of unsized arrays
       C) Perform assignment conversions

  Decl is passed (from the root) to provide name/coord for error messages

 ****************************************************************************/

PRIVATE Node *SemCheckInitList(Node *decl, Node *dtype, Node *init, Bool top_p)
{ 
#if 0
  printf("\nSemCheckInitList(decl dtype init %d)\n", top_p);
  PrintNode(stdout, dtype, 0); printf("\n");
  PrintNode(stdout, init,  0); printf("\n");
#endif

  if (IsScalarType(dtype)) 
    if (IsInitializer(init))
      { Node *val = InitializerFirstItem(init);

	/* Swallow the first element of the list */
	InitializerNext(init);

	/* If at top-level then complain if list is not empty */
	if (top_p && !InitializerEmptyList(init))
	  SyntaxErrorCoord(decl->coord,
			   "too many initializers for scalar \"%s\"",
			   decl->u.decl.name);

	if (IsInitializer(val)) 
	  {
	    SyntaxErrorCoord(decl->coord,
			     "initializer for scalar \"%s\" requires one element",
			     decl->u.decl.name);
	    return NULL;
	  }
	else
	  return AssignmentConversions(val, dtype);
      }
    else
      return AssignmentConversions(init, dtype);

  else if (IsArrayType(dtype))
    if (IsArrayOfChar(dtype) && 
	(IsStringConstant(init) || 
	 (IsInitializer(init)      &&
	  InitializerLength(init) == 1 &&
	  IsStringConstant(InitializerFirstItem(init)))))
      { Node *sinit = IsInitializer(init) ? InitializerFirstItem(init) : init,
	     *dim   = dtype->u.adcl.dim;
	const char *string = NodeConstantStringValue(sinit), *ptr = string;
	List *result   = NULL;
        int   count    = 0, 
              maxcount = (dim) ? NodeConstantIntegralValue(dim) : -1;

	while ((maxcount == -1 || count < maxcount) && *ptr)
	  { 
	    result = AppendItem(result, MakeConstSint(*ptr));
	    count++;
	    ptr++;
	  }

	/* If the decl is an array of undefined size, then set it now */
	if (dtype->u.adcl.dim == NULL) 
	  { Node *etype  = NodeDataType(dtype->u.adcl.type);
	  
	    result = AppendItem(result, MakeConstSint('\0'));
	    count++;
	    dtype->u.adcl.dim  = MakeImplicitCast(PrimSint, NULL);
	    NodeSetSintValue(dtype->u.adcl.dim, count);
	    dtype->u.adcl.size = count * NodeSizeof(dtype, etype);
	  }
	else if (maxcount > count)
	  result = AppendItem(result, MakeConstSint('\0'));
	else if (*ptr == '\0')
	  ;
	else
	  WarningCoord(1, decl->coord, 
		       "%d extra byte(s) in string literal initalizer ignored",
		       strlen(ptr));
#if 0
/* don't change the initializer -- memory leak -- rcm */
	return MakeInitializerCoord(result, init->coord);
#endif
	return init;
      }
    else if (!IsInitializer(init)) {
      /* initializing an aggregate or union with a single expression of same
	 type:  eg "struct foo f = g;" */
      return AssignmentConversions(init, dtype);      
    }
    else
      { Node *atype    = ArraySubtype(dtype),
	     *ilist    = EnsureInitializerExpr(init, decl),
             *result   = MakeInitializerCoord(NULL, init->coord),
	     *dim      = dtype->u.adcl.dim;
        int   count    = 0, 
              maxcount = (dim) ? NodeConstantIntegralValue(dim) : -1;

	while ((maxcount == -1 || count < maxcount) && !InitializerEmptyList(ilist))
	  { Node *item = InitializerFirstItem(ilist);

	    if (IsInitializer(item))
	      { Node *val = SemCheckInitList(decl, atype, InitializerCopy(item), TRUE);

		InitializerAppendItem(result, val);
		InitializerNext(ilist);
	      }
	    else
	      { Node *val = SemCheckInitList(decl, atype, ilist, FALSE);

		InitializerAppendItem(result, val);
	      }

	    count++;
	  }

	/* If the decl is an array of undefined size, then set it now */
	if (dtype->u.adcl.dim == NULL) 
	  { Node *etype  = NodeDataType(dtype->u.adcl.type);
	  
	    dtype->u.adcl.dim  = MakeImplicitCast(PrimSint, NULL);
	    NodeSetSintValue(dtype->u.adcl.dim, count);
	    dtype->u.adcl.size = count * NodeSizeof(dtype, etype);
	  }
	else if (top_p && !InitializerEmptyList(ilist))
	  SyntaxErrorCoord(decl->coord,
			   "too many array initializers: \"%s\"",
			   decl->u.decl.name);

	return result;
      }

  else if (IsStructType(dtype)) 
    if (!IsInitializer(init))
      return AssignmentConversions(init, dtype);      
    else return SUE_MatchInitList(StructUnionFields(dtype), 
				  decl,
				  EnsureInitializerExpr(init, decl),
				  top_p);

  else if (IsUnionType(dtype))
    if (!IsInitializer(init))
      return AssignmentConversions(init, dtype);      
    else { 
      Node *uinit = EnsureInitializerExpr(init, decl);

      return SemCheckInitList(decl, 
			      NodeDataType(UnionFirstField(dtype)),
			      uinit, 
			      top_p);
    }

  else 
    {
      SyntaxErrorCoord(decl->coord, 
		       "Expression cannot have an initializer \"%s\"", 
		       decl->u.decl.name);
      PrintNode(stdout, dtype, 0);
      printf("\n");
      return NULL;
    }
}

PRIVATE void RequireConstantInitializer(Node *node)
{
  assert(node);

  if (node->typ == Initializer) {
    ListMarker marker; Node *n;
  
    IterateList(&marker, node->u.initializer.exprs);
    while (NextOnList(&marker, (GenericREF) &n))
      RequireConstantInitializer(n);
  }

  else if (!IsLinktimeConstant(node))
    SyntaxErrorCoord(node->coord, "initializer must be constant");
}

PRIVATE Bool IsLinktimeConstant(Node *node)
{
  /* if node is compile-time constant, then certainly it's
     link-time */
  if (NodeIsConstant(node))
    return TRUE;


  /* otherwise check special cases */
  switch (node->typ) {
  case Id:{
    Node *decl = node->u.id.decl;
    Node *declType = NodeDataType(decl);

    /* global/static array and function name are link-time constants */
    return (IsArrayType(declType) && HasConstantAddress(node))
      || IsFunctionType(declType);
    }

  case Unary:
    if (node->u.unary.op == ADDRESS)
      return HasConstantAddress(node->u.unary.expr);

  case Binop: {
    OpType op = node->u.binop.op;
    Node *left = node->u.binop.left;
    Node *right = node->u.binop.right;

    /* check for pointer arithmetic involving constant addresses */
    if (op == '+' || op == '-') {
      return IsLinktimeConstant(left) && IsLinktimeConstant(right);
    }
    else if (op == '.') {
      return IsArrayType(node->u.binop.type) && HasConstantAddress(left);
    } 
    else {
      return FALSE;
    }
  }

  case Cast:
    /* casts are ignored */
    return IsLinktimeConstant(node->u.cast.expr);

  case ImplicitCast:
    return IsLinktimeConstant(node->u.implicitcast.expr);

  default:
    return FALSE;
  }
}


PRIVATE Bool HasConstantAddress(Node *node)
{
  assert(node);

  switch (node->typ) {
  case Id: {
    Node *decl = node->u.id.decl;

    /* global/static variable always has constant address */
    return (DeclIsExternal(decl) || DeclIsStatic(decl));
    }

  case Binop: {
    OpType op = node->u.binop.op;

    /* structure/union field reference has constant address iff
       structure does */
    if (op == '.')
      return HasConstantAddress(node->u.binop.left);
    else if (op == ARROW)
      return IsLinktimeConstant(node->u.binop.left);
    else return FALSE;
  }

  case Array: {
    ListMarker marker; Node *n;
  
    /* array reference has constant address iff name and all dimensions
       are linktime constants */
    if (!IsLinktimeConstant(node->u.array.name))
      return FALSE;

    IterateList(&marker, node->u.array.dims);
    while (NextOnList(&marker, (GenericREF) &n))
      if (!IsLinktimeConstant(n))
	return FALSE;
    return TRUE;
  }
    
  case Cast:
    /* casts are ignored */
    return HasConstantAddress(node->u.cast.expr);

  case ImplicitCast:
    return HasConstantAddress(node->u.implicitcast.expr);

  default:
    return FALSE;
  }
}

PRIVATE Node *EnsureInitializerExpr(Node *init, Node *decl)
{
  if (IsInitializer(init))
    return init;

  WarningCoord(1, decl->coord, 
	       "{}-enclosed initializer required \"%s\"",
	       decl->u.decl.name);
  return MakeInitializerCoord(MakeNewList(init), init->coord);
}


GLOBAL Bool IsInitializer(Node *node)
{
  assert(node);
  return node->typ == Initializer;
}

GLOBAL Node *InitializerCopy(Node *node)
{
  assert(node);
  assert(node->typ == Initializer);
  return NodeCopy(node, NodeOnly);
}

GLOBAL int InitializerLength(Node *node)
{
  assert(node);
  assert(node->typ == Initializer);
  return (ListLength(node->u.initializer.exprs));
}

GLOBAL Node *InitializerFirstItem(Node *node)
{
  assert(node);
  assert(node->typ == Initializer);

  return FirstItem(node->u.initializer.exprs);
}

GLOBAL List *InitializerExprs(Node *node)
{ 
  assert(node);
  assert(node->typ == Initializer);
  return node->u.initializer.exprs;
}

GLOBAL Bool InitializerEmptyList(Node *node)
{
  assert(node);
  assert(node->typ == Initializer);
  return node->u.initializer.exprs == NULL;
}

GLOBAL void InitializerNext(Node *node)
{
  assert(node);
  assert(node->typ == Initializer);
  node->u.initializer.exprs = Rest(node->u.initializer.exprs);
}

GLOBAL Node *InitializerAppendItem(Node *initializer, Node *element)
{
  assert(initializer);
  assert(initializer->typ == Initializer);
  initializer->u.initializer.exprs = AppendItem(initializer->u.initializer.exprs, element);
  return initializer;
}

GLOBAL Node *ArraySubtype(Node *node)
{
  assert(node);
  assert(node->typ == Adcl);
  return NodeDataType(node->u.adcl.type);
}

GLOBAL int ArrayNumberElements(Node *node)
{ int total;

  assert(node);
  assert(node->typ == Adcl);

  for (total = 1; node->typ == Adcl; node = node->u.adcl.type) 
    {
      assert(node->u.adcl.dim);
      total = total * NodeConstantIntegralValue(node->u.adcl.dim);
    }

  return total;
}

GLOBAL SUEtype *StructUnionFields(Node *node)
{
  assert(node);

  if (node->typ == Sdcl)
    return node->u.sdcl.type;
  else if (node->typ == Udcl)
    return node->u.udcl.type;
  else
    assert(FALSE);
  UNREACHABLE;
  return NULL; /* eliminates warning */
}

GLOBAL Node *UnionFirstField(Node *node)
{
  assert(node);
  assert(node->typ == Udcl);
  return FirstItem(node->u.udcl.type->fields);
}


GLOBAL Node *SUE_MatchInitList(SUEtype *sue, Node *decl, Node *initializer, Bool top_p)
{ ListMarker marker;
  Node *field;
  List *result = NULL;

  /* Loop over the fields of the SDCL */
  IterateList(&marker, sue->fields);
  while (NextOnList(&marker, (GenericREF) &field) && !InitializerEmptyList(initializer)) 
    { Node *val   = InitializerFirstItem(initializer),
           *ftype = NodeDataType(field->u.decl.type);

      InitializerNext(initializer);

      if (IsInitializer(val)) {
	Node *new = SemCheckInitList(decl, ftype, InitializerCopy(val), TRUE);
	result = AppendItem(result, new);
      }
      else
	result = AppendItem(result, AssignmentConversions(val, ftype));
    }

  /* If at top-level then complain if list is not empty */
  if (top_p && !InitializerEmptyList(initializer))
    SyntaxErrorCoord(decl->coord,
		     "too many struct/union initializers for \"%s\"",
		     decl->u.decl.name);

  return MakeInitializerCoord(result, initializer->coord);
}
