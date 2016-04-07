/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  ast.c,v
 * Revision 1.14  1995/05/11  18:54:05  rcm
 * Added gcc extension __attribute__.
 *
 * Revision 1.13  1995/05/05  19:18:21  randall
 * Added #include reconstruction.
 *
 * Revision 1.12  1995/04/21  05:44:01  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.11  1995/03/23  15:30:46  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.10  1995/03/01  16:23:03  rcm
 * Various type-checking bug fixes; added T_REDUNDANT_EXTERNAL_DECL.
 *
 * Revision 1.9  1995/02/13  18:14:51  rcm
 * Fixed LISTWALK to skip non-null list members.
 *
 * Revision 1.8  1995/02/13  01:59:57  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.7  1995/02/01  23:03:40  rcm
 * Added Text node and #pragma collection
 *
 * Revision 1.6  1995/02/01  21:07:05  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.5  1995/01/27  01:38:50  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.4  1995/01/20  03:37:57  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.3  1995/01/06  16:48:30  rcm
 * added copyright message
 *
 * Revision 1.2  1994/12/23  09:18:14  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.1  1994/12/20  09:20:20  rcm
 * Created
 *
 * Revision 1.5  1994/11/22  01:54:32  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.4  1994/11/10  03:13:14  rcm
 * Fixed line numbers on AST nodes.
 *
 * Revision 1.3  1994/11/03  07:38:43  rcm
 * Added code to output C from the parse tree.
 *
 * Revision 1.2  1994/10/28  18:52:32  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Mon Apr 26 12:48:52 EDT 1993
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
#pragma ident "ast.c,v 1.14 1995/05/11 18:54:05 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"


extern char *Filename; /* current filename */
extern int Line; /* current linenumber */

Coord UnknownCoord = { 
  /* line:   */ 0,
  /* offset: */ 0,
  /* file:   */	0,
  /* includedp: */ FALSE
  };
			 


/* use HeapNew() (defined in ast.h) to allocate whole objects */
GLOBAL inline void *HeapAllocate(int number, int size)
{ 
  return calloc(number, size);
}

GLOBAL inline void HeapFree(void *ptr)
{
  free(ptr);
}



GLOBAL inline Node *NewNode(NodeType typ)
{
    Node *create = HeapNew(Node);

    create->typ = typ;
    create->coord = UnknownCoord;
    create->parenthesized = FALSE;
    create->analysis.livevars = NULL;
    return(create);
}



/*************************************************************************/
/*                                                                       */
/*                          Expression nodes                             */
/*                                                                       */
/*************************************************************************/

GLOBAL inline Node *MakeConstSint(int value)
{ Node *node = NewNode(Const);
  node->u.Const.type = PrimSint;
  node->u.Const.value.i  = value;
  node->u.Const.text = NULL;
  return node;
}

