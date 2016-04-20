/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Rob Miller
 *  
 *  output.c,v
 * Revision 1.21  1995/05/11  18:54:22  rcm
 * Added gcc extension __attribute__.
 *
 * Revision 1.20  1995/05/08  04:30:39  randall
 * Cleaned up the #include-induced suppression of output generation.  Now,
 * #includes are only generated at the top level.  If they occur in a scope,
 * the file will be written to the output and no #include will be generated.
 *
 * Revision 1.19  1995/05/05  19:18:30  randall
 * Added #include reconstruction.
 *
 * Revision 1.18  1995/04/21  05:44:33  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.17  1995/04/09  21:30:50  rcm
 * Added Analysis phase to perform all analysis at one place in pipeline.
 * Also added checking for functions without return values and unreachable
 * code.  Added tests of live-variable analysis.
 *
 * Revision 1.16  1995/03/23  15:31:17  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.15  1995/02/13  02:00:16  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.14  1995/02/07  21:24:24  rcm
 * Fixed SetOutputCoord problem and allowed Text.text to be null
 *
 * Revision 1.13  1995/02/01  23:01:25  rcm
 * Added Text node and #pragma collection
 *
 * Revision 1.12  1995/02/01  21:07:20  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.11  1995/02/01  07:37:45  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.10  1995/01/27  01:39:01  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.9  1995/01/20  03:38:09  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.8  1995/01/06  16:48:57  rcm
 * added copyright message
 *
 * Revision 1.7  1994/12/23  09:18:33  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.6  1994/12/20  09:24:09  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.5  1994/11/22  01:54:37  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.4  1994/11/10  03:13:22  rcm
 * Fixed line numbers on AST nodes.
 *
 * Revision 1.3  1994/11/03  07:38:47  rcm
 * Added code to output C from the parse tree.
 *
 * Revision 1.2  1994/10/28  18:52:39  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Wed Apr 28 16:07:13 EDT 1993
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
#pragma ident "output.c,v 1.21 1995/05/11 18:54:22 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"


typedef enum {
  Left,
  Right
  } Context;

typedef enum {
  TopDecl,   /* toplevel decls: procs, global variables, typedefs, SUE defs */
  BlockDecl,      /* local decls at beginning of a block */
  SUFieldDecl,    /* structure/union field decls */
  EnumConstDecl,  /* enumerated constant decls */
  FormalDecl      /* formal args to a procedure */
  } DeclKind;

typedef struct {
  FILE *f;
  Coord curr;
  int block;
  int block_indents[MAX_NESTED_SCOPES];
} OutputContext;


PRIVATE void SetOutputCoord(OutputContext *out, Coord *pcoord);
PRIVATE void SetOutputCoordStmt(OutputContext *out, Coord *pcoord);
PRIVATE void ForceNewLine(OutputContext *out, Coord *pcoord);
PRIVATE inline void OutCh(OutputContext *out, int ch);
PRIVATE inline void OutS(OutputContext *out, const char *s);
PRIVATE inline void OutS_embedded_newlines(OutputContext *out, const char *s);
PRIVATE inline void OutOffset(OutputContext *out, int len);

PRIVATE void StartBlockIndent(OutputContext *out, List *block_items);
PRIVATE void EndBlockIndent(OutputContext *out);
PRIVATE inline int BlockIndent(OutputContext *out);


PRIVATE Bool IsSourceExpression(Node *node);
PRIVATE int Precedence(Node *node, Bool *left_assoc);


PRIVATE void OutputExpr(OutputContext *out, Node *node);
PRIVATE void OutputInnerExpr(OutputContext *out, Node *node, int enclosing_precedence, Context context);
PRIVATE void OutputPartialType(OutputContext *out, Context context, 
			       Node *node, TypeQual sc);
PRIVATE void OutputType(OutputContext *out, Node *node);
PRIVATE void OutputStatement(OutputContext *out, Node *node);
PRIVATE void OutputStatementList(OutputContext *out, List *lst);
PRIVATE void OutputAttribs(OutputContext *out, List *attribs);
PRIVATE void OutputDecl(OutputContext *out, DeclKind k, Node *node);
PRIVATE void OutputDeclList(OutputContext *out, DeclKind k, List *lst);
PRIVATE void OutputSUE(OutputContext *out, SUEtype *sue, Bool elaboratedp);
PRIVATE void OutputTextNode(OutputContext *out, Node *node);



