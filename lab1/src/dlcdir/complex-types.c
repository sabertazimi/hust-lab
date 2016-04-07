/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  complex-types.c,v
 * Revision 1.18  1995/05/11  18:54:16  rcm
 * Added gcc extension __attribute__.
 *
 * Revision 1.17  1995/04/21  05:44:09  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.16  1995/03/23  15:31:02  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.15  1995/03/01  16:23:14  rcm
 * Various type-checking bug fixes; added T_REDUNDANT_EXTERNAL_DECL.
 *
 * Revision 1.14  1995/02/13  02:00:06  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.13  1995/02/01  23:23:43  rcm
 * Added warning for use of inline with -ansi
 *
 * Revision 1.12  1995/02/01  23:00:06  rcm
 * Removed some dead code.
 *
 * Revision 1.11  1995/02/01  21:07:12  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.10  1995/02/01  07:36:55  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.9  1995/01/27  01:38:54  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.8  1995/01/25  02:16:16  rcm
 * Changed how Prim types are created and merged.
 *
 * Revision 1.7  1995/01/11  17:18:19  rcm
 * Anonymous struct/union/enums now given arbitrary unique tag.
 *
 * Revision 1.6  1995/01/06  16:48:37  rcm
 * added copyright message
 *
 * Revision 1.5  1994/12/20  09:23:55  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.4  1994/11/22  01:54:28  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.3  1994/11/10  03:13:12  rcm
 * Fixed line numbers on AST nodes.
 *
 * Revision 1.2  1994/10/28  18:52:15  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Tue Apr 27 15:18:50 EDT 1993
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
#pragma ident "complex-types.c,v 1.18 1995/05/11 18:54:16 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"





/* SetBaseType:
   Follow chain of pointers, arrays, and functions to bottom,
   then set the base type, which should be NULL coming in.

   Example:
         In: base=int, complex=(Ptr (Adcl NULL))
                               [pointer to an array of ???]
	 Out:  (Ptr (Adcl int))
               [pointer to an array of int]
	 In: base=void, complex=(Ptr (Fdcl (int) NULL))
	                        [pointer to a function from int to ???]
	 Out:  (Ptr (Fdcl (int) void))
	       [pointer to a function from int to void]
*/

GLOBAL Node *SetBaseType(Node *complex, Node *base)
{
    Node *chain = complex;

    assert(complex != NULL);

    for (;;) {
	switch (chain->typ) {
	  case Ptr:
	    if (chain->u.ptr.type == NULL) {
		chain->u.ptr.type = base;
		return(complex);
	    } else {
		chain = chain->u.ptr.type;
	    }
	    continue;
	  case Adcl:
	    if (chain->u.adcl.type == NULL) {
		chain->u.adcl.type = base;
		return(complex);
	    } else {
		chain = chain->u.adcl.type;
	    }
	    continue;
	  case Fdcl:
	    if (chain->u.fdcl.returns == NULL) {
		chain->u.fdcl.returns = base;
		return(complex);
	    } else {
		chain = chain->u.fdcl.returns;
	    }
	    continue;
	  default:
	    Warning(1, "Internal Error!: invalid `complex' arg\n");
	    PrintNode(stderr, complex, 0);
	    fprintf(stderr, "\n");
	    exit(1);
	    return(complex);  /* unreachable */
	}
    }
    /* unreachable */
}


GLOBAL Node *GetShallowBaseType(Node *complex)
{
  assert(complex != NULL);
  switch (complex->typ) {
  case Ptr:
    return complex->u.ptr.type;
  case Adcl:
    return complex->u.adcl.type;
  case Fdcl:
    return complex->u.fdcl.returns;
  default:
    return complex;
  }
}


GLOBAL Node *GetDeepBaseType(Node *complex)
{
    Node *chain = complex;

    assert(complex != NULL);

    for (;;) {
	assert(chain != NULL);
	switch (chain->typ) {
	  case Ptr:
	    chain = chain->u.ptr.type;
	    continue;
	  case Adcl:
	    chain = chain->u.adcl.type;
	    continue;
	  case Fdcl:
	    chain = chain->u.fdcl.returns;
	    continue;
	  default:
	    return(chain);
	}
    }
    /* unreachable */
}

GLOBAL Node *ExtendArray(Node *array, Node *dim, Coord coord)
{
    assert(array != NULL);
    if (array->typ == Array) {
	AppendItem(array->u.array.dims, dim);
	return array;
    } else {
	return MakeArrayCoord(array, MakeNewList(dim), coord);
    }
}

#if 0
GLOBAL Node *AddArrayDimension(Node *array, Node *dim)
{
    assert(array != NULL  &&  array->typ == Adcl);
    assert(array->u.adcl.dims != NULL);
    AppendItem(array->u.adcl.dims, dim);
    return(array);
}
#endif

