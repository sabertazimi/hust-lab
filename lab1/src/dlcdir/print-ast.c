/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  print-ast.c,v
 * Revision 1.17  1995/05/11  18:54:25  rcm
 * Added gcc extension __attribute__.
 *
 * Revision 1.16  1995/04/21  05:44:36  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.15  1995/03/23  15:31:20  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.14  1995/02/13  02:00:19  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.13  1995/02/01  23:01:28  rcm
 * Added Text node and #pragma collection
 *
 * Revision 1.12  1995/02/01  21:07:22  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.11  1995/01/27  01:39:03  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.10  1995/01/25  02:15:25  rcm
 * Pointer values are once again printed
 *
 * Revision 1.9  1995/01/20  03:38:11  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.8  1995/01/06  16:48:58  rcm
 * added copyright message
 *
 * Revision 1.7  1994/12/23  09:18:36  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.6  1994/12/20  09:24:11  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.5  1994/11/22  01:54:40  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.4  1994/11/10  03:13:26  rcm
 * Fixed line numbers on AST nodes.
 *
 * Revision 1.3  1994/11/03  07:38:53  rcm
 * Added code to output C from the parse tree.
 *
 * Revision 1.2  1994/10/28  18:52:45  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Tue Apr 27 13:17:36 EDT 1993
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
#pragma ident "print-ast.c,v 1.17 1995/05/11 18:54:25 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include <ctype.h>
#include "ast.h"




/* main debugging entry points -- handy for calling from gdb */

GLOBAL void DPN(Node *n)
{
  PrintNode(stdout, n, 0);
  putchar('\n');
  fflush(stdout);
}

GLOBAL void DPL(List *list)
{
  PrintList(stdout, list, 0);
  putchar('\n');
  fflush(stdout);
}




/*************************************************************************/
/*                                                                       */
/*                          Expression nodes                             */
/*                                                                       */
/*************************************************************************/

PRIVATE inline void PrintConst(FILE *out, Node *node, ConstNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Const: ");
  fflush(out);
  PrintConstant(out, node, TRUE);
}

PRIVATE inline void PrintId(FILE *out, Node *node, idNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Id: %s", u->text);
  if (u->value) {
    PrintCRSpaces(out, offset + 2);
    fputs("Value: ", out);
    fflush(out);
    PrintCRSpaces(out, offset + 4);
    PrintNode(out, u->value, offset + 4);
  }
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->decl, offset + 2);
}

PRIVATE inline void PrintBinop(FILE *out, Node *node, binopNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Binop: ");
  fflush(out);
  PrintOp(out, u->op);
  if (u->type) {
    PrintCRSpaces(out, offset + 2);
    PrintNode(out, u->type, offset + 2);
  }
  if (u->value) {
    PrintCRSpaces(out, offset + 2);
    fputs("Value: ", out);
    fflush(out);
    PrintCRSpaces(out, offset + 4);
    PrintNode(out, u->value, offset + 4);
  }
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->left,  offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->right, offset + 2);
}

PRIVATE inline void PrintUnary(FILE *out, Node *node, unaryNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Unary: ");
  fflush(out);
  PrintOp(out, u->op);
  if (u->type) {
    PrintCRSpaces(out, offset + 2);
    PrintNode(out, u->type, offset + 2);
  }
  if (u->value) {
    PrintCRSpaces(out, offset + 2);
    fputs("Value: ", out);
    fflush(out);
    PrintCRSpaces(out, offset + 4);
    PrintNode(out, u->value, offset + 4);
  }
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->expr, offset + 2);
}

PRIVATE inline void PrintCast(FILE *out, Node *node, castNode *u, int offset, Bool norecurse)
{
  fputs("Cast: ", out);
  fflush(out);
  if (u->value) {
    PrintCRSpaces(out, offset + 2);
    fputs("Value: ", out);
    fflush(out);
    PrintCRSpaces(out, offset + 4);
    PrintNode(out, u->value, offset + 4);
  }
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->type, offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->expr, offset + 2);
}

PRIVATE inline void PrintComma(FILE *out, Node *node, commaNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Comma: List: exprs");
  fflush(out);
  PrintCRSpaces(out, offset + 2);
  PrintList(out, u->exprs, offset + 2);
}