GLOBAL void OutputProgram(FILE *outfile, List *program)
{
  OutputContext out;

  out.f = outfile;
  out.curr = UnknownCoord;
  out.block = 0;
  out.block_indents[0] = 0;

  OutputDeclList(&out, TopDecl, program);
  OutCh(&out, '\n');
}


/* If SetOutputCoord() needs to adjust the output line number, it can
   insert at most MAX_INSERTED_NEWLINES newline characters.  If more
   adjustment is needed, a #line directive is emitted instead.  This
   limits the number of #line directives needed.
*/   
#define MAX_INSERTED_NEWLINES      3


PRIVATE void SetOutputCoord(OutputContext *out, Coord *pcoord)
{
  if (IsUnknownCoord(*pcoord))
    return;  /* *pcoord == UnknownCoord, so ignore */
    
  /* First, set line */
  if (pcoord->file != out->curr.file) {
    if (out->curr.offset != 0)
      fputc('\n', out->f);
    if (!FormatReadably)
      fprintf(out->f, "#line %d \"%s\"\n", pcoord->line, 
	      FileNames[pcoord->file]);
    out->curr.file = pcoord->file;
    out->curr.line = pcoord->line;
    out->curr.offset = 0;
  }
  else if (pcoord->line == out->curr.line) 
    /* do nothing */
    ;
  else if (pcoord->line > out->curr.line && 
	   pcoord->line <= out->curr.line + MAX_INSERTED_NEWLINES) {
    for (; out->curr.line < pcoord->line; ++out->curr.line)
      fputc('\n', out->f);
    out->curr.offset = 0;
  }
  else {
    if (out->curr.offset != 0)
      fputc('\n', out->f);
    if (!FormatReadably)
      fprintf(out->f, "#line %d\n", pcoord->line);
    out->curr.line = pcoord->line;
    out->curr.offset = 0;
  }


  /* Now, set offset */
  for (; out->curr.offset < pcoord->offset; ++out->curr.offset)
    fputc(' ', out->f);
}


/* SetOutputCoordStmt is like SetOutputCoord, but handles
   UnknownCoord differently: if -N option was supplied to
   c2c, insert a line break and indent to current block indentation */
PRIVATE void SetOutputCoordStmt(OutputContext *out, Coord *pcoord)
{
  if (FormatReadably && IsUnknownCoord(*pcoord)) {
    Coord new = out->curr;
    ++new.line;  /* force line break */
    new.offset = BlockIndent(out);
    pcoord = &new;
  }
  
  SetOutputCoord(out, pcoord);
}


/* ForceNewLine ensures that only whitespace appears before
   current position on output line */
PRIVATE void ForceNewLine(OutputContext *out, Coord *pcoord)
{
  /* if current offset is > 0, need to start a new line */
  if (out->curr.offset > 0) {
    fputc('\n', out->f);
    out->curr.offset = 0;
    ++out->curr.line;
  }

  SetOutputCoord(out, pcoord);
}



PRIVATE inline void OutCh(OutputContext *out, int ch)
{
  fputc(ch, out->f);
  fflush(out->f);
  ++out->curr.offset;
}

PRIVATE inline void OutS(OutputContext *out, const char *s)
{
  fputs(s, out->f);
  out->curr.offset += strlen(s);
}

PRIVATE inline void OutS_embedded_newlines(OutputContext *out, const char *s)
{
  const char *p;

  fputs(s, out->f);

  /* scan through s, updating the line counter */
  for (; (p = strchr(s, '\n'))!=NULL; s = p+1) {
    ++out->curr.line;
    out->curr.offset = 0;
  }

  out->curr.offset += strlen(s);
}

PRIVATE inline void OutOffset(OutputContext *out, int len)
{
  out->curr.offset += len;
}


PRIVATE void StartBlockIndent(OutputContext *out, List *block_items)
{
  Node *item = NULL;

  while (block_items != NULL &&
	 ((item = FirstItem(block_items)) == NULL ||
	  IsUnknownCoord(item->coord)))
    block_items = Rest(block_items);

  ++out->block;
  out->block_indents[out->block] = 
    block_items == NULL
      ? out->block_indents[out->block-1] + 2
	: item->coord.offset;
}

PRIVATE void EndBlockIndent(OutputContext *out)
{
  assert(out->block > 0);
  --out->block;
}