/* ModifyDeclType:
   Modifies a current declaration with a pointer/array/function.
   Example:
      in: decl=(Decl x int NULL)  mod=(Ptr NULL)
      out: (Decl x (Ptr int) NULL)
*/
GLOBAL Node *ModifyDeclType(Node *decl, Node *mod)
{
    assert(decl != NULL && decl->typ == Decl);
    assert(mod != NULL &&
	   (mod->typ == Ptr || mod->typ == Adcl || mod->typ == Fdcl));
    if (decl->u.decl.type == NULL)
      decl->u.decl.type = mod;
    else
      decl->u.decl.type = SetBaseType(decl->u.decl.type, mod);
    return(decl);
}


PRIVATE void extern_conflict(Node *orig, Node *create)
{
  assert(orig   && orig->typ == Decl);
  assert(create && create->typ == Decl);

  /* "external declarations for the same identifier must agree in
     type and linkage" --  K&R2, A10.2 */
  if (!TypeEqual(orig->u.decl.type, create->u.decl.type))
    {
      SyntaxErrorCoord(create->coord,
		       "extern `%s' redeclared", VAR_NAME(orig));
      fprintf(stderr, "\tPrevious declaration: ");
      PRINT_COORD(stderr, orig->coord);
      fputc('\n', stderr);
      orig->u.decl.type = create->u.decl.type;
      orig->coord = create->coord;
    }
}

PRIVATE void var_conflict(Node *orig, Node *create)
{
    /* the two are equal for redundant function/extern declarations */
    if (orig != create)
      SyntaxErrorCoord(create->coord,
		       "variable `%s' redeclared", VAR_NAME(orig));
}


GLOBAL Node *SetDeclType(Node *decl, Node *type, ScopeState redeclare)
{
    TypeQual sc;
    Node *var;

#if 0
    printf("\nSetDeclType(decl, type, %d)\n", redeclare);
    PrintNode(stdout, decl, 0); printf("\n");
    PrintNode(stdout, type, 0); printf("\n");
#endif

    assert(decl != NULL && decl->typ == Decl);
    assert(type != NULL && IsType(type));

    if (decl->u.decl.type == NULL) {
	decl->u.decl.type = type;
    } else {  /* must be pointer/array/function of 'type' */
	decl->u.decl.type = SetBaseType(decl->u.decl.type, type);
    }

    if (type->typ == Ptr  ||  type->typ == Adcl  || type->typ == Fdcl) {
	/* these three will call SetDeclType again when
	   their base type is set */
	return(decl);
    }

/*******************************************************

  Hereafter we finish up the decl, cleaning it up, moving
  storage classes to Decl node, and inserting it in the
  symbol table.

********************************************************/

    decl = FinishDecl(decl);
    sc = NodeStorageClass(decl);

    if (OldStyleFunctionDefinition) {
	/* this declaration is part of an old-style function definition,
	   so treat it as a formal parameter */
	if (redeclare != SU) redeclare = Formal;
    }

    if (sc == T_TYPEDEF) {
      var = decl;
    } else if (decl->u.decl.type->typ == Fdcl && (redeclare != Formal)) {

        /* the formal parameter line was added by Manish 2/2/94  this fixes bugs
	   like :  
                  int a(int f(int,int))
                  {}
                  
                  int b(int f(double,float)) 
                  {} 


		  */

	/* if the arglist contains Id's, then we are in the middle of
	   an old-style function definition, so don't insert the symbol.
	   It will be inserted by DefineProc */
	List *args = decl->u.decl.type->u.fdcl.args;

	if (args) {
	    Node *first_arg = FirstItem(args);
	    if (first_arg->typ == Id) return(decl);
	}

	/* normal function declaration, check for consistency with Externals */
	var = InsertSymbol(Externals, 
			   decl->u.decl.name, 
			   decl,
			   (ConflictProc) FunctionConflict);
    } else if (sc == T_EXTERN ||
	       (Level == 0  &&  redeclare == Redecl)) {
	/* top-level variable, check for consistency with Externals */
	var = InsertSymbol(Externals, decl->u.decl.name, decl,
			   (ConflictProc) extern_conflict);
    } else var = decl;

    /* 
     * Check if decl is a redundant external declaration.  (See
     * description of T_REDUNDANT_EXTERNAL_DECL in ast.h.)
     */
    if (var != decl) {
      /* Name was already in Externals symbol table, so possibly redundant.
	 Look for previous declaration in scope */
      Generic *trash;
      if (LookupSymbol(Identifiers, decl->u.decl.name, &trash))
	/* decl could be redundant, but we don't know if it's a 
	   definition or declaration yet.  Mark it, and let SetDeclInit
	   decide. */
	NodeAddTq(decl, T_REDUNDANT_EXTERNAL_DECL);
    }

    switch (redeclare) {
      case NoRedecl:
	if (IsAType(decl->u.decl.name)) {
	    SyntaxErrorCoord(decl->coord,
			"illegal to redeclare typedef `%s' with default type",
		        decl->u.decl.name);
	}
	/* falls through to Redecl */
      case Redecl:
	NodeSetDeclLocation(decl, Level == 0 ? T_TOP_DECL : T_BLOCK_DECL);

	/* add to current scope */
	InsertSymbol(Identifiers, decl->u.decl.name, var,
		     (ConflictProc) var_conflict);
	break;
      case SU:
	NodeSetDeclLocation(decl, T_SU_DECL);

	/* each struct/union has it own namespace for fields */
	break;
      case Formal:
	NodeSetDeclLocation(decl, T_FORMAL_DECL);

	if (sc != 0  &&  sc != T_REGISTER) {
	    SyntaxErrorCoord(decl->coord,
			     "illegal storage class for parameter `%s'",
			     decl->u.decl.name);
	    if (sc == T_TYPEDEF) break;
	    /* reset storage class for body */
	    NodeSetStorageClass(decl, 0);
	}

	/* convert Adcl to pointer */
	{
	  Node *decltype = decl->u.decl.type;
	  
	  if (decltype->typ == Adcl)
	    decl->u.decl.type = MakePtrCoord(decltype->u.adcl.tq,
					     decltype->u.adcl.type,
					     decltype->coord);
	}	

	/* formals are not in scope yet; either
	   1) this is only a function declaration, in which case the
	      identifiers are only for documentation,  or
	   2) this is part of a function definition, in which case the
	      formal are not in scope until the upcoming function body.
	      In this case, the formals are added by DefineProc just
	      before the body is parsed. */
	break;
    }
    return(decl);
}


