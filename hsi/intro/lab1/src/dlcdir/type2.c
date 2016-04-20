/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  type2.c,v
 * Revision 1.5  1995/04/21  05:45:03  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.4  1995/03/23  15:31:44  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.3  1995/02/01  07:39:19  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.2  1995/01/06  16:49:18  rcm
 * added copyright message
 *
 * Revision 1.1  1994/12/20  09:20:37  rcm
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
#pragma ident "type2.c,v 1.5 1995/04/21 05:45:03 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"


PRIVATE Node *NodeDataTypeBase(Node *node, Bool TdefIndir);


/***************************************************************************/
/*                       N O D E  D A T A  T Y P E                         */
/***************************************************************************/

/*
  These routines extract type information from nodes that have
  already been type-checked with SemCheckNode().
*/

GLOBAL Node *NodeDataType(Node *node)
{ Node *result;

#if 0
  printf("\nNodeDataType()\n");
  PrintNode(stdout, node, 0);
  printf("\n");
#endif

  assert(node);

  result = NodeDataTypeBase(node, TRUE);

#if 0
  printf("result\n");
  PrintNode(stdout, result, 0);
  printf("\n");
#endif

  if (result == NULL)
    {
      printf("NodeDataType().  Trying to return NULL\n");
      PrintNode(stdout, node, 0);
      printf("\n");
      assert(FALSE);
    }

  return result;
}

GLOBAL Node *NodeDataTypeSuperior(Node *node)
{ Node *result;

#if 0
  printf("NodeDataTypeSuperior()\n");
  PrintNode(stdout, node, 0);
  printf("\n");
#endif

  assert(node);

  result = NodeDataTypeBase(node, FALSE);

  if (result == NULL)
    {
      printf("NodeDataTypeSuperior().  Trying to return NULL\n");
      PrintNode(stdout, node, 0);
      printf("\n");
      assert(FALSE);
    }

  return result;
}

PRIVATE Node *NodeDataTypeBase(Node *node, Bool TdefIndir)
{
  assert(node);

  switch(node->typ) {
  case Proc:
    assert(node->u.proc.decl);
    return NodeDataTypeBase(node->u.proc.decl, TdefIndir);
  case Decl:
    assert(node->u.decl.type);
    return NodeDataTypeBase(node->u.decl.type, TdefIndir);
  case Prim:
    return node;
  case Tdef:
    if (TdefIndir && node->u.tdef.type) 
      return NodeDataTypeBase(node->u.tdef.type, TdefIndir);
    else return node;
  case Ptr:
    return node;
  case Adcl:
    return node;
  case Sdcl:
  case Udcl:
  case Edcl:
    return node;
  case Fdcl:
    return node;
  case Call:
    { Node *atype;

      atype = NodeDataTypeBase(node->u.call.name, TRUE);
      
      if (atype->typ == Ptr) 
	atype = atype->u.ptr.type;  /* Manish 2/1 look at SemCheckCall -- if the type is a ptr,
				       we want to get up to the fdcl */

      assert(atype->typ == Fdcl);
      return NodeDataTypeBase(atype->u.fdcl.returns, TdefIndir);
    }
  case Return:
    return PrimVoid;
  case Cast:
    assert(node->u.cast.type);
    return NodeDataTypeBase(node->u.cast.type, TdefIndir);
  case Comma:
    { Node *last = LastItem(node->u.comma.exprs);

      assert(last);
      return NodeDataTypeBase(last, TdefIndir);
    }
  case Ternary:
    assert(node->u.ternary.type);
    return NodeDataTypeBase(node->u.ternary.type, TdefIndir);
  case Array:
    assert(node->u.array.type);
    return NodeDataTypeBase(node->u.array.type, TdefIndir);
  case Initializer:
    return node;
  case ImplicitCast:
    assert(node->u.implicitcast.type);
    return NodeDataTypeBase(node->u.implicitcast.type, TdefIndir);
  case Label:
    return node;
  case Goto:
    return node;
  case Unary: 
    assert(node->u.unary.type);
    return NodeDataTypeBase(node->u.unary.type, TdefIndir);
  case Binop:
    assert(node->u.binop.type);
    return NodeDataTypeBase(node->u.binop.type, TdefIndir);
  case Const:
    assert(node->u.Const.type);
    return NodeDataTypeBase(node->u.Const.type, TdefIndir);
  case Id:
    if (node->u.id.decl)
      {
	assert(node->u.id.decl);
	assert(node->u.id.decl->u.decl.type);
	return NodeDataTypeBase(node->u.id.decl->u.decl.type, TdefIndir);
      }
    else
      return node;

  case Block:
    assert(node->u.Block.type);
    return NodeDataTypeBase(node->u.Block.type, TdefIndir);

  case If:
  case For:
  case While:
  case Do:
  case Continue:
  case Break:
  case Switch:
  case Case:
  case Default:
    return node;

  default:
    fprintf(stderr, "Internal Error! NodeDataType: Unknown node type\n");
    PrintNode(stdout, node, 0);
    printf("\n");
    return node;
  }
}