PRIVATE inline void PrintTernary(FILE *out, Node *node, ternaryNode *u, int offset, Bool norecurse)
{
  fputs("Ternary: ", out);
  fflush(out);
  if (u->value) {
    PrintCRSpaces(out, offset + 2);
    fputs("Value: ", out);
    fflush(out);
    PrintCRSpaces(out, offset + 4);
    PrintNode(out, u->value, offset + 4);
  }
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->cond,  offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->true,  offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->false, offset + 2);
}

PRIVATE inline void PrintArray(FILE *out, Node *node, arrayNode *u, int offset, Bool norecurse)
{
  fputs("Array: ", out);
  fflush(out);
  if (u->type) {
    PrintCRSpaces(out, offset + 2);
    PrintNode(out, u->type, offset + 2);
  }
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->name, offset + 2);
  PrintCRSpaces(out, offset + 2);
  fputs("List: dims", out);
  fflush(out);
  PrintCRSpaces(out, offset + 4);
  PrintList(out, u->dims, offset + 4);
}

PRIVATE inline void PrintCall(FILE *out, Node *node, callNode *u, int offset, Bool norecurse)
{
  fputs("Call: ", out);
  fflush(out);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->name, offset + 2);
  PrintCRSpaces(out, offset + 2);
  fputs("List: args", out);
  fflush(out);
  PrintCRSpaces(out, offset + 4);
  PrintList(out, u->args, offset + 4);
}

PRIVATE inline void PrintInitializer(FILE *out, Node *node, initializerNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Initializer: List: exprs");
  fflush(out);
  PrintCRSpaces(out, offset + 2);
  PrintList(out, u->exprs, offset + 2);
}

PRIVATE inline void PrintImplicitCast(FILE *out, Node *node, implicitcastNode *u, int offset, Bool norecurse)
{
  fputs("ImplicitCast: ", out);
  fflush(out);
  if (u->type) {
    PrintCRSpaces(out, offset + 2);
    fputs("Type:", out);
    fflush(out);
    PrintCRSpaces(out, offset + 4);
    PrintNode(out, u->type, offset + 2);
  }
  if (u->value) {
    PrintCRSpaces(out, offset + 2);
    fputs("Value: ", out);
    fflush(out);
    PrintCRSpaces(out, offset + 4);
    PrintNode(out, u->value, offset + 4);
  }
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->expr, offset + 2);
}

/*************************************************************************/
/*                                                                       */
/*                          Statement nodes                              */
/*                                                                       */
/*************************************************************************/

PRIVATE inline void PrintLabel(FILE *out, Node *node, labelNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Label: %s (0x%p)",  u->name, node);
  fflush(out);
  if (u->stmt) {
    PrintCRSpaces(out, offset + 2);
    PrintNode(out, u->stmt, offset + 2);
  }
}

PRIVATE inline void PrintSwitch(FILE *out, Node *node, SwitchNode *u, int offset, Bool norecurse)
{
  ListMarker marker; 
  Node *cse;
  
  fprintf(out, "Switch: (0x%p)", node);
  fflush(out);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->expr, offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->stmt, offset + 2);
  PrintCRSpaces(out, offset + 2);
  
  IterateList(&marker, u->cases);
  fprintf(out, "Cases:");
  fflush(out);
  while (NextOnList(&marker, (GenericREF) &cse)) {
    fprintf(out, " %d", cse->coord.line);
    fflush(out);
  }
}

PRIVATE inline void PrintCase(FILE *out, Node *node, CaseNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Case: (container = 0x%p)", u->container);
  fflush(out);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->expr, offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->stmt, offset + 2);
}

PRIVATE inline void PrintDefault(FILE *out, Node *node, DefaultNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Default: (container = 0x%p)", u->container);
  fflush(out);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->stmt, offset + 2);
}

PRIVATE inline void PrintIf(FILE *out, Node *node, IfNode *u, int offset, Bool norecurse)
{
  fputs("If: ", out);
  fflush(out);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->expr,  offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->stmt,  offset + 2);
}

PRIVATE inline void PrintIfElse(FILE *out, Node *node, IfElseNode *u, int offset, Bool norecurse)
{
  fputs("IfElse: ", out);
  fflush(out);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->expr,  offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->true,  offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->false, offset + 2);
}

PRIVATE inline void PrintWhile(FILE *out, Node *node, WhileNode *u, int offset, Bool norecurse)
{
  fprintf(out, "While: (0x%p) ", node);
  fflush(out);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->expr, offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->stmt, offset + 2);
}


PRIVATE inline void PrintDo(FILE *out, Node *node, DoNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Do: (0x%p) ", node);
  fflush(out);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->stmt, offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->expr, offset + 2);
}