GLOBAL Node *SetDeclInit(Node *decl, Node *init)
{
    assert(decl != NULL  &&  decl->typ == Decl);
    assert(decl->u.decl.init == NULL);
    decl->u.decl.init = init;


    if (init) {
      if (NodeTq(decl) & T_REDUNDANT_EXTERNAL_DECL)
	/* fix up misprediction made in SetDeclType.  
	   decl has an initializer, so it isn't redundant. */
	NodeRemoveTq(decl, T_REDUNDANT_EXTERNAL_DECL);
      
    }

    return(decl);
}

GLOBAL Node *SetDeclBitSize(Node *decl, Node *bitsize)
{
    assert(decl != NULL  &&  decl->typ == Decl);
    assert(decl->u.decl.bitsize == NULL);
    decl->u.decl.bitsize = bitsize;
    return(decl);
}

GLOBAL Node *SetDeclAttribs(Node *decl, List *attribs)
{
    assert(decl != NULL  &&  decl->typ == Decl);
    assert(decl->u.decl.attribs == NULL);
    decl->u.decl.attribs = attribs;
    return(decl);
}

/*
   FinishDecl moves declaration qualifiers from the type to the Decl node,
   and does various other operations to turn a Decl into its final
   form.

   WARNING:  FinishDecl may be run more than once on a decl, so it
   should not blindly make unnecessary changes.
*/
GLOBAL Node *FinishDecl(Node *decl)
{
  Node *deepbasetype;
  TypeQual tq, sc;

  assert(decl->typ == Decl);

  decl->u.decl.type = FinishType(decl->u.decl.type);
  deepbasetype = GetDeepBaseType(decl->u.decl.type);

  /* move decl qualifiers to decl */
  tq = NodeTq(deepbasetype);
  NodeRemoveTq(deepbasetype, T_DECL_QUALS);
  NodeAddTq(decl, DECL_QUALS(tq));
  sc = STORAGE_CLASS(tq);

  /* check for incomplete struct/union/enum */
  if (sc != T_TYPEDEF) VerifySUEcomplete(decl->u.decl.type);
  
  return decl;
}



/* 
   FinishType performs consistency checks that can't be conveniently 
   expressed in the grammar, some time after the type has been
   constructed.  It is called for both declarations and type names
   (such as in a cast or sizeof expression). 

   WARNING:  FinishType may be run more than once on a type, so it
   should not blindly make unnecessary changes.
*/
GLOBAL Node *FinishType(Node *type)
{
  Node *deepbasetype = GetDeepBaseType(type);
  TypeQual basetq = NodeTq(deepbasetype);

  if (basetq & T_INLINE) {
    if (ANSIOnly)
      SyntaxError("inline keyword not allowed with -ansi switch");
    else if (!IsFunctionType(type))
      WarningCoord(1, type->coord, 
		   "inline qualifier applies only to functions");
    else NodeAddTq(type, T_INLINE);
    NodeRemoveTq(deepbasetype, T_INLINE);
  }

  /* Insert your extensions here */

  return type;
}



/* 
  Append decl adds decl to list, giving it the same type and declaration
   qualifiers as the decls already on list.
*/
GLOBAL List *AppendDecl(List *list, Node *decl, ScopeState redeclare)
{
    Node *firstdecl, *type;

    if (list == NULL)
      return NULL;

    assert(decl != NULL  && decl->typ == Decl);

    firstdecl = FirstItem(list);
    assert(firstdecl != NULL  &&  firstdecl->typ == Decl);
    assert(firstdecl->u.decl.type != NULL);

    type = NodeCopy(GetDeepBaseType(firstdecl->u.decl.type), NodeOnly);

    AppendItem(list, SetDeclType(decl, type, redeclare));
    decl->u.decl.tq |= firstdecl->u.decl.tq;

    return(list);
}