GLOBAL void SetNodeDataType(Node *node, Node *type)
{
  if (node == NULL)
    return;

  switch(node->typ) {
  case Decl:
    node->u.decl.type = type;
    return;
  case Id:
    SetNodeDataType(node->u.id.decl, type);
    return;
  default:
      /*assert(("SetNodeDataType: Unknown node type", FALSE));*/
      assert(FALSE);
  }
}




GLOBAL Node *ArrayType(Node *array)
{ Node *atype;

  assert(array->typ == Array);
  assert(array->u.array.name);

  atype = NodeDataType(array->u.array.name);

  if (atype->typ == Adcl) {
    Node *btype = atype, *item;
    ListMarker marker;

    /* Loop down the index operations to find the type */
    IterateList(&marker, array->u.array.dims);
    while (NextOnList(&marker, (GenericREF) &item))
      if (btype->typ == Adcl)
	btype = NodeDataType(btype->u.adcl.type);
      else if (btype->typ == Ptr)
	btype = NodeDataType(btype->u.ptr.type);
      else {
	SyntaxErrorCoord(array->coord,
			 "3 cannot dereference non-pointer type");
	return PrimVoid;
      }

    return btype;
  }

  else if (atype->typ == Ptr) {
    Node *btype = atype, *item;
    ListMarker marker;

    /* Loop down the index operations to find the type */
    IterateList(&marker, array->u.array.dims);
    while (NextOnList(&marker, (GenericREF) &item))
      if (btype->typ == Adcl)
	btype = NodeDataType(btype->u.adcl.type);
      else if (btype->typ == Ptr)
	btype = NodeDataType(btype->u.ptr.type);
      else {
	SyntaxErrorCoord(array->coord,
			 "4 cannot dereference non-pointer type");
	return PrimVoid;
      }

    return btype;
  }

  else {
    fprintf(stderr, "ArrayType: Node at ");
    PRINT_COORD(stderr, array->coord);
    fputc('\n', stderr);
    PrintNode(stderr, array, 0);
    fprintf(stderr, "\n");
    assert(FALSE); return(NULL);
  }
}



GLOBAL Node *SdclFindField(Node *sdcl, Node *field_name)
{
  if (sdcl->typ == Sdcl)
    return SUE_FindField(sdcl->u.sdcl.type, field_name);
  else if (sdcl->typ == Udcl)
    return SUE_FindField(sdcl->u.udcl.type, field_name);
  else if (sdcl->typ == Ptr)
    {
      assert(sdcl->u.ptr.type);
      return SdclFindField(NodeDataType(sdcl->u.ptr.type), field_name);
    }
  else if (sdcl->typ == Binop)
    if (sdcl->u.binop.op == '.' || sdcl->u.binop.op == ARROW)
      return(SdclFindField(sdcl->u.binop.type, field_name));
    else {
      printf("SdclFindField(): not a supported binop\n");
      PrintNode(stdout, sdcl,       0); printf("\n");
      PrintNode(stdout, field_name, 0); printf("\n");
      assert(FALSE);
    }
  else {
    printf("SdclFindField(): not a recognized type\n");
    PrintNode(stdout, sdcl,       0); printf("\n");
    PrintNode(stdout, field_name, 0); printf("\n");
    assert(FALSE); 
  }
  UNREACHABLE;
  return NULL; /* eliminates warning */
}
