/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  sem-check.c,v
 * Revision 1.20  1995/05/11  18:54:31  rcm
 * Added gcc extension __attribute__.
 *
 * Revision 1.19  1995/04/21  05:44:43  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.18  1995/04/09  21:30:56  rcm
 * Added Analysis phase to perform all analysis at one place in pipeline.
 * Also added checking for functions without return values and unreachable
 * code.  Added tests of live-variable analysis.
 *
 * Revision 1.17  1995/03/23  15:31:29  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.16  1995/03/01  16:23:21  rcm
 * Various type-checking bug fixes; added T_REDUNDANT_EXTERNAL_DECL.
 *
 * Revision 1.15  1995/02/13  02:00:25  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.14  1995/02/01  23:02:01  rcm
 * Added Text node and #pragma collection
 *
 * Revision 1.13  1995/02/01  21:07:31  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.12  1995/02/01  07:38:18  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.11  1995/01/27  01:39:11  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.10  1995/01/25  21:38:23  rcm
 * Added TypeModifiers to make type modifiers extensible
 *
 * Revision 1.9  1995/01/20  03:38:16  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.8  1995/01/06  16:49:04  rcm
 * added copyright message
 *
 * Revision 1.7  1994/12/23  09:18:42  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.6  1994/12/20  09:24:15  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.5  1994/11/22  01:54:46  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.4  1994/11/10  03:13:34  rcm
 * Fixed line numbers on AST nodes.
 *
 * Revision 1.3  1994/11/03  07:38:57  rcm
 * Added code to output C from the parse tree.
 *
 * Revision 1.2  1994/10/28  18:52:57  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Sun May 30 14:00:45 EDT 1993
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
#pragma ident "sem-check.c,v 1.20 1995/05/11 18:54:31 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"
#include "conversions.h"
#include "initializer.h"

PRIVATE void  SemCheckIsArithmeticType(Node *type, Node *op);
PRIVATE void  SemCheckIsScalarType(Node *type, Node *op);
PRIVATE void  SemCheckIsIntegralType(Node *type, Node *op);
/*PRIVATE Node *EnsureComparison(Node *node);*/
PRIVATE void AssignEnumValues(SUEtype *enm);
GLOBAL void StructCheckFields(SUEtype *sue);
GLOBAL void UnionCheckFields(SUEtype *sue);

PRIVATE Node *SemCheckAssignment(Node *node, binopNode *u);
PRIVATE Node *SemCheckDot(Node *node, binopNode *u);
PRIVATE Node *SemCheckArrow(Node *node, binopNode *u);
PRIVATE Node *SemCheckArithmetic(Node *node, binopNode *u);
PRIVATE Node *SemCheckComparison(Node *node, binopNode *u);

PRIVATE void SemCheckCallArgs(Node *node, List *formals, List *actuals);

PRIVATE struct SwitchCheck *NewSwitchCheck(List *cases);
PRIVATE void FreeSwitchCheck(struct SwitchCheck *check);
PRIVATE void SwitchCheckAddCase(struct SwitchCheck *check, Node *expr);
PRIVATE void SwitchCheckAddDefault(struct SwitchCheck *check, Node *node);



GLOBAL List *SemanticCheckProgram(List *program)
{ ListMarker marker;
  Node *item;
  
  IterateList(&marker, program);
  while (NextOnList(&marker, (GenericREF) &item)) 
    {
      assert(item);
      SemCheckNode(item);
      
      if (item->typ == Decl && item->u.decl.init == NULL) 
	{ Node *type;
	  
	  assert(item->u.decl.type);
	  type = NodeDataType(item->u.decl.type);
	  
	  if (NodeIsConstQual(type) && !DeclIsExtern(item) && !DeclIsTypedef(item))
	    WarningCoord(1, item->coord,
			 "const object should have initializer: \"%s\"",
			 item->u.decl.name);
	}
    }
  
  return program;
}




/*************************************************************************/
/*                                                                       */
/*                          Expression nodes                             */
/*                                                                       */
/*************************************************************************/

PRIVATE inline Node *SemCheckConst(Node *node, ConstNode *u)
{
  u->type = SemCheckNode(u->type);
  return node;
}

PRIVATE inline Node *SemCheckId(Node *node, idNode *u)
{  
#if 0
  /* This logic was not ANSI standard.  If x is declared "const int x = 0", 
     that does not mean x can be replaced by 0 statically anywhere it appears.
     In particular, "int foo[x]" would not be valid. -- rcm */
  if (u->decl)
    { Node *decl = u->decl;
      
      assert(decl);
      assert(decl->typ == Decl);
      
      if (NodeIsConstQual(decl->u.decl.type) && 
	  decl->u.decl.init                  &&
	  IsArithmeticType(decl->u.decl.init))
	return ConstantCopyWithCoord(decl->u.decl.init, node->coord);
    }
#endif
  
  if (u->decl) {
    Node *decl = u->decl;
    
    /* if id is an enum constant, get its value */
    if (DeclIsEnumConst(decl)) {
      assert(decl->u.decl.init);
      NodeSetConstantValue(node, NodeGetConstantValue(decl->u.decl.init));
    }
  }
  return node;
}

PRIVATE inline Node *SemCheckBinop(Node *node, binopNode *u)
{
  OpType operator = u->op;

  u->left = SemCheckNode(u->left);
  u->right = SemCheckNode(u->right);
  
  if (IsAssignmentOp(operator))
    return SemCheckAssignment(node, u);
  else if (operator == '.')
    return SemCheckDot(node, u);
  else if (operator == ARROW)
    return SemCheckArrow(node, u);
  else if (IsArithmeticOp(operator))
    return SemCheckArithmetic(node, u);
  else if (IsComparisonOp(operator))
    return SemCheckComparison(node, u);
  else {
    fprintf(stderr, "Internal Error: Unrecognized Binop\n");
    assert(FALSE);
  }  
  UNREACHABLE;
  return NULL; /* eliminates warning */
}

PRIVATE inline Node *SemCheckUnary(Node *node, unaryNode *u)
{
  u->expr = SemCheckNode(u->expr);
  u->type = NodeDataType(u->expr);
  
  switch (u->op) {
    /* Must be arithmetic.  Apply usual conversions */
  case UMINUS:
    SemCheckIsArithmeticType(u->type, node);
    
    if (NodeIsConstant(u->expr))
      {
	if (NodeTypeIsSint(u->expr))
	  { int eval = NodeConstantSintValue(u->expr);
	    
	    NodeSetSintValue(node, 0 - eval);
	  }
	else if (NodeTypeIsUint(u->expr))
	  { unsigned int eval = NodeConstantUintValue(u->expr);
	    
	    NodeSetUintValue(node, 0 - eval);
	  }
	else if (NodeTypeIsSlong(u->expr))
	  { long eval = NodeConstantSlongValue(u->expr);
	    
	    NodeSetSlongValue(node, 0 - eval);
	  }
	else if (NodeTypeIsUlong(u->expr))
	  { unsigned long eval = NodeConstantUlongValue(u->expr);
	    
	    NodeSetUlongValue(node, 0 - eval);
	  }
	else if (NodeTypeIsFloat(u->expr))
	  { float eval = NodeConstantFloatValue(u->expr);
	    
	    NodeSetFloatValue(node, 0 - eval);
	  }
	else if (NodeTypeIsDouble(u->expr))
	  { double eval = NodeConstantDoubleValue(u->expr);
	    
	    NodeSetDoubleValue(node, 0 - eval);
	  }
      }
    break;
  case UPLUS:
    SemCheckIsArithmeticType(u->type, node);
    return u->expr;
    
  case '!':
    u->expr = UsualUnaryConversions(u->expr, FALSE);
    u->type = NodeDataType(u->expr);
#if 0	
    /* Desugar <x> into !(<x> == 0) */
    if (!IsLogicalOrRelationalExpression(u->expr)) {
      SemCheckIsScalarType(u->type, node);
      u->expr = MakeNotZerop(u->expr, u->type);
    }
#endif
    u->type = PrimSint;
    
    if (NodeIsConstant(u->expr))
      {
	if (NodeTypeIsSint(u->expr))
	  { int eval = NodeConstantSintValue(u->expr);
	    
	    NodeSetSintValue(node, eval == 0);
	  }
	else if (NodeTypeIsUint(u->expr))
	  { unsigned int eval = NodeConstantUintValue(u->expr);
	    
	    NodeSetSintValue(node, eval == 0);
	  }
	else if (NodeTypeIsSlong(u->expr))
	  { long eval = NodeConstantSlongValue(u->expr);
	    
	    NodeSetSintValue(node, eval == 0);
	  }
	else if (NodeTypeIsUlong(u->expr))
	  { unsigned long eval = NodeConstantUlongValue(u->expr);
	    
	    NodeSetSintValue(node, eval == 0);
	  }
	else if (NodeTypeIsFloat(u->expr))
	  { float eval = NodeConstantFloatValue(u->expr);
	    
	    NodeSetSintValue(node, eval == 0);
	  }
	else if (NodeTypeIsDouble(u->expr))
	  { double eval = NodeConstantDoubleValue(u->expr);
	    
	    NodeSetSintValue(node, eval == 0);
	  }
      }
    break;
    
    /* Must be integral.  Apply usual conversions. */
  case '~':
    u->expr = UsualUnaryConversions(u->expr, FALSE);
    u->type = NodeDataType(u->expr);
    SemCheckIsIntegralType(u->type, node);
    if (NodeIsConstant(u->expr))
      {
	if (NodeTypeIsSint(u->expr))
	  { int eval = NodeConstantSintValue(u->expr);
	    
	    NodeSetSintValue(node, ~eval);
	  }
	else if (NodeTypeIsUint(u->expr))
	  { unsigned int eval = NodeConstantUintValue(u->expr);
	    
	    NodeSetUintValue(node, ~eval);
	  }
	else if (NodeTypeIsSlong(u->expr))
	  { long eval = NodeConstantSlongValue(u->expr);
	    
	    NodeSetSlongValue(node, ~eval);
	  }
	else if (NodeTypeIsUlong(u->expr))
	  { unsigned long eval = NodeConstantUlongValue(u->expr);
	    
	    NodeSetUlongValue(node, ~eval);
	  }
      }
    break;
    
    /* Must be scalar modifiable lval.  Apply usual conversions */
  case PREINC:
  case PREDEC:
  case POSTINC:
  case POSTDEC:
    if (!IsModifiableLvalue(u->expr))
      SyntaxErrorCoord(node->coord, 
		       "operand must be modifiable lvalue: op %s",
		       Operator[u->op].text);
    
    u->type = NodeDataType(u->expr);
    SemCheckIsScalarType(u->type, node);

    if (IsPointerType(u->type)) {
      /* try to get size of base type, to ensure that it is defined 
	 (and not void or an incomplete struct/union type) */
      (void)NodeSizeof(node, GetShallowBaseType(u->type));
    }
    break;
    
    /* Memory leak */
  case SIZEOF:
    NodeSetUintValue(node, NodeSizeof(u->expr, u->type));
    u->type = PrimUint;  /* fix: should really be size_t */
    break;
    
    /* Function or object lvalue.  Returns PTR to T */
  case ADDRESS:
    if (IsLvalue(u->expr) || IsFunctionType(u->type) || IsArrayType(u->type))
      u->type = MakePtr(EMPTY_TQ, u->type);
    else
      SyntaxErrorCoord(node->coord, 
		       "cannot take the address of a non-lvalue");
    
    break;
    
    /* Must be a pointer or Adcl.  Result type is referenced object */
  case INDIR:
    if (u->type->typ == Ptr)
      u->type = u->type->u.ptr.type;
    else if (u->type->typ == Adcl)
      u->type = u->type->u.adcl.type;
    else if (u->type->typ == Fdcl)
      ; /* Fdcl automatically becomes Ptr(Fdcl), then INDIR
	   eliminates the Ptr */
    else
      SyntaxErrorCoord(node->coord, "2 cannot dereference non-pointer type");
    break;
    
  default:
    fprintf(stdout, 
	    "Unsupported unary operator \"%s\"\n", 
	    Operator[u->op].text);
    assert(FALSE);
  }
  
  return node;
}

