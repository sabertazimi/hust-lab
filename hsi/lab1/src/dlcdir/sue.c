/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  sue.c,v
 * Revision 1.16  1995/04/21  05:44:49  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.15  1995/02/01  21:07:39  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.14  1995/02/01  07:38:40  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.13  1995/01/27  01:39:14  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.12  1995/01/25  02:16:23  rcm
 * Changed how Prim types are created and merged.
 *
 * Revision 1.11  1995/01/20  05:10:19  rcm
 * Minor bug fixes
 *
 * Revision 1.10  1995/01/20  03:38:21  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.9  1995/01/11  17:18:21  rcm
 * Anonymous struct/union/enums now given arbitrary unique tag.
 *
 * Revision 1.8  1995/01/06  16:49:10  rcm
 * added copyright message
 *
 * Revision 1.7  1994/12/23  09:18:46  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.6  1994/12/20  09:24:22  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.5  1994/11/22  01:54:51  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.4  1994/11/10  03:13:42  rcm
 * Fixed line numbers on AST nodes.
 *
 * Revision 1.3  1994/11/03  07:39:03  rcm
 * Added code to output C from the parse tree.
 *
 * Revision 1.2  1994/10/28  18:53:10  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Sun May  9 16:09:51 EDT 1993
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
#pragma ident "sue.c,v 1.16 1995/04/21 05:44:49 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"

/***********************************************************************\
* structure/union/enum procedures
\***********************************************************************/

PRIVATE SUEtype *make_SUE(NodeType typ, const char *name, List *fields)
{
    SUEtype *create = HeapNew(SUEtype);
    create->typ = typ;
    create->complete = FALSE;
    create->coord = UnknownCoord;
    create->right_coord = UnknownCoord;
    create->name   = name;
    create->visited = FALSE;
    create->size   = 0;
    create->align  = 1;
    create->fields = fields;

    return(create);
}

GLOBAL void PrintSUE(FILE *out, SUEtype *sue, int offset, Bool recursep)
{
    ListMarker marker;
    Node *decl;
    const char *name;

    if (sue == NULL) {
	fprintf(out, "Null SUE");
	return;
    } 

    name = (sue->name) ? sue->name : "nil";

    switch (sue->typ) {
      case Sdcl:
	fprintf(out, "struct %s (%d)", name, sue->size);
	break;
      case Udcl:
	fprintf(out, "union %s", name);
	break;
      case Edcl:
	fprintf(out, "enum %s", name);
	break;
      default:
	fprintf(out, "unexpected SUE type %d", sue->typ);
    }

    if (recursep) {
      IterateList(&marker, sue->fields);
      while (NextOnList(&marker, (GenericREF) &decl)) {
	assert(decl->typ == Decl);
	PrintCRSpaces(out, offset);
	PrintNode(out, decl, offset);
      }
    }
}

PRIVATE void tag_conflict(SUEtype *o, SUEtype *n)
{
    assert(o->typ == Sdcl || o->typ == Udcl || o->typ == Edcl);
    assert(n->typ == Sdcl || n->typ == Udcl || n->typ == Edcl);
    
    if (o == n) return;

    if (o->typ != n->typ) {
	SyntaxErrorCoord(n->coord,
			 "redeclaration of structure/union/enum tag `%s'",
			 o->name);
	fprintf(stderr, "\tPrevious declaration: ");
	PRINT_COORD(stderr, o->coord);
	fputc('\n', stderr);
    } else if (!o->complete) { /* update original with nlist */
	o->fields = n->fields;
	o->complete = TRUE;
	o->coord = n->coord;
	o->right_coord = n->right_coord;
    } else if (n->complete) {
	/* both are complete (i.e., with list of fields) => conflict */
	switch (o->typ) {
	  case Sdcl:
	    SyntaxErrorCoord(n->coord,
			     "multiple declarations of structure `%s'",
			     o->name);
	    break;
	  case Udcl:
	    SyntaxErrorCoord(n->coord,
			     "multiple declarations of union `%s'",
			     o->name);
	    break;
	  case Edcl:
	    SyntaxErrorCoord(n->coord,
			     "multiple declarations of enum `%s'",
			     o->name);
	    break;
	  default:
	    UNREACHABLE;
	}
	fprintf(stderr, "\tPrevious definition: ");
	PRINT_COORD(stderr, o->coord);
	fputc('\n', stderr);
    } /* else o->complete, !n->complete => leave unchanged */
}


