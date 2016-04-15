/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  verify-parse.c,v
 * Revision 1.17  1995/05/11  18:54:42  rcm
 * Added gcc extension __attribute__.
 *
 * Revision 1.16  1995/04/21  05:45:04  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.15  1995/04/09  21:31:04  rcm
 * Added Analysis phase to perform all analysis at one place in pipeline.
 * Also added checking for functions without return values and unreachable
 * code.  Added tests of live-variable analysis.
 *
 * Revision 1.14  1995/02/13  02:00:32  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.13  1995/02/01  23:02:11  rcm
 * Added Text node and #pragma collection
 *
 * Revision 1.12  1995/02/01  21:07:48  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.11  1995/02/01  07:39:27  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.10  1995/01/27  01:39:21  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.9  1995/01/25  02:16:30  rcm
 * Changed how Prim types are created and merged.
 *
 * Revision 1.8  1995/01/20  03:38:28  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.7  1995/01/06  16:49:20  rcm
 * added copyright message
 *
 * Revision 1.6  1994/12/23  09:18:54  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.5  1994/12/20  09:24:31  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.4  1994/11/22  01:54:57  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.3  1994/11/10  03:15:17  rcm
 * Removed unnecessary asserts in Switch, Case, and Default.
 *
 * Revision 1.2  1994/10/28  18:53:26  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Mon May 24 11:44:00 EDT 1993
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
#pragma ident "verify-parse.c,v 1.17 1995/05/11 18:54:42 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"

typedef enum verifycontext {
  TopLevel,
  FormalParm,
  StructField,
  Other
  } Context;

PRIVATE void VerifyNode(Node *node, Context c);
PRIVATE void VerifyType(Node *type);
PRIVATE void VerifyDeclList(List *list, Context c);
PRIVATE void VerifyExpr(Node *node);
PRIVATE void VerifyExprList(List *list);
PRIVATE void VerifyTypeOrExpr(Node *node);
PRIVATE void VerifyStmt(Node *node);
PRIVATE void VerifyStmtList(List *list);
PRIVATE void VerifyTq(TypeQual tq);
PRIVATE void VerifyScAndDq(TypeQual tq);


GLOBAL void VerifyParse(List *program)
{
  /* a program is a list of declarations and proc definitions */
  VerifyDeclList(program, TopLevel);
}


/*************************************************************************/
/*                                                                       */
/*                          Expression nodes                             */
/*                                                                       */
/*************************************************************************/

PRIVATE inline void VerifyConst(Node *node, ConstNode *u, Context c)
{
  VerifyType(u->type);
}

PRIVATE inline void VerifyId(Node *node, idNode *u, Context c)
{  
  Node *var;
  
  assert(u->text != NULL);
  var = u->decl;
  /* var can be NULL for struct/union field names, but VerifyExpr
     is not called for the right side of -> and . */
  if (var == NULL) {
      printf("NULL var.  u->text = '%s'\n", u->text);
  }
  assert(var != NULL);
  assert(var->typ == Decl);
  /* name in decl must match id name */
  assert(var->u.decl.name == u->text);
}

PRIVATE inline void VerifyBinop(Node *node, binopNode *u, Context c)
{
  /* fix: check op */
  if (u->op == ARROW || u->op == '.') {
    VerifyExpr(u->left);
    assert(u->right != NULL);
    assert(u->right->typ == Id);
    assert(u->right->u.id.decl == NULL);
  } else {
    VerifyExpr(u->left);
    VerifyExpr(u->right);
  }
}

PRIVATE inline void VerifyUnary(Node *node, unaryNode *u, Context c)
{
  /* fix: check op */
  if (u->op == SIZEOF)
    VerifyTypeOrExpr(u->expr);
  else VerifyExpr(u->expr);
}

PRIVATE inline void VerifyCast(Node *node, castNode *u, Context c)
{
  VerifyType(u->type);
  VerifyExpr(u->expr);
}

PRIVATE inline void VerifyComma(Node *node, commaNode *u, Context c)
{
  assert(u->exprs != NULL);
  VerifyExprList(u->exprs);
}

PRIVATE inline void VerifyTernary(Node *node, ternaryNode *u, Context c)
{
  VerifyExpr(u->cond);
  VerifyExpr(u->true);
  VerifyExpr(u->false);
}

PRIVATE inline void VerifyArray(Node *node, arrayNode *u, Context c)
{
  VerifyExpr(u->name);
  VerifyExprList(u->dims);
}

PRIVATE inline void VerifyCall(Node *node, callNode *u, Context c)
{
  VerifyExpr(u->name);
  /* u->args is NULL if there are no arguments */
  VerifyExprList(u->args);
}

PRIVATE inline void VerifyInitializer(Node *node, initializerNode *u, Context c)
{
  assert(u->exprs != NULL);
  VerifyExprList(u->exprs);
}

