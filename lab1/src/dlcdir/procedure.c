/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  procedure.c,v
 * Revision 1.16  1995/04/21  05:44:38  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.15  1995/04/09  21:30:52  rcm
 * Added Analysis phase to perform all analysis at one place in pipeline.
 * Also added checking for functions without return values and unreachable
 * code.  Added tests of live-variable analysis.
 *
 * Revision 1.14  1995/03/23  15:31:23  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.13  1995/02/13  02:00:21  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.12  1995/02/01  21:07:25  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.11  1995/02/01  07:37:57  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.10  1995/01/27  01:39:06  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.9  1995/01/25  02:16:21  rcm
 * Changed how Prim types are created and merged.
 *
 * Revision 1.8  1995/01/20  03:38:13  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.7  1995/01/06  16:49:00  rcm
 * added copyright message
 *
 * Revision 1.6  1994/12/23  09:18:38  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.5  1994/12/20  09:24:13  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.4  1994/11/22  01:54:43  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.3  1994/11/10  03:13:30  rcm
 * Fixed line numbers on AST nodes.
 *
 * Revision 1.2  1994/10/28  18:52:52  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Fri May  7 10:21:56 EDT 1993
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
#pragma ident "procedure.c,v 1.16 1995/04/21 05:44:38 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"
#include "conversions.h" /* for UsualUnaryConversionsType */

/************************************************************************
* FunctionConflict
*
* This routine is called if a function declaration, i.e. an Fdcl, is parsed 
* and there is already a declaration.
*
* In general, either of ORIG or NEW could be a declaration,
* a prototype, or the start of a function definition and it is not possible to
* tell which is which.  In particular, the expression 
*
*       int f()
*
* may be an old-style function declaration that permits an arbitrary number
* of arguments of types compatible with "the usual unary conversions" or it
* may be a function definition for a function with no arguments.
* 
* We assume that
* In a "standard" program, the original expression is an ANSI-C prototype
* and the create expression is the function declaration
*
* In the general case, this confirms that the two specifications are
* the same.  If the create declaration forces a revision of the old one
*
*     e.g.    int foo();
*             int foo(void) { ... }
*
* then it is required that the OLD one be mutated accordingly since there
* are already references to the old one
*
\***********************************************************************/

/* Must mutate original if changes required for consistency */
GLOBAL void FunctionConflict(Node *orig, Node *create)
{ Node *ofdcl, *nfdcl;

  assert(orig);
  assert(create);
  assert(orig->typ == Decl);
  assert(create->typ == Decl);

#if 0
  printf("\nFunctionConflict\n");
  PrintNode(stdout, orig, 0);
  printf("\n");
  PrintNode(stdout, create,  0);
  printf("\n\n");
#endif

  ofdcl = orig->u.decl.type;
  nfdcl = create->u.decl.type;
  
  if (ofdcl->typ != Fdcl || nfdcl->typ != Fdcl)
    goto Mismatch;

  assert(ofdcl->typ == Fdcl);
  assert(nfdcl->typ == Fdcl);

  /* The Result Type must be equal */
  if (!TypeEqual(ofdcl->u.fdcl.returns, nfdcl->u.fdcl.returns))
    goto Mismatch;

  /* Inspect the parameter lists */
  { List *optr = ofdcl->u.fdcl.args,
         *nptr = nfdcl->u.fdcl.args;

    /* Are both definitions in prototype form? */
    if (optr && nptr) {

      /* Then every parameter must be compatible */
      for ( ; optr && nptr; optr = Rest(optr), nptr = Rest(nptr)) {
	Node *oitem = FirstItem(optr),
	     *otype = NodeDataTypeSuperior(oitem),
             *nitem = FirstItem(nptr),
             *ntype = NodeDataTypeSuperior(nitem);

#if 0
	printf("CheckParam\n");
	PrintNode(stdout, oitem, 0); printf("\n");
	PrintNode(stdout, nitem, 0); printf("\n");
	printf("\n");
#endif

	if (!TypeEqual(otype, ntype)) {
	  SetItem(optr, nitem);
	  goto Mismatch;
	}
      }

      /* And the parameter lists must be of the same length */
      if (optr || nptr)
	goto Mismatch;
    }

    /* Check for <Type> f(void)  vs  <Type> f() */
    else if (IsVoidArglist(optr))
      ;
    
    /* Check for <Type> f()  vs  <Type> f(void) */
    else if (IsVoidArglist(nptr))
      ofdcl->u.fdcl.args = MakeNewList(PrimVoid);
    
    /* Else the provided types must be the "usual unary conversions" */
    else {

      /* Either this loop will run */
      for ( ; optr; optr = Rest(optr)) {
	Node *oitem = FirstItem(optr),
	     *otype = NodeDataType(oitem);

	if (!TypeEqual(otype, UsualUnaryConversionType(otype)) ||
	    IsEllipsis(otype))
	  goto Mismatch;
      }

      /* Or this one will */
      for ( ; nptr; nptr = Rest(nptr)) {
	Node *nitem = FirstItem(nptr),
	     *ntype = NodeDataType(nitem);
#if 0
	printf("\nCheckArg\n");
	PrintNode(stdout, nitem, 0); printf("\n");
	PrintNode(stdout, ntype, 0); printf("\n");
	PrintNode(stdout, UsualUnaryConversionType(ntype), 0); 
	printf("\n");
#endif

	if (!TypeEqual(ntype, UsualUnaryConversionType(ntype)) ||
	    IsEllipsis(ntype))
	  goto Mismatch;
      }
    }
  }

  return;

 Mismatch:
  SyntaxErrorCoord(create->coord,
		   "identifier `%s' redeclared", VAR_NAME(orig));
  fprintf(stderr, "\tPrevious declaration: ");
  PRINT_COORD(stderr, orig->coord);
  fputc('\n', stderr);
  return;
}