PRIVATE inline Node *SemCheckCast(Node *node, castNode *u)
{
  u->type = SemCheckNode(u->type);
  u->expr = SemCheckNode(u->expr);
  
  u->expr = CastConversions(u->expr, u->type);
  ConstFoldCast(node);
  return node;
}

PRIVATE inline Node *SemCheckComma(Node *node, commaNode *u)
{
  u->exprs = SemCheckList(u->exprs);
  return node;
}

PRIVATE inline Node *SemCheckTernary(Node *node, ternaryNode *u)
{ Node *cond  = u->cond,
    *true  = u->true,
    *false = u->false,
    *ctype,
    *ttype,
    *ftype;
  
  cond  = SemCheckNode(cond);
  true  = SemCheckNode(true);
  false = SemCheckNode(false);
  
  cond = UsualUnaryConversions(cond, FALSE);
  
  assert(cond);
  assert(true);
  assert(false);
  
  ctype = NodeDataType(cond);
  ttype = NodeDataType(true);
  ftype = NodeDataType(false);
#if 0
  /* Make sure the predicate is a logical expression */
  if (!IsLogicalOrRelationalExpression(cond)) {
    SemCheckIsScalarType(ctype, cond);
    
    cond = MakeNotZerop(cond, ctype);
    ctype = PrimSint;
    u->cond = cond;
  }
#endif
  /* Apply the standard unary conversions */
  true  = UsualUnaryConversions(true,  FALSE);
  false = UsualUnaryConversions(false, FALSE);
  
  /* Unify the true/false branches */
  u->type  = ConditionalConversions(&true, &false);
  u->true  = true;
  u->false = false;
  
  ConstFoldTernary(node);
  
  return node;
}

PRIVATE inline Node *SemCheckArray(Node *node, arrayNode *u)
{ Node *type;
  
  assert(u->name);
  assert(u->dims);
  
  u->name = SemCheckNode(u->name);
  SemCheckList(u->dims);
  
  assert(u->name);
  type = NodeDataType(u->name);
  
  /* if array.name is not an Adcl or a Ptr then check first dimension */
  if (type->typ != Adcl && type->typ != Ptr) 
    { Node *first = FirstItem(u->dims),
	*ftype;
      
      /* Canonicalize A[i] and i[A] */
      assert(first);
      ftype = NodeDataType(first);
      
      if (ftype->typ == Adcl || ftype->typ == Ptr) 
	{
	  SetItem(u->dims, u->name);
	  u->name = first;
	  type = ftype;
	}
      else {
	SyntaxErrorCoord(node->coord,
			 "1 cannot dereference non-pointer type");
	u->type = PrimVoid;
	return node;
      }
    }

  /* try to get size of base type, to ensure that it is defined 
   (and not void or an incomplete struct/union type) */
  (void)NodeSizeof(u->name, GetShallowBaseType(type));
  
  u->type = ArrayType(node);

  return node;
}

PRIVATE inline Node *SemCheckCall(Node *node, callNode *u)
{ Node *call_type;
  
  u->name = SemCheckNode(u->name);
  u->args = SemCheckList(u->args);
  
  call_type = NodeDataType(u->name);
  
  if (call_type->typ == Fdcl)
    SemCheckCallArgs(node, call_type->u.fdcl.args, u->args);
  else if (call_type->typ == Ptr && call_type->u.ptr.type->typ == Fdcl)
    SemCheckCallArgs(node, call_type->u.ptr.type->u.fdcl.args, u->args);
  else 
    SyntaxErrorCoord(node->coord, "called object is not a function");

  return node;
}

PRIVATE inline Node *SemCheckInitializer(Node *node, initializerNode *u)
{
  u->exprs = SemCheckList(u->exprs);
  return node;
}

PRIVATE inline Node *SemCheckImplicitCast(Node *node, implicitcastNode *u)
{
  u->expr = SemCheckNode(u->expr);
  return node;
}

/*************************************************************************/
/*                                                                       */
/*                          Statement nodes                              */
/*                                                                       */
/*************************************************************************/

PRIVATE inline Node *SemCheckLabel(Node *node, labelNode *u)
{
  u->stmt = SemCheckNode(u->stmt);
  return node;
}



PRIVATE inline Node *SemCheckSwitch(Node *node, SwitchNode *u)
{
  u->expr = SemCheckNode(u->expr);
  if (!NodeTypeIsIntegral(u->expr))
    SyntaxErrorCoord(u->expr->coord,
		     "controlling expression must have integral type");
  
  u->check = NewSwitchCheck(u->cases);
  u->stmt = SemCheckNode(u->stmt);

  /* fix: if u->expr is enumerated type, look at u->check and issue 
     warning if not all cases covered */ 
  FreeSwitchCheck(u->check);
  u->check = NULL;

  return node;
}

PRIVATE inline Node *SemCheckCase(Node *node, CaseNode *u)
{
  u->expr = SemCheckNode(u->expr);
  if (!IsIntegralConstant(u->expr))
    SyntaxErrorCoord(u->expr->coord,
		     "case expression must be integer constant");
  else {
    assert(u->container->typ == Switch);
    SwitchCheckAddCase(u->container->u.Switch.check, u->expr);
  }

  u->stmt = SemCheckNode(u->stmt);

  return node;
}

PRIVATE inline Node *SemCheckDefault(Node *node, DefaultNode *u)
{
  assert(u->container->typ == Switch);
  SwitchCheckAddDefault(u->container->u.Switch.check, node);

  u->stmt = SemCheckNode(u->stmt);
  return node;
}

PRIVATE inline Node *SemCheckIf(Node *node, IfNode *u)
{ Node *type;
  
  u->expr = SemCheckNode(u->expr);
  assert(u->expr);
  type = NodeDataType(u->expr);
  
  if (!(IsScalarType(type)))
    SyntaxErrorCoord(u->expr->coord,
		     "controlling expressions must have scalar type");
  
  /*      u->expr = EnsureComparison(u->expr); */
  
  if (u->stmt) u->stmt  = SemCheckNode(u->stmt);
  return node;
}

PRIVATE inline Node *SemCheckIfElse(Node *node, IfElseNode *u)
{ Node *type;
  
  u->expr = SemCheckNode(u->expr);
  assert(u->expr);
  type = NodeDataType(u->expr);
  
  if (!(IsScalarType(type)))
    SyntaxErrorCoord(u->expr->coord,
		     "controlling expressions must have scalar type");
  
  /*      u->expr = EnsureComparison(u->expr); */
  
  if (u->true)  u->true  = SemCheckNode(u->true);
  if (u->false) u->false = SemCheckNode(u->false);
  return node;
}

PRIVATE inline Node *SemCheckWhile(Node *node, WhileNode *u)
{
  u->expr = SemCheckNode(u->expr);
  u->stmt = SemCheckNode(u->stmt);
  
  if (u->expr) {
    Node *type = NodeDataType(u->expr);
    
    if (type && !(IsScalarType(type)))
      SyntaxErrorCoord(u->expr->coord,
		       "controlling expressions must have scalar type");
    
    /*      u->expr = EnsureComparison(u->expr); */
  }
  
  return node;
}

