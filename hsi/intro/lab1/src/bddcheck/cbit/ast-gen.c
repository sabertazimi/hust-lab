#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "gen-hash.h"
#include "boolnet.h"
#include "ast.h"

/* This should have been defined in stdlib.h */
float strtof(const char *nptr, char **endptr);

/********************************** AST Information *************************************************/

static char *node_type_names[] = 
  {
  "E_BINOP",
  "E_UNOP", 
  "E_ASSIGN",
  "E_PASSIGN",
  "E_QUESCOLON",
  "E_VAR",
  "E_AREF",
  "E_AVAR",
  "E_LVAR",
  "E_LAVAR",
  "E_PTR",
  "E_DEREF",
  "E_ADIM",
  "E_CONST",
  "E_CAND",
  "E_CAST",
  "E_SEQUENCE",
  "E_FUNCALL",
  "S_NOP",
  "S_SEQUENCE",
  "S_IFTHEN",
  "S_WHILE",
  "S_RETURN",
  "S_BREAK",
  "S_CONTINUE",
  "S_SWITCH",
  "S_CASE",
  "S_CATCHB",
  "S_CATCHC",
  "S_DECL",
  "S_UNDECL"
};

char *node_type_name(node_t n)
{
  if (n < 0 || n >= N_CNT)
    return ("Unknown");
  return node_type_names[n];
}

/********************************** Generation of AST ***********************************************/

void yyerror(const char *str);
void yyserror(const char *str, char *other);

static node_ptr *var_stack = NULL;
static int stack_cnt = 0;
static int stack_acount = 0;

int LLSIZE = WSIZE;      /* Size of long long (bits) */
int LSIZE = 4*CSIZE;     /* Size of long (bits) */
int ISIZE = 4*CSIZE;     /* Size of int (bits) */
int FSIZE = 32;          /* Size of float (bits) */
int PSIZE = 4*CSIZE;     /* Size of pointer (bits) */
int SSIZE = 2*CSIZE;     /* Size of short (bits) */


void init_ast_gen()
{
    stack_acount = 64;
    var_stack = calloc(stack_acount, sizeof(node_ptr));
    stack_cnt = 0;
}

static void push_var(node_ptr vnode)
{
    if (stack_cnt >= stack_acount)
	stack_acount *= 2;
    var_stack = realloc(var_stack, stack_acount * sizeof(node_ptr));
    var_stack[stack_cnt] = vnode;
    stack_cnt++;
}

node_ptr new_node(node_t ntype, iop_t op, int degree)
{
  node_ptr result = malloc(sizeof(node_ele));
  result->ntype = ntype;
  result->op = op;
  result->dtype = DATA_SIGNED;
  result->wsize = WSIZE;
  result->degree = degree;
  result->val = int_const(0L);
  result->name = NULL;
  result->isdefined = one();
  result->children[0] = result->children[0] = result->children[0] = NULL;
  return result;
}

node_ptr new_node0(node_t ntype, iop_t op)
{
  return new_node(ntype, op, 0);
}

node_ptr new_node1(node_t ntype, iop_t op, node_ptr c0)
{
  node_ptr result = new_node(ntype, op, 1);
  result->children[0] = c0;
  return result;
}

node_ptr new_node2(node_t ntype, iop_t op, node_ptr c0, node_ptr c1)
{
  node_ptr result = new_node(ntype, op, 2);
  result->children[0] = c0;
  result->children[1] = c1;
  return result;
}

node_ptr new_node3(node_t ntype, iop_t op, node_ptr c0, node_ptr c1, node_ptr c2)
{
  node_ptr result = new_node(ntype, op, 3);
  result->children[0] = c0;
  result->children[1] = c1;
  result->children[2] = c2;
  return result;
}

node_ptr sequence_node(node_ptr s0, node_ptr s1)
{
  if (s0->ntype == S_NOP)
    return s1;
  if (s1 && s1->ntype == S_NOP)
    return s0;
  return new_node2(S_SEQUENCE, IOP_NONE, s0, s1);
}

node_ptr cast_node(int wsize, data_t dtype, node_ptr enode)
{
  node_ptr result = new_node1(E_CAST, IOP_NONE, enode);
  result->wsize = wsize;
  result->dtype = dtype;
  return result;
}