#if 0
/* DEAD CODE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */
GLOBAL Bool IsCompatibleFdcls(Node *node1, Node *node2)
{
  assert(node1->typ == Fdcl);
  assert(node2->typ == Fdcl);

#if 0
  printf("IsCompatibleFdcls\n");
  PrintNode(stdout, node1, 0); printf("\n");
  PrintNode(stdout, node2, 0); printf("\n");
#endif

  /* The Result Type must be equal */
  if (!TypeEqual(node1->u.fdcl.returns, node2->u.fdcl.returns))
    return FALSE;

  /* Inspect the parameter lists */
  { List *optr = node1->u.fdcl.args,
         *nptr = node2->u.fdcl.args;

    /* Are both definitions in prototype form? */
    if (optr && nptr) {

      /* Then every parameter must be compatible */
      for ( ; optr && nptr; optr = Rest(optr), nptr = Rest(nptr)) {
	Node *oitem = FirstItem(optr),
	     *otype = NodeDataType(oitem),
             *nitem = FirstItem(nptr),
             *ntype = NodeDataType(nitem);

	if (!TypeEqual(otype, ntype)) {
#if 0
	  PrintNode(stdout, otype, 0); printf("\n");
	  PrintNode(stdout, ntype, 0); printf("\n");
#endif
	  return FALSE;
	}
      }

      /* And the parameter lists must be of the same length */
      if (optr || nptr)
	return FALSE;
      else
	return TRUE;
    }

    /* Check for <Type> f(void)  vs  <Type> f() */
    else if (IsVoidArglist(optr))
      return TRUE;

    /* Check for <Type> f()  vs  <Type> f(void) */
    else if (IsVoidArglist(nptr))
      return TRUE;
    
    /* Else the provided types must be the "usual unary conversions" */
    else {

      /* Either this loop will run */
      for ( ; optr; optr = Rest(optr)) {
	Node *oitem = FirstItem(optr),
	     *otype = NodeDataType(oitem);

	if (!TypeEqual(otype, UsualUnaryConversionType(otype)) ||
	    IsEllipsis(otype))
	  return FALSE;
      }

      /* Or this one will */
      for ( ; nptr; nptr = Rest(nptr)) {
	Node *nitem = FirstItem(nptr),
	     *ntype = NodeDataType(nitem);

	if (!TypeEqual(ntype, UsualUnaryConversionType(ntype)) ||
	    IsEllipsis(ntype))
	  return FALSE;
      }

      return TRUE;
    }
  }
}
/* DEAD CODE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */
#endif