PRIVATE inline Node *SemCheckDo(Node *node, DoNode *u)
{
  u->expr = SemCheckNode(u->expr);
  u->stmt = SemCheckNode(u->stmt);
  
  if (u->expr) {
    Node *type = NodeDataType(u->expr);
    
    if (type && !(IsScalarType(type)))
      SyntaxErrorCoord(u->expr->coord,
		       "controlling expressions must have scalar type");
    
    /*      u->expr = EnsureComparison(u->expr); */
  }
  return node;
}

PRIVATE inline Node *SemCheckFor(Node *node, ForNode *u)
{
  u->cond = SemCheckNode(u->cond);
  u->init = SemCheckNode(u->init);
  u->next = SemCheckNode(u->next);
  u->stmt = SemCheckNode(u->stmt);
  
  if (u->cond)  {
    Node *type = NodeDataType(u->cond);
    
    if (type && !(IsScalarType(type)))
      SyntaxErrorCoord(u->cond->coord,
		       "controlling expressions must have scalar type");
    
    /*      u->cond = EnsureComparison(u->cond); */
  }
  
  return node;
}

PRIVATE inline Node *SemCheckGoto(Node *node, GotoNode *u)
{
  return node;
}

PRIVATE inline Node *SemCheckContinue(Node *node, ContinueNode *u)
{
  return node;
}

PRIVATE inline Node *SemCheckBreak(Node *node, BreakNode *u)
{
  return node;
}

PRIVATE inline Node *SemCheckReturn(Node *node, ReturnNode *u)
{
  Node *FunctionRetType = FunctionReturnType(u->proc);

  u->expr = SemCheckNode(u->expr);

  if (u->expr) {
    if (IsVoidType(FunctionRetType))
      SyntaxErrorCoord(u->expr->coord, "void function cannot return value");
    else
      u->expr = ReturnConversions(u->expr, FunctionRetType);
  }
  else if (!IsVoidType(FunctionRetType))
    SyntaxErrorCoord(node->coord, "non-void function must return value");
    
  return node;
}

PRIVATE inline Node *SemCheckBlock(Node *node, BlockNode *u)
{
  /* Check that any Adcl's in the declaration list are complete */
  ListMarker decl_marker;
  Node *decl;
  
  IterateList(&decl_marker, u->decl);
  while (NextOnList(&decl_marker, (GenericREF) &decl)) 
    {
      if (decl) decl = SemCheckNode(decl);
      
      if (decl->typ == Decl && decl->u.decl.init == NULL) 
	{ Node *type;
	  
	  assert(decl->u.decl.type);
	  type = NodeDataType(decl->u.decl.type);
	  
	  if (NodeIsConstQual(type) && !DeclIsExtern(decl) && !DeclIsTypedef(decl)) {
	    WarningCoord(1, decl->coord,
			 "const object should have initializer: \"%s\"",
			 decl->u.decl.name);
	    PrintNode(stdout, decl, 0); printf("\n");
	    PrintNode(stdout, type, 0); printf("\n");
	  }
	}
    }
  
  /* Now walk the statements */
  u->stmts = SemCheckList(u->stmts);
  
  if (u->type == NULL) 
    { Node *item = LastItem(u->stmts);
      
      assert(item);
      u->type = NodeDataType(item);
      /* PrintNode(stdout, u->type, 2); */
    }
  
  return node;
}


/*************************************************************************/
/*                                                                       */
/*                             Type nodes                                */
/*                                                                       */
/*************************************************************************/

PRIVATE inline Node *SemCheckPrim(Node *node, primNode *u)
{
  return node;
}

PRIVATE inline Node *SemCheckTdef(Node *node, tdefNode *u)
{
  return node;
}

PRIVATE inline Node *SemCheckPtr(Node *node, ptrNode *u)
{
  u->type = SemCheckNode(u->type);
  return node;
}

PRIVATE inline Node *SemCheckAdcl(Node *node, adclNode *u)
{
  u->type = SemCheckNode(u->type);
  
  /* WCH: bug fix */
  if (u->dim) 
    {
      Node *dim = SemCheckNode(u->dim);
      u->dim = dim;
      
      if (!NodeIsConstant(dim)) {
	SyntaxErrorCoord(dim->coord, "array dimension must be constant");
	u->size = 0;
      }
      else if (!IsIntegralType(NodeDataType(dim))) {
	SyntaxErrorCoord(dim->coord,
			 "array dimension must be an integer type");
	u->size = 0;
      }
      else {
	int val = NodeConstantIntegralValue(dim);
	
	assert(u->type);
	
	/* check the array bound */
	if (val < 0) {
	  SyntaxErrorCoord(dim->coord, "negative array dimension");
	  u->size = 0;
	}
	else {
	  if (val == 0 && ANSIOnly)
	    WarningCoord(1, dim->coord, "array dimension is zero");

	  u->size =
	    val * NodeSizeof(node, NodeDataType(u->type));
	}
      }
    }
  else
    u->size = 0;
  
  return node;
}

PRIVATE inline Node *SemCheckFdcl(Node *node, fdclNode *u)
{
  u->args = SemCheckList(u->args);
  u->returns = SemCheckNode(u->returns);
  return node;
}

PRIVATE inline Node *SemCheckSdcl(Node *node, sdclNode *u)
{
  if (SUE_ELABORATED(u->tq))
    StructCheckFields(u->type);
  return node;
}

PRIVATE inline Node *SemCheckUdcl(Node *node, udclNode *u)
{
  if (SUE_ELABORATED(u->tq))
    UnionCheckFields(u->type);
  return node;
}

PRIVATE inline Node *SemCheckEdcl(Node *node, edclNode *u)
{
  if (SUE_ELABORATED(u->tq))
    AssignEnumValues(u->type);
  return node;
}

/*************************************************************************/
/*                                                                       */
/*                      Other nodes (decls et al.)                       */
/*                                                                       */
/*************************************************************************/

PRIVATE inline Node *SemCheckDecl(Node *node, declNode *u)
{
  u->type    = SemCheckNode(u->type);
  u->init    = SemCheckNode(u->init);
  u->bitsize = SemCheckNode(u->bitsize);
  
  if (u->init)
    SemCheckDeclInit(node, NodeDeclLocation(node) == T_BLOCK_DECL);
  
  return node;
}

PRIVATE inline Node *SemCheckAttrib(Node *node, attribNode *u)
{
  return node;
}

PRIVATE inline Node *SemCheckProc(Node *node, procNode *u)
{
  Node *type;
  List *args;


  u->decl = SemCheckNode(u->decl);

  assert(u->decl->typ == Decl);
  type = u->decl->u.decl.type;

  args = type->u.fdcl.args;
  
  /* Verify that none of the parameters have initializers */
  { ListMarker marker;
    Node *item;
    
    if (!IsVoidArglist(args))
      {
	IterateList(&marker, args);
	while (NextOnList(&marker, (GenericREF) &item))
	  if (item->typ == Decl)
	    {
	      if (item->u.decl.init)
		SyntaxErrorCoord(item->coord,
				 "cannot initialize parameter %s",
				 item->u.decl.name);
	    }
	  else if (IsEllipsis(item))
	    ;
	  else
	    {
	      fprintf(stderr, "Unrecognized parameter\n");
	      PrintNode(stderr, item, 0);
	      fprintf(stderr, "\n");
	      assert(FALSE);
	    }
      }
  }
  
  u->body = SemCheckNode(u->body);
  
  return node;
}

PRIVATE inline Node *SemCheckText(Node *node, textNode *u)
{
  return node;
}

/*************************************************************************/
/*                                                                       */
/*                            Extensions                                 */
/*                                                                       */
/*************************************************************************/






/*************************************************************************/
/*                                                                       */
/*                  SemCheckNode and SemCheckList                        */
/*                                                                       */
/*************************************************************************/


GLOBAL Node *SemCheckNode(Node *node)
{ 
#if 0
  printf("\nSemCheckNode 0x%08x\n", node);
#endif
  
  if (node == NULL)
    return node;
  
#if 0
  PrintNode(stdout, node, 0); printf("\n");
#endif
  
  
#define CODE(name, node, union) return SemCheck##name(node, union)
  ASTSWITCH(node, CODE)
#undef CODE
    
    UNREACHABLE;
  return NULL;
}

GLOBAL List *SemCheckList(List *list)
{ List *aptr;
  
  for (aptr = list; aptr; aptr = Rest(aptr))
    { Node *item = FirstItem(aptr);
      
      if (item) SetItem(aptr, SemCheckNode(item));
    }
  
  return list;
}




/*************************************************************************/
/*                  Auxilliary routines for SemCheck                     */
/*************************************************************************/


PRIVATE void SemCheckIsArithmeticType(Node *type, Node *op)
{
  assert(type);
  assert(op);
  if (!IsArithmeticType(type)) {
    OpType opcode = (op->typ == Unary) ? op->u.unary.op : op->u.binop.op;
    
    SyntaxErrorCoord(op->coord,
		     "operand must have arithmetic type: op \"%s\"", 
		     Operator[opcode].text);
  }
}

PRIVATE void SemCheckIsScalarType(Node *type, Node *op)
{
  if (!IsScalarType(type)) {
    OpType opcode = (op->typ == Unary) ? op->u.unary.op : op->u.binop.op;
    
    SyntaxErrorCoord(op->coord,
		     "operand must have scalar type: op \"%s\"", 
		     Operator[opcode].text);
  }
}