PRIVATE inline int BlockIndent(OutputContext *out)
{
  return out->block_indents[out->block];
}



PRIVATE Bool IsSourceExpression(Node *node)
{
  while (node && node->typ == ImplicitCast)
    node = node->u.implicitcast.expr;

  return (node != NULL);
}

PRIVATE int Precedence(Node *node, Bool *left_assoc)
{
    switch (node->typ) {
      case Unary:
	return OpPrecedence(Unary, node->u.unary.op, left_assoc);
      case Binop:
	return OpPrecedence(Binop, node->u.binop.op, left_assoc);
      case Cast:
	*left_assoc = FALSE;
	return 14;
      case Comma:
	*left_assoc = TRUE;
	return 1;
      case Ternary:
	*left_assoc = FALSE;
	return 3;
      default:
	*left_assoc = TRUE;
	return 20;  /* highest precedence */
    }
    /* unreachable */
}

PRIVATE void OutputBinop(OutputContext *out, Node *node, int my_precedence)
{
  assert(node->typ == Binop);

#if 0
  /* force parenthesizing of subexpressions of certain ops -- this prevents 
     backend compiler (like gcc) from warning about common precedence 
     errors */
  switch (node->u.binop.op) {
  case OROR:
  case '|':
  case '^':
    my_precedence = 20;
    break;
  default:
    break;
  }
#endif

  OutputInnerExpr(out, node->u.binop.left, my_precedence, Left);
    
  SetOutputCoord(out, &node->coord);
  OutOffset(out, PrintOp(out->f, node->u.binop.op));
  
  OutputInnerExpr(out, node->u.binop.right, my_precedence, Right);
}

PRIVATE void OutputUnary(OutputContext *out, Node *node, int my_precedence)
{
  assert(node->typ == Unary);

  switch (node->u.unary.op) {
  case SIZEOF:
    SetOutputCoord(out, &node->coord);
    OutS(out, "sizeof(");
    if (IsType(node->u.unary.expr))
      OutputType(out, node->u.unary.expr);
    else OutputExpr(out, node->u.unary.expr);
    OutCh(out, ')');
    break;

  case PREDEC:
  case PREINC:
    SetOutputCoord(out, &node->coord);
    OutOffset(out, PrintOp(out->f, node->u.unary.op));
    OutputInnerExpr(out, node->u.unary.expr, my_precedence, Right);
    break;

  case POSTDEC:
  case POSTINC:
    OutputInnerExpr(out, node->u.unary.expr, my_precedence, Left);
    SetOutputCoord(out, &node->coord);
    OutOffset(out, PrintOp(out->f, node->u.unary.op));
    break;

  default:
    SetOutputCoord(out, &node->coord);
    OutOffset(out, PrintOp(out->f, node->u.unary.op));
    OutputInnerExpr(out, node->u.unary.expr, my_precedence, Right);
    break;
  }
}


PRIVATE void OutputCommaList(OutputContext *out, List *list)
{
    ListMarker marker; Node *expr;
    
    if (list == NULL)
      return;

    IterateList(&marker, list);
    if (!NextOnList(&marker, (GenericREF) &expr))
      return;

    OutputExpr(out, expr);
    while (NextOnList(&marker, (GenericREF) &expr)) {
        OutCh(out, ',');
	OutputExpr(out, expr);
    }
}


PRIVATE void OutputDimensions(OutputContext *out, List *dim)
{
    ListMarker marker; Node *expr;

    IterateList(&marker, dim);
    while (NextOnList(&marker, (GenericREF) &expr)) {
	OutCh(out, '[');
	OutputExpr(out, expr);
	OutCh(out, ']');
    }
}


PRIVATE void OutputArray(OutputContext *out, Node *node, int my_precedence)
{
    OutputInnerExpr(out, node->u.array.name, my_precedence, Left);
    SetOutputCoord(out, &node->coord);
    OutputDimensions(out, node->u.array.dims);
}


PRIVATE void OutputCall(OutputContext *out, Node *node, int my_precedence)
{
    OutputInnerExpr(out, node->u.call.name, my_precedence, Left);
    SetOutputCoord(out, &node->coord);
    OutCh(out, '(');
    OutputCommaList(out, node->u.call.args);
    OutCh(out, ')');
}

