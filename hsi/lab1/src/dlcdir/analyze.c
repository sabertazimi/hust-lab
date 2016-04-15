/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Rob Miller
 *  
 *  analyze.c,v
 * Revision 1.3  1995/05/11  18:54:02  rcm
 * Added gcc extension __attribute__.
 *
 * Revision 1.2  1995/04/21  06:21:49  rcm
 * Released c2c-0-7-2.
 *
 * Revision 1.1  1995/04/21  05:43:59  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.2  1995/04/09  21:30:43  rcm
 * Added Analysis phase to perform all analysis at one place in pipeline.
 * Also added checking for functions without return values and unreachable
 * code.  Added tests of live-variable analysis.
 *
 * Revision 1.1  1995/03/23  15:31:08  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
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
#pragma ident "analyze.c,v 1.3 1995/05/11 18:54:02 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"


#define Gen(n)  ((n)->analysis.gen)
#define Kill(n) ((n)->analysis.kill)
#define LiveVars(n)  ((n)->analysis.livevars)



/*************************************************************************/
/*                                                                       */
/*                        Bit vector frameworks                          */
/*                                                                       */
/*************************************************************************/

PRIVATE FlowValue EmptySet = {FALSE, {(BitVector)0}};
/*PRIVATE*/ FlowValue TotalSet = {FALSE, {~(BitVector)0}};

#define Bit(bitnum)    (((BitVector)1)<<(bitnum))
#define SetBit(v, bitnum)    ((v).u.bitvector |= Bit(bitnum))
#define ClearBit(v, bitnum)  ((v).u.bitvector &= ~Bit(bitnum))
#define IsBitSet(v, bitnum)  (((v).u.bitvector & Bit(bitnum)) != 0)


/*
 * SetIntersection: meet operation for subset lattice
 */
/*PRIVATE*/ inline FlowValue SetIntersection(FlowValue v1, FlowValue v2)
{
  if (v1.undefined)
    return v2;
  else if (v2.undefined)
    return v1;
  else {
    FlowValue v;
    
    v.undefined = FALSE;
    v.u.bitvector = v1.u.bitvector & v2.u.bitvector;
    return v;
  }
}

/*
 * SetUnion: meet operation for superset lattice
 */
PRIVATE inline FlowValue SetUnion(FlowValue v1, FlowValue v2)
{
  if (v1.undefined)
    return v2;
  else if (v2.undefined)
    return v1;
  else {
    FlowValue v;
    
    v.undefined = FALSE;
    v.u.bitvector = v1.u.bitvector | v2.u.bitvector;
    return v;
  }
}


/*
 * SetEqual: equality operation for bitvector frameworks
 */
PRIVATE inline Bool SetEqual(FlowValue v1, FlowValue v2)
{
  if (v1.undefined)
    return v2.undefined;
  else 
    return !v2.undefined && v1.u.bitvector == v2.u.bitvector;
}

/*
 * GenKill: used in transfer function of a bitvector framework
 */
PRIVATE inline FlowValue GenKill(Node *node, FlowValue v)
{
  if (!v.undefined)
    v.u.bitvector = 
      (v.u.bitvector & ~Kill(node).u.bitvector) | Gen(node).u.bitvector;
  return v;
}

/*
 * ListFind: returns bitvector with bit i set to 1 iff ith member of
 * list is node.  Useful for setting up Gen and Kill sets.
 */
PRIVATE FlowValue ListFind(List *list, Node *node)
{
  int di = 0;
  FlowValue v;

  v.undefined = FALSE;
  v.u.bitvector = 0;
  while (list) {
    if (node == FirstItem(list))
      SetBit(v, di);
    ++di;
    list = Rest(list);
  }
  return v;
}

/*
 * ListSelect: returns sublist of list, containing the ith member of
 * list iff ith bit of v is 1.  Used by a transfer function to convert
 * a bitvector flow value to persistent form during final pass.
 */
PRIVATE List *ListSelect(List *list, FlowValue v)
{
  List *new = NULL;
  
  while (v.u.bitvector != 0 && list != NULL) {
    if (v.u.bitvector & 1)
      new = ConsItem(FirstItem(list), new);
    list = Rest(list);
    v.u.bitvector >>= 1;
  }
  return new;
}


/*
 *  ApplyInChunks: splits up a list into bitvector-length sublists and applies
 *                 proc to each
 */
PRIVATE void ApplyInChunks(void (*proc) (Node *, List *), Node *root, List *list)
{
  ListMarker m;
  List *chunk;

  IterateList(&m, list);

  while ((chunk = NextChunkOnList(&m, MAX_BITVECTOR_LENGTH)) != NULL)
    proc(root, chunk);
}

