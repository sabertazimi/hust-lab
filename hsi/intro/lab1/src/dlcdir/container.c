/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  container.c,v
 * Revision 1.7  1995/04/21  05:44:13  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.6  1995/02/01  07:37:03  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.5  1995/01/27  01:38:57  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.4  1995/01/06  16:48:41  rcm
 * added copyright message
 *
 * Revision 1.3  1994/12/20  09:23:59  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.2  1994/10/28  18:52:20  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Wed Jun 16 10:39:24 EDT 1993
 *
 *
 *
 *  This file contains the code that tracks the nearest enclosing body
 *  for a break, continue, case or default statement.  It also builds the
 *  list of cases for a switch statement.
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
#pragma ident "container.c,v 1.7 1995/04/21 05:44:13 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif


#include "ast.h"

typedef struct {
    NodeType typ;
    List *cases;
    List *exits;
} Container;

PRIVATE Container stack[MAX_SCOPE_DEPTH];
PRIVATE Container *top = NULL;


GLOBAL void PushContainer(NodeType typ)
{
    if (top == NULL) top = stack;
    else top++;

    top->typ = typ;
    top->cases = top->exits = NULL;
}


GLOBAL Node *PopContainer(Node *n)
{
    ListMarker marker;
    Node *containee;

    assert(n->typ == top->typ);
    assert(top != NULL);

    IterateList(&marker, top->exits);
    while (NextOnList(&marker, (GenericREF) &containee)) {
	switch(containee->typ) {
	  case Break:
	    containee->u.Break.container = n;
	    break;
	  case Continue:
	    assert(n->typ != Switch);
	    containee->u.Continue.container = n;
	    break;
	  default:
	    FAIL("unexpected containee type");
	}
    }

    IterateList(&marker, top->cases);
    while (NextOnList(&marker, (GenericREF) &containee)) {
	assert(n->typ == Switch);
	switch(containee->typ) {
	  case Case:
	    containee->u.Case.container = n;
	    break;
	  case Default:
	    containee->u.Default.container = n;
	    n->u.Switch.has_default = TRUE;
	    break;
	  default:
	    FAIL("unexpected containee type");
	}
    }

    /* store cases list into enclosing switch node */
    if (n->typ == Switch)
      n->u.Switch.cases = top->cases;

    /* memory leak: exits list */

    if (top == stack)
      top = NULL;
    else
      top--;

    return(n);
}


GLOBAL Node *AddContainee(Node *c)
{
    Container *container;

    if (top == NULL) {
      switch (c->typ) {
      case Case:
      case Default:
	goto NoSwitch;
      case Break:
	SyntaxErrorCoord(c->coord,
			 "no enclosing loop or switch statement found");
	return(c);
      case Continue:
	goto NoLoop;
      default:
	break;
      }
    }
    
    switch(c->typ) {
      case Case:
      case Default:
	for (container = top; container >= stack; container--) {
	    if (container->typ == Switch) {
		if (container->cases == NULL)
		  container->cases = MakeNewList(c);
		else
		  AppendItem(container->cases, c);
		return(c);
	    }
	}
      NoSwitch:
	/* didn't find an enclosing switch... */
	SyntaxErrorCoord(c->coord, "no enclosing switch statement");
	break;
      case Break:
	if (top->exits == NULL)
	  top->exits = MakeNewList(c);
	else
	  AppendItem(top->exits, c);
	break;
      case Continue:
	for (container = top; container >= stack; container--) {
	    if (container->typ != Switch) {
		if (container->exits == NULL)
		  container->exits = MakeNewList(c);
		else
		  AppendItem(container->exits, c);
		return(c);
	    }
	}
      NoLoop:
	/* didn't find an enclosing loop... */
	SyntaxErrorCoord(c->coord, "no enclosing loop");
	break;
      default:
	FAIL("unexpected node type");
    }
    return(c);
}



