/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  constexpr.c,v
 * Revision 1.9  1995/04/21  05:44:12  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.8  1995/02/01  23:00:08  rcm
 * Removed some dead code.
 *
 * Revision 1.7  1995/02/01  21:07:13  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.6  1995/01/27  01:38:55  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.5  1995/01/20  03:38:04  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.4  1995/01/06  16:48:40  rcm
 * added copyright message
 *
 * Revision 1.3  1994/12/23  09:18:23  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.2  1994/12/20  09:23:58  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.1  1994/11/22  01:51:52  rcm
 * Created.
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
#pragma ident "constexpr.c,v 1.9 1995/04/21 05:44:12 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"


PRIVATE BasicType BasicTypeOfConstantValue(Node *type);




/* NodeIsConstant returns true iff node is a constant expression.
   Requires SemCheck(node) to be called first. */
GLOBAL Bool NodeIsConstant(Node *node)
{ 
  assert(node);
  return (NodeGetConstantValue(node) != NULL);
}


GLOBAL Node *NodeGetConstantValue(Node *node)
{
  Node *value;

  switch (node->typ) {
  case Const:
    value = node;
    break;
  case Id:
    value = node->u.id.value;
    break;
  case Binop:
    value = node->u.binop.value;
    break;
  case Unary:
    value = node->u.unary.value;
    break;
  case Cast:
    value = node->u.cast.value;
    break;
  case ImplicitCast:
    value = node->u.implicitcast.value;
    break;
  case Comma:
    value = NULL;
    break;
  case Ternary:
    value = node->u.ternary.value;
    break;
  case Array:
  case Call:
    value = NULL;
    break;
  case Initializer:
    value = NULL;
    break;
  default:  /* non-expression nodes */
    value = NULL;
    break;
  }

  /* if value is present, must be a Const node */
  assert(!value || value->typ == Const);
  return value;

}

GLOBAL void NodeSetConstantValue(Node *node, Node *value)
{
  assert(node);
  assert(value);
  assert(value->typ == Const);

  switch (node->typ) {
  case Const:
    node->u.Const.value = value->u.Const.value;
    break;
  case Id:
    node->u.id.value = value;
    break;
  case Binop:
    node->u.binop.value = value;
    break;
  case Unary:
    node->u.unary.value = value;
    break;
  case Cast:
    node->u.cast.value = value;
    break;
  case ImplicitCast:
    node->u.implicitcast.value = value;
    break;
  case Ternary:
    node->u.ternary.value = value;
    break;
  default:  /* Comma, Array, Call, Initializer, and non-expression nodes */
    UNREACHABLE;  /* should not set constant value on these types of nodes */
  }
}

GLOBAL int NodeConstantCharValue(Node *node)
{ 
  Node *val = NodeGetConstantValue(node);

  assert(val);
  assert(NodeTypeIsChar(val));

  return val->u.Const.value.i;
}

GLOBAL int NodeConstantSintValue(Node *node)
{ 
  Node *val = NodeGetConstantValue(node);

  assert(val);
  assert(NodeTypeIsSint(val));

  return val->u.Const.value.i;
}

GLOBAL unsigned int NodeConstantUintValue(Node *node)
{ 
  Node *val = NodeGetConstantValue(node);

  assert(val);
  assert(NodeTypeIsUint(val));

  return val->u.Const.value.u;
}

GLOBAL long NodeConstantSlongValue(Node *node)
{ 
  Node *val = NodeGetConstantValue(node);

  assert(val);
  assert(NodeTypeIsSlong(val));

  return val->u.Const.value.l;
}

GLOBAL unsigned long NodeConstantUlongValue(Node *node)
{ 
  Node *val = NodeGetConstantValue(node);

  assert(val);
  assert(NodeTypeIsUlong(val));

  return val->u.Const.value.ul;
}

GLOBAL float NodeConstantFloatValue(Node *node)
{ 
  Node *val = NodeGetConstantValue(node);

  assert(val);
  assert(NodeTypeIsFloat(val));

  return val->u.Const.value.f;
}

GLOBAL double NodeConstantDoubleValue(Node *node)
{ 
  Node *val = NodeGetConstantValue(node);

  assert(val);
  assert(NodeTypeIsDouble(val));

  return val->u.Const.value.d;
}

GLOBAL const char *NodeConstantStringValue(Node *node)
{ 
  Node *val = NodeGetConstantValue(node);

  assert(val);
  assert(NodeTypeIsString(val));

  return val->u.Const.value.s;
}

