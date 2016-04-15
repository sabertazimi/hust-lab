/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Rob Miller
 *  
 *  transform.c,v
 * Revision 1.9  1995/04/21  05:44:55  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.8  1995/02/10  22:36:26  rcm
 * Removed TransformNode, because it turned out to be useless in Cilk 1.9.
 * transform.c is now reduced to a stub.
 *
 * Revision 1.7  1995/02/06  21:41:26  rcm
 * Alpha release v0.60
 *
 * Revision 1.6  1995/02/01  23:02:05  rcm
 * Added Text node and #pragma collection
 *
 * Revision 1.5  1995/02/01  07:34:04  rcm
 * Added TransformFlag and TransformContext to transform.c
 *
 * Revision 1.4  1995/01/27  01:39:15  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.3  1995/01/20  03:38:22  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.2  1995/01/06  16:49:13  rcm
 * added copyright message
 *
 * Revision 1.1  1994/12/20  09:20:34  rcm
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
#pragma ident "transform.c,v 1.9 1995/04/21 05:44:55 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"


/*
 * TransformProgram should convert a type-checked source language tree
 * into a standard C tree.  Type information does not need to be preserved,
 * but all new Decl nodes must be properly annotated with their DECL_LOCATION
 * (e.g. top-level, block, structure field, etc.).
 */

GLOBAL List *TransformProgram(List *program)
{

  return program;
}