PRIVATE inline void PrintFor(FILE *out, Node *node, ForNode *u, int offset, Bool norecurse)
{
  fprintf(out, "For: (0x%p) ", node);
  fflush(out);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->init, offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->cond, offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->next, offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->stmt, offset + 2);
}

PRIVATE inline void PrintGoto(FILE *out, Node *node, GotoNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Goto: %s", 
	  (u->label ? u->label->u.label.name : "nil"));
  fflush(out);
}

PRIVATE inline void PrintContinue(FILE *out, Node *node, ContinueNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Continue: (container = 0x%p)", u->container);
  fflush(out);
}

PRIVATE inline void PrintBreak(FILE *out, Node *node, BreakNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Break: (container = 0x%p)", u->container);
  fflush(out);
}

PRIVATE inline void PrintReturn(FILE *out, Node *node, ReturnNode *u, int offset, Bool norecurse)
{
  fputs("Return: ", out);
  fflush(out);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->expr, offset + 2);
}

PRIVATE inline void PrintBlock(FILE *out, Node *node, BlockNode *u, int offset, Bool norecurse)
{
  fputs("Block:", out);
  fflush(out);
  PrintCRSpaces(out, offset + 2);
  fprintf(out, "Type: (0x%p)", u->type);
  fflush(out);
  PrintCRSpaces(out, offset + 4);
  PrintNode(out, u->type, offset + 4);
  PrintCRSpaces(out, offset + 2);
  fputs("List: decl", out);
  fflush(out);
  PrintCRSpaces(out, offset + 4);
  PrintList(out, u->decl,  offset + 4);
  
  PrintCRSpaces(out, offset + 2);
  fputs("List: stmts", out);
  fflush(out);
  PrintCRSpaces(out, offset + 4);
  PrintList(out, u->stmts, offset + 4);
}


/*************************************************************************/
/*                                                                       */
/*                            Type nodes                                 */
/*                                                                       */
/*************************************************************************/

PRIVATE inline void PrintPrim(FILE *out, Node *node, primNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Prim: ");
  fflush(out);
  PrintPrimType(out, node);
}

PRIVATE inline void PrintTdef(FILE *out, Node *node, tdefNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Tdef: %s (0x%p) (type=0x%p)  ",
	  u->name, node, u->type);
  fflush(out);
  PrintTQ(out, u->tq); 
}

PRIVATE inline void PrintPtr(FILE *out, Node *node, ptrNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Ptr: ");
  fflush(out);
  PrintTQ(out, u->tq);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->type, offset + 2);
}

PRIVATE inline void PrintAdcl(FILE *out, Node *node, adclNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Adcl: ");
  fflush(out);
  PrintTQ(out, u->tq);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->type, offset + 2);
  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->dim,  offset + 2);
  if (u->size > 0) {
    PrintCRSpaces(out, offset + 2);
    fprintf(out, "%d", u->size);
    fflush(out);
  }
}

PRIVATE inline void PrintFdcl(FILE *out, Node *node, fdclNode *u, int offset, Bool norecurse)
{
  fputs("Fdcl: ", out);
  fflush(out);
  PrintTQ(out, u->tq);
  PrintCRSpaces(out, offset + 2);
  fputs("List: Args: ", out);
  fflush(out);
  PrintCRSpaces(out, offset + 4);
  PrintList(out, u->args,    offset + 4);
  PrintCRSpaces(out, offset + 2);
  fputs("Returns: ", out);
  fflush(out);
  PrintCRSpaces(out, offset + 4);
  PrintNode(out, u->returns, offset + 4);
}

PRIVATE inline void PrintSdcl(FILE *out, Node *node, sdclNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Sdcl: (0x%p) ", node);
  fflush(out);
  if (norecurse) {
    fprintf(out, "%s\n", u->type->name);
  fflush(out);
  } else {
    PrintCRSpaces(out, offset + 2);
    PrintTQ(out, u->tq);
    PrintSUE(out, u->type, offset + 4, TRUE);
  }
}

PRIVATE inline void PrintUdcl(FILE *out, Node *node, udclNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Udcl: (0x%p) ", node);
  fflush(out);
  
  if (norecurse) {
    fprintf(out, "%s\n", u->type->name);
    fflush(out);
  } else {
    PrintCRSpaces(out, offset + 2);
    PrintTQ(out, u->tq);
    PrintSUE(out, u->type, offset + 4, TRUE);
  }
}