GLOBAL unsigned long NodeConstantIntegralValue(Node *node)
{
  Node *val = NodeGetConstantValue(node);
  Node *type = NodeDataType(val);

  assert(val);
  assert(type);

  if (type->typ == Prim) {
    switch (type->u.prim.basic) {
    case Sint:   return val->u.Const.value.i;
    case Uint:   return val->u.Const.value.u;
    case Slong:  return val->u.Const.value.l;
    case Ulong:  return val->u.Const.value.ul;
#if 0
    case Float:  return val->u.Const.value.f;
    case Double: return val->u.Const.value.d;
#endif
    default:     break;
    }
  }
  /*assert(("Unexpected constant type", FALSE));*/
  UNREACHABLE;
  return 0;  /* eliminates warning */
}

GLOBAL Bool NodeConstantBooleanValue(Node *node)
{
  Node *val = NodeGetConstantValue(node);
  Node *type = NodeDataType(val);

  assert(val);
  assert(type);

  if (type->typ == Prim) {
    switch (type->u.prim.basic) {
    case Sint:   return val->u.Const.value.i;
    case Uint:   return val->u.Const.value.u;
    case Slong:  return val->u.Const.value.l;
    case Ulong:  return val->u.Const.value.ul;
    case Float:  return val->u.Const.value.f;
    case Double: return val->u.Const.value.d;
    default: break;
    }
  }
  else if (type->typ == Adcl)
    return TRUE;  /* constant string, always true */

  /*assert(("Unexpected constant type", FALSE));*/
  assert(FALSE);
  UNREACHABLE;
  return FALSE; /* eliminates warning */
}


GLOBAL void NodeSetSintValue(Node *node, int i)
{
  NodeSetConstantValue(node, MakeConstSint(i));
}

GLOBAL void NodeSetUintValue(Node *node, unsigned u)
{
  NodeSetConstantValue(node, MakeConstUint(u));
}

GLOBAL void NodeSetSlongValue(Node *node, long l)
{
  NodeSetConstantValue(node, MakeConstSlong(l));
}

GLOBAL void NodeSetUlongValue(Node *node, unsigned long ul)
{
  NodeSetConstantValue(node, MakeConstUlong(ul));
}

GLOBAL void NodeSetFloatValue(Node *node, float f)
{
  NodeSetConstantValue(node, MakeConstFloat(f));
}

GLOBAL void NodeSetDoubleValue(Node *node, double d)
{
  NodeSetConstantValue(node, MakeConstDouble(d));
}

GLOBAL void NodeSetStringValue(Node *node, const char *s)
{
  NodeSetConstantValue(node, MakeString(s));
}



/* Return TRUE if this is a constant string */
GLOBAL Bool IsConstantString(Node *node) 
{ 
  return (NodeIsConstant(node) && NodeTypeIsString(node)); 
}

GLOBAL Bool IsIntegralConstant(Node *node)
{ 
  return (NodeIsConstant(node) && NodeTypeIsIntegral(node)); 
}


GLOBAL Bool IsConstantZero(Node *node)
{
  Node *val = NodeGetConstantValue(node);
  Node *type;

  if (val == NULL)
    return FALSE;

  type = NodeDataType(val);
  assert(type);

  if (type->typ == Prim) {
    switch (type->u.prim.basic) {
    case Sint:   return val->u.Const.value.i == 0;
    case Uint:   return val->u.Const.value.u == 0;
    case Slong:  return val->u.Const.value.l == 0;
    case Ulong:  return val->u.Const.value.ul == 0;
    case Float:  return val->u.Const.value.f == 0;
    case Double: return val->u.Const.value.d == 0;
    default:     break;
    }
  }
  else if (type->typ == Adcl)
    return FALSE;  /* constant string, never 0 */

  /*assert(("Unexpected constant type", FALSE));*/
  assert(FALSE);
  UNREACHABLE;
  return FALSE;  /* eliminates warning */
}


GLOBAL Bool IntegralConstEqual(Node *node1, Node *node2)
{
  return (NodeConstantIntegralValue(node1) == NodeConstantIntegralValue(node2));
}



/***************************************************************************/
/*	              C O N S T A N T     F O L D I N G                    */
/***************************************************************************/


GLOBAL void ConstFoldTernary(Node *node)
{
  Node *cond, *true, *false;

  assert(node->typ == Ternary);

  cond = node->u.ternary.cond;
  true = node->u.ternary.true;
  false = node->u.ternary.false;

  if (NodeIsConstant(cond) && NodeIsConstant(true) && NodeIsConstant(false)) {
    Node *value;
    
    value = (NodeConstantBooleanValue(cond)) 
      ? NodeGetConstantValue(true)
	: NodeGetConstantValue(false);
    
    NodeSetConstantValue(node, value);
  }
}