PRIVATE void OutputInnerExpr(OutputContext *out, Node *node, 
		     int enclosing_precedence, Context context)
{
  int my_precedence;
  Bool left_assoc;
  Bool parenthesize;
    
  if (node == NULL) return;

  my_precedence = Precedence(node, &left_assoc);

  /* determine whether node needs enclosing parentheses */
  if (node->parenthesized)
    parenthesize = TRUE;  /* always parenthesize if source did */
  else if (my_precedence < enclosing_precedence)
    parenthesize = TRUE;
  else if (my_precedence > enclosing_precedence)
    parenthesize = FALSE;
  else  /* my_precedence == enclosing_precedence */
    if ((left_assoc && context == Right) || (!left_assoc && context == Left))
      parenthesize = TRUE;
    else
      parenthesize = FALSE;

  if (parenthesize)
    OutCh(out, '(');

  switch (node->typ) {
  case Block:
    SetOutputCoord(out, &node->coord);
    OutCh(out, '(');
    OutputStatement(out, node);
    OutCh(out, ')');
    break;
  case ImplicitCast:
    /* ignore implicitcasts inserted for typechecking */
    OutputInnerExpr(out, node->u.implicitcast.expr, enclosing_precedence, context);
    break;
  case Id:
    SetOutputCoord(out, &node->coord);
    OutS(out, node->u.id.text);
    break;
  case Const:
    SetOutputCoord(out, &node->coord);
    if (node->u.Const.text)
      OutS(out, node->u.Const.text);
    else
      OutOffset(out, PrintConstant(out->f, node, FALSE));
    break;
  case Binop:
    OutputBinop(out, node, my_precedence);
    break;
  case Unary:
    OutputUnary(out, node, my_precedence);
    break;
  case Ternary:
    OutputInnerExpr(out, node->u.ternary.cond, my_precedence, Left);
    SetOutputCoord(out, &node->coord);
    OutCh(out, '?');
    OutputInnerExpr(out, node->u.ternary.true, my_precedence, Right);
    SetOutputCoord(out, &node->u.ternary.colon_coord);
    OutCh(out, ':');
    OutputInnerExpr(out, node->u.ternary.false, my_precedence, Right);
    break;
  case Cast:
    SetOutputCoord(out, &node->coord);
    OutCh(out, '(');
    OutputType(out, node->u.cast.type);
    OutCh(out, ')');
    OutputInnerExpr(out, node->u.cast.expr, my_precedence, Right);
    break;
  case Comma:
    SetOutputCoord(out, &node->coord);
    OutputCommaList(out, node->u.comma.exprs);
    break;
  case Array:
    OutputArray(out, node, my_precedence);
    break;
  case Call:
    OutputCall(out, node, my_precedence);
    break;
  case Initializer:
    SetOutputCoordStmt(out, &node->coord);
    OutCh(out, '{');
    StartBlockIndent(out, node->u.initializer.exprs);
    OutputCommaList(out, node->u.initializer.exprs);
    EndBlockIndent(out);
    SetOutputCoordStmt(out, &UnknownCoord);
    OutCh(out, '}');
    break;
  default:
    fprintf(stderr, "Internal error: unexpected node");
    PrintNode(stderr, node, 2);
    UNREACHABLE;
  }
  
  if (parenthesize)
    OutCh(out, ')');
}

PRIVATE void OutputExpr(OutputContext *out, Node *node)
{
  OutputInnerExpr(out, node, 0, Left);
}


/*
 * OutputPartialType() should be called twice: first with context==Left
 * to output type components appearing before the declared identifier,
 * then with context==Right to output type components appearing after.
 * sc is the storage class, which is emitted before all components in
 * the Left context.
 */