GLOBAL Node *SetSUdclNameFields(Node *sudcl, Node *id, List *fields, Coord left_coord, Coord right_coord)
{
    SUEtype *sue;
    const char *name;

    assert(sudcl != NULL  &&  (sudcl->typ == Sdcl || sudcl->typ == Udcl));
    assert(sudcl->u.sdcl.type == NULL);  /* not allocated yet */

    if (id != NULL)  { /* add to Tags namespace */
      assert(id->typ == Id);
      name = id->u.id.text;
    }
    else name = NULL;

    /* create structure/union */
    sue = make_SUE(sudcl->typ, name, fields);
    sue->complete = TRUE;
    sue->coord = left_coord;
    sue->right_coord = right_coord;

    if (name)
      sue = InsertSymbol(Tags, name, sue, (ConflictProc) tag_conflict);
    else sue->name = InsertUniqueSymbol(Tags, sue, "___sue");

    sudcl->u.sdcl.tq |= T_SUE_ELABORATED;
    sudcl->u.sdcl.type = sue;
    return(sudcl);
}

GLOBAL Node *SetSUdclName(Node *sudcl, Node *id, Coord coord)
{
    SUEtype *sue, *tmp;
    const char *name;

    assert(sudcl != NULL  &&  (sudcl->typ == Sdcl || sudcl->typ == Udcl));
    assert(sudcl->u.sdcl.type == NULL);  /* not allocated yet */

    if (id != NULL)  { /* add to Tags namespace */
        assert(id->typ == Id);
        name = id->u.id.text;

        if (LookupSymbol(Tags, name, (GenericREF) &tmp)) {
		/* use previous definition */
		sue = tmp;
	} else {
	    /* create structure/union */
	    sue = make_SUE(sudcl->typ, name, NULL);
	    sue->coord = coord;
	    sue = InsertSymbol(Tags, name, sue, (ConflictProc) tag_conflict);
	}
    } else {
	sue = make_SUE(sudcl->typ, NULL, NULL);
	sue->coord = coord;
 	/* create unique name for anonymous sue */
	sue->name = InsertUniqueSymbol(Tags, sue, "___sue");
    }

    sudcl->u.sdcl.tq &= ~T_SUE_ELABORATED;
    sudcl->u.sdcl.type = sue;
    return(sudcl);
}


/* the following is only called from ForceNewSU */
PRIVATE void forced_tag_conflict(SUEtype *old, SUEtype *create)
{
    assert(old != create);
    /* ignore create, since it assumed we wouldn't get here */
    return;
}


GLOBAL Node *ForceNewSU(Node *sudcl, Coord coord)
{
    SUEtype *sue, *tmp;

    /* this procedure handles the "recondite" rule that says that
          struct.or.union identifier ';'
       creates a create struct/union even if the tag is defined in an outer
       scope.  See K&R2, p213 */

    /* assume that this tag is not already in the innermost scope,
       1) create a create struct/union
       2) add it to the current scope
       3) if there's a conflict, then the assumption was false
          and we use the previous version instead  */
	  
    sue = sudcl->u.sdcl.type;
    if (sue->name == NULL) return(sudcl);

    /* ignore sue->fields */

    sue = make_SUE(sudcl->typ, sue->name, NULL);
    sue->coord = coord;

    tmp = InsertSymbol(Tags, sue->name, sue,
		       (ConflictProc) forced_tag_conflict);

    /* tmp != sue  implies conflict and memory leak of *sue */
    return(sudcl);
}