/************************************************************************
* Routines for building Proc nodes
\***********************************************************************/

PRIVATE Node *CurrentProc = NULL;


/* formal_conflict handles conflicts between a formal and
   something of the same name in the same scope.  Since formals
   are added at the beginning of the body (and the scope), the
   only conflict can be with earlier formals for the same procedure */

PRIVATE void formal_conflict(Node *orig, Node *create)
{
    SyntaxErrorCoord(create->coord,
		     "formal `%s' used multiple times", VAR_NAME(orig));
}



GLOBAL Node *DefineProc(Bool old_style, Node *decl)
{
    Node *fdcl, *arg;
    ListMarker marker;
    extern char *yytext;
    Bool first;

    assert(decl != NULL  &&  decl->typ == Decl);
    fdcl = decl->u.decl.type;
    assert(fdcl != NULL);
    if (fdcl->typ != Fdcl) 
      {
	SyntaxErrorCoord(decl->coord, "expecting a function definition");
	return(decl);
      }

#if 0
    printf("\nDefineProc(%d, decl)\n", old_style);
    PrintNode(stdout, decl, 0);
    printf("\n");
#endif

    /* since the parser uses the '{' to determine that
       this is a definition, we know that yylex() just returned
       the '{' and so has entered the scope for the upcoming body. */
    assert(*yytext == '{'); /* verify that last token was '{' */
    assert(Level == 0);

    decl = FinishDecl(decl);
    NodeSetDeclLocation(decl, T_TOP_DECL);

    /* 
       We know that this is a function definition, rather than merely a
       declaration.  Convert an empty arglist to (void) and then recheck
       the definition against the external scope (where the previous
       declarations will be).
    */
    if (fdcl->u.fdcl.args == NULL) 
      {
	fdcl->u.fdcl.args = MakeNewList(MakePrimCoord(EMPTY_TQ, Void, fdcl->coord));

	/* Recheck against the prototype */
	InsertSymbol(Externals, 
		     decl->u.decl.name,
		     decl,
		     (ConflictProc) FunctionConflict);
      }

    if (old_style) 
      {	Node *var = decl;

	/* Convert any formals of type ID to the default DECL */
	IterateList(&marker, fdcl->u.fdcl.args);
	while (NextOnList(&marker, (GenericREF) &arg))
	  if (arg->typ == Id)
	    ConvertIdToDecl(arg, T_FORMAL_DECL, 
			    MakeDefaultPrimType(EMPTY_TQ, arg->coord),
			    NULL, NULL);
	
#if 0
/* now done in SetDeclType -- rcm */
	/* 
	  Convert any Adcls to Ptr.  
	  This is done in ANSI.y for prototypes and for ANSI defn's
	  */
	IterateList(&marker, fdcl->u.fdcl.args);
	while (NextOnList(&marker, (GenericREF) &arg))
	  AdclFdclToPtr(arg);
#endif

	/* insert the declaration (for the first time) */
	var = InsertSymbol(Externals, decl->u.decl.name, var,
			   (ConflictProc) FunctionConflict);
	InsertSymbol(Identifiers, decl->u.decl.name, var,
		     (ConflictProc) FunctionConflict);
#if 0
/* under new scoping protocol, name of procedure is already at
   external definition level -- rcm */
	MoveToOuterScope(Identifiers, decl->u.decl.name);
#endif
    } 

#if 0
/* under new scoping protocol, name of procedure is already at
   external definition level -- rcm */

    else { /* create-style definition */
	/* The name of the procedure has been put in the scope of the
	   upcoming block, which it NOT the desired behavior.  Thus, we
	   move it out one level to the external definition level. */
	MoveToOuterScope(Identifiers, decl->u.decl.name);
    }
#endif


    /* enter scope of function body */
    EnterScope();
    
    /* add formals to the scope of the upcoming block */
    IterateList(&marker, fdcl->u.fdcl.args);
    first = TRUE;
    while (NextOnList(&marker, (GenericREF) &arg)) {
	if (arg->typ == Decl) { 
	    InsertSymbol(Identifiers, 
			 arg->u.decl.name,
			 arg,
			 (ConflictProc) formal_conflict);
	} else {
	  if (IsEllipsis(arg))
	    /* okay */;
	  else if (IsVoidType(arg)) {
	    if (!first)
	      SyntaxErrorCoord(arg->coord,
			       "void argument must be first");
	  }
	  else {
	    SyntaxErrorCoord(arg->coord, "argument without a name");
	  }
	}
	first = FALSE;
    }
    
    /* return Proc with no body */
    CurrentProc = MakeProcCoord(decl, NULL, decl->coord);

    return CurrentProc;
}


