/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Rob Miller
 *
 *  dataflow.h,v
 * Revision 1.3  1995/04/21  05:44:20  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.2  1995/04/09  21:30:44  rcm
 * Added Analysis phase to perform all analysis at one place in pipeline.
 * Also added checking for functions without return values and unreachable
 * code.  Added tests of live-variable analysis.
 *
 * Revision 1.1  1995/03/23  15:31:10  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
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
#pragma ident "dataflow.h,v 1.3 1995/04/21 05:44:20 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif 

#ifndef _DATAFLOW_H_
#define _DATAFLOW_H_

typedef unsigned long BitVector;
#define MAX_BITVECTOR_LENGTH    (sizeof(BitVector) * CHAR_BIT)

typedef struct {
  Bool undefined;
  union {
    BitVector bitvector;
    List *list;
    Generic *ptr;
  } u;
} FlowValue;

typedef struct {
  /* Structures used in analysis */
  FlowValue gen, kill;

  /* Analysis results */
  List *livevars;
} Analysis;



typedef enum {
  Backwards,
  Forwards
} Direction;

typedef enum {
  EntryPoint,
  ExitPoint
} Point;

typedef FlowValue (*MeetOp) (FlowValue, FlowValue);
typedef FlowValue (*TransOp) (Node *, FlowValue, Point, Bool);
typedef Bool (*EqualOp) (FlowValue, FlowValue);


/* from dataflow.c */
GLOBAL void IterateDataFlow(
			     Node *root,       /* root node */
			     FlowValue init,  /* input value for root node */
			     Direction dir,    /* direction */
			     MeetOp meet,      /* meet operation */
			     EqualOp equal,    /* equality operation */
			     TransOp trans     /* transfer function */
			     );


/* from analyze.c */
GLOBAL List *RegisterVariables(Node *node, List *vars);

GLOBAL void PV(List *vars);
GLOBAL int PrintVariables(FILE *out, List *vars);
GLOBAL int PrintAnalysis(FILE *out, Node *node);

GLOBAL void AnalyzeLiveVariables(Node *root, List *vars);
GLOBAL void AnalyzeReturnFlow(Node *root);

GLOBAL void AnalyzeProgram(List *program);

#endif