PRIVATE void SemCheckIsIntegralType(Node *type, Node *op)
{
  if (!IsIntegralType(type)) {
    OpType opcode = (op->typ == Unary) ? op->u.unary.op : op->u.binop.op;
    
    SyntaxErrorCoord(op->coord,
		     "operand must have integral type: op \"%s\"", 
		     Operator[opcode].text);
  }
}




PRIVATE void AssignEnumValues(SUEtype *enm)
{
  ListMarker marker;
  Node *c;
  TARGET_INT current_value = 0;
  
  assert(enm->typ == Edcl);
  if (enm->fields == NULL) return;
  
  IterateList(&marker, enm->fields);
  while (NextOnList(&marker, (GenericREF) &c)) {
    assert(c->typ == Decl);
    if (c->u.decl.init == NULL) {
      c->u.decl.init = MakeImplicitCast(PrimSint, NULL);
      NodeSetSintValue(c->u.decl.init, current_value);
    } else {
      Node *value = SemCheckNode(c->u.decl.init);
      c->u.decl.init = value;
      
      if (!NodeIsConstant(value)) {
	SyntaxErrorCoord(value->coord, "enum initializer must be constant");
      }
      else if (NodeTypeIsSint(value))
	current_value = NodeConstantSintValue(value);
      else if (NodeTypeIsUint(value)) {
	current_value = NodeConstantUintValue(value);
	c->u.decl.init = AssignmentConversions(value, PrimSint);
      }
      else {
	SyntaxErrorCoord(value->coord, "enum initializer must be type int");
      }
    }
    /* constants are already in the symbol table (by BuildEnumConst) */
    current_value++;
    /* it would be nice to check for values used twice, which is
       legal but usually a mistake */
  }
}


GLOBAL void StructCheckFields(SUEtype *sue)
{ 
    if (sue->visited == FALSE) {
	int currentbit = 0, max_bitalign = 8;
#if 0
	int totalbitsize = 0;
#endif
	ListMarker marker;
	Node *field;
	
	/* To stop infinite recursion */
	sue->visited = TRUE;
	
	/* Loop over the fields of the SDCL */
	IterateList(&marker, sue->fields);
	while (NextOnList(&marker, (GenericREF) &field)) {
	    int bitsize, bitalign;
	    declNode *decl;
	    Node *type;
	    
	    assert(field->typ == Decl);
	    decl = &(field->u.decl);
	    type = NodeDataType(decl->type);
	    
	    if (decl->bitsize != NULL) {

		if ((type->typ != Prim) ||
		    ((type->u.prim.basic != Sint) &&
		     (type->u.prim.basic != Uint))) {
		    /* the only legal types are sint/uint */
		    SyntaxErrorCoord(field->coord,
				     "bitfield must be of type "
				     "signed int or unsigned int"
				     );
		}

		/* resolve bitsize */
		decl->bitsize = SemCheckNode(decl->bitsize);
		bitalign = BYTE_LENGTH;
		if ((! NodeIsConstant(decl->bitsize)) ||
		    (! IsIntegralType(NodeDataType(decl->bitsize)))) {
		    SyntaxErrorCoord(field->coord,
				     "bitfield must be an positive "
				     "integral constant");
		    bitsize = 8;
		}
		else
		    bitsize = NodeConstantIntegralValue(decl->bitsize);
		
#if 0
/* bitlength not needed in c-to-c -- rcm */
		/* set the bitlength; ignore empty fields */
		if (decl->name == NULL) {
		    decl->bitlength = 0;
		} else {
		    decl->bitlength = bitsize;
		}
#endif

#if 0
/* c-to-c can't enforce maximum bitfield size, because it doesn't know the
   word length of the target architecture  -- rcm */
		if (bitsize > WORD_LENGTH) {
		    SyntaxErrorCoord(field->coord,
				     "bitfield %s%scannot exceed %d bits",
				     (decl->name ? decl->name : ""), 
				     (decl->name ? " " : ""),
				     INT_SIZE*BYTE_LENGTH);
		    decl->init = SintZero;
		}
#endif
		if (bitsize < 0) {
		    SyntaxErrorCoord(field->coord,
				     "bitfield size must be positive");
#if 0
		    decl->init = SintZero;
#endif
		}
		else if (bitsize == 0) {
		    if (decl->name == NULL) {
			/* realign and go on */
			if (currentbit % WORD_LENGTH != 0) {
			    currentbit = currentbit + WORD_LENGTH -
				(currentbit % WORD_LENGTH); 
#if 0
			    decl->init = SintZero;
#endif
			}
		    } else {
			SyntaxErrorCoord(field->coord,
					 "zero width for bit-field %s",
					 decl->name);
#if 0
			decl->init = SintZero;
#endif
		    }
		}
		else {
#if 0
		    int bytealign = bitsize % BYTE_LENGTH;
#endif
		    
		    if (((currentbit + bitsize - 1) / WORD_LENGTH) !=
			(currentbit / WORD_LENGTH)) {
			/*
			 * bitfield crosses a word boundary
			 * realign to next word
			 */
			currentbit =
			    WORD_LENGTH * ((currentbit / WORD_LENGTH) + 1);
		    }

#if 0
/* no point in optimization -- rcm */
		    
		    /* optimize correctly sized and aligned fields */
		    if ((currentbit % bitsize == 0) && (bytealign == 0) &&
			(bitsize != 24)) {
			
			/* treat as a non-bitfield declaration */
			decl->init = MakeIntConst(currentbit / BYTE_LENGTH);
			decl->bitlength = -1;
			switch (bitsize) {
			  case BYTE_LENGTH:
			    /* byte/char access */
			    if (NodeTypeIsSint(decl->type))
				decl->type = PrimSchar;
			    else
				decl->type = PrimUchar;
			    break;
			  case HALFWORD_LENGTH:
			    /* halfword/short access */
			    if (NodeTypeIsSint(decl->type))
				decl->type = PrimSshort;
			    else
				decl->type = PrimUshort;
			    break;
			  case WORD_LENGTH:
			    /* word/int access */
			    /* nothing changes */
			    break;
			  default:
			    /* can't happen */
			    assert(0);
			    break;
			}
		    } else {
			decl->init =
			    MakeIntConst(INT_SIZE *
					 (currentbit / WORD_LENGTH));
			decl->bitoffset = currentbit % WORD_LENGTH;
		    }
#endif

#if 0
/* neither bitoffset nor byte offset (stored in init) are needed for
   c-to-c  -- rcm */
		    decl->init =
		      MakeIntConst(INT_SIZE *
				   (currentbit / WORD_LENGTH));
		    decl->bitoffset = currentbit % WORD_LENGTH;
#endif
		    
		    currentbit += bitsize;
		}
	    } else { /* not a bitfield */
	      field = SemCheckNode(field);
	      SetCurrentOnList(&marker, field);
		
		bitsize  = abs(NodeSizeof(field, NULL)) * BYTE_LENGTH;
		bitalign = NodeAlignment(field, NULL) * BYTE_LENGTH;
		
		/* realign field */
		if (currentbit % bitalign != 0)
		    currentbit = currentbit + bitalign -
			(currentbit % bitalign);
#if 0
		decl->init = MakeIntConst(currentbit / BYTE_LENGTH);
#endif
		
		currentbit += bitsize;
	    }
	    
	    if (bitalign > max_bitalign) max_bitalign = bitalign;
	}
	
	/* realign struct */
	if (currentbit % max_bitalign != 0)
	    currentbit = currentbit + max_bitalign - (currentbit % max_bitalign);
	
	sue->size  = currentbit / BYTE_LENGTH;
	sue->align = max_bitalign / BYTE_LENGTH;
    }
}

GLOBAL void UnionCheckFields(SUEtype *sue)
{ 
    if (sue->visited == FALSE) {
	int max_align = 0, max_size = 0;
	ListMarker marker;
	Node *field;
	
	/* To stop infinite recursion */
	sue->visited = TRUE;
	
	/* Loop over the fields of the SDCL */
	IterateList(&marker, sue->fields);
	while (NextOnList(&marker, (GenericREF) &field)) {
	    Node *type;
	    int size, align;
	    
	    assert(field->typ == Decl);
	    type = NodeDataType(field->u.decl.type);

	    if (IsStructType(type) ||
		IsArrayType(type) ||
		IsUnionType(type)
		) {
	      field = SemCheckNode(field);
	      SetCurrentOnList(&marker, field);
	    }
	    
	    size  = abs(NodeSizeof(field, NULL));
	    align = NodeAlignment(field, NULL);

#if 0
/* offsets and bitlengths not kept in c-to-c -- rcm */	    
	    field->u.decl.init = SintZero;
	    field->u.decl.bitlength = -1; /* no bit length */
#endif

	    if (size  > max_size ) max_size  = size;
	    if (align > max_align) max_align = align;
	}
	
	sue->size = max_size;
#ifndef AUTOPILOT
	sue->align = max_align;
#else
	/*
	  for Autopilot, short-align all unions so that
	  internal structs are never character-aligned
	  */
	sue->align = (max_align < 2) ? 2 : max_align;
#endif
    }
}