GLOBAL Node *SetProcBody(Node *proc, Node *block)
{
    assert(proc != NULL  &&  proc->typ == Proc);
    assert(block == NULL  ||  block->typ == Block);
    assert(proc->u.proc.decl != NULL  &&  proc->u.proc.decl->typ == Decl);

    /* exit function body scope */
    ExitScope();

    proc->u.proc.body = block;

    if (block == NULL) {
	WarningCoord(4, proc->u.proc.decl->coord,
		     "procedure `%s' has no code",
		     proc->u.proc.decl->u.decl.name);
    } else {
	/* check for unreferenced/unresolved labels,
	   all labels are now out of scope */
	ResetSymbolTable(Labels);
    }

    CurrentProc = NULL;

    return(proc);
}


GLOBAL Node *AddReturn(Node *returnnode)
{
  assert(CurrentProc != NULL);
  assert(returnnode->typ == Return);
  returnnode->u.Return.proc = CurrentProc;
  return returnnode;
}


/************************************************************************
* Support for old-style function definitions
\***********************************************************************/

GLOBAL Bool OldStyleFunctionDefinition = FALSE;

/* AddParameterTypes

   This takes a old-style function declaration `decl', which has a
   list of identifiers (Id nodes) as its argument list, and and a list of
   the parameter declarations `types', and converts the list
   of identifiers to a list of declarations (Decl nodes) with the types
   determined by the declaration list.  It is called upon the reduction of a
   procedure defined using the old-sytle function declaration.

   In: decl = (Decl name (Fdcl args=(List Id's) returntype) NULL NULL)
       types = (List Decl's)
   Out : (Decl name (Fdcl args=(List Decl's) returntype) NULL NULL)
*/
GLOBAL Node *AddParameterTypes(Node *decl, List *types)
{
    Node *fdcl, *type, *id;
    List *ids;
    ListMarker tl, il;
    const char *name;
    Bool found;

    assert(decl != NULL  &&  decl->typ == Decl);
    fdcl = decl->u.decl.type;
    assert(fdcl != NULL  &&  fdcl->typ == Fdcl);
    ids = fdcl->u.fdcl.args;

    IterateList(&tl, types);
    while (NextOnList(&tl, (GenericREF)&type)) {
	assert(type->typ == Decl);
	name = type->u.decl.name;
	found = FALSE;
	IterateList(&il, ids);
	while (NextOnList(&il, (GenericREF)&id)) {
	    if (id->typ == Id  &&  id->u.id.text == name) {
		/* if a name appears twice in the identifer list,
		   it will be caught by DefineProc when its adds the
		   formals to the scope of the body */
		memcpy((char *)id, (char *)type,
		       sizeof(Node));  /* replace Id with Decl */
		found = TRUE;
		break;
	    } else if (id->typ == Decl) {
		if (id->u.decl.name == name) {
		    SyntaxErrorCoord(type->coord,
			        "multiple declarations for parameter `%s'",
				name);
		    found = TRUE;  /* name does exist */
		    break;
		}
	    }
	}
	if (!found) 
	  SyntaxErrorCoord(type->coord,
			   "declaration for nonexistent parameter `%s'", name);
    }
    
    /* check for missing declarations */
    IterateList(&il, ids);
    while(NextOnList(&il, (GenericREF) &id)) 
      {
	if (id->typ == Id) 
	  {
	    WarningCoord(2, id->coord,
			 "parameter `%s' defaults to signed int",
			 id->u.id.text);
	    ConvertIdToDecl(id, T_FORMAL_DECL,
			    MakeDefaultPrimType(EMPTY_TQ, id->coord), 
			    NULL, NULL);
	  }
      }

    return decl;
}