GLOBAL inline Node *MakeConstSintTextCoord(const char *text, int value, Coord coord)
{
  Node *create = MakeConstSint(value);
  create->u.Const.text = text;
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeConstPtr(unsigned int value)
{ Node *node = NewNode(Const);
  node->u.Const.type = PtrVoid;
  node->u.Const.value.u  = value;
  node->u.Const.text = NULL;
  return node;
}

GLOBAL inline Node *MakeConstPtrTextCoord(const char *text, unsigned int value, Coord coord)
{
  Node *create = MakeConstPtr(value);
  create->u.Const.text = text;
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeConstUint(unsigned int value)
{ Node *node = NewNode(Const);
  node->u.Const.type = PrimUint;
  node->u.Const.value.u  = value;
  node->u.Const.text = NULL;
  return node;
}

GLOBAL inline Node *MakeConstUintTextCoord(const char *text, unsigned int value, Coord coord)
{
  Node *create = MakeConstUint(value);
  create->u.Const.text = text;
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeConstSlong(long value)
{ Node *node = NewNode(Const);
  node->u.Const.type = PrimSlong;
  node->u.Const.value.l  = value;
  node->u.Const.text = NULL;
  return node;
}

GLOBAL inline Node *MakeConstSlongTextCoord(const char *text, long value, Coord coord)
{
  Node *create = MakeConstSlong(value);
  create->u.Const.text = text;
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeConstUlong(unsigned long value)
{ Node *node = NewNode(Const);
  node->u.Const.type = PrimUlong;
  node->u.Const.value.ul  = value;
  node->u.Const.text = NULL;
  return node;
}

GLOBAL inline Node *MakeConstUlongTextCoord(const char *text, unsigned long value, Coord coord)
{
  Node *create = MakeConstUlong(value);
  create->u.Const.text = text;
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeConstFloat(float value)
{ Node *node = NewNode(Const);
  node->u.Const.type = PrimFloat;
  node->u.Const.value.f  = value;
  node->u.Const.text = NULL;
  return node;
}

GLOBAL inline Node *MakeConstFloatTextCoord(const char *text, float value, Coord coord)
{
  Node *create = MakeConstFloat(value);
  create->u.Const.text = text;
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeConstDouble(double value)
{ Node *node = NewNode(Const);
  node->u.Const.type = PrimDouble;
  node->u.Const.value.d  = value;
  node->u.Const.text = NULL;
  return node;
}

GLOBAL inline Node *MakeConstDoubleTextCoord(const char *text, double value, Coord coord)
{
  Node *create = MakeConstDouble(value);
  create->u.Const.text = text;
  create->coord = coord;
  return(create);
}



GLOBAL inline Node *MakeString(const char *value)
{ Node *node = NewNode(Const),
       *adcl = MakeAdcl(EMPTY_TQ, PrimChar, MakeConstSint(strlen(value) + 1));

  node->u.Const.type = adcl;
  node->u.Const.value.s  = value; /* quotes stripped, escape sequences converted */
  node->u.Const.text = NULL;
  return node;
}

GLOBAL inline Node *MakeStringTextCoord(const char *text, const char *value, Coord coord)
{
  Node *create = MakeString(value);
  create->u.Const.text = text;
  create->coord = coord;
  return(create);
}


GLOBAL inline Node *MakeId(const char* text)
{
    Node *create = NewNode(Id);

    create->u.id.text = text;
    create->u.id.decl = NULL;
    return(create);
}

GLOBAL inline Node *MakeIdCoord(const char* text, Coord coord)
{
  Node *create = MakeId(text);
  create->coord = coord;
  return(create);
}



GLOBAL inline Node *MakeUnary(OpType op, Node *expr)
{ Node *create = NewNode(Unary);

  if (op == '*')
    op = INDIR;
  else if (op == '&')
    op = ADDRESS;
  else if (op == '-')
    op = UMINUS;
  else if (op == '+')
    op = UPLUS;
      
  create->u.unary.op   = op;
  create->u.unary.expr = expr;

  create->u.unary.type = NULL;
  create->u.unary.value = NULL;
  
  return create;
}

GLOBAL inline Node *MakeUnaryCoord(OpType op, Node *expr, Coord coord)
{
  Node *create = MakeUnary(op, expr);
  create->coord = coord;
  return(create);
}


GLOBAL inline Node *MakeBinop(OpType op, Node *left, Node *right)
{ 
  Node *create = NewNode(Binop);

  create->u.binop.op    = op;
  create->u.binop.left  = left;
  create->u.binop.right = right;
  create->u.binop.type = NULL;
  create->u.binop.value = NULL;
  return(create);
}

GLOBAL inline Node *MakeBinopCoord(OpType op, Node *left, Node *right, Coord coord)
{
  Node *create = MakeBinop(op, left, right);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeCast(Node *type, Node *expr)
{ Node *create = NewNode(Cast);

  create->u.cast.type = type;
  create->u.cast.expr = expr;
  create->u.cast.value = NULL;
  return(create);
}

GLOBAL inline Node *MakeCastCoord(Node *type, Node *expr, Coord coord)
{
  Node *create = MakeCast(type, expr);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeComma(List* exprs)
{
    Node *create = NewNode(Comma);
    create->u.comma.exprs  = exprs;
    return(create);
}

GLOBAL inline Node *MakeCommaCoord(List* exprs, Coord coord)
{
  Node *create = MakeComma(exprs);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeTernary(Node *cond, Node *true, Node *false)
{
    Node *create = NewNode(Ternary);
    create->u.ternary.cond  = cond;
    create->u.ternary.true  = true;
    create->u.ternary.false = false;
    create->u.ternary.colon_coord = UnknownCoord;
    create->u.ternary.type  = NULL;
    create->u.ternary.value = NULL;
    return(create);
}

GLOBAL inline Node *MakeTernaryCoord(Node *cond, Node *true, Node *false, Coord qmark_coord, Coord colon_coord)
{
  Node *create = MakeTernary(cond, true, false);
  create->coord = qmark_coord;
  create->u.ternary.colon_coord = colon_coord;
  return(create);
}

GLOBAL inline Node *MakeArray(Node *name, List* dims)
{
    Node *create = NewNode(Array);
    create->u.array.type = NULL;
    create->u.array.name = name;
    create->u.array.dims = dims;
    return(create);
}

GLOBAL inline Node *MakeArrayCoord(Node *name, List* dims, Coord coord)
{
  Node *create = MakeArray(name, dims);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeCall(Node *name, List* args)
{
    Node *create = NewNode(Call);
    create->u.call.name = name;
    create->u.call.args = args;
    create->coord = name->coord;
    return(create);
}

GLOBAL inline Node *MakeCallCoord(Node *name, List* args, Coord coord)
{
  Node *create = MakeCall(name, args);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeInitializer(List* exprs)
{
    Node *create = NewNode(Initializer);
    create->u.comma.exprs  = exprs;
    return(create);
}

GLOBAL inline Node *MakeInitializerCoord(List* exprs, Coord coord)
{
  Node *create = MakeInitializer(exprs);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeImplicitCast(Node *type, Node *expr)
{
  Node *create = NewNode(ImplicitCast);

  create->u.implicitcast.type = type;
  create->u.implicitcast.expr = expr;
  create->u.implicitcast.value = NULL;
  return(create);
}

GLOBAL inline Node *MakeImplicitCastCoord(Node *type, Node *expr, Coord coord)
{
  Node *create = MakeImplicitCast(type, expr);
  create->coord = coord;
  return(create);
}

/*************************************************************************/
/*                                                                       */
/*                          Statement nodes                              */
/*                                                                       */
/*************************************************************************/

GLOBAL inline Node *MakeLabel(const char* name, Node *stmt)
{
    Node *create = NewNode(Label);
    create->u.label.name       = name;
    create->u.label.stmt       = stmt;
    create->u.label.references = NULL;
    return(create);
}

GLOBAL inline Node *MakeLabelCoord(const char* name, Node *stmt, Coord coord)
{
  Node *create = MakeLabel(name, stmt);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeSwitch(Node *expr, Node *stmt, List* cases)
{
    Node *create = NewNode(Switch);
    create->u.Switch.expr = expr;
    create->u.Switch.stmt = stmt;
    create->u.Switch.cases = cases;
    create->u.Switch.has_default = FALSE;
    while (cases) {
      Node *n = FirstItem(cases);
      assert(n);
      if (n->typ == Default)
	create->u.Switch.has_default = TRUE;
      cases = Rest(cases);
    }
    return(create);
}

GLOBAL inline Node *MakeSwitchCoord(Node *expr, Node *stmt, List* cases, Coord coord)
{
  Node *create = MakeSwitch(expr, stmt, cases);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeCase(Node *expr, Node *stmt, Node *container)
{
    Node *create = NewNode(Case);
    create->u.Case.expr = expr;
    create->u.Case.stmt = stmt;
    create->u.Case.container = container;
    return(create);
}

GLOBAL inline Node *MakeCaseCoord(Node *expr, Node *stmt, Node *container, Coord coord)
{
  Node *create = MakeCase(expr, stmt, container);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeDefault(Node *stmt, Node *container)
{
    Node *create = NewNode(Default);
    create->u.Default.stmt = stmt;
    create->u.Default.container = container;
    return(create);
}

GLOBAL inline Node *MakeDefaultCoord(Node *stmt, Node *container, Coord coord)
{
  Node *create = MakeDefault(stmt, container);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeIf(Node *expr, Node *stmt)
{
    Node *create = NewNode(If);
    create->u.If.expr = expr;
    create->u.If.stmt = stmt;
    return(create);
}

GLOBAL inline Node *MakeIfCoord(Node *expr, Node *stmt, Coord coord)
{
  Node *create = MakeIf(expr, stmt);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeIfElse(Node *expr, Node *true, Node *false)
{
    Node *create = NewNode(IfElse);
    create->u.IfElse.expr = expr;
    create->u.IfElse.true = true;
    create->u.IfElse.false = false;
    create->u.IfElse.else_coord = UnknownCoord;
    return(create);
}

GLOBAL inline Node *MakeIfElseCoord(Node *expr, Node *true, Node *false, Coord if_coord, Coord else_coord)
{
  Node *create = MakeIfElse(expr, true, false);
  create->coord = if_coord;
  create->u.IfElse.else_coord = else_coord;
  return(create);
}

GLOBAL inline Node *MakeWhile(Node *expr, Node *stmt)
{
    Node *create = NewNode(While);
    create->u.While.expr = expr;
    create->u.While.stmt = stmt;
    return(create);
}

GLOBAL inline Node *MakeWhileCoord(Node *expr, Node *stmt, Coord coord)
{
  Node *create = MakeWhile(expr, stmt);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeDo(Node *stmt, Node *expr)
{
    Node *create = NewNode(Do);
    create->u.Do.stmt = stmt;
    create->u.Do.expr = expr;
    create->u.Do.while_coord = UnknownCoord;
    return(create);
}

GLOBAL inline Node *MakeDoCoord(Node *stmt, Node *expr, Coord do_coord, Coord while_coord)
{
  Node *create = MakeDo(stmt, expr);
  create->coord = do_coord;
  create->u.Do.while_coord = while_coord;
  return(create);
}

GLOBAL inline Node *MakeFor(Node *init, Node *cond, Node *next, Node *stmt)
{
    Node *create = NewNode(For);
    create->u.For.init = init;
    create->u.For.cond = cond;
    create->u.For.next = next;
    create->u.For.stmt = stmt;
    return(create);
}

GLOBAL inline Node *MakeForCoord(Node *init, Node *cond, Node *next, Node *stmt, Coord coord)
{
  Node *create = MakeFor(init, cond, next, stmt);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeGoto(Node* label)
{
    Node *create = NewNode(Goto);
    create->u.Goto.label = label;
    return(create);
}

GLOBAL inline Node *MakeGotoCoord(Node* label, Coord coord)
{
  Node *create = MakeGoto(label);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeContinue(Node *container)
{
    Node *create = NewNode(Continue);
    create->u.Continue.container = container;
    return(create);
}

GLOBAL inline Node *MakeContinueCoord(Node *container, Coord coord)
{
  Node *create = MakeContinue(container);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeBreak(Node *container)
{
    Node *create = NewNode(Break);

    create->u.Break.container = container;
    return(create);
}

GLOBAL inline Node *MakeBreakCoord(Node *container, Coord coord)
{
  Node *create = MakeBreak(container);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeReturn(Node *expr)
{
    Node *create = NewNode(Return);

    create->u.Return.expr = expr;
    create->u.Return.proc = NULL;
    return(create);
}

GLOBAL inline Node *MakeReturnCoord(Node *expr, Coord coord)
{
  Node *create = MakeReturn(expr);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeBlock(Node *type, List* decl, List* stmts)
{
  Node *create = NewNode(Block);
  create->u.Block.type  = type;
  create->u.Block.decl  = decl;
  create->u.Block.stmts = stmts;
  create->u.Block.right_coord = UnknownCoord;
  return(create);
}

GLOBAL inline Node *MakeBlockCoord(Node *type, List* decl, List* stmts, Coord left_coord, Coord right_coord)
{
  Node *create = MakeBlock(type, decl, stmts);
  create->coord = left_coord;
  create->u.Block.right_coord = right_coord;
  return(create);
}

/*************************************************************************/
/*                                                                       */
/*                            Type nodes                                 */
/*                                                                       */
/*************************************************************************/

GLOBAL inline Node *MakePrim(TypeQual tq, BasicType basic)
{
    Node *create = NewNode(Prim);

    create->u.prim.tq = tq;
    create->u.prim.basic = basic;
    return(create);
}

GLOBAL inline Node *MakePrimCoord(TypeQual tq, BasicType basic, Coord coord)
{
  Node *create = MakePrim(tq, basic);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeTdef(TypeQual tq, const char *name)
{
  Node *create = NewNode(Tdef);
  create->u.tdef.name = name;
  create->u.tdef.tq = tq;
  create->u.tdef.type = NULL;
  return(create);
}

GLOBAL inline Node *MakeTdefCoord(TypeQual tq, const char *name, Coord coord)
{
  Node *create = MakeTdef(tq, name);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakePtr(TypeQual tq, Node *type)
{
    Node *create = NewNode(Ptr);
    create->u.ptr.tq = tq;
    create->u.ptr.type = type;
    return(create);
}

GLOBAL inline Node *MakePtrCoord(TypeQual tq, Node *type, Coord coord)
{
  Node *create = MakePtr(tq, type);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeAdcl(TypeQual tq, Node *type, Node *dim)
{
    Node *create = NewNode(Adcl);
    create->u.adcl.tq = tq;
    create->u.adcl.type = type;
#if 0
/* fix: we need to constant-fold dim during the parse phase in order to
   compare the types of multiply-declared arrays, but this probably isn't
    the best place to do it. -- rcm */
    create->u.adcl.dim  = SemCheckNode(dim);
#endif
    create->u.adcl.dim = dim;
    create->u.adcl.size = 0;
    return(create);
}

GLOBAL inline Node *MakeAdclCoord(TypeQual tq, Node *type, Node *dim, Coord coord)
{
  Node *create = MakeAdcl(tq, type, dim);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeFdcl(TypeQual tq, List* args, Node *returns)
{
    Node *create = NewNode(Fdcl);
    create->u.fdcl.tq = tq;
    create->u.fdcl.args = args;
    create->u.fdcl.returns = returns;
    return(create);
}

GLOBAL inline Node *MakeFdclCoord(TypeQual tq, List* args, Node *returns, Coord coord)
{
  Node *create = MakeFdcl(tq, args, returns);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeSdcl(TypeQual tq, SUEtype* type)
{
    Node *create = NewNode(Sdcl);
    create->u.sdcl.tq   = tq;
    create->u.sdcl.type = type;
    return(create);
}

GLOBAL inline Node *MakeSdclCoord(TypeQual tq, SUEtype* type, Coord coord)
{
  Node *create = MakeSdcl(tq, type);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeUdcl(TypeQual tq, SUEtype* type)
{
    Node *create = NewNode(Udcl);
    create->u.udcl.tq   = tq;
    create->u.udcl.type = type;
    return(create);
}

GLOBAL inline Node *MakeUdclCoord(TypeQual tq, SUEtype* type, Coord coord)
{
  Node *create = MakeUdcl(tq, type);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeEdcl(TypeQual tq, SUEtype* type)
{
    Node *create = NewNode(Edcl);
    create->u.edcl.tq = tq;
    create->u.edcl.type = type;
    return(create);
}

GLOBAL inline Node *MakeEdclCoord(TypeQual tq, SUEtype* type, Coord coord)
{
  Node *create = MakeEdcl(tq, type);
  create->coord = coord;
  return(create);
}


/*************************************************************************/
/*                                                                       */
/*                      Other nodes (decls et al.)                       */
/*                                                                       */
/*************************************************************************/

GLOBAL inline Node *MakeDecl(const char *name, TypeQual tq, Node *type, Node *init, Node *bitsize)
{
  Node *create = NewNode(Decl);
  create->u.decl.name = name;
  create->u.decl.tq = tq;
  create->u.decl.type = type;
  create->u.decl.init = init;
  create->u.decl.bitsize = bitsize;
  create->u.decl.references = 0;
  create->u.decl.attribs = NULL;
  return(create);
}

GLOBAL inline Node *MakeDeclCoord(const char *name, TypeQual tq, Node *type, Node *init, Node *bitsize, Coord coord)
{
  Node *create = MakeDecl(name, tq, type, init, bitsize);
  create->coord = coord;
  return(create);
}

GLOBAL inline Node *MakeAttrib(const char *name, Node *arg)
{
  Node *create = NewNode(Attrib);
  create->u.attrib.name = name;
  create->u.attrib.arg = arg;
  return create;
}

GLOBAL inline Node *MakeAttribCoord(const char *name, Node *arg, Coord coord)
{
  Node *create = MakeAttrib(name, arg);
  create->coord = coord;
  return create;
}

GLOBAL inline Node *MakeProc(Node *decl, Node *body)
{
    Node *create = NewNode(Proc);
    create->u.proc.decl = decl;
    create->u.proc.body = body;
    return(create);
}

GLOBAL inline Node *MakeProcCoord(Node *decl, Node *body, Coord coord)
{
    Node *create = MakeProc(decl, body);
    create->coord = coord;
    return(create);
}

GLOBAL inline Node *MakeText(const char *text, Bool start_new_line)
{
  Node *create = NewNode(Text);
  create->u.text.text = text;
  create->u.text.start_new_line = start_new_line;
  return create;
}

GLOBAL inline Node *MakeTextCoord(const char *text, Bool start_new_line, Coord coord)
{
  Node *create = MakeText(text, start_new_line);
  create->coord = coord;
  return create;
}


/*************************************************************************/
/*                                                                       */
/*                            Extensions                                 */
/*                                                                       */
/*************************************************************************/







/*****************************************************************
 
                Converting nodes between types

*****************************************************************/

GLOBAL Node *ConvertIdToTdef(Node *id, TypeQual tq, Node *type)
{
    assert(id->typ == Id);
    id->typ = Tdef;
    id->u.tdef.name = id->u.id.text;
    id->u.tdef.tq = tq;
    id->u.tdef.type = type;
    return(id);
}

GLOBAL Node *ConvertIdToDecl(Node *id, TypeQual tq, Node *type, Node *init, Node *bitsize)
{
    assert(id->typ == Id);
    id->typ = Decl;
    id->u.decl.name = id->u.id.text;
    id->u.decl.tq = tq;
    id->u.decl.type = type;
    id->u.decl.init = init;
    id->u.decl.bitsize = bitsize;
    id->u.decl.references = 0;
    return(id);
}

GLOBAL Node *ConvertIdToAttrib(Node *id, Node *arg)
{
    assert(id->typ == Id);
    id->typ = Attrib;
    id->u.attrib.name = id->u.id.text;
    id->u.attrib.arg = arg;
    return(id);
}


#if 0
/* dead code -- rcm */
GLOBAL Node *AdclFdclToPtr(Node *node)
{
  if (node->typ == Decl)
    if (node->u.decl.type->typ == Adcl)
      node->u.decl.type->typ = Ptr;
    else if (node->u.decl.type->typ == Fdcl)
      node->u.decl.type = MakePtrCoord(EMPTY_TQ, node->u.decl.type, node->coord);

  return node;
}
#endif




/*****************************************************************
 
                      Node-kind predicates

*****************************************************************/

GLOBAL inline Bool IsExpr(Node *node)
{ return KindsOfNode(node) & KIND_EXPR; }

GLOBAL inline Bool IsStmt(Node *node)
{ return KindsOfNode(node) & KIND_STMT; }

GLOBAL inline Bool IsType(Node *node)
{ return KindsOfNode(node) & KIND_TYPE; }

GLOBAL inline Bool IsDecl(Node *node)
{ return KindsOfNode(node) & KIND_DECL; }


/*************************************************************************/
/*                                                                       */
/*                          Expression nodes                             */
/*                                                                       */
/*************************************************************************/

PRIVATE inline Kinds KindsOfConst()
{ return KIND_EXPR | KIND_STMT; }

PRIVATE inline Kinds KindsOfId()
{ return KIND_EXPR | KIND_STMT; }

PRIVATE inline Kinds KindsOfBinop()
{ return KIND_EXPR | KIND_STMT; }

PRIVATE inline Kinds KindsOfUnary()
{ return KIND_EXPR | KIND_STMT; }

PRIVATE inline Kinds KindsOfCast()
{ return KIND_EXPR | KIND_STMT; }

PRIVATE inline Kinds KindsOfComma()
{ return KIND_EXPR | KIND_STMT; }

PRIVATE inline Kinds KindsOfTernary()
{ return KIND_EXPR | KIND_STMT; }

PRIVATE inline Kinds KindsOfArray()
{ return KIND_EXPR | KIND_STMT; }

PRIVATE inline Kinds KindsOfCall()
{ return KIND_EXPR | KIND_STMT; }

PRIVATE inline Kinds KindsOfInitializer()
{ return KIND_EXPR | KIND_STMT; }

PRIVATE inline Kinds KindsOfImplicitCast()
{ return KIND_EXPR | KIND_STMT; }

/*************************************************************************/
/*                                                                       */
/*                          Statement nodes                              */
/*                                                                       */
/*************************************************************************/

PRIVATE inline Kinds KindsOfLabel()
{ return KIND_STMT; }

PRIVATE inline Kinds KindsOfSwitch()
{ return KIND_STMT; }

PRIVATE inline Kinds KindsOfCase()
{ return KIND_STMT; }

PRIVATE inline Kinds KindsOfDefault()
{ return KIND_STMT; }

PRIVATE inline Kinds KindsOfIf()
{ return KIND_STMT; }

PRIVATE inline Kinds KindsOfIfElse()
{ return KIND_STMT; }

PRIVATE inline Kinds KindsOfWhile()
{ return KIND_STMT; }

PRIVATE inline Kinds KindsOfDo()
{ return KIND_STMT; }

PRIVATE inline Kinds KindsOfFor()
{ return KIND_STMT; }

PRIVATE inline Kinds KindsOfGoto()
{ return KIND_STMT; }

PRIVATE inline Kinds KindsOfContinue()
{ return KIND_STMT; }

PRIVATE inline Kinds KindsOfBreak()
{ return KIND_STMT; }

PRIVATE inline Kinds KindsOfReturn()
{ return KIND_STMT; }

PRIVATE inline Kinds KindsOfBlock()
{ return ANSIOnly ? KIND_STMT : KIND_STMT | KIND_EXPR; }


/*************************************************************************/
/*                                                                       */
/*                             Type nodes                                */
/*                                                                       */
/*************************************************************************/

PRIVATE inline Kinds KindsOfPrim()
{ return KIND_TYPE; }

PRIVATE inline Kinds KindsOfTdef()
{ return KIND_TYPE; }

PRIVATE inline Kinds KindsOfPtr()
{ return KIND_TYPE; }

PRIVATE inline Kinds KindsOfAdcl()
{ return KIND_TYPE; }

PRIVATE inline Kinds KindsOfFdcl()
{ return KIND_TYPE; }

PRIVATE inline Kinds KindsOfSdcl()
{ return KIND_TYPE | KIND_DECL; }

PRIVATE inline Kinds KindsOfUdcl()
{ return KIND_TYPE | KIND_DECL; }

PRIVATE inline Kinds KindsOfEdcl()
{ return KIND_TYPE | KIND_DECL; }

/*************************************************************************/
/*                                                                       */
/*                      Other nodes (decls et al.)                       */
/*                                                                       */
/*************************************************************************/

PRIVATE inline Kinds KindsOfDecl()
{ return KIND_DECL; }

PRIVATE inline Kinds KindsOfAttrib()
{ return 0; }

PRIVATE inline Kinds KindsOfProc()
{ return KIND_DECL; }

PRIVATE inline Kinds KindsOfText()
{ return KIND_DECL | KIND_STMT; }


/*************************************************************************/
/*                                                                       */
/*                            Extensions                                 */
/*                                                                       */
/*************************************************************************/





/*************************************************************************/
/*                                                                       */
/*                           KindsOfNode                                 */
/*                                                                       */
/*************************************************************************/

GLOBAL inline Kinds KindsOfNode(Node *node)
{
#define CODE(name, node, union) return KindsOf##name()
  ASTSWITCH(node, CODE);
#undef CODE
    
  return 0; /* unreachable -- eliminates warning */
}  



/*************************************************************************/
/*                                                                       */
/*                           AST Operations                              */
/*                                                                       */
/*************************************************************************/

GLOBAL Node *NodeCopy(Node *from, TreeOpDepth d)
{
  Node *new = NewNode(from->typ);
  *new = *from;

  switch (from->typ) {
    /* for nodes with sub-lists, make new copy of sub-list */
  case Comma:         new->u.comma.exprs = ListCopy(new->u.comma.exprs);  break;
  case Array:         new->u.array.dims = ListCopy(new->u.array.dims);  break;
  case Call:          new->u.call.args = ListCopy(new->u.call.args);  break;
  case Initializer:   new->u.initializer.exprs = ListCopy(new->u.initializer.exprs);  break;
  case Block:         new->u.Block.decl = ListCopy(new->u.Block.decl);  new->u.Block.stmts = ListCopy(new->u.Block.stmts);  break;
  case Fdcl:          new->u.fdcl.args = ListCopy(new->u.fdcl.args);  break;

  case Sdcl:
  case Udcl:
  case Edcl:
    /* if from elaborated a struct/union's fields, new should not,
       since it's sharing */
    NodeRemoveTq(new, T_SUE_ELABORATED);
    break;
  default:
    break;
  }

  if (d == Subtree) {
    /* recursively copy children */
#define CHILD(n)   n = NodeCopy(n, d)
    ASTWALK(new, CHILD)
#undef CHILD
  }

  return new;
}



PRIVATE void SetCoordsNode(Node *node, Coord *c)
{
  node->coord = *c;

  /* handle special-case coordinates as well */
  switch (node->typ) {
  case Ternary: node->u.ternary.colon_coord = *c; break;
  case IfElse:  node->u.IfElse.else_coord = *c; break;
  case Do:      node->u.Do.while_coord = *c; break;
  case Block:   node->u.Block.right_coord = *c; break;
  case Sdcl:    
    if (SUE_ELABORATED(node->u.sdcl.tq)) {
      node->u.sdcl.type->coord = *c; 
      node->u.sdcl.type->right_coord = *c;
    }
    break;
  case Udcl:
    if (SUE_ELABORATED(node->u.udcl.tq)) {
      node->u.udcl.type->coord = *c; 
      node->u.udcl.type->right_coord = *c;
    }
    break;
  case Edcl:
    if (SUE_ELABORATED(node->u.edcl.tq)) {
      node->u.edcl.type->coord = *c; 
      node->u.edcl.type->right_coord = *c;
    }
    break;
  default:
    break;
  }
}


/* SetCoords sets all coordinates on a node or subtree to c. */
GLOBAL void SetCoords(Node *node, Coord c, TreeOpDepth d)
{
  if (d == NodeOnly)
    SetCoordsNode(node, &c);
  else WalkTree(node, (WalkProc)SetCoordsNode, &c, Preorder);

  if (d == Subtree) {
    #define CHILD(n)   SetCoords(n, c, d)
    ASTWALK(node, CHILD);
    #undef CHILD
  }
}


GLOBAL void WalkTree(Node *node, WalkProc proc, void *ptr, WalkOrder order)
{
  if (order == Preorder)
    proc(node, ptr);

  #define CHILD(n)   WalkTree(n, proc, ptr, order)
  ASTWALK(node, CHILD);
  #undef CHILD
  
  if (order == Postorder)
    proc(node, ptr);
}