PRIVATE void SemCheckCallArgs(Node *node, List *formals, List *actuals)
{
  ListMarker fm, am;
  Node *formal, *actual;
  int formals_len, actuals_len;
  Node *formaltype;
  Bool traditional = (formals == NULL);
  Bool variable_length = traditional || IsEllipsis(LastItem(formals));


  formals_len = IsVoidArglist(formals) ? 0 : ListLength(formals);
  actuals_len = ListLength(actuals);

  if (!variable_length && formals_len != actuals_len) {
    SyntaxErrorCoord(node->coord, 
		     "argument mismatch: %d args passed, %d expected",
		     actuals_len, formals_len);
  }
  else if (!IsVoidArglist(formals)) {
    IterateList(&am, actuals);
    if (!traditional) IterateList(&fm, formals);
    while (NextOnList(&am, (GenericREF) &actual)) {
      if (!traditional) {
	NextOnList(&fm, (GenericREF) &formal);
	if (IsEllipsis(formal))
	  traditional = TRUE;
      }

      if (traditional)
	actual = UsualUnaryConversions(actual, TRUE);
      else {
	formaltype = NodeDataType(formal);
	actual = CallConversions(actual, formaltype);
      }
	
      SetCurrentOnList(&am, actual);
    }
  }
}



/***************************************************************************/
/*                    B I N A R Y    O P E R A T O R S                     */
/***************************************************************************/

/* Binop assignment */
PRIVATE Node *SemCheckAssignment(Node *node, binopNode *u)
{ Node *left, *right, *ltype, *rtype;
  OpType opcode;
  
  assert(node);
  left   = u->left;
  right  = u->right;
  assert(left);
  assert(right);
  ltype  = NodeDataType(left);
  rtype  = NodeDataType(right);
  assert(ltype);
  assert(rtype);
  opcode = u->op;
  
#if 0
  printf("SemCheckAssignment\n");
  PrintNode(stdout, left,  0); printf("\n");
  PrintNode(stdout, right, 0); printf("\n");
  PrintNode(stdout, ltype, 0); printf("\n");
  PrintNode(stdout, rtype, 0); printf("\n\n");
#endif
  
  assert(left);
  assert(right);
  assert(ltype);
  assert(rtype);
  
  /* The left hand side must be a modifiable lvalue */
  if (!IsModifiableLvalue(left))
    SyntaxErrorCoord(node->coord, 
		     "left operand must be modifiable lvalue: op %s",
		     OperatorText(opcode));
  
  
  /* assignment conversions don't work for ptr+=int or ptr-=int,
     so treat them as special cases */
  if ((opcode == PLUSassign || opcode == MINUSassign) &&
      IsPointerType(ltype) && 
      IsIntegralType(UsualUnaryConversionType(rtype)))
    /* make sure we can calculate size of base type */
    (void)NodeSizeof(node, GetDeepBaseType(ltype));
  else
    u->right = AssignmentConversions(right, ltype);

  
  /* The type of the expression is the type of the LHS */
  u->type = ltype;
  
  return node;
}

PRIVATE Node *SemCheckDot(Node *node, binopNode *u)
{ Node *field = NULL,
    *left, *right, *ltype, *rtype, *type;
  
  assert(node);
  
  left  = u->left;
  right = u->right;
  assert(left);
  assert(right);
  ltype = NodeDataType(left);
  rtype = NodeDataType(right);
  assert(ltype);
  type  = NodeDataType(ltype);
  assert(type);
  
  /* The lhs must be a struct or union */
  if (!(type->typ == Sdcl || type->typ == Udcl)) {
    SyntaxErrorCoord(node->coord, 
		     "left operand of \".\" must be a struct/union object");
    u->type = type;
    return node;
  }
  
  field = SdclFindField(type, right);
  
  /* Check that the field is valid */
  if (field == NULL) {
    SyntaxErrorCoord(node->coord, 
		     "undefined struct/union member: \"%s\"",
		     rtype->u.id.text);
    u->type = type;
    return node;
  }
  
  assert(field->u.decl.type);
  u->type = NodeDataType(field->u.decl.type);
  return node;
}


PRIVATE Node *SemCheckArrow(Node *node, binopNode *u)
{ ListMarker marker;
  Node *decl, *field = NULL, *right, *left, *ltype, *rtype, *type;
  
  assert(node);
  right = u->right;
  /* perform UnaryConversions on left node, to ensure that arrays
     are converted to pointers */
  left  = UsualUnaryConversions(u->left, FALSE);
  
  assert(right);
  assert(left);
  ltype = NodeDataType(left);
  rtype = NodeDataType(right);
  
  assert(ltype);
  assert(rtype);
  type  = NodeDataType(ltype);
  assert(type);
  
  /* The lhs must be a pointer to a struct or union */
  if (ltype->typ != Ptr) {
    SyntaxErrorCoord(node->coord, 
		     "left operand of \"%s\" must be a pointer to a struct/union",
		     OperatorText(u->op));
    u->type = ltype;
    return node;
  }
  
  assert(ltype->u.ptr.type);
  type = NodeDataType(ltype->u.ptr.type);
  
  if (!(type->typ == Sdcl || type->typ == Udcl) ) {
    SyntaxErrorCoord(node->coord, 
		     "left operand of \"%s\" must be a struct/union object",
		     OperatorText(u->op));
    u->type = type;
    return node;
  }
  
  /* Find the field in the struct/union fields */
  IterateList(&marker, type->u.sdcl.type->fields);
  while (NextOnList(&marker, (GenericREF) &decl)) {
    assert(decl->typ == Decl);
    if (strcmp(right->u.id.text, decl->u.decl.name) == 0) {
      field = decl;
      break;
    }
  }
  
  /* Check that the field is valid */
  if (field == NULL) {
    SyntaxErrorCoord(node->coord, 
		     "undefined struct/union member: \"%s\"",
		     rtype->u.id.text);
    u->type = type;
    return node;
  }
  
  assert(field->u.decl.type);
  u->type = NodeDataType(field->u.decl.type);
  return node;
}