/* Create a new variable */
static node_ptr new_ast_var(char *name)
{
  node_ptr result = new_node0(E_VAR, IOP_NONE);
  char *sname = strsave(name);
  result->val = int_const(0L);
  result->name = sname;
  return result;
}

node_ptr declare_var(node_ptr tnode, node_ptr vnode, int islocal)
{
    if (vnode->ntype == E_AVAR || vnode->ntype == E_LVAR) {
	/* Declaring a new variable that will alias an existing one */
	vnode = new_ast_var(vnode->name);
    }
    if (vnode->ntype != E_VAR) {
	fprintf(ERRFILE,
		"Error (declare_var).  Expected node of type %s, got one of %s\n",
		node_type_name(E_VAR), node_type_name(vnode->ntype));
	exit(1);
    }
  vnode->wsize = tnode->wsize;
  vnode->dtype = tnode->dtype;
  vnode->ntype = islocal ? E_LVAR : E_AVAR;
  vnode->isdefined = zero();
  push_var(vnode);
  return new_node1(S_DECL, IOP_NONE, vnode);
}

/* Apply type to set of declared variables.  Work by recursing through sequencing constructs. */
void apply_type(node_ptr tnode, node_ptr dnode)
{
    if (dnode->ntype == S_DECL) {
	node_ptr vnode = dnode->children[0];
	vnode->wsize = tnode->wsize;
	vnode->dtype = tnode->dtype;
	return;
    }
    if (dnode->ntype == S_SEQUENCE) {
      apply_type(tnode, dnode->children[0]);
      apply_type(tnode, dnode->children[1]);
    }
}

/* Add new dimension to array */
void add_array_dim(node_ptr sofar, node_ptr dimval)
{
  node_ptr dim = new_node2(E_ADIM, IOP_NONE, dimval, NULL);
  if (sofar->ntype == E_LAVAR) {
    /* Already know that this is an array.  Want to add new dimension to rightmost end */
    node_ptr last = sofar->children[0];
    while (last->children[1]) {
      last = last->children[1];
    }
    last->children[1] = dim;
  } else if (sofar->ntype == E_LVAR) {
    /* Convert to array */
    sofar->ntype = E_LAVAR;
    sofar->degree = 1;
    sofar->children[0] = dim;
  } else {
      fprintf(ERRFILE,
		"Error (add_array_dim).  Expected node of type %s or %s, got one of %s\n",
		node_type_name(E_LVAR), node_type_name(E_LAVAR), node_type_name(sofar->ntype));
	exit(1);
  }
}

/* Add new index on right of array reference */
node_ptr add_array_ref(node_ptr sofar, node_ptr indexval)
{
  node_ptr index = new_node2(E_ADIM, IOP_NONE, indexval, NULL);
  if (sofar->ntype == E_AREF) {
    /* Already constructed array reference.  Want to add new index to rightmost end */
    node_ptr last = sofar;
    while (last->children[1])
      last = last->children[1];
    last->children[1] = index;
    return sofar;
  } else if (sofar->ntype == E_LAVAR) {
    /* First element of array reference */
    node_ptr ref = new_node2(E_AREF, IOP_NONE, sofar, index);
    return ref;
  } else {
      fprintf(ERRFILE,
		"Error (add_array_ref).  Expected node of type %s or %s, got one of %s\n",
		node_type_name(E_LVAR), node_type_name(E_LAVAR), node_type_name(sofar->ntype));
	exit(1);
  }
}

/* Look for self-reference in assignment to newly declared variable */
void self_check(node_ptr dnode, node_ptr enode)
{
  int i;
  node_ptr vnode = dnode;
  if (!enode)
    return;
  /* First find variable node (in case of array) */
  while (vnode && vnode->ntype != E_LVAR && vnode->ntype != E_LAVAR)
    vnode = vnode->children[0];
  if (!vnode) {
    fprintf(ERRFILE, "Error (self_check).  No declared variable found\n");
    exit(1);
  }
  if ((enode->ntype == E_LVAR || enode->ntype == E_AVAR || enode->ntype == E_LAVAR) &&
      !strcmp(enode->name, vnode->name))
    yyserror("Invalid reference to newly-declared variable '%s'", vnode->name);
  for (i = 0; i < enode->degree; i++)
    self_check(vnode, enode->children[i]);
}