PRIVATE inline void PrintEdcl(FILE *out, Node *node, edclNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Edcl: (0x%p) ", node);
  fflush(out);
  
  if (norecurse) { 
    fprintf(out, "%s\n", u->type->name);
    fflush(out);
  } else {
    PrintCRSpaces(out, offset + 2);
    PrintTQ(out, u->tq);
    PrintSUE(out, u->type, offset + 4, TRUE);
  }
}

/*************************************************************************/
/*                                                                       */
/*                      Other nodes (decls et al.)                       */
/*                                                                       */
/*************************************************************************/

PRIVATE inline void PrintDecl(FILE *out, Node *node, declNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Decl: %s (0x%p) ", u->name ? u->name : "", node);
  fflush(out);
  PrintTQ(out, u->tq);
  if (norecurse)
    fprintf(out, "\n");
  else {
    PrintCRSpaces(out, offset + 2);
    PrintNode(out, u->type,    offset + 2);
    PrintCRSpaces(out, offset + 2);
    PrintNode(out, u->init,    offset + 2);
    PrintCRSpaces(out, offset + 2);
    PrintNode(out, u->bitsize, offset + 2);
  }
}

PRIVATE inline void PrintAttrib(FILE *out, Node *node, attribNode *u, int offset, Bool norecurse)
{
  fprintf(out, "Attrib: %s", u->name);

  PrintCRSpaces(out, offset + 2);
  PrintNode(out, u->arg, offset + 2);
}

PRIVATE inline void PrintProc(FILE *out, Node *node, procNode *u, int offset, Bool norecurse)
{
  fputs("Proc:\n  ", out);
  fflush(out);
  PrintNode(out, u->decl, 2);
  fputs("\n  ", out);
  fflush(out);
  PrintNode(out, u->body, 2);
}

PRIVATE inline void PrintText(FILE *out, Node *node, textNode *u, int offset, Bool norecurse)
{
  fputs("Text: ", out);
  fflush(out);
  if (u->start_new_line) {
    fputs("(new line) ", out);
    fflush(out);
  }
  PrintString(out, u->text);
}


/*************************************************************************/
/*                                                                       */
/*                            Extensions                                 */
/*                                                                       */
/*************************************************************************/






/*************************************************************************/
/*                                                                       */
/*                      PrintNode and PrintList                          */
/*                                                                       */
/*************************************************************************/


GLOBAL short PassCounter = 0;
GLOBAL int PrintInvocations = 0;  /* number of pending PrintNodes on call
				     stack */


