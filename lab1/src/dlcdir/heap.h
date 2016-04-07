/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  heap.h,v
 * Revision 1.6  1995/04/21  05:44:21  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.5  1995/02/01  21:07:17  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.4  1995/01/06  16:48:45  rcm
 * added copyright message
 *
 * Revision 1.3  1994/12/20  09:24:00  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.2  1994/10/28  18:52:23  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Thu Apr 22 16:32:18 EDT 1993
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
#pragma ident "heap.h,v 1.6 1995/04/21 05:44:21 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#ifndef _HEAP_H_
#define _HEAP_H_

#define HeapNew(T) ((T *)HeapAllocate(1, sizeof(T)))
#define HeapNewArray(T, c) ((T *)HeapAllocate(c, sizeof(T)))

GLOBAL inline void *HeapAllocate(int number, int size);
GLOBAL inline void HeapFree(void *ptr);

#endif  /* ifndef _HEAP_H_ */