/*************************************************************************/
/*                                                                       */
/*                        Live-variable analysis                         */
/*                                                                       */
/*************************************************************************/

/*
 * VariableSet: set of variables currently being analyzed 
 */
PRIVATE List *VariableSet;


/* 
 * Live variable analysis is a typical c2c analysis framework, with three
 * parts:
 * 
 *   Control: splits up variable set into manageable (32-element) 
 *             partitions for analysis
 *   Initialization: sets up tree for analysis
 *   Transfer function: transforms live-variable set as it flows through
 *                      a node, and stores results on tree in final pass
 */


/* 
 * Initialization
 */

PRIVATE void InitLVLists(Node *node)
{
  LiveVars(node) = NULL;
}

PRIVATE void InitLVGenKill(Node *node)
{
  switch (node->typ) {
  case Id:
    Gen(node) = ListFind(VariableSet, node->u.id.decl);
    Kill(node) = EmptySet;
    break;
    
  case Decl:
    Gen(node) = EmptySet;
    Kill(node) = ListFind(VariableSet, node);
    break;
    
  case Binop:
    if (node->u.binop.op == '=' && node->u.binop.left->typ == Id) {
      Node *left = node->u.binop.left;
      
      Gen(node) = EmptySet;
      Kill(node) = ListFind(VariableSet, left->u.id.decl);
      
      /* reset variable's gen-kill sets, since it's an lvalue and
	 shouldn't generate a use.  (Note that this function is
	 being executed postorder, so left has already been visited.) */
      Gen(left) = EmptySet;
      Kill(left) = EmptySet;
    }
    break;
    
  default:
    Gen(node) = EmptySet;
    Kill(node) = EmptySet;
    break;
  }
}



/*
 * Transfer function
 */

PRIVATE FlowValue TransLV(Node *node, FlowValue v, Point p, Bool final)
{
  switch (p) {
  case EntryPoint:
#if 0
    /* if you care about live variables on entry to an expression,
       instead of exit, then uncomment this code and comment out
       the duplicate code in the ExitPoint case */
    
    if (final) {
      List *livevars = ListSelect(VariableSet, v);
      LiveVars(node) = JoinLists(livevars, LiveVars(node));
    }
#endif

    return v;

  case ExitPoint:
    if (final) {
      List *livevars = ListSelect(VariableSet, v);
      LiveVars(node) = JoinLists(livevars, LiveVars(node));
    }

    /* do gen/kill only at ExitPoint of each expression, where Kills
       (assignments) presumably occur */
    return GenKill(node, v);

  default:
    return v;
  }
}



/*
 * Control
 */

/* 
 * AnalyzeLV: performs analysis for small (<=32) set of variables 
 */
PRIVATE void AnalyzeLV(Node *root, List *vars)
{
  VariableSet = vars;

  WalkTree(root, (WalkProc)InitLVGenKill, NULL, Postorder);

  IterateDataFlow(
		  root,      /* root node */
		  EmptySet,  /* initial value: no variables live */
		  Backwards, /* direction */
		  SetUnion,  /* meet operation */
		  SetEqual,  /* equality operation */
		  TransLV    /* transfer function */
		  );
}


/* 
 * AnalyzeLiveVariables: handles any size set of variables by splitting up
 *                        into small partitions
 */
GLOBAL void AnalyzeLiveVariables(Node *root, List *vars)
{
  /* initialize live variables list on every node to NULL */
  WalkTree(root, (WalkProc)InitLVLists, NULL, Preorder);

  /* compute flow for 32 variables at a time (to fit easily in bitvector) */
  ApplyInChunks(AnalyzeLV, root, vars);
}





/*************************************************************************/
/*                                                                       */
/*            Checking for function without return                       */
/*                                                                       */
/*************************************************************************/

#define FALLS_OFF        0
#define VALUE_RETURNED   1
#define NOTHING_RETURNED 2

/* 
 * Initialization
 */

PRIVATE void InitRF(Node *node)
{
  Gen(node) = EmptySet;
  Kill(node) = EmptySet;

  switch (node->typ) {
  case Proc:
    SetBit(Gen(node), FALLS_OFF);
    break;

  case Return:
    SetBit(Kill(node), FALLS_OFF);
    SetBit(Gen(node), 
	   node->u.Return.expr ? VALUE_RETURNED : NOTHING_RETURNED);
    break;

  default:
    break;
  }
}