PRIVATE void OutputPartialType(OutputContext *out, Context context, Node *node, 
		       TypeQual sc)
{
  if (node == NULL) return;

  switch (node->typ) {
  /* 
   *  base types: primitive, typedef, SUE 
   */
  case Prim:
    if (context == Left) {
      SetOutputCoord(out, &node->coord);
      OutOffset(out, PrintTQ(out->f, sc));
      OutOffset(out, PrintPrimType(out->f, node));
    }
    /* no action in Right context */
    break;

  case Tdef:
    if (context == Left) {
      SetOutputCoord(out, &node->coord);
      OutOffset(out, PrintTQ(out->f, sc));
      OutOffset(out, PrintTQ(out->f, node->u.tdef.tq));
      OutS(out, node->u.tdef.name);
    }
    /* no action in Right context */
    break;

  case Sdcl:
  case Udcl:
  case Edcl:
    if (context == Left) {
      SetOutputCoord(out, &node->coord);
      OutOffset(out, PrintTQ(out->f, sc));
      OutOffset(out, PrintTQ(out->f, node->u.sdcl.tq & ~T_SUE_ELABORATED));
      OutputSUE(out, node->u.sdcl.type, SUE_ELABORATED(node->u.sdcl.tq));
    }
    /* no action in Right context */
    break;


  /* 
   *  type operators: pointer, array, function.
   */
#define IS_ARRAY_OR_FUNC(n)  (n->typ == Adcl || n->typ == Fdcl)

  case Ptr:
    if (context == Left) {
      OutputPartialType(out, context, node->u.ptr.type, sc);

      if (IS_ARRAY_OR_FUNC(node->u.ptr.type))
	OutCh(out, '(');

      SetOutputCoord(out, &node->coord);
      OutCh(out, '*');
      OutOffset(out, PrintTQ(out->f, node->u.ptr.tq));
    }
    else {
      if (IS_ARRAY_OR_FUNC(node->u.ptr.type))
	OutCh(out, ')');
      OutputPartialType(out, context, node->u.ptr.type, sc);
    }
    break;

  case Adcl:
    if (context == Left)
      OutputPartialType(out, context, node->u.adcl.type, sc);
    else {
      SetOutputCoord(out, &node->coord);
      OutCh(out, '[');
      if (IsSourceExpression(node->u.adcl.dim))
	OutputExpr(out, node->u.adcl.dim);
      OutCh(out, ']');

      OutputPartialType(out, context, node->u.adcl.type, sc);
    }
    break;

  case Fdcl:
    if (context == Left) {
      OutOffset(out, PrintTQ(out->f, node->u.fdcl.tq));
      OutputPartialType(out, context, node->u.fdcl.returns, sc);
    }
    else {
      SetOutputCoord(out, &node->coord);
      OutCh(out, '(');
      OutputDeclList(out, FormalDecl, node->u.fdcl.args);
      OutCh(out, ')');

      OutputPartialType(out, context, node->u.fdcl.returns, sc);
    }
    break;

  default:
    fprintf(stderr, "Internal error: unexpected node");
    PrintNode(stderr, node, 2);
    UNREACHABLE;
  }
}


PRIVATE void OutputSUE(OutputContext *out, SUEtype *sue, Bool elaboratedp)
{
  
  assert(sue != NULL);

  switch (sue->typ) {
  case Sdcl:
    OutS(out, "struct");
    break;
   case Udcl:
    OutS(out, "union");
    break;
  case Edcl:
    OutS(out, "enum");
    break;
  default:
    UNREACHABLE;
  }

  OutCh(out, ' ');
  if (sue->name) {
    OutS(out, sue->name);
    OutCh(out, ' ');
  }

  if (elaboratedp) {
    SetOutputCoordStmt(out, &sue->coord);
    OutCh(out, '{');
    StartBlockIndent(out, sue->fields);
    OutputDeclList(out,
		   (sue->typ == Edcl) ? EnumConstDecl : SUFieldDecl,
		   sue->fields);
    EndBlockIndent(out);
    SetOutputCoordStmt(out, &sue->right_coord);
    OutCh(out, '}');
  }
}

PRIVATE void OutputType(OutputContext *out, Node *node)
{
  OutputPartialType(out, Left, node, EMPTY_TQ);
  OutputPartialType(out, Right, node, EMPTY_TQ);
}


PRIVATE void OutputTextNode(OutputContext *out, Node *node)
{
  assert(node->typ == Text);

  if (node->u.text.start_new_line)
    ForceNewLine(out, &node->coord);
  else SetOutputCoord(out, &node->coord);

  if (node->u.text.text)
    OutS_embedded_newlines(out, node->u.text.text);
}