#if 0
/* Look for default case in switch body */
node_ptr extract_default(node_ptr bnode)
{
    int i;
    if (!bnode)
	return NULL;
    if (bnode->ntype == S_SEQUENCE) {
	node_ptr cnode = bnode->children[0];
	if (cnode->ntype == S_CASE && cnode->degree == 0)
	    /* Found the default.  Return other child */
	    return bnode->children[1];
    }
    if (bnode->ntype == S_SWITCH)
	/* Can't use the default case from embedded switch */
	return NULL;
    for (i = 0; i < bnode->degree; i++) {
	node_ptr result = extract_default(bnode->children[i]);
	if (result)
	    return result;
    }
    /* No default found */
    return NULL;
}
#endif
 
/* Flush declarations contained within block of code.  Append as S_UNDECL's to block */
node_ptr flush_decls(node_ptr snode)
{
    node_ptr vnode;
    /* First, must find first declaration within snode.  Get this by following left branches
       of S_SEQUENCE nodes until hit declaration */
    node_ptr dnode = snode;
    node_ptr unode = new_node0(S_NOP, IOP_NONE);
    int new_cnt;
    while (dnode->ntype == S_SEQUENCE)
	dnode = dnode->children[0];
    if (dnode->ntype != S_DECL)
	/* There are no active declarations in this block. */
	return snode;
    vnode = dnode->children[0];
    if (vnode->ntype != E_LVAR && vnode->ntype != E_AVAR && vnode->ntype != E_LAVAR) {
      fprintf(ERRFILE, "Error (flush_decls).  Expected variable, got node of type %s\n", node_type_name(vnode->ntype));
      exit(1);
    }

    /* Now see if vnode is on the stack (it might have already been deallocated */
    for (new_cnt = stack_cnt-1; new_cnt >= 0 && vnode != var_stack[new_cnt]; new_cnt--)
      ;
    if (new_cnt >= 0) {
      while (stack_cnt > new_cnt) {
	stack_cnt--;
	unode = sequence_node(new_node1(S_UNDECL, IOP_NONE, var_stack[stack_cnt]), unode);
      }
      return sequence_node(snode, unode);
    } else
      return snode;
}

/* Find or create variable */
node_ptr get_ast_var(char *name)
{
  /* See if it's already there */
  int pos;
  for (pos = stack_cnt-1; pos >= 0; pos--)
      if (!strcmp(name, var_stack[pos]->name))
	  return var_stack[pos];
  return new_ast_var(name);
}

void check_ast_var(node_ptr vnode)
{
    if (vnode->ntype == E_VAR)
	yyserror("Invalid variable '%s'", vnode->name);
    if (vnode->ntype == E_AREF) {
      check_ast_var(vnode->children[0]);
      return;
    }
    if (vnode->ntype != E_LVAR && vnode->ntype != E_AVAR && vnode->ntype != E_LAVAR) {
      fprintf(ERRFILE, "Error (check_ast_var).  Expected variable.  Got node of type %s\n", node_type_name(vnode->ntype));
      exit(1);
    }
}

/* Make constant node from sizeof declaration.  Type node as parameter */
node_ptr sizeof_node(node_ptr tnode)
{
  node_ptr result = new_node0(E_CONST, IOP_NONE);
  result->dtype = DATA_UNSIGNED;
  result->wsize = LSIZE;
  result->val = int_const(tnode->wsize/CSIZE);
  return result;
}

/* Encode rules for determining promotion sequence for integer constants */
typedef struct {
  int maxpos;   /* What is the maximum position of a 1 bit */
  data_t dtype; /* What is the resulting data type */
  int wsize;    /* What is the resulting word size */
} promo_rec, *promo_ptr, **promo_set;


