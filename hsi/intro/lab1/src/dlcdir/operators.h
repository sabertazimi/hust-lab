/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  operators.h,v
 * Revision 1.3  1995/04/21  05:44:32  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.2  1995/01/06  16:48:54  rcm
 * added copyright message
 *
 * Revision 1.1  1994/12/20  09:20:41  rcm
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
#pragma ident "operators.h,v 1.3 1995/04/21 05:44:32 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#ifndef _OPERATORS_H_
#define _OPERATORS_H_

/* unary/binary operator table information */
typedef struct {
    const char *text;  /* text of the operator */
    const char *name;  /* name of the operator for debugging */
    short unary_prec;  /* unary precedence, all unary ops are right assoc */
    short binary_prec; /* binary precedence */
    Bool left_assoc;   /* TRUE iff binary op is left associative */
    Bool (*unary_eval)(Node *);
    Bool (*binary_eval)(Node *);
} OpEntry;

GLOBAL extern OpEntry Operator[MAX_OPERATORS];  /* oeprators.c */


/* from operators.c */
GLOBAL void InitOperatorTable(void);  /* operators.c */
GLOBAL int  OpPrecedence(NodeType typ, OpType op, Bool *left_assoc);
GLOBAL Node *EvaluateConstantExpr(Node *);
GLOBAL Bool ApplyUnary(Node *unary);   /* operators.c */


#endif /* _OPERATORS_H_ */