GLOBAL void ConstFoldCast(Node *node)
{
  Node *expr;
  Node *from_type, *to_type;
  BasicType from_basic, to_basic;

  /* this function works on both casts and implicitcasts */
  switch (node->typ) {
  case Cast:
    expr = node->u.cast.expr;
    break;
  case ImplicitCast:
    expr = node->u.implicitcast.expr;
    if (expr == NULL)
      return;
    break;
  default:
    UNREACHABLE;
  }

  if (!NodeIsConstant(expr))
    return;

  to_type = NodeDataType(node);
  from_type = NodeDataType(expr);


  /* can only constant-fold scalar expressions (integral, floating,
     and pointer) */

  if (IsScalarType(to_type) && IsScalarType(from_type)) {
    from_basic = BasicTypeOfConstantValue(from_type);
    to_basic = BasicTypeOfConstantValue(to_type);

    switch (to_basic) {
    case Slonglong:
    case Ulonglong:
    case Longdouble:
      /* fix: cannot represent these types internally, so no constant-folding
	 occurs. */
      return;
    default:
      break;
    }

    switch (from_basic) {
    case Sint:
      { int eval = NodeConstantSintValue(expr);
	switch (to_basic) {
	case Sint:
	  NodeSetSintValue(node, eval);   return;
	case Uint:
	  NodeSetUintValue(node, eval);   return;
	case Slong:
	  NodeSetSlongValue(node, eval);  return;
	case Ulong:
	  NodeSetUlongValue(node, eval);  return;
	case Float:
	  NodeSetFloatValue(node, eval);  return;
	case Double:
	  NodeSetDoubleValue(node, eval); return;
	default:
	  UNREACHABLE;
	}
      }
    case Uint:
      { unsigned eval = NodeConstantUintValue(expr);
	switch (to_basic) {
	case Sint:
	  NodeSetSintValue(node, eval);   return;
	case Uint:
	  NodeSetUintValue(node, eval);   return;
	case Slong:
	  NodeSetSlongValue(node, eval);  return;
	case Ulong:
	  NodeSetUlongValue(node, eval);  return;
	case Float:
	  NodeSetFloatValue(node, eval);  return;
	case Double:
	  NodeSetDoubleValue(node, eval); return;
	default:
	  UNREACHABLE;
	}
      }
    case Slong:
      { long eval = NodeConstantSlongValue(expr);
	switch (to_basic) {
	case Sint:
	  NodeSetSintValue(node, eval);   return;
	case Uint:
	  NodeSetUintValue(node, eval);   return;
	case Slong:
	  NodeSetSlongValue(node, eval);  return;
	case Ulong:
	  NodeSetUlongValue(node, eval);  return;
	case Float:
	  NodeSetFloatValue(node, eval);  return;
	case Double:
	  NodeSetDoubleValue(node, eval); return;
	default:
	  UNREACHABLE;
	}
      }
    case Ulong:
      { unsigned long eval = NodeConstantUlongValue(expr);
	switch (to_basic) {
	case Sint:
	  NodeSetSintValue(node, eval);   return;
	case Uint:
	  NodeSetUintValue(node, eval);   return;
	case Slong:
	  NodeSetSlongValue(node, eval);  return;
	case Ulong:
	  NodeSetUlongValue(node, eval);  return;
	case Float:
	  NodeSetFloatValue(node, eval);  return;
	case Double:
	  NodeSetDoubleValue(node, eval); return;
	default:
	  UNREACHABLE;
	}
      }
    case Float:
      { float eval = NodeConstantFloatValue(expr);
	switch (to_basic) {
	case Sint:
	  NodeSetSintValue(node, eval);   return;
	case Uint:
	  NodeSetUintValue(node, eval);   return;
	case Slong:
	  NodeSetSlongValue(node, eval);  return;
	case Ulong:
	  NodeSetUlongValue(node, eval);  return;
	case Float:
	  NodeSetFloatValue(node, eval);  return;
	case Double:
	  NodeSetDoubleValue(node, eval); return;
	default:
	  UNREACHABLE;
	}
      }
    case Double:
      { double eval = NodeConstantDoubleValue(expr);
	switch (to_basic) {
	case Sint:
	  NodeSetSintValue(node, eval);   return;
	case Uint:
	  NodeSetUintValue(node, eval);   return;
	case Slong:
	  NodeSetSlongValue(node, eval);  return;
	case Ulong:
	  NodeSetUlongValue(node, eval);  return;
	case Float:
	  NodeSetFloatValue(node, eval);  return;
	case Double:
	  NodeSetDoubleValue(node, eval); return;
	default:
	  UNREACHABLE;
	}
      }
    default:
      UNREACHABLE;
    }
  }
}


PRIVATE BasicType BasicTypeOfConstantValue(Node *type)
{
  if (type->typ == Ptr)
    return Uint;

  if (type->typ == Edcl)
    return Sint;

  assert(type->typ == Prim);
  switch (type->u.prim.basic) {
  case Char:
  case Schar:
  case Uchar:
  case Sshort:
  case Ushort:
    return Sint;
  default:
    return type->u.prim.basic;
  }
}