GLOBAL void PrintNode(FILE *out, Node *node, int offset)
{
  Bool norecurse;
  
  if (node == NULL) {
    fprintf(out, "nil");
    return;
  }
  
  if (PrintInvocations++ == 0) {
    /* then we're the first invocation for this pass over the tree */
    ++PassCounter;
  }
  norecurse = (node->pass == PassCounter);
  node->pass = PassCounter;
  
  switch ( node ->typ) { 
  case Const: 
    PrintConst (out, node , &node->u.Const ,offset,norecurse) ; 
    break; 

  case Id: 
    PrintId (out, node , &node ->u.id ,offset,norecurse) ; 
    break; 

  case Binop: 
    PrintBinop (out, node , & node ->u.binop ,offset,norecurse) ; 
    break; 

  case Unary:
    PrintUnary (out, node , & node ->u.unary ,offset,norecurse) ; 
    break;

  case Cast:
    PrintCast (out, node , & node ->u.cast ,offset,norecurse) ;
    break; 

  case Comma: 
    PrintComma (out, node , & node ->u.comma,offset,norecurse) ; 
    break; 
			  
  case Ternary: 
    PrintTernary (out, node , &node ->u.ternary ,offset,norecurse) ; 
    break; 

  case Array: 
    PrintArray(out, node , & node ->u.array ,offset,norecurse) ; 
    break; 

  case Call:
    PrintCall (out, node , & node ->u.call ,offset,norecurse) ; 
    break;

  case Initializer: 
    PrintInitializer (out, node , & node ->u.initializer ,offset,norecurse) ; 
    break; 

  case ImplicitCast: 
    PrintImplicitCast(out,node,&node->u.implicitcast,offset,norecurse); 
    break; 

  case Label:
    PrintLabel (out, node , & node ->u.label ,offset,norecurse) ; 
    break;

  case Switch: 
    PrintSwitch (out, node , & node ->u.Switch,offset,norecurse); 
    break; 

  case Case: 
    PrintCase (out, node , & node->u.Case ,offset,norecurse) ; 
    break; 

  case Default: 
    PrintDefault (out, node , & node ->u.Default ,offset,norecurse) ; 
    break; 

  case If: 
    PrintIf(out, node , & node ->u.If ,offset,norecurse) ; 
    break; 

  case IfElse:
    PrintIfElse (out, node , & node ->u.IfElse ,offset,norecurse) ; 
    break;

  case While: 
    PrintWhile (out, node , & node ->u.While,offset,norecurse) ; 
    break; 

  case Do: 
    PrintDo (out, node , & node->u.Do ,offset,norecurse) ; 
    break; 

  case For: 
    PrintFor (out, node , &node ->u.For ,offset,norecurse) ; 
    break; 

  case Goto: 
    PrintGoto (out, node , & node ->u.Goto ,offset,norecurse) ; 
    break; 

  case Continue:
    PrintContinue (out, node , &node ->u.Continue ,offset,norecurse) ;
    break; 

  case Break: 
    PrintBreak (out, node , & node ->u.Break,offset,norecurse) ; 
    break; 

  case Return: 
    PrintReturn (out, node , &node ->u.Return ,offset,norecurse); 
    break; 

  case Block: 
    PrintBlock(out, node , &node->u.Block, offset,norecurse) ; 
    break; 

  case Prim:
    PrintPrim (out, node , & node ->u.prim ,offset,norecurse) ; 
    break;

  case Tdef: 
    PrintTdef (out, node , & node ->u.tdef ,offset,norecurse) ;
    break; 

  case Ptr: 
    PrintPtr (out, node , & node ->u.ptr,offset,norecurse) ; 
    break; 

  case Adcl: 
    PrintAdcl (out, node , & node->u.adcl ,offset,norecurse) ; 
    break; 

  case Fdcl: 
    PrintFdcl (out, node ,& node ->u.fdcl ,offset,norecurse) ; 
    break; 

  case Sdcl: 
    PrintSdcl (out, node , & node ->u.sdcl ,offset,norecurse) ; 
    break; 

  case Udcl: 
    PrintUdcl (out, node , & node ->u.udcl ,offset,norecurse) ; 
    break;

  case Edcl: 
    PrintEdcl (out, node , & node ->u.edcl ,offset,norecurse) ;
    break; 

  case Decl: 
    PrintDecl (out, node , & node ->u.decl,offset,norecurse) ; 
    break; 

  case Attrib: 
    PrintAttrib (out, node , &node ->u.attrib ,offset,norecurse) ; 
    break; 

  case Proc: 
    PrintProc (out,node , & node ->u.proc ,offset,norecurse) ;
    break; 

  case Text:
    PrintText (out, node , & node ->u.text ,offset,norecurse) ; 
    break;

  default: 
    Fail("print-ast.c", 658, "unexpected node type" ) ; 
    break; 
}

#if 0
#define CODE(name, node, union) Print##name(out,node,union,offset,norecurse)
  ASTSWITCH(node, CODE)
#undef CODE
#endif

  if (node->analysis.livevars) {
    PrintCRSpaces(out, offset+2);
    PrintAnalysis(out, node);
  }
    
  --PrintInvocations;
}


GLOBAL void PrintList(FILE *out, List *list, int offset)
{
  ListMarker marker;
  Node *item;
  Bool firstp = TRUE;
  
  if (PrintInvocations++ == 0) {
    /* then we're the first invocation for this pass over the tree */
    ++PassCounter;
  }
  
  IterateList(&marker, list);
  while (NextOnList(&marker, (GenericREF) &item)) {
    if (firstp == TRUE)
      firstp = FALSE;
    else if (offset < 0) {
      fputs("\n\n", out);
      fflush(out);
    }
    else {
      PrintCRSpaces(out, offset);
      fflush(out);
    }
    PrintNode(out, item, offset);
  }
  
  if (firstp == TRUE) {
    fputs("nil", out);
    fflush(out);

  }

  --PrintInvocations;
}




/*************************************************************************/
/*                                                                       */
/*                      Low-level output routines                        */
/*                                                                       */
/*************************************************************************/

int print_float(FILE *fd, float val)
{
  int   i;
  char  fmt[8];
  char  buf[64];
  float tmp;
  
  i = 7;
  while (1)
    {
      sprintf(fmt, "%%.%dg", i);
      sprintf(buf, fmt, val);
      sscanf(buf, "%f", &tmp);
      if (tmp == val) break;
      i += 1;
      assert(i < 20);
    }
  
  return fprintf(fd, "%s", buf);
}