PRIVATE void OutputDecl(OutputContext *out, DeclKind k, Node *node)
{
  assert(node != NULL);
  assert(node->typ == Decl);

  if (k != EnumConstDecl) {
    int sc = NodeStorageClass(node);
    OutputPartialType(out, Left, node->u.decl.type, sc);

    /* Separate type and identifier (unless type is a pointer, which
       delimits the identifier with "*".) */
    if (node->u.decl.type->typ != Ptr)
      OutCh(out, ' ');

    if (node->u.decl.name) {
      SetOutputCoord(out, &node->coord);
      OutS(out, node->u.decl.name);
    }

    OutputPartialType(out, Right, node->u.decl.type, sc);
  }
  else {
    SetOutputCoord(out, &node->coord);
    OutS(out, node->u.decl.name);
  }

  switch (k) {
  case SUFieldDecl:
    if (node->u.decl.bitsize != NULL) {
      OutCh(out, ':');
      OutputExpr(out, node->u.decl.bitsize);
    }
    break;

  case TopDecl:
  case BlockDecl:
  case EnumConstDecl:
    if (IsSourceExpression(node->u.decl.init)) {
      OutCh(out, '=');
      OutputExpr(out, node->u.decl.init);
    }
    break;

  case FormalDecl:
    break;
  }

  if (node->u.decl.attribs)
    OutputAttribs(out, node->u.decl.attribs);
}


PRIVATE void OutputAttribs(OutputContext *out, List *attribs)
{
  OutS(out, " __attribute__((");
  while (attribs != NULL) {
    Node *attrib = FirstItem(attribs);
    
    OutS(out, attrib->u.attrib.name);
    if (attrib->u.attrib.arg) {
      OutCh(out, '(');
      OutputExpr(out, attrib->u.attrib.arg);
      OutCh(out, ')');
    }

    attribs = Rest(attribs);
    if (attribs)
      OutCh(out, ',');
  }
  OutS(out, "))");
}


PRIVATE void OutputStatement(OutputContext *out, Node *node)
{
  if (node == NULL) {
    /* empty statement */
    OutCh(out, ';');
    return;
  }


  switch (node->typ) {
  case Id:
  case Const:
  case Binop:
  case Unary:
  case Cast:
  case Ternary:
  case Comma:
  case Call:
  case Array:
  case ImplicitCast:
    if (FormatReadably && IsUnknownCoord(node->coord))
      SetOutputCoordStmt(out, &UnknownCoord);
	
    OutputExpr(out, node);
    OutCh(out, ';');
    break;
  case Label:
    SetOutputCoordStmt(out, &node->coord);
    OutS(out, node->u.label.name);
    OutCh(out, ':');
    OutputStatement(out, node->u.label.stmt);
    break;
  case Switch:
    SetOutputCoordStmt(out, &node->coord);
    OutS(out, "switch (");
    OutputExpr(out, node->u.Switch.expr);
    OutS(out, ") ");
    OutputStatement(out, node->u.Switch.stmt);
    break;
  case Case:
    SetOutputCoordStmt(out, &node->coord);
    OutS(out, "case ");
    OutputExpr(out, node->u.Case.expr);
    OutS(out, ": ");
    OutputStatement(out, node->u.Case.stmt);
    break;
  case Default:
    SetOutputCoordStmt(out, &node->coord);
    OutS(out, "default: ");
    OutputStatement(out, node->u.Default.stmt);
    break;
  case If:
    SetOutputCoordStmt(out, &node->coord);
    OutS(out, "if (");
    OutputExpr(out, node->u.If.expr);
    OutS(out, ") ");
    OutputStatement(out, node->u.If.stmt);
    break;
  case IfElse:
    SetOutputCoordStmt(out, &node->coord);
    OutS(out, "if (");
    OutputExpr(out, node->u.IfElse.expr);
    OutS(out, ") ");
    OutputStatement(out, node->u.IfElse.true);
    SetOutputCoordStmt(out, &node->u.IfElse.else_coord);
    OutS(out, "else ");
    OutputStatement(out, node->u.IfElse.false);
    break;
  case While:
    SetOutputCoordStmt(out, &node->coord);
    OutS(out, "while (");
    OutputExpr(out, node->u.While.expr);
    OutS(out, ") ");
    OutputStatement(out, node->u.While.stmt);
    break;
  case Do:
    SetOutputCoordStmt(out, &node->coord);
    OutS(out, "do");
    OutputStatement(out, node->u.Do.stmt);
    SetOutputCoordStmt(out, &node->u.Do.while_coord);
    OutS(out, "while (");
    OutputExpr(out, node->u.Do.expr);
    OutS(out, ");");
    break;
  case For:
    SetOutputCoordStmt(out, &node->coord);
    OutS(out, "for (");
    OutputExpr(out, node->u.For.init);
    OutS(out, "; ");
    OutputExpr(out, node->u.For.cond);
    OutS(out, "; ");
    OutputExpr(out, node->u.For.next);
    OutS(out, ") ");
    OutputStatement(out, node->u.For.stmt);
    break;	
  case Goto:
    assert(node->u.Goto.label->typ == Label);
    SetOutputCoordStmt(out, &node->coord);
    OutS(out, "goto ");
    OutS(out, node->u.Goto.label->u.label.name);
    OutCh(out, ';');
    break;
  case Continue:
    SetOutputCoordStmt(out, &node->coord);
    OutS(out, "continue;");
    break;
  case Break:
    SetOutputCoordStmt(out, &node->coord);
    OutS(out, "break;");
    break;
  case Return:
    SetOutputCoordStmt(out, &node->coord);
    OutS(out, "return");
    if (node->u.Return.expr) {
      OutCh(out, ' ');
      OutputExpr(out, node->u.Return.expr);
    }
    OutCh(out, ';');
    break;
  case Block:
    SetOutputCoordStmt(out, &node->coord);
    OutCh(out, '{');
    
    StartBlockIndent(out, node->u.Block.stmts);
    OutputDeclList(out, BlockDecl, node->u.Block.decl);
    OutputStatementList(out, node->u.Block.stmts);
    EndBlockIndent(out);
    
    SetOutputCoordStmt(out, &node->u.Block.right_coord);
    OutCh(out, '}');
    break;
  case Text:
    OutputTextNode(out, node);
    break;
  default:
    fprintf(stderr, "Internal error: unexpected node");
    PrintNode(stderr, node, 2);
    UNREACHABLE;
  }
 
  if (PrintLiveVars && node->analysis.livevars) {
    OutS(out, " /* ");
    OutOffset(out, PrintAnalysis(out->f, node));
    OutS(out, " */");
  }
}