GLOBAL Node *BuildEnum(Node *id, List *values, Coord enum_coord, Coord left_coord, Coord right_coord)
{
    SUEtype *tmp, *sue;
    const char *name;
    Node *new;

    if (id != NULL) { /* add to Tags namespace */
      Bool insert = TRUE;

	assert(id->typ == Id);
	name = id->u.id.text;
	sue = make_SUE(Edcl, name, values);
        sue->complete = TRUE;
	sue->coord = left_coord;
	sue->right_coord = right_coord;

	if (values == NULL) {
	    /* incomplete enums are illegal, so if there is no list
	       of values, then the enum tag must be in scope */
	    if (! LookupSymbol(Tags, name, (GenericREF) &tmp)) {
		SyntaxErrorCoord(id->coord, "undeclared enum `%s'", name);
		/* put it in scope to prevent further errors */
	      }
	    else insert = FALSE;
	}

        if (insert)
	  sue = InsertSymbol(Tags, name, sue, (ConflictProc) tag_conflict);
    } else {
	sue = make_SUE(Edcl, NULL, values);
	sue->coord = left_coord;
	sue->right_coord = right_coord;

	/* no tag, so must have a value list (property of the grammar) */
	assert(values != NULL);
    }

#if 0
/* assignment of enum values moved to sem-check.c -- rcm */

    /* if the enum tag was redeclared sue may no longer be an Edcl;
       don't assign enum values unless it still is. */
    if (sue->typ == Edcl) {
	assign_enum_values(sue);
    }
#endif

    new = MakeEdclCoord(EMPTY_TQ, sue, enum_coord);
    if (values)
      new->u.edcl.tq |= T_SUE_ELABORATED;
    else new->u.edcl.tq &= ~T_SUE_ELABORATED;

    return new;
}


GLOBAL void VerifySUEcomplete(Node *type)
{
    SUEtype *sue;
    const char *kind;

    if (type == NULL) return;

    switch (type->typ) {
      case Ptr: /* pointers may use incomplete types */
	return;
      case Adcl:
	VerifySUEcomplete(type->u.adcl.type);
	return;
      case Fdcl:
	VerifySUEcomplete(type->u.fdcl.returns);
	return;
      case Sdcl:
	sue = type->u.sdcl.type;
	kind = "structure";
	break;
      case Udcl:
	sue = type->u.udcl.type;
	kind = "union";
	break;
      case Edcl: /* incomplete enums are always illegal and are
		    caught by BuildEnum (K&R2 A8.4, p215) */
      default:
	return;
    }

    if (!sue->complete) {
	if (sue->name == NULL) {
	    SyntaxError("incomplete unnamed %s", kind);
	} else {
	    SyntaxError("incomplete %s `%s'", kind, sue->name);
	}
    }
}


PRIVATE void enum_const_conflict(Node *orig, Node *create)
{
    SyntaxErrorCoord(create->coord,
		     "enum constant `%s' redeclares previous identifier",
		     VAR_NAME(orig));
    fprintf(stderr, "\tPrevious definition: ");
    PRINT_COORD(stderr, orig->coord);
    fputc('\n', stderr);
}


GLOBAL Node *BuildEnumConst(Node *name, Node *value)
{ Node *decl = ConvertIdToDecl(name, T_ENUM_DECL,
			       MakeDefaultPrimType(T_CONST, name->coord), 
			       value, NULL);
  InsertSymbol(Identifiers, decl->u.decl.name, decl,
	       (ConflictProc) enum_const_conflict);
  return(decl);
}


GLOBAL void ShadowTag(SUEtype *create, SUEtype *shadowed)
{
    /* the two are equal only for redundant function/extern declarations */
    if (create != shadowed && WarningLevel == 5) {
	WarningCoord(5, create->coord,
		     "struct/union/enum tag `%s' shadows previous declaration",
		     create->name);
	fprintf(stderr, "\tPrevious declaration: ");
	PRINT_COORD(stderr, shadowed->coord);
	fputc('\n', stderr);
    }
}


GLOBAL int SUE_Sizeof(SUEtype *sue)
{ 
  assert(sue);
  return sue->size; 
}

GLOBAL int SUE_Alignment(SUEtype *sue)
{ 
  assert(sue);
  return sue->align; 
}

GLOBAL Node *SUE_FindField(SUEtype *sue, Node *field_name)
{ ListMarker marker;
  Node *field;
  const char *name;

  assert(field_name->typ == Id);

  name = field_name->u.id.text;

  /* Find the field in the struct/union fields */
  IterateList(&marker, sue->fields);
  while (NextOnList(&marker, (GenericREF) &field)) {
    assert(field->typ == Decl);
    if (strcmp(name, field->u.decl.name) == 0)
      return field;
  }

  return NULL;
}

GLOBAL Bool  SUE_SameTagp(SUEtype *sue1, SUEtype *sue2)
{ 
  if (!sue1->name  ||  !sue2->name)
    return FALSE;
  else return strcmp(sue1->name, sue2->name) == 0; 
}