int print_double(FILE *fd, double val)
{
  int    i;
  char   fmt[8];
  char   buf[64];
  double tmp;
  
  i = 16;
  while (1)
    {
      sprintf(fmt, "%%.%dlg", i);
      sprintf(buf, fmt, val);
      sscanf(buf, "%lf", &tmp);
      if (tmp == val) break;
      i += 1;
      assert(i < 20);
    }
  
  return fprintf(fd, "%s", buf);
}

GLOBAL int PrintConstant(FILE *out, Node *c, Bool with_name)
{ int len = 0;
  
  if (with_name)
    switch (c->u.Const.type->typ) {
    case Prim:
      len = PrintPrimType(out, c->u.Const.type) + 1;
      fputc(' ', out);
      break;
      /* Used for strings */
    case Adcl:
      assert(c->u.Const.type->u.adcl.type->typ == Prim);
      fprintf(out, "array of ");
      len = PrintPrimType(out, c->u.Const.type->u.adcl.type) + 10;
      fputc(' ', out);
      break;
    default:
      len = fprintf(out, "??? ");
    }
  
  switch (c->u.Const.type->typ) {
  case Prim:
    switch (c->u.Const.type->u.prim.basic) {
    case Sint:
      return len + fprintf(out, "%d", c->u.Const.value.i);
      
      /*Manish 2/3 hack to print pointer constants */
    case Uint:
      return len + fprintf(out, "%uU", c->u.Const.value.u);
    case Slong:
      return len + fprintf(out, "%ldL", c->u.Const.value.l);
    case Ulong:
      return len + fprintf(out, "%luUL", c->u.Const.value.ul);
    case Float:
      return len + print_float(out, c->u.Const.value.f);
    case Double:
      return len + print_double(out, c->u.Const.value.d);
    case Char:
    case Schar:
    case Uchar:
      return len + PrintChar(out, c->u.Const.value.i);
      
    default:
      Fail(__FILE__, __LINE__, "");
      return 0;
    }
    
    /* Manish 2/3  Print Constant Pointers */
  case Ptr:
    return len + fprintf(out, "%u", c->u.Const.value.u);
    /* Used for strings */
  case Adcl:
    return len + PrintString(out, c->u.Const.value.s);
    
  default:
      /*assert(("Unrecognized constant type", TRUE));*/
      assert(FALSE);
    return 0;
  }
}

void PrintCRSpaces(FILE *out, int spaces)
{ fputc('\n', out); while (spaces--) fputc(' ', out); }

void PrintSpaces(FILE *out, int spaces)
{ while (spaces--) fputc(' ', out); }


GLOBAL void CharToText(char *array, unsigned char value)
{
  if (value < ' ') {
    static const char *names[32] = {
      "nul","soh","stx","etx","eot","enq","ack","bel",
      "\\b", "\\t", "\\n", "\\v", "ff", "cr", "so", "si",
      "dle","dc1","dc2","dc3","dc4","nak","syn","etb",
      "can","em", "sub","esc","fs", "gs", "rs", "us" };
    sprintf(array, "0x%02x (%s)", value, names[value]);
  } else if (value < 0x7f) {
    sprintf(array, "'%c'", value);
  } else if (value == 0x7f) {
    strcpy(array, "0x7f (del)");
  } else { /* value >= 0x80 */
    sprintf(array, "0x%x", value);
  }
}


GLOBAL inline int PrintChar(FILE *out, int value)
{
  switch(value) {
  case '\n': return fprintf(out, "\\n");
  case '\t': return fprintf(out, "\\t");
  case '\v': return fprintf(out, "\\v");
  case '\b': return fprintf(out, "\\b");
  case '\r': return fprintf(out, "\\r");
  case '\f': return fprintf(out, "\\f");
  case '\a': return fprintf(out, "\\a");
  case '\\': return fprintf(out, "\\\\");
  case '\?': return fprintf(out, "\\\?");
  case '\"': return fprintf(out, "\\\"");
  case '\'': return fprintf(out, "\\\'");
  default:
    if (isprint(value)) {
      fputc(value, out);
      return 1;
    } else {
      return fprintf(out, "\\%o", value);
    }
  }
}


GLOBAL int PrintString(FILE *out, const char *s)
{
  int len = 0;
  
  fputc('\"', out);
  while (*s != 0) {
    len += PrintChar(out, *s++);
  }
  fputc('\"', out);
  
  return len + 2;
}




