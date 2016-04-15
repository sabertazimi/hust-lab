/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  operators.c,v
 * Revision 1.9  1995/04/21  05:44:30  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.8  1995/02/13  02:00:15  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.7  1995/01/06  16:48:53  rcm
 * added copyright message
 *
 * Revision 1.6  1994/12/20  09:24:06  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.5  1994/11/22  01:54:35  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.4  1994/11/10  03:13:19  rcm
 * Fixed line numbers on AST nodes.
 *
 * Revision 1.3  1994/11/03  07:38:45  rcm
 * Added code to output C from the parse tree.
 *
 * Revision 1.2  1994/10/28  18:52:36  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Tue May 25 13:19:41 EDT 1993
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
#pragma ident "operators.c,v 1.9 1995/04/21 05:44:30 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"

GLOBAL OpEntry Operator[MAX_OPERATORS];


/************************************************************************\
* Evaluation functions
*     used for statically evaluating constant expressions
\************************************************************************/




/************************************************************************\
* InitOperatorTable
\************************************************************************/

PRIVATE void SET_OP(int i, const char *text, const char *name, int unary, int binary)
{
  assert(i >= 0 && i < MAX_OPERATORS);
  assert(Operator[i].text == NULL);

  Operator[i].text = text;
  Operator[i].name = name;
  Operator[i].left_assoc  = TRUE;
  Operator[i].unary_prec  = unary;
  Operator[i].binary_prec = binary;
}

PRIVATE void RIGHT_ASSOC(int op)
{ 

  assert(op >= 0 && op < MAX_OPERATORS);
  assert(Operator[op].text != NULL);

  Operator[op].left_assoc = FALSE;
}

GLOBAL void InitOperatorTable()
{
  SET_OP(ARROW,       "->",      "ARROW",       0, 15);
  SET_OP('.',         ".",       "DOT",         0, 15);

  SET_OP('!',         "!",       "not",        14,  0);
  SET_OP('~',         "~",       "bitnot",     14,  0);
  SET_OP(ICR,         "++",      "ICR",        14,  0);
  SET_OP(POSTINC,     "++",      "postinc",    14,  0);
  SET_OP(PREINC,      "++",      "preinc",     14,  0);
  SET_OP(DECR,        "--",      "DECR",       14,  0);
  SET_OP(POSTDEC,     "--",      "postdec",    14,  0);
  SET_OP(PREDEC,      "--",      "predec",     14,  0);

  SET_OP(SIZEOF,      "sizeof",  "sizeof",     14,  0);

  SET_OP(ADDRESS,     "&",       "addrof",     14,  0);
  SET_OP(INDIR,       "*",       "indir",      14,  0);
  SET_OP(UPLUS,       "+",       "UPLUS",      14,  0);
  SET_OP(UMINUS,      "-",       "neg",        14,  0);
    
  SET_OP('*',         "*",       "mul",         0, 13);
  SET_OP('/',         "/",       "div",         0, 13);
  SET_OP('%',         "%",       "mod",         0, 13);

  SET_OP('+',         "+",       "add",         0, 12);
  SET_OP('-',         "-",       "sub",         0, 12);
    
  SET_OP(LS,          "<<",      "lsh",         0, 11);
  SET_OP(RS,          ">>",      "rsh",         0, 11);
    
  SET_OP('<',         "<",       "lt",          0, 10);
  SET_OP('>',         ">",       "gt",          0, 10);
  SET_OP(LE,          "<=",      "le",          0, 10);
  SET_OP(GE,          ">=",      "ge",          0, 10);
    
  SET_OP(EQ,          "==",      "eq",          0,  9);
  SET_OP(NE,          "!=",      "ne",          0,  9);
    
  SET_OP('&',         "&",       "band",        0,  8);
    
  SET_OP('^',         "^",       "bxor",        0,  7);
    
  SET_OP('|',         "|",       "bor",         0,  6);
    
  SET_OP(ANDAND,      "&&",      "and",         0,  5);
  SET_OP(OROR,        "||",      "or",          0,  4);

  /* ternary operator has precedence three, but is handled separately */

  SET_OP('=',         "=",       "asgn" ,       0,  2); RIGHT_ASSOC('=');
  SET_OP(MULTassign,  "*=",      "*=",          0,  2); RIGHT_ASSOC(MULTassign);
  SET_OP(DIVassign,   "/=",      "/=",          0,  2); RIGHT_ASSOC(DIVassign);
  SET_OP(MODassign,   "%=",      "%=",          0,  2); RIGHT_ASSOC(MODassign);
  SET_OP(PLUSassign,  "+=",      "+=",          0,  2); RIGHT_ASSOC(PLUSassign);
  SET_OP(MINUSassign, "-=",      "-=",          0,  2); RIGHT_ASSOC(MINUSassign);
  SET_OP(LSassign,    "<<=",     "<<=",         0,  2); RIGHT_ASSOC(LSassign);
  SET_OP(RSassign,    ">>=",     ">>=",         0,  2); RIGHT_ASSOC(RSassign);
  SET_OP(ANDassign,   "&=",      "&=",          0,  2); RIGHT_ASSOC(ANDassign);
  SET_OP(ERassign,    "^=",      "^=",          0,  2); RIGHT_ASSOC(ERassign);
  SET_OP(ORassign,    "|=",      "|=",          0,  2); RIGHT_ASSOC(ORassign);
    
  /* comma operator has precedence one, but is handled separately */
}

GLOBAL const char *OperatorName(OpType op)
{
  assert(op >= 0 && op < MAX_OPERATORS);
  return Operator[op].name;
}

GLOBAL const char *OperatorText(OpType op)
{
  assert(op >= 0 && op < MAX_OPERATORS);
  return Operator[op].text;
}

GLOBAL int PrintOp(FILE *out, OpType op)
{
    OpEntry *operator = &Operator[op];

    assert(op > 0  &&  op < MAX_OPERATORS);

    if (operator->text == NULL) {
	fprintf(stderr, "unknown operator %d\n", op);
	FAIL("");
    }

    fputs(operator->text, out);
    return strlen(operator->text);
}


GLOBAL int OpPrecedence(NodeType typ, OpType op, Bool *left_assoc)
{
    OpEntry *operator = &Operator[op];

    assert(op > 0  &&  op < MAX_OPERATORS);

    if (operator->text == NULL) {
	fprintf(stderr, "unknown operator %d\n", op);
	FAIL("");
    }

    if (typ == Binop) {
	*left_assoc = operator->left_assoc;
	return(operator->binary_prec);
    } else {
	*left_assoc = FALSE;  /* all unary ops are right associative */
	return(operator->unary_prec);
    }
    /* unreachable */
}

GLOBAL Bool IsAssignmentOp(OpType op)
{
  switch (op) {
  case '=':
  case MULTassign:
  case DIVassign:
  case MODassign:
  case PLUSassign:
  case MINUSassign:
  case LSassign:
  case RSassign:
  case ANDassign:
  case ERassign:
  case ORassign:
    return TRUE;
  default:
    return FALSE;
  }
}


GLOBAL Bool IsComparisonOp(OpType op)
{
  switch (op) {
  case '!':
  case EQ:
  case NE:
  case '<':
  case LE:
  case '>':
  case GE:
    return TRUE;
  default:
    return FALSE;
  }
}

GLOBAL Bool IsArithmeticOp(OpType op)
{
  switch (op) {
  case '+':
  case '-':
  case '*':
  case '/':
  case '%':
  case '|':
  case '&':
  case '^':
  case ANDAND:
  case OROR:
  case LS:
  case RS:
    return TRUE;
  default:
    return FALSE;
  }
}