/* AddDefaultParameterTypes

   This takes a badly formed prototype, which parses like an old-style function
   declarator without the type list, and sets all of the parameters to be
   signed int.  The grammar has already complained about this declarator
*/
GLOBAL Node *AddDefaultParameterTypes(Node *decl)
{ Node *fdcl, *id;
  ListMarker il;
  List *ids;

  assert(decl != NULL  &&  decl->typ == Decl);
  fdcl = decl->u.decl.type;
  assert(fdcl != NULL  &&  fdcl->typ == Fdcl);
  ids = fdcl->u.fdcl.args;

  /* Set the type */
  IterateList(&il, ids);
  while(NextOnList(&il, (GenericREF) &id)) 
    ConvertIdToDecl(id, T_FORMAL_DECL,
		    MakeDefaultPrimType(EMPTY_TQ, id->coord), NULL, NULL);
  
  return decl;
}

/************************************************************************
* Routines for handling labels and goto statements
************************************************************************/

PRIVATE void label_conflict(Node *orig, Node *create)
{
  assert(orig);
  assert(create);
  assert(orig->typ   == Label);
  assert(create->typ == Label);

  if (create->u.label.stmt != Undeclared) {
    if (orig->u.label.stmt != Undeclared)
      SyntaxErrorCoord(create->coord,
		       "multiple definitions of label `%s'",
		       orig->u.label.name);
    else 
      /* Loop over all the references to the old one and point them here */
      { ListMarker marker;
	Node *item;

	IterateList(&marker, orig->u.label.references);
	while (NextOnList(&marker, (GenericREF) &item))
	  {
	    assert(item->typ == Goto);
	    item->u.Goto.label = create;
	  }

	/* Prevent EndOfScope checker from whining */
	orig->u.label.stmt = NULL;
	create->u.label.references = orig->u.label.references;
      }
  }
}

GLOBAL Node *BuildLabel(Node *id, Node *stmt)
{
  Node *var, *label;

  assert(id->typ == Id);
  assert(Level > 0);

  label = id;
  label->typ = Label;
  label->u.label.name = id->u.id.text;
  label->u.label.stmt = stmt;
  label->u.label.references = NULL;
  
  var = InsertSymbol(Labels,
		     label->u.label.name, 
		     label,
		     (ConflictProc) label_conflict);
  return label;
}

GLOBAL Node *ResolveGoto(Node *id, Coord coord)
{ Node *label, *goto_node;
  const char *name = id->u.id.text;
  
  assert(id->typ == Id);

  if (! LookupSymbol(Labels, name, (GenericREF) &label)) {
      label = MakeLabelCoord(name, Undeclared, UnknownCoord);
      label->coord = id->coord;
      label = InsertSymbol(Labels, name, label,
			   (ConflictProc) label_conflict);
  }

  assert(label);
  assert(label->typ == Label);

  goto_node = id;
  goto_node->typ = Goto;
  goto_node->coord = coord;
  goto_node->u.Goto.label = label;

  label->u.label.references = ConsItem(goto_node, label->u.label.references);
  return(goto_node);
}


/* This is called for all labels at the end of a function definition.
   The call chain is: SetProcBody -> ResetSymbolTable -> EndOfLabelScope */

GLOBAL void EndOfLabelScope(Node *label)
{
  assert(label);
  assert(label->typ == Label);

  if (label->u.label.stmt == Undeclared)
    SyntaxErrorCoord(label->coord,
		     "undefined label `%s'",
		     label->u.label.name);
  else if (label->u.label.references == NULL)
    WarningCoord(2, label->coord,
		 "unreferenced label `%s'",
		 label->u.label.name);
}