PRIVATE inline void VerifyImplicitCast(Node *node, implicitcastNode *u, Context c)
{
  if (u->expr != NULL)
    VerifyExpr(u->expr);
  if (u->type != NULL)
    VerifyType(u->type);
}

/*************************************************************************/
/*                                                                       */
/*                          Statement nodes                              */
/*                                                                       */
/*************************************************************************/

PRIVATE inline void VerifyLabel(Node *node, labelNode *u, Context c)
{
  assert(u->name != NULL);
  if (u->stmt) VerifyStmt(u->stmt);
}

PRIVATE inline void VerifySwitch(Node *node, SwitchNode *u, Context c)
{
  VerifyExpr(u->expr);
  if (u->stmt) VerifyStmt(u->stmt);
}

PRIVATE inline void VerifyCase(Node *node, CaseNode *u, Context c)
{
  VerifyExpr(u->expr);
  if (u->stmt) VerifyStmt(u->stmt);
}

PRIVATE inline void VerifyDefault(Node *node, DefaultNode *u, Context c)
{
  if (u->stmt) VerifyStmt(u->stmt);
}

PRIVATE inline void VerifyIf(Node *node, IfNode *u, Context c)
{
  VerifyExpr(u->expr);
  /* `true' field may be NULL, e.g.,  if (1) {} */
  if (u->stmt) VerifyStmt(u->stmt);
}

PRIVATE inline void VerifyIfElse(Node *node, IfElseNode *u, Context c)
{
  VerifyExpr(u->expr);
  /* `true' field may be NULL, e.g.,  if (1) {} */
  if (u->true) VerifyStmt(u->true);
  /* `false' field may be NULL */
  if (u->false) VerifyStmt(u->false);
}

PRIVATE inline void VerifyWhile(Node *node, WhileNode *u, Context c)
{
  VerifyExpr(u->expr);
  if (u->stmt) VerifyStmt(u->stmt);
}

PRIVATE inline void VerifyDo(Node *node, DoNode *u, Context c)
{
  VerifyExpr(u->expr);
  if (u->stmt) VerifyStmt(u->stmt);
}

PRIVATE inline void VerifyFor(Node *node, ForNode *u, Context c)
{
  /* any field may be NULL */
  if (u->init) VerifyExpr(u->init);
  if (u->cond) VerifyExpr(u->cond);
  if (u->next) VerifyExpr(u->next);
  if (u->stmt) VerifyStmt(u->stmt);
}

PRIVATE inline void VerifyGoto(Node *node, GotoNode *u, Context c)
{
  Node *var;
  
  var = u->label;
  assert(var != NULL);
  assert(var->typ == Label);
}

PRIVATE inline void VerifyContinue(Node *node, ContinueNode *u, Context c)
{
}

PRIVATE inline void VerifyBreak(Node *node, BreakNode *u, Context c)
{
}

PRIVATE inline void VerifyReturn(Node *node, ReturnNode *u, Context c)
{
  /* expr may be NULL */
  if (u->expr) VerifyExpr(u->expr);
  assert(u->proc);
  assert(u->proc->typ == Proc);
}

PRIVATE inline void VerifyBlock(Node *node, BlockNode *u, Context c)
{
  VerifyDeclList(u->decl, Other);
  VerifyStmtList(u->stmts);
}


/*************************************************************************/
/*                                                                       */
/*                             Type nodes                                */
/*                                                                       */
/*************************************************************************/

PRIVATE inline void VerifyPrim(Node *node, primNode *u, Context c)
{
  VerifyTq(u->tq);
  assert(u->basic > 0 && u->basic < MaxBasicType && u->basic != Int_ParseOnly);
}

PRIVATE inline void VerifyTdef(Node *node, tdefNode *u, Context c)
{
  VerifyTq(u->tq);
  assert(u->name != NULL);
  VerifyType(u->type);
}

PRIVATE inline void VerifyPtr(Node *node, ptrNode *u, Context c)
{
  VerifyTq(u->tq);
  VerifyType(u->type);
}

PRIVATE inline void VerifyAdcl(Node *node, adclNode *u, Context c)
{
  assert(u->tq == EMPTY_TQ);
  VerifyType(u->type);
  if (u->dim) VerifyExpr(u->dim);  /* can be null */
}

PRIVATE inline void VerifyFdcl(Node *node, fdclNode *u, Context c)
{
  assert(u->tq == EMPTY_TQ || u->tq == T_INLINE);
  VerifyType(u->returns);
  VerifyDeclList(u->args, FormalParm);
}

PRIVATE inline void VerifySdcl(Node *node, sdclNode *u, Context c)
{
  VerifyTq(u->tq);
  assert(u->type != NULL);
  assert(u->type->typ == Sdcl);
  /* u->type->name could be NULL */

  if (SUE_ELABORATED(u->tq)) {
    VerifyDeclList(u->type->fields, StructField);
  }
}

