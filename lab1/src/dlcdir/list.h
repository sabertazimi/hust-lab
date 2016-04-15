/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  list.h,v
 * Revision 1.8  1995/04/21  05:44:27  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.7  1995/04/09  21:30:46  rcm
 * Added Analysis phase to perform all analysis at one place in pipeline.
 * Also added checking for functions without return values and unreachable
 * code.  Added tests of live-variable analysis.
 *
 * Revision 1.6  1995/02/13  02:00:12  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.5  1995/02/01  07:37:35  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.4  1995/01/06  16:48:50  rcm
 * added copyright message
 *
 * Revision 1.3  1994/12/20  09:24:03  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.2  1994/10/28  18:52:27  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Mon Apr 26 13:19:35 EDT 1993
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
#pragma ident "list.h,v 1.8 1995/04/21 05:44:27 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#ifndef _LIST_H_
#define _LIST_H_

typedef struct liststruct List;

typedef struct {
    List *first, *current, *tail;
} ListMarker;

GLOBAL Generic *FirstItem(List *list);
GLOBAL Generic *LastItem(List *list);
GLOBAL Generic *SetItem(List *list, Generic *element);
GLOBAL List    *Rest(List *list);
GLOBAL List    *Last(List *list);
GLOBAL int      ListLength(List *list);

GLOBAL List *FindItem(List *list, Generic *item);
GLOBAL List *RemoveItem(List *list, Generic *item);

GLOBAL List *MakeNewList(Generic *item);
GLOBAL List *ConsItem(Generic *item, List *list);
GLOBAL List *AppendItem(List *list, Generic *item);
GLOBAL List *JoinLists(List *list1, List *list2);
GLOBAL List *ListCopy(List *list);

#define List1 MakeNewList
GLOBAL List *List2(Generic *x1, Generic *x2);
GLOBAL List *List3(Generic *x1, Generic *x2, Generic *x3);
GLOBAL List *List4(Generic *x1, Generic *x2, Generic *x3, Generic *x4);
GLOBAL List *List5(Generic *x1, Generic *x2, Generic *x3, Generic *x4, Generic *x5);


/* ListMarker passed by reference in the following */
GLOBAL void IterateList(ListMarker *, List *);   
GLOBAL Bool NextOnList(ListMarker *, GenericREF itemref);
GLOBAL List *InsertList(ListMarker *marker, List *list);
GLOBAL List *SplitList(ListMarker *marker);
GLOBAL void SetCurrentOnList(ListMarker *marker, Generic *handle);
GLOBAL List *NextChunkOnList(ListMarker *, int chunksize);

#endif  /* ifndef _LIST_H_ */