PRIVATE void OutputDeclList(OutputContext *out, DeclKind k, List *lst)
{
  ListMarker marker;
  Node *node;
  Bool firstp = TRUE;
  Bool commalistp;

  if (lst == NULL) return;

  commalistp = (k == FormalDecl || k == EnumConstDecl);
    
  IterateList(&marker, lst);
  while (NextOnList(&marker, (GenericREF) &node)) {
    /* ignore decls deleted by transformation */
    if (node == NULL)
      continue;

    /* if this declaration is from an included file, don't output it. */
    if (k == TopDecl && node->coord.includedp)
      continue;

    if (k != FormalDecl)
      SetOutputCoordStmt(out, &UnknownCoord);
	
    /* output Text nodes without inserting delimiters (like ",") */
    if (node->typ == Text) {
      
      /* if text node is an #include, it must be at the top level
	 for us to output it. */
      if (!strncmp(node->u.text.text, "#include", 8) && k != TopDecl)
	continue;
      
      OutputTextNode(out, node);
      continue;
    }

    if (firstp)
      firstp = FALSE;
    else if (commalistp)
      OutCh(out, ',');


    switch (node->typ) {
    case Proc:
      assert(k == TopDecl);
      OutputDecl(out, k, node->u.proc.decl);
      if (node->u.proc.body)
	OutputStatement(out, node->u.proc.body);
      else {
	/* must output an empty pair of braces to distinguish this
	   function definition (with an empty body) from a
	   function prototype */
	OutS(out, "{}");
      }
      break;

    case Decl:
      OutputDecl(out, k, node);
      if (!commalistp)
	OutCh(out, ';');
      break;

    case Prim:
    case Tdef:
    case Adcl:
    case Fdcl:
    case Ptr:
    case Sdcl:
    case Udcl:
    case Edcl:
      OutputType(out, node);
      if (k != FormalDecl)
	OutCh(out, ';');
      break;

    default:
      fprintf(stderr, "Internal error: unexpected node");
      PrintNode(stderr, node, 2);
      UNREACHABLE;
    }
  }
}

PRIVATE void OutputStatementList(OutputContext *out, List *lst)
{
  ListMarker marker;
  Node *node;
 
  if (lst == NULL) return;

  IterateList(&marker, lst);
  while (NextOnList(&marker, (GenericREF)&node))
    OutputStatement(out, node);
}