node_ptr make_ast_num(char *sval)
{
  node_ptr result = new_node0(E_CONST, IOP_NONE);
  data_t dtype = DATA_SIGNED;
  int long_cnt = 0;
  int pos = strlen(sval)-1;
  int wsize = ISIZE;
  int i;
  int isdecimal = 1;
  char *endptr;
  ullong val = 0;
  float fval = 0.0;

/* Promotion rules for decimal integer constants */
promo_rec dec_int_promo[] =
  { { ISIZE-2, DATA_SIGNED, ISIZE },     /* int */
    { LSIZE-2, DATA_SIGNED, LSIZE },     /* long int */
    { LSIZE-1, DATA_UNSIGNED, LSIZE },   /* long unsigned */
    { LLSIZE-2, DATA_SIGNED, LLSIZE },   /* long long int */
    { LLSIZE-1, DATA_UNSIGNED, LLSIZE }, /* long long unsigned */
    { 0, 0, 0 }}; /* Too big */

promo_ptr dec_long_promo = &dec_int_promo[1];
promo_ptr dec_llong_promo = &dec_int_promo[3];

/* Promotion rules for hex/octal integer constants */
promo_rec hex_int_promo[] =
  { { ISIZE-2, DATA_SIGNED, ISIZE },     /* int */
    { ISIZE-1, DATA_UNSIGNED, ISIZE },   /* unsigned */
    { LSIZE-2, DATA_SIGNED, LSIZE },     /* long int */
    { LSIZE-1, DATA_UNSIGNED, LSIZE },   /* long unsigned */
    { LLSIZE-2, DATA_SIGNED, LLSIZE },   /* long long int */
    { LLSIZE-1, DATA_UNSIGNED, LLSIZE }, /* long long unsigned */
    { 0, 0, 0 }}; /* Too big */

promo_ptr hex_long_promo = &hex_int_promo[2];
promo_ptr hex_llong_promo = &hex_int_promo[4];

/* Promotion rules for unsigned integer constants */
promo_rec unsigned_int_promo[] =
  { { ISIZE-1, DATA_UNSIGNED, ISIZE }, /* unsigned */
    { LSIZE-1, DATA_UNSIGNED, LSIZE }, /* long unsigned */
    { LLSIZE-1, DATA_UNSIGNED, LLSIZE }, /* long long unsigned */
    { 0, 0, 0 }}; /* Too big */


promo_ptr unsigned_long_promo = &dec_int_promo[1];
promo_ptr unsigned_llong_promo = &dec_int_promo[2];

promo_ptr all_dec_promo[3] = { dec_int_promo, dec_long_promo, dec_llong_promo };
promo_ptr all_hex_promo[3] = { hex_int_promo, hex_long_promo, hex_llong_promo };
promo_ptr all_unsigned_promo[3] = { unsigned_int_promo, unsigned_long_promo, unsigned_llong_promo };

  /* See if suffixed with u, U, l, or L */
  int c = sval[pos];
  while (!isxdigit(c)) {
    switch (c) {
    case 'u':
    case 'U':
      dtype = DATA_UNSIGNED;
      break;
    case 'l':
    case 'L':
      long_cnt++;
      break;
    default:
      yyserror("Invalid number: '%s'", sval);
      break;
    }
    sval[pos] = 0;
    c = sval[--pos];
  }
  if (sval[0] == '0')
    isdecimal = 0;
  /* See if contains ., e, or E, but is not in hex */
  for (i = 0; sval[i]; i++) {
    char c = sval[i];
    if (c == 'x' || c == 'X') {
      break; /* hex */
    }
    if (c == '.' || c == 'e' || c == 'E') {
      dtype = DATA_FLOAT;
      isdecimal = 0;
      break;
    }
  }
  if (dtype == DATA_FLOAT) {
    fval = strtof(sval, &endptr);
    wsize = FSIZE;
  } else {
#if HAVE_LONGLONG
    val = strtoull(sval, &endptr, 0);
#else
    val = strtoul(sval, &endptr, 0);
#endif
  }
  if (*endptr)
    yyserror("Invalid number '%s'", sval);

  if (dtype != DATA_FLOAT) {
    ullong bits;
    /* Find the most significant 1 position */
    int msone = -1;
    for (bits = val; bits; bits >>= 1)
      msone++;
    if (long_cnt > 2)
      yyserror("Invalid number: '%s'", sval);
    else {
      /* Apply rules for sizing/typing integer constants */
      promo_ptr rules =
	dtype == DATA_UNSIGNED ? all_unsigned_promo[long_cnt] :
	isdecimal ? all_dec_promo[long_cnt] : all_hex_promo[long_cnt];
      int ok = 0;
      for (i = 0; !ok && rules[i].maxpos != 0; i++) {
	if (msone <= rules[i].maxpos) {
	  /* Debugging */
#ifdef DEBUG
	  data_t old_dtype = dtype;
	  int old_wsize = wsize;
#endif
	  /* Change to this data type */
	  dtype = rules[i].dtype;
	  wsize = rules[i].wsize;
#ifdef DEBUG
	  if (old_dtype != dtype || old_wsize != wsize) {
	    printf("Changing '%s' to data type %s, word size %d (msb at %d)\n",
		   sval, dtype == DATA_UNSIGNED ? "unsigned" : "int", wsize, msone);
	  }
#endif
	  ok = 1;
	}
      }
      if (!ok) {
	yyserror("Number too large for data type: '%s'", sval);
      }
    }
  }
  result->wsize = wsize;
  result->val = dtype == DATA_FLOAT ? float_const(fval) :
    mask_size(dtype == DATA_UNSIGNED ? uint_const(val) : int_const(val), wsize, dtype);
  result->dtype = dtype;
  return result;
}

