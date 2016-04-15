/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  conversions.h,v
 * Revision 1.4  1995/04/21  05:44:17  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.3  1995/03/23  15:31:06  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.2  1995/01/06  16:48:44  rcm
 * added copyright message
 *
 * Revision 1.1  1994/12/20  09:20:25  rcm
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
#pragma ident "conversions.h,v 1.4 1995/04/21 05:44:17 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#ifndef _CONVERSIONS_H_
#define _CONVERSIONS_H_

GLOBAL Node *UsualUnaryConversions(Node *node, Bool f_to_d);
GLOBAL Node *UsualUnaryConversionType(Node *type);
GLOBAL void  UsualBinaryConversions(Node **node1p, Node **node2p);
GLOBAL void  UsualPointerConversions(Node **node1p, Node **node2p, Bool allow_void_or_zero);
GLOBAL Node *AssignmentConversions(Node *expr, Node *to_type);
GLOBAL Node *CallConversions(Node *expr, Node *to_type);
GLOBAL Node *ReturnConversions(Node *expr, Node *to_type);
GLOBAL Node *CastConversions(Node *expr, Node *to_type);
GLOBAL Node *ConditionalConversions(Node **truep, Node **falsep);


#endif /* _CONVERSIONS_H_ */