/*
 * Transfer function
 */

PRIVATE FlowValue TransRF(Node *node, FlowValue v, Point p, Bool final)
{
  switch (p) {

  case EntryPoint:
    if (v.undefined && (IsExpr(node) && node->typ != Block)) {
      if (final)
	WarningCoord(5, node->coord, "unreachable code");
      
      return EmptySet; /* prevents cascade of warnings from children
			  and successors which are also unreachable */
    }
    else return GenKill(node, v);

  case ExitPoint:
    if (final && node->typ == Proc) {
      Bool novalue = IsBitSet(v, FALLS_OFF) || IsBitSet(v, NOTHING_RETURNED);
      Bool value = IsBitSet(v, VALUE_RETURNED);

      if (!novalue == !value)
	WarningCoord(3, node->coord, 
		     "function returns both with and without a value");
      else {
	Node *type = FunctionReturnType(node);

	if (!IsVoidType(type) && !TypeIsSint(type) &&
	    IsBitSet(v, FALLS_OFF))
	  WarningCoord(3, node->coord, 
		       "control falls off end of non-void function");
      }
    }

    return v;

  default: 
    return v;
  }
}


GLOBAL void AnalyzeReturnFlow(Node *proc)
{
  WalkTree(proc, InitRF, NULL, Preorder);
  IterateDataFlow(proc,
		  EmptySet,
		  Forwards,
		  SetUnion, 
		  SetEqual, 
		  TransRF);
}





/*************************************************************************/
/*                                                                       */
/*                        Printing analysis results                      */
/*                                                                       */
/*************************************************************************/

GLOBAL void PV(List *vars)
{
  PrintVariables(stdout, vars);
  putchar('\n');
  fflush(stdout);
}

GLOBAL int PrintVariables(FILE *out, List *vars)
{
  ListMarker m;  Node *var;
  int len = 0;

  IterateList(&m, vars);
  while (NextOnList(&m, (GenericREF) &var))
    len += fprintf(out, "%s ", var->u.decl.name);
  return len;
}
 
GLOBAL int PrintAnalysis(FILE *out, Node *node)
{
  int len = 0;

  len += fprintf(out, "Live: ");
  len += PrintVariables(out, LiveVars(node));
  return len;
}




/*************************************************************************/
/*                                                                       */
/*               Finding unaliased local variables                       */
/*                                                                       */
/*************************************************************************/

PRIVATE List *RemoveAliased(Node *node, List *vars);

/* 
 * Returns list of Decls which are potential candidates for registers.
 * Includes local, scalar variable decls appearing below node.
 * Omits arrays, structures, statics, externs, and variables whose
 * address has been taken.
 */
GLOBAL List *RegisterVariables(Node *node, List *vars)
{
  switch (node->typ) {
  case Decl:
    {
      TypeQual dl = NodeDeclLocation(node);
      TypeQual sc = NodeStorageClass(node);

      if ((dl == T_BLOCK_DECL || dl == T_FORMAL_DECL) &&
	  (sc != T_TYPEDEF && sc != T_EXTERN && sc != T_STATIC) &&
	  IsScalarType(NodeDataType(node)))
	vars = ConsItem(node, vars);
      break;
    }

  case Unary:
    if (node->u.unary.op == ADDRESS)
      /* remove any decls referenced by & */
      vars = RemoveAliased(node->u.unary.expr, vars);
    break;

  default:
    break;
  }

#define CODE(n)   vars = RegisterVariables(n, vars)
  ASTWALK(node, CODE)
#undef CODE
    
  return vars;
}

PRIVATE List *RemoveAliased(Node *node, List *vars)
{
  switch (node->typ) {
  case Id:
    assert(node->u.id.decl);
    assert(node->u.id.decl->typ == Decl);
    vars = RemoveItem(vars, node->u.id.decl);
    break;

  case Binop:
    if (node->u.binop.op == '.')
      vars = RemoveAliased(node->u.binop.left, vars);
    break;

  default:
    break;
  }

  return vars;
}


/*************************************************************************/
/*                                                                       */
/*                        Running analysis                               */
/*                                                                       */
/*************************************************************************/

GLOBAL void AnalyzeProgram(List *program)
{
  ListMarker m;  Node *n;

  IterateList(&m, program);
  while (NextOnList(&m, (GenericREF) &n))
    if (n && n->typ == Proc) {
      List *locals = RegisterVariables(n, NULL);

      AnalyzeLiveVariables(n, locals);
      AnalyzeReturnFlow(n);
    }
}