PRIVATE inline void VerifyUdcl(Node *node, udclNode *u, Context c)
{
  VerifyTq(u->tq);
  assert(u->type != NULL);
  assert(u->type->typ == Udcl);
  /* u->type->name could be NULL */

  if (SUE_ELABORATED(u->tq)) {
    VerifyDeclList(u->type->fields, StructField);
  }
}

PRIVATE inline void VerifyEdcl(Node *node, edclNode *u, Context c)
{
  VerifyTq(u->tq);
  assert(u->type != NULL);
  /* fix: verify list? */
#if 0
  /* unlike struct/union, there are no empty enum declarations */
  fprintf(stderr, "unexpected node type %d\n", decl->typ);
  assert(FALSE);
#endif
}

/*************************************************************************/
/*                                                                       */
/*                      Other nodes (decls et al.)                       */
/*                                                                       */
/*************************************************************************/

PRIVATE inline void VerifyDecl(Node *node, declNode *u, Context c)
{
  if (c != StructField) assert(u->name != NULL);
  VerifyScAndDq(u->tq);
  VerifyType(u->type);
  if (u->init != NULL) {
    VerifyExpr(u->init);
    assert(u->bitsize == NULL);
  } 
  if (u->bitsize != NULL) {
    VerifyExpr(u->bitsize);
    assert(u->init == NULL);
  }	
}

PRIVATE inline void VerifyAttrib(Node *node, attribNode *u, Context c)
{
}

PRIVATE inline void VerifyProc(Node *node, procNode *u, Context c)
{
  assert(u->decl != NULL);
  assert(u->decl->typ == Decl);
  assert(u->decl->u.decl.type != NULL);
  assert(u->decl->u.decl.type->typ == Fdcl);
  VerifyNode(u->decl, Other);
  
  /* body must be a Block, but could be NULL */
  if (u->body != NULL) {
    assert(u->body->typ == Block);
    VerifyStmt(u->body);
  }
}

PRIVATE inline void VerifyText(Node *node, textNode *u, Context c)
{
  /* anything goes */
}

/*************************************************************************/
/*                                                                       */
/*                            Extensions                                 */
/*                                                                       */
/*************************************************************************/






/*************************************************************************/
/*                                                                       */
/*                        Verify et al.                              */
/*                                                                       */
/*************************************************************************/

PRIVATE void VerifyNode(Node *node, Context c)
{
  assert(node);
  
#define CODE(name, node, union) Verify##name(node, union, c);
  ASTSWITCH(node, CODE)
#undef CODE
  }



PRIVATE void VerifyTq(TypeQual tq)
{
  assert(tq == TYPE_QUALS(tq));
}

PRIVATE void VerifyScAndDq(TypeQual tq)
{
  int sc = STORAGE_CLASS(tq);
  int dl = DECL_LOCATION(tq);
  assert(sc == 0  ||  sc == T_TYPEDEF  || sc == T_EXTERN
	 || sc == T_STATIC  || sc == T_AUTO  || sc == T_REGISTER);
  assert(dl == T_TOP_DECL || dl == T_BLOCK_DECL || dl == T_FORMAL_DECL ||
	 dl == T_SU_DECL || dl == T_ENUM_DECL);
  assert(TYPE_QUALS(tq) == 0);
}


PRIVATE void VerifyType(Node *type)
{
  assert(type);
  assert(IsType(type));
  VerifyNode(type, Other);
}


PRIVATE void VerifyDeclList(List *list, Context c)
{
  ListMarker marker;
  Node *decl;
  
  IterateList(&marker, list);
  while (NextOnList(&marker, (GenericREF) &decl)) {
    assert(decl);
    
    switch (c) {
    case TopLevel:
      assert(IsDecl(decl));
      break;
      
    case FormalParm:
      assert(decl->typ == Decl ||
	     IsType(decl));
      break;
      
    default:
      assert(IsDecl(decl) && decl->typ != Proc);
      break;
    }
    
    VerifyNode(decl, c);
  }
}


PRIVATE void VerifyExpr(Node *node)
{
  assert(node);
  assert(IsExpr(node));
  VerifyNode(node, Other);
}

PRIVATE void VerifyExprList(List *list)
{
  ListMarker marker;
  Node *item;
  
  IterateList(&marker, list);
  while (NextOnList(&marker, (GenericREF) &item))
    VerifyExpr(item);
}

PRIVATE void VerifyTypeOrExpr(Node *node)
{
  assert(node);
  assert(IsType(node) || IsExpr(node));
  VerifyNode(node, Other);
}


PRIVATE void VerifyStmt(Node *node)
{
  assert(node);
  assert(IsStmt(node));
  VerifyNode(node, Other);
}

PRIVATE void VerifyStmtList(List *list)
{
  ListMarker marker;
  Node *item;
  
  IterateList(&marker, list);
  while (NextOnList(&marker, (GenericREF) &item))
    if (item) /* NULL statements are legal */
      VerifyStmt(item);
}
