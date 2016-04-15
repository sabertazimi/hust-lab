/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  initializer.h,v
 * Revision 1.5  1995/04/21  05:44:24  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.4  1995/02/01  07:37:21  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.3  1995/01/06  16:48:48  rcm
 * added copyright message
 *
 * Revision 1.2  1994/12/23  09:18:29  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.1  1994/12/20  09:20:31  rcm
 * Created
 *
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
#pragma ident "initializer.h,v 1.5 1995/04/21 05:44:24 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif 

#ifndef _INITIALIZER_H_
#define _INITIALIZER_H_

GLOBAL void  SemCheckDeclInit(Node *decl, Bool blockp);
GLOBAL Bool IsInitializer(Node *node);
GLOBAL Node *InitializerCopy(Node *node);
GLOBAL int InitializerLength(Node *node);
GLOBAL Node *InitializerFirstItem(Node *node);
GLOBAL List *InitializerExprs(Node *node);
GLOBAL Bool InitializerEmptyList(Node *node);
GLOBAL void InitializerNext(Node *node);
GLOBAL Node *InitializerAppendItem(Node *initializer, Node *element);
GLOBAL Node *ArraySubtype(Node *node);
GLOBAL int ArrayNumberElements(Node *node);
GLOBAL SUEtype *StructUnionFields(Node *node);
GLOBAL Node *UnionFirstField(Node *node);
GLOBAL Node *SUE_MatchInitList(SUEtype *sue, Node *decl, Node *initializer, Bool top_p);

#endif /* _INITIALIZER_H_ */