/******************************************** Output Display *****************************************/

/* 100 spaces */
static char *fill_buf = 
"                                                                                                    ";
static int fill_pos = 0;
static int max_pos = 99;
static char *fill_string = "";

void reset_pos() {
  fill_pos = max_pos;
  fill_string = fill_buf+fill_pos;
}

void indent_pos() {
  if (fill_pos > 0)
    fill_pos-=2;
  fill_string = fill_buf+fill_pos;
}

void unindent_pos() {
  if (fill_pos < max_pos)
    fill_pos+=2;
  fill_string = fill_buf+fill_pos;
}

static char *show_op(iop_t op)
{
  switch(op) {
  case  IOP_ADD:
    return "+";
  case  IOP_SUB:
    return "-";
  case IOP_NEG:
    return "-";
  case IOP_AND:
    return "&";
  case IOP_XOR:
    return "^";
  case IOP_NOT:
    return "~";
  case IOP_ISZERO:
    return "!";
  case IOP_LSHIFT:
    return "<<";
  case IOP_RSHIFT:
    return ">>";
  case IOP_MUL:
    return "*";
  case IOP_DIV:
    return "/";
  case IOP_REM:
    return "%";
  case IOP_NONE:
    return "XX";
  case IOP_EQUAL:
    return "==";
  case IOP_LESS:
    return "<";
  case IOP_LESSEQUAL:
    return "<=";
  default:
    return "??";
  }
}

static void show_type(FILE *fp, node_ptr node)
{
  int wsize = node->wsize;
  data_t dtype = node->dtype;
  char c;
  switch(dtype) {
  case DATA_SIGNED:
    c = 'i';
    break;
  case DATA_UNSIGNED:
    c = 'u';
    break;
  case DATA_FLOAT:
    c = 'f';
    break;
  default:
    c = '?';
    break;
  }
  fprintf(fp, "%c%d", c, wsize);
}