PRIVATE Node *SemCheckArithmetic(Node *node, binopNode *u)
{ Node   *left, *right, *ltype, *rtype;
  OpType  opcode;
  
  assert(node);
  
  left   = UsualUnaryConversions(u->left,  FALSE),
  right  = UsualUnaryConversions(u->right, FALSE),
  opcode = u->op;
  
  assert(left);
  assert(right);
  
#if 0
  printf("\nSemCheckArith\n");
  PrintNode(stdout, left,  0); printf("\n");
  PrintNode(stdout, right, 0); printf("\n");
#endif
  
  switch(opcode) {
  case LS:
  case RS:
    break;
  default:
    UsualBinaryConversions(&left, &right);
  }
  
  assert(left);
  assert(right);
  
  ltype  = NodeDataType(left);
  rtype  = NodeDataType(right);
  
  if (ltype == NULL) {
    PrintNode(stdout, left, 0);
    printf("\n");
  }
  
  assert(left);
  assert(right);
  assert(ltype);
  assert(rtype);
  
  switch(opcode) {
  case '+':
    /* Canonicalize PTR + INT expressions */
    if (IsIntegralType(ltype) && IsPointerType(rtype)) {
      Node *tnode = left, *ttype = ltype;
      
      left  = right; ltype = rtype;
      right = tnode; rtype = ttype;
    }
    
    if (!((IsArithmeticType(ltype) && IsArithmeticType(rtype)) ||
	  (IsPointerType(ltype)    && IsIntegralType(rtype))))
      SyntaxErrorCoord(node->coord,
		       "operands must have arithmetic type or ptr/int: op \"+\"");
    u->type = ltype;

    if (IsPointerType(ltype)) {
      /* try to get size of base type, to ensure that it is defined 
	 (and not void or an incomplete struct/union type) */
      (void)NodeSizeof(left, GetShallowBaseType(ltype));
    }
      
    
    if (NodeIsConstant(left) && NodeIsConstant(right))
      {
	if (NodeTypeIsSint(left))
	  { int lval = NodeConstantSintValue(left),
	      rval = NodeConstantSintValue(right);
	    
	    NodeSetSintValue(node, lval + rval);
	  }
	else if (NodeTypeIsUint(left))
	  { unsigned int lval = NodeConstantUintValue(left),
	      rval = NodeConstantUintValue(right);
	    
	    NodeSetUintValue(node, lval + rval);
	  }
	else if (NodeTypeIsSlong(left))
	  { long lval = NodeConstantSlongValue(left),
	      rval = NodeConstantSlongValue(right);
	    
	    NodeSetSlongValue(node, lval + rval);
	  }
	else if (NodeTypeIsUlong(left))
	  { unsigned long lval = NodeConstantUlongValue(left),
	      rval = NodeConstantUlongValue(right);
	    
	    NodeSetUlongValue(node, lval + rval);
	  }
	
	else if (NodeTypeIsFloat(left))
	  { float lval = NodeConstantFloatValue(left),
	      rval = NodeConstantFloatValue(right);
	    
	    NodeSetFloatValue(node, lval + rval);
	  }
	else if (NodeTypeIsDouble(left))
	  { double lval = NodeConstantDoubleValue(left),
	      rval = NodeConstantDoubleValue(right);
	    
	    NodeSetDoubleValue(node, lval + rval);
	  }
      }
    
    break;
    
  case '-':
    if (!( (IsArithmeticType(ltype) && IsArithmeticType(rtype)) ||
	  (IsPointerType(ltype)    && IsIntegralType(rtype))   ||
	  (IsPointerType(ltype)    && IsPointerType(rtype)))) 
      {
	SyntaxErrorCoord(node->coord,
			 "operands have incompatible types: op \"-\"");
      }
    
    if (ltype->typ == Ptr && rtype->typ == Ptr)
      u->type = PrimSint; /* fix: should really be ptrdiff_t */
    else
      u->type = ltype;
    
    if (NodeIsConstant(left) && NodeIsConstant(right))
      {
	if (NodeTypeIsSint(left))
	  { int lval = NodeConstantSintValue(left),
	      rval = NodeConstantSintValue(right);
	    
	    NodeSetSintValue(node, lval - rval);
	  }
	else if (NodeTypeIsUint(left))
	  { unsigned int lval = NodeConstantUintValue(left),
	      rval = NodeConstantUintValue(right);
	    
	    NodeSetUintValue(node, lval - rval);
	  }
	else if (NodeTypeIsSlong(left))
	  { long lval = NodeConstantSlongValue(left),
	      rval = NodeConstantSlongValue(right);
	    
	    NodeSetSlongValue(node, lval - rval);
	  }
	else if (NodeTypeIsUlong(left))
	  { unsigned long lval = NodeConstantUlongValue(left),
	      rval = NodeConstantUlongValue(right);
	    
	    NodeSetUlongValue(node, lval - rval);
	  }
	
	else if (NodeTypeIsFloat(left))
	  { float lval = NodeConstantFloatValue(left),
	      rval = NodeConstantFloatValue(right);
	    
	    NodeSetFloatValue(node, lval - rval);
	  }
	else if (NodeTypeIsDouble(left))
	  { double lval = NodeConstantDoubleValue(left),
	      rval = NodeConstantDoubleValue(right);
	    
	    NodeSetDoubleValue(node, lval - rval);
	  }
      }
    break;
    
  case '*':
    if (!(IsArithmeticType(ltype) && IsArithmeticType(rtype)))
      SyntaxErrorCoord(node->coord,
		       "operands must have arithmetic type: op \"%s\"",
		       Operator[opcode].text);
    
    u->type = ltype;
    
    if (NodeIsConstant(left) && NodeIsConstant(right))
      {
	if (NodeTypeIsSint(left))
	  { int lval = NodeConstantSintValue(left),
	      rval = NodeConstantSintValue(right);
	    
	    NodeSetSintValue(node, lval * rval);
	  }
	else if (NodeTypeIsUint(left))
	  { unsigned int lval = NodeConstantUintValue(left),
	      rval = NodeConstantUintValue(right);
	    
	    NodeSetUintValue(node, lval * rval);
	  }
	else if (NodeTypeIsSlong(left))
	  { long lval = NodeConstantSlongValue(left),
	      rval = NodeConstantSlongValue(right);
	    
	    NodeSetSlongValue(node, lval * rval);
	  }
	else if (NodeTypeIsUlong(left))
	  { unsigned long lval = NodeConstantUlongValue(left),
	      rval = NodeConstantUlongValue(right);
	    
	    NodeSetUlongValue(node, lval * rval);
	  }
	
	else if (NodeTypeIsFloat(left))
	  { float lval = NodeConstantFloatValue(left),
	      rval = NodeConstantFloatValue(right);
	    
	    NodeSetFloatValue(node, lval * rval);
	  }
	else if (NodeTypeIsDouble(left))
	  { double lval = NodeConstantDoubleValue(left),
	      rval = NodeConstantDoubleValue(right);
	    
	    NodeSetDoubleValue(node, lval * rval);
	  }
      }
    break;
    
  case '/':
    if (!(IsArithmeticType(ltype) && IsArithmeticType(rtype)))
      SyntaxErrorCoord(node->coord,
		       "operands must have arithmetic type: op \"%s\"",
		       Operator[opcode].text);
    
    if (NodeIsConstant(left) && NodeIsConstant(right))
      {
	if (NodeTypeIsSint(left))
	  { int lval = NodeConstantSintValue(left),
	      rval = NodeConstantSintValue(right);
	    
	    if (rval == 0)
	      SyntaxErrorCoord(node->coord,
			       "attempt to divide constant by 0");
	    else
	      NodeSetSintValue(node, lval / rval);
	  }
	else if (NodeTypeIsUint(left))
	  { unsigned int lval = NodeConstantUintValue(left),
	      rval = NodeConstantUintValue(right);
	    
	    if (rval == 0)
	      SyntaxErrorCoord(node->coord,
			       "attempt to divide constant by 0");
	    else
	      NodeSetUintValue(node, lval / rval);
	  }
	else if (NodeTypeIsSlong(left))
	  { long lval = NodeConstantSlongValue(left),
	      rval = NodeConstantSlongValue(right);
	    
	    if (rval == 0)
	      SyntaxErrorCoord(node->coord,
			       "attempt to divide constant by 0");
	    else
	      NodeSetSlongValue(node, lval / rval);
	  }
	else if (NodeTypeIsUlong(left))
	  { unsigned long lval = NodeConstantUlongValue(left),
	      rval = NodeConstantUlongValue(right);
	    
	    if (rval == 0)
	      SyntaxErrorCoord(node->coord,
			       "attempt to divide constant by 0");
	    else
	      NodeSetUlongValue(node, lval / rval);
	  }
	
	else if (NodeTypeIsFloat(left))
	  { float lval = NodeConstantFloatValue(left),
	      rval = NodeConstantFloatValue(right);
	    
	    if (rval == 0)
	      SyntaxErrorCoord(node->coord,
			       "attempt to divide constant by 0");
	    else
	      NodeSetFloatValue(node, lval / rval);
	  }
	else if (NodeTypeIsDouble(left))
	  { double lval = NodeConstantDoubleValue(left),
	      rval = NodeConstantDoubleValue(right);
	    
	    if (rval == 0)
	      SyntaxErrorCoord(node->coord,
			       "attempt to divide constant by 0");
	    else
	      NodeSetDoubleValue(node, lval / rval);
	  }
      }
    u->type = ltype;
    break;
    
  case '%':
    if (!(IsIntegralType(ltype) && IsIntegralType(rtype)))
      SyntaxErrorCoord(node->coord,
		       "operands must have integral type: op \"%s\"",
		       Operator[opcode].text);
    if (NodeIsConstant(left) && NodeIsConstant(right))
      {
	if (NodeTypeIsSint(left))
	  { int lval = NodeConstantSintValue(left),
	      rval = NodeConstantSintValue(right);
	    
	    NodeSetSintValue(node, lval % rval);
	  }
	else if (NodeTypeIsUint(left))
	  { unsigned int lval = NodeConstantUintValue(left),
	      rval = NodeConstantUintValue(right);
	    
	    NodeSetUintValue(node, lval % rval);
	  }
	else if (NodeTypeIsSlong(left))
	  { long lval = NodeConstantSlongValue(left),
	      rval = NodeConstantSlongValue(right);
	    
	    NodeSetSlongValue(node, lval % rval);
	  }
	else if (NodeTypeIsUlong(left))
	  { unsigned long lval = NodeConstantUlongValue(left),
	      rval = NodeConstantUlongValue(right);
	    
	    NodeSetUlongValue(node, lval % rval);
	  }
      }
    u->type = ltype;
    break;
  case LS:
    if (!(IsIntegralType(ltype) && IsIntegralType(rtype)))
      SyntaxErrorCoord(node->coord,
		       "operands must have integral type: op \"%s\"",
		       Operator[opcode].text);
    if (NodeIsConstant(left) && NodeIsConstant(right))
      {
	unsigned long rval = NodeConstantIntegralValue(right);

	if (NodeTypeIsSint(left))
	  { int lval = NodeConstantSintValue(left);
	    
	    NodeSetSintValue(node, lval << rval);
	  }
	else if (NodeTypeIsUint(left))
	  { unsigned int lval = NodeConstantUintValue(left);

	    NodeSetUintValue(node, lval << rval);
	  }
	else if (NodeTypeIsSlong(left))
	  { long lval = NodeConstantSlongValue(left);
	    
	    NodeSetSlongValue(node, lval << rval);
	  }
	else if (NodeTypeIsUlong(left))
	  { unsigned long lval = NodeConstantUlongValue(left);
	    
	    NodeSetUlongValue(node, lval << rval);
	  }
      }
    u->type = ltype;
    break;
  case RS:
      /*if (!(IsIntegralType,(ltype) && IsIntegralType(rtype)))*/
      if (!(IsIntegralType(ltype) && IsIntegralType(rtype)))
      SyntaxErrorCoord(node->coord,
		       "operands must have integral type: op \"%s\"",
		       Operator[opcode].text);
    if (NodeIsConstant(left) && NodeIsConstant(right))
      {
	unsigned long rval = NodeConstantIntegralValue(right);

	if (NodeTypeIsSint(left))
	  { int lval = NodeConstantSintValue(left);
	    
	    NodeSetSintValue(node, lval >> rval);
	  }
	else if (NodeTypeIsUint(left))
	  { unsigned int lval = NodeConstantUintValue(left);
	    
	    NodeSetUintValue(node, lval >> rval);
	  }
	else if (NodeTypeIsSlong(left))
	  { long lval = NodeConstantSlongValue(left);
	    
	    NodeSetSlongValue(node, lval >> rval);
	  }
	else if (NodeTypeIsUlong(left))
	  { unsigned long lval = NodeConstantUlongValue(left);
	    
	    NodeSetUlongValue(node, lval >> rval);
	  }
      }
    u->type = ltype;
    break;
  case '&':
    if (!(IsIntegralType(ltype) && IsIntegralType(rtype)))
      SyntaxErrorCoord(node->coord,
		       "operands must have integral type: op \"%s\"",
		       Operator[opcode].text);
    if (NodeIsConstant(left) && NodeIsConstant(right))
      {
	if (NodeTypeIsSint(left))
	  { int lval = NodeConstantSintValue(left),
	      rval = NodeConstantSintValue(right);
	    
	    NodeSetSintValue(node, lval & rval);
	  }
	else if (NodeTypeIsUint(left))
	  { unsigned int lval = NodeConstantUintValue(left),
	      rval = NodeConstantUintValue(right);
	    
	    NodeSetUintValue(node, lval & rval);
	  }
	else if (NodeTypeIsSlong(left))
	  { long lval = NodeConstantSlongValue(left),
	      rval = NodeConstantSlongValue(right);
	    
	    NodeSetSlongValue(node, lval & rval);
	  }
	else if (NodeTypeIsUlong(left))
	  { unsigned long lval = NodeConstantUlongValue(left),
	      rval = NodeConstantUlongValue(right);
	    
	    NodeSetUlongValue(node, lval & rval);
	  }
      }
    u->type = ltype;
    break;
  case '^':
    if (!(IsIntegralType(ltype) && IsIntegralType(rtype)))
      SyntaxErrorCoord(node->coord,
		       "operands must have integral type: op \"%s\"",
		       Operator[opcode].text);
    if (NodeIsConstant(left) && NodeIsConstant(right))
      {
	if (NodeTypeIsSint(left))
	  { int lval = NodeConstantSintValue(left),
	      rval = NodeConstantSintValue(right);
	    
	    NodeSetSintValue(node, lval ^ rval);
	  }
	else if (NodeTypeIsUint(left))
	  { unsigned int lval = NodeConstantUintValue(left),
	      rval = NodeConstantUintValue(right);
	    
	    NodeSetUintValue(node, lval ^ rval);
	  }
	else if (NodeTypeIsSlong(left))
	  { long lval = NodeConstantSlongValue(left),
	      rval = NodeConstantSlongValue(right);
	    
	    NodeSetSlongValue(node, lval ^ rval);
	  }
	else if (NodeTypeIsUlong(left))
	  { unsigned long lval = NodeConstantUlongValue(left),
	      rval = NodeConstantUlongValue(right);
	    
	    NodeSetUlongValue(node, lval ^ rval);
	  }
      }
    u->type = ltype;
    break;
  case '|':
    if (!(IsIntegralType(ltype) && IsIntegralType(rtype)))
      SyntaxErrorCoord(node->coord,
		       "operands must have integral type: op \"%s\"",
		       Operator[opcode].text);
    if (NodeIsConstant(left) && NodeIsConstant(right))
      {
	if (NodeTypeIsSint(left))
	  { int lval = NodeConstantSintValue(left),
	      rval = NodeConstantSintValue(right);
	    
	    NodeSetSintValue(node, lval | rval);
	  }
	else if (NodeTypeIsUint(left))
	  { unsigned int lval = NodeConstantUintValue(left),
	      rval = NodeConstantUintValue(right);
	    
	    NodeSetUintValue(node, lval | rval);
	  }
	else if (NodeTypeIsSlong(left))
	  { long lval = NodeConstantSlongValue(left),
	      rval = NodeConstantSlongValue(right);
	    
	    NodeSetSlongValue(node, lval | rval);
	  }
	else if (NodeTypeIsUlong(left))
	  { unsigned long lval = NodeConstantUlongValue(left),
	      rval = NodeConstantUlongValue(right);
	    
	    NodeSetUlongValue(node, lval | rval);
	  }
      }
    u->type = ltype;
    break;
    
  case ANDAND:
    if (NodeIsConstant(left) && NodeIsConstant(right))
      { int lval = IsConstantZero(left),
	  rval = IsConstantZero(right);
	
	NodeSetSintValue(node, !lval && !rval);
      }
#if 0
    if (!IsLogicalOrRelationalExpression(left)) {
      SemCheckIsScalarType(ltype, left);
      
      left  = MakeNotZerop(left, ltype);
      ltype = PrimSint;
      u->left = left;
    }
    
    if (!IsLogicalOrRelationalExpression(right)) {
      SemCheckIsScalarType(rtype, right);
      right = MakeNotZerop(right, rtype);
      rtype = PrimSint;
      u->right = right;
    }
#endif
    u->type = PrimSint;
    break;
  case OROR:
    if (NodeIsConstant(left) && NodeIsConstant(right))
      { int lval = IsConstantZero(left),
	  rval = IsConstantZero(right);
	
	NodeSetSintValue(node, !lval || !rval);
      }
#if 0
    if (!IsLogicalOrRelationalExpression(left)) {
      SemCheckIsScalarType(ltype, left);
      
      left  = MakeNotZerop(left, ltype);
      ltype = PrimSint;
      u->left = left;
    }
    
    if (!IsLogicalOrRelationalExpression(right)) {
      SemCheckIsScalarType(rtype, right);
      right = MakeNotZerop(right, rtype);
      rtype = PrimSint;
      u->right = right;
    }
#endif
    u->type = PrimSint;
    break;
  default:
    fprintf(stderr, "Internal Error! Unrecognized arithmetic operator\n");
    assert(FALSE);
  }
  
  u->left  = left;
  u->right = right;
  return node;
}