void show_node(FILE *fp, node_ptr node, int toplevel)
{
  if (toplevel) {
    reset_pos();
  }
  if (!node) {
    fprintf(fp, "[NIL]");
    return;
  }
  switch(node->ntype) {
  case E_BINOP:
    fprintf(fp, "(");
    show_node(fp, node->children[0], 0);
    fprintf(fp, " %s ", show_op(node->op));
    show_node(fp, node->children[1], 0);
    fprintf(fp, ")");
    break;
  case E_UNOP:
    fprintf(fp, "(");
    fprintf(fp, "%s", show_op(node->op));
    show_node(fp, node->children[0], 0);
    fprintf(fp, ")");
    break;
  case E_ASSIGN:
    fprintf(fp, "(");
    show_node(fp, node->children[0], 0);
    fprintf(fp, " <-- ");
    show_node(fp, node->children[1], 0);
    fprintf(fp, ")");
    break;
  case E_PASSIGN:
    fprintf(fp, "(");
    show_node(fp, node->children[1], 0);
    fprintf(fp, " --> ");
    show_node(fp, node->children[0], 0);
    fprintf(fp, ")");
    break;
  case E_QUESCOLON:
    fprintf(fp, "(");
    show_node(fp, node->children[0], 0);
    fprintf(fp, " ? ");
    show_node(fp, node->children[1], 0);
    fprintf(fp, " : ");
    show_node(fp, node->children[2], 0);
    fprintf(fp, ")");
    break;
  case E_VAR:
    fprintf(fp, "%s", node->name);
    break;
  case E_AVAR:
    fprintf(fp, "%s.arg.", node->name);
    show_type(fp, node);
    break;
  case E_LVAR:
    fprintf(fp, "%s.local.", node->name);
    show_type(fp, node);
    break;
  case E_CONST:
    show_const(fp, node->val, node->wsize, node->dtype);
    break;
  case E_CAND:
    fprintf(fp, "(");
    show_node(fp, node->children[0], 0);
    fprintf(fp, " && ");
    show_node(fp, node->children[1], 0);
    fprintf(fp, ")");
    break;
  case E_CAST:
    fprintf(fp, "(");
    show_type(fp, node);
    fprintf(fp, ")");
    show_node(fp, node->children[0], 0);
    break;
  case E_SEQUENCE:
    fprintf(fp, "(");
    show_node(fp, node->children[0], 0);
    fprintf(fp, ", ");
    show_node(fp, node->children[1], 0);
    fprintf(fp, ")");
    break;
  case S_NOP:
    fprintf(fp, "[NOP]");
    break;
  case S_SEQUENCE:
    show_node(fp, node->children[0], 0);
    fprintf(fp, "\n%s", fill_string);
    show_node(fp, node->children[1], 0);
    break;
  case S_IFTHEN:
    fprintf(fp, "if ");
    show_node(fp, node->children[0], 0);
    fprintf(fp, "\n%sthen", fill_string);
    indent_pos();
    fprintf(fp, "\n%s", fill_string);
    show_node(fp, node->children[1], 0);
    unindent_pos();
    fprintf(fp, "\n%selse", fill_string);
    indent_pos();
    fprintf(fp, "\n%s", fill_string);
    show_node(fp, node->children[2], 0);
    unindent_pos();
    break;
  case S_WHILE:
    fprintf(fp, "while ");
    show_node(fp, node->children[0], 0);
    indent_pos();
    fprintf(fp, "\n%s", fill_string);
    show_node(fp, node->children[1], 0);
    unindent_pos();
    break;
  case S_RETURN:
    fprintf(fp, "return ");
    show_node(fp, node->children[0], 0);
    break;
  case S_BREAK:
    fprintf(fp, "break");
    break;
  case S_CONTINUE:
    fprintf(fp, "continue");
    break;
  case S_SWITCH:
      fprintf(fp, "switch (");
      show_node(fp, node->children[0], 0);
      indent_pos();
      fprintf(fp, ")\n%s", fill_string);
      show_node(fp, node->children[1], 0);
      unindent_pos();
      break;
  case S_CASE:
      if (node->degree) {
	  fprintf(fp, "case ");
	  show_node(fp, node->children[0], 0);
	  fprintf(fp, " :");
      } else {
	  fprintf(fp, "default :");
      }
      break;
  case S_CATCHB:
      fprintf(fp, "catch break");
      indent_pos();
      fprintf(fp, "\n%s", fill_string);
      show_node(fp, node->children[0], 0);
      unindent_pos();
      break;
  case S_CATCHC:
      fprintf(fp, "catch continue");
      indent_pos();
      fprintf(fp, "\n%s", fill_string);
      show_node(fp, node->children[0], 0);
      unindent_pos();
      break;
  case S_DECL:
    fprintf(fp, "new ");
    show_node(fp, node->children[0], 0);
    break;
  case S_UNDECL:
    fprintf(fp, "free ");
    show_node(fp, node->children[0], 0);
    break;
  default:
    fprintf(fp, "[??]");
    break;
  }
  if (toplevel)
    fprintf(fp, "\n");
}