PRIVATE Node *SemCheckComparison(Node *node, binopNode *u)
{ Node   *left   = UsualUnaryConversions(u->left,  FALSE),
    *right  = UsualUnaryConversions(u->right, FALSE),
    *ltype,
    *rtype;
  OpType  opcode = u->op;
  
  assert(left);
  assert(right);
  
  UsualBinaryConversions(&left, &right);
  
  assert(left);
  assert(right);
  
  ltype = NodeDataType(left);
  rtype = NodeDataType(right);
  
  assert(ltype);
  assert(rtype);
  
  switch(opcode) {
  case '<':
    u->type = PrimSint;
    
    if (IsArithmeticType(ltype) && IsArithmeticType(rtype))
      {
	if (NodeIsConstant(left) && NodeIsConstant(right))
	  {
	    if (NodeTypeIsSint(left))
	      { int lval = NodeConstantSintValue(left),
		  rval = NodeConstantSintValue(right);
		
		NodeSetSintValue(node, lval < rval);
	      }
	    else if (NodeTypeIsUint(left))
	      { unsigned int lval = NodeConstantUintValue(left),
		  rval = NodeConstantUintValue(right);
		
		NodeSetSintValue(node, lval < rval);
	      }
	    else if (NodeTypeIsSlong(left))
	      { long lval = NodeConstantSlongValue(left),
		  rval = NodeConstantSlongValue(right);
		
		NodeSetSintValue(node, lval < rval);
	      }
	    else if (NodeTypeIsUlong(left))
	      { unsigned long lval = NodeConstantUlongValue(left),
		  rval = NodeConstantUlongValue(right);
		
		NodeSetSintValue(node, lval < rval);
	      }
	    else if (NodeTypeIsFloat(left))
	      { float lval = NodeConstantFloatValue(left),
		  rval = NodeConstantFloatValue(right);
		
		NodeSetSintValue(node, lval < rval);
	      }
	    else if (NodeTypeIsDouble(left))
	      { double lval = NodeConstantDoubleValue(left),
		  rval = NodeConstantDoubleValue(right);
		
		NodeSetSintValue(node, lval < rval);
	      }
	  }
      }
    else if (IsPointerType(ltype) && IsPointerType(rtype))
      UsualPointerConversions(&left, &right, FALSE);
    else
      SyntaxErrorCoord(node->coord,
		       "operands have incompatible types: op \"%s\"",
		       OperatorText(opcode));
    break;
  case LE:
    u->type = PrimSint;
    
    if (IsArithmeticType(ltype) && IsArithmeticType(rtype))
      {
	if (NodeIsConstant(left) && NodeIsConstant(right))
	  {
	    if (NodeTypeIsSint(left))
	      { int lval = NodeConstantSintValue(left),
		  rval = NodeConstantSintValue(right);
		
		NodeSetSintValue(node, lval <= rval);
	      }
	    else if (NodeTypeIsUint(left))
	      { unsigned int lval = NodeConstantUintValue(left),
		  rval = NodeConstantUintValue(right);
		
		NodeSetSintValue(node, lval <= rval);
	      }
	    else if (NodeTypeIsSlong(left))
	      { long lval = NodeConstantSlongValue(left),
		  rval = NodeConstantSlongValue(right);
		
		NodeSetSintValue(node, lval <= rval);
	      }
	    else if (NodeTypeIsUlong(left))
	      { unsigned long lval = NodeConstantUlongValue(left),
		  rval = NodeConstantUlongValue(right);
		
		NodeSetSintValue(node, lval <= rval);
	      }
	    else if (NodeTypeIsFloat(left))
	      { float lval = NodeConstantFloatValue(left),
		  rval = NodeConstantFloatValue(right);
		
		NodeSetSintValue(node, lval <= rval);
	      }
	    else if (NodeTypeIsDouble(left))
	      { double lval = NodeConstantDoubleValue(left),
		  rval = NodeConstantDoubleValue(right);
		
		NodeSetSintValue(node, lval <= rval);
	      }
	  }
      }
    else if (IsPointerType(ltype) && IsPointerType(rtype))
      UsualPointerConversions(&left, &right, FALSE);
    else
      SyntaxErrorCoord(node->coord,
		       "operands have incompatible types: op \"%s\"",
		       OperatorText(opcode));
    break;
  case '>':
    u->type = PrimSint;
    
    if (IsArithmeticType(ltype) && IsArithmeticType(rtype))
      {
	if (NodeIsConstant(left) && NodeIsConstant(right))
	  {
	    if (NodeTypeIsSint(left))
	      { int lval = NodeConstantSintValue(left),
		  rval = NodeConstantSintValue(right);
		
		NodeSetSintValue(node, lval > rval);
	      }
	    else if (NodeTypeIsUint(left))
	      { unsigned int lval = NodeConstantUintValue(left),
		  rval = NodeConstantUintValue(right);
		
		NodeSetSintValue(node, lval > rval);
	      }
	    else if (NodeTypeIsSlong(left))
	      { long lval = NodeConstantSlongValue(left),
		  rval = NodeConstantSlongValue(right);
		
		NodeSetSintValue(node, lval > rval);
	      }
	    else if (NodeTypeIsUlong(left))
	      { unsigned long lval = NodeConstantUlongValue(left),
		  rval = NodeConstantUlongValue(right);
		
		NodeSetSintValue(node, lval > rval);
	      }
	    else if (NodeTypeIsFloat(left))
	      { float lval = NodeConstantFloatValue(left),
		  rval = NodeConstantFloatValue(right);
		
		NodeSetSintValue(node, lval > rval);
	      }
	    else if (NodeTypeIsDouble(left))
	      { double lval = NodeConstantDoubleValue(left),
		  rval = NodeConstantDoubleValue(right);
		
		NodeSetSintValue(node, lval > rval);
	      }
	  }
      }
    else if (IsPointerType(ltype) && IsPointerType(rtype))
      UsualPointerConversions(&left, &right, FALSE);
    else
      SyntaxErrorCoord(node->coord,
		       "operands have incompatible types: op \"%s\"",
		       OperatorText(opcode));
    break;
  case GE:
    u->type = PrimSint;
    
    if (IsArithmeticType(ltype) && IsArithmeticType(rtype))
      {
	if (NodeIsConstant(left) && NodeIsConstant(right))
	  {
	    if (NodeTypeIsSint(left))
	      { int lval = NodeConstantSintValue(left),
		  rval = NodeConstantSintValue(right);
		
		NodeSetSintValue(node, lval >= rval);
	      }
	    else if (NodeTypeIsUint(left))
	      { unsigned int lval = NodeConstantUintValue(left),
		  rval = NodeConstantUintValue(right);
		
		NodeSetSintValue(node, lval >= rval);
	      }
	    else if (NodeTypeIsSlong(left))
	      { long lval = NodeConstantSlongValue(left),
		  rval = NodeConstantSlongValue(right);
		
		NodeSetSintValue(node, lval >= rval);
	      }
	    else if (NodeTypeIsUlong(left))
	      { unsigned long lval = NodeConstantUlongValue(left),
		  rval = NodeConstantUlongValue(right);
		
		NodeSetSintValue(node, lval >= rval);
	      }
	    else if (NodeTypeIsFloat(left))
	      { float lval = NodeConstantFloatValue(left),
		  rval = NodeConstantFloatValue(right);
		
		NodeSetSintValue(node, lval >= rval);
	      }
	    else if (NodeTypeIsDouble(left))
	      { double lval = NodeConstantDoubleValue(left),
		  rval = NodeConstantDoubleValue(right);
		
		NodeSetSintValue(node, lval >= rval);
	      }
	  }
      }
    else if (IsPointerType(ltype) && IsPointerType(rtype))
      UsualPointerConversions(&left, &right, FALSE);
    else
      SyntaxErrorCoord(node->coord,
		       "operands have incompatible types: op \"%s\"",
		       OperatorText(opcode));
    break;
    
  case EQ:
    u->type = PrimSint;
    
    if (IsArithmeticType(ltype) && IsArithmeticType(rtype))
      {
	if (NodeIsConstant(left) && NodeIsConstant(right))
	  {
	    if (NodeTypeIsSint(left))
	      { int lval = NodeConstantSintValue(left),
		  rval = NodeConstantSintValue(right);
		
		NodeSetSintValue(node, lval == rval);
	      }
	    else if (NodeTypeIsUint(left))
	      { unsigned int lval = NodeConstantUintValue(left),
		  rval = NodeConstantUintValue(right);
		
		NodeSetSintValue(node, lval == rval);
	      }
	    else if (NodeTypeIsSlong(left))
	      { long lval = NodeConstantSlongValue(left),
		  rval = NodeConstantSlongValue(right);
		
		NodeSetSintValue(node, lval == rval);
	      }
	    else if (NodeTypeIsUlong(left))
	      { unsigned long lval = NodeConstantUlongValue(left),
		  rval = NodeConstantUlongValue(right);
		
		NodeSetSintValue(node, lval == rval);
	      }
	    else if (NodeTypeIsFloat(left))
	      { float lval = NodeConstantFloatValue(left),
		  rval = NodeConstantFloatValue(right);
		
		NodeSetSintValue(node, lval == rval);
	      }
	    else if (NodeTypeIsDouble(left))
	      { double lval = NodeConstantDoubleValue(left),
		  rval = NodeConstantDoubleValue(right);
		
		NodeSetSintValue(node, lval == rval);
	      }
	  }
      }
    else if (IsPointerType(ltype) && IsPointerType(rtype))
      UsualPointerConversions(&left, &right, TRUE);
    else if ((IsPointerType(ltype) && IsConstantZero(right)) ||
	     (IsConstantZero(left) && IsPointerType(rtype)))
      ;
    else
      SyntaxErrorCoord(node->coord,
		       "operands have incompatible types: op \"%s\"",
		       OperatorText(opcode));
    break;
  case NE:
    u->type = PrimSint;
    
    if (IsArithmeticType(ltype) && IsArithmeticType(rtype))
      {
	if (NodeIsConstant(left) && NodeIsConstant(right))
	  {
	    if (NodeTypeIsSint(left))
	      { int lval = NodeConstantSintValue(left),
		  rval = NodeConstantSintValue(right);
		
		NodeSetSintValue(node, lval != rval);
	      }
	    else if (NodeTypeIsUint(left))
	      { unsigned int lval = NodeConstantUintValue(left),
		  rval = NodeConstantUintValue(right);
		
		NodeSetSintValue(node, lval != rval);
	      }
	    else if (NodeTypeIsSlong(left))
	      { long lval = NodeConstantSlongValue(left),
		  rval = NodeConstantSlongValue(right);
		
		NodeSetSintValue(node, lval != rval);
	      }
	    else if (NodeTypeIsUlong(left))
	      { unsigned long lval = NodeConstantUlongValue(left),
		  rval = NodeConstantUlongValue(right);
		
		NodeSetSintValue(node, lval != rval);
	      }
	    else if (NodeTypeIsFloat(left))
	      { float lval = NodeConstantFloatValue(left),
		  rval = NodeConstantFloatValue(right);
		
		NodeSetSintValue(node, lval != rval);
	      }
	    else if (NodeTypeIsDouble(left))
	      { double lval = NodeConstantDoubleValue(left),
		  rval = NodeConstantDoubleValue(right);
		
		NodeSetSintValue(node, lval != rval);
	      }
	  }
      }
    else if (IsPointerType(ltype) && IsPointerType(rtype))
      UsualPointerConversions(&left, &right, TRUE);
    else if ((IsPointerType(ltype) && IsConstantZero(right)) ||
	     (IsConstantZero(left) && IsPointerType(rtype)))
      ;
    else
      SyntaxErrorCoord(node->coord,
		       "operands have incompatible types: op \"%s\"",
		       OperatorText(opcode));
    break;
  default:
    fprintf(stdout, "Internal Error: Unrecognized comparison operator\n");
    assert(FALSE);
  }
  
  u->left  = left;
  u->right = right;
  return node;
}

/***************************************************************************/
/*                  S W I T C H   S T A T E M E N T S                      */
/***************************************************************************/

struct SwitchCheck {
  Node *defaultcase; /* Default node, or NULL if not found yet */
  unsigned tablesize;/* number of entries in table */
  Node *table[1];    /* Case expr nodes checked so far, hashed by value */
};

#define HASH_FACTOR   2


PRIVATE struct SwitchCheck *NewSwitchCheck(List *cases)
{
  int i;
  int count = ListLength(cases);
  int tablesize = count * HASH_FACTOR;
  struct SwitchCheck *check = 
    HeapAllocate(sizeof(struct SwitchCheck) + sizeof(Node *)*(tablesize-1), 
		 1);
  assert(check);
  
  check->defaultcase = NULL;
  check->tablesize = tablesize;
  for (i=0; i<tablesize; ++i)
    check->table[i] = NULL;

  return check;
}

PRIVATE void FreeSwitchCheck(struct SwitchCheck *check)
{
  /* invalidate some fields in check before freeing it */
  check->tablesize = 0;
  HeapFree(check);
}

PRIVATE void SwitchCheckAddCase(struct SwitchCheck *check, Node *expr)
{
  unsigned long val;
  unsigned h;

  assert(check);
  assert(expr);

  val = NodeConstantIntegralValue(expr);

  /* starting at hash value, probe linearly for empty slot or
     matching value (indicating a redundant case).  Since hash table
     HASH_FACTOR times larger than the number of cases, this loop will 
     always eventually find a NULL slot, so it will terminate.  */
  for (h = (unsigned) (val % check->tablesize);  
           check->table[h] != NULL;
               h = (h+1) % check->tablesize)
    if (NodeConstantIntegralValue(check->table[h]) == val) {
      SyntaxErrorCoord(expr->coord, "duplicate case label");
      fprintf(stderr, "\tOriginal case: ");
      PRINT_COORD(stderr, check->table[h]->coord);
      fputc('\n', stderr);
      return;
    }
      
  check->table[h] = expr;
}

PRIVATE void SwitchCheckAddDefault(struct SwitchCheck *check, Node *node)
{
  assert(check);
  assert(node);

  if (check->defaultcase != NULL)
    SyntaxErrorCoord(node->coord, "multiple default cases");
  else check->defaultcase = node;
}



