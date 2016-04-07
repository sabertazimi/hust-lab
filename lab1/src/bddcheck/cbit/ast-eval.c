/* Manage generation of bit vector from C */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>

#include "gen-hash.h"
#include "boolnet.h"
#include "ast.h"
#include "mem.h"

#define DEBUG 0

#define MAX(a,b) ((a)<(b)?(b):(a))

/* For now, we will disable ability to change byte order */
static int big_endian = 0;

/* Stack entries for function arguments */
typedef struct {
  node_ptr var;   /* Variable, with all its type information */
  bvec_ptr val;   /* Value of variable */
  int restrict_range; /* Have there been restrictions placed on range of values? */
  long int minval;  /* Used to restrict arguments */
  long unsigned maxval;
  data_t dtype; 
} stack_ele, stack_ptr;

static int arg_cnt = 0;
static int pattern_cnt = 0;
/* static int final_arg_cnt = 0; */ /* Not used? */
static int arg_acount = 0;
static stack_ele *arg_buf = NULL;

static op_ptr args_in_range;
static op_ptr define_use_ok;
static op_ptr loop_ok;
static int pass = 0;
static int unroll_limit = 32;

/* Keep track of return data type */
static data_t ret_dtype = DATA_SIGNED;
static int ret_wsize = 32;

/**************** Information about status of evaluation *************/

#if DEBUG
/* A debugging function */
static void show_context(FILE *fp, context_ptr con)
{
    if (con->default_only)
	fprintf(fp, "  Default Only\n");
    fprintf(fp, "  Casting %s\n", con->casting ? "occurred" : "did not occur");
    fprintf(fp, "  normal:      ");  expr_display(fp, con->normal, 0);
    if (con->switching != zero()) {
	fprintf(fp, "\n  switching:   ");  expr_display(fp, con->switching, 0);
	fprintf(fp, "\n  switchval:   "); bvec_display(fp, con->switchval);
    }
    if (con->continuing != zero()) {
	fprintf(fp, "\n  continuing:  ");  expr_display(fp, con->continuing, 0);
    }
    if (con->breaking != zero()) {
	fprintf(fp, "\n  breaking:    ");  expr_display(fp, con->breaking, 0);
    }
    if (con->returning != zero()) { 
	fprintf(fp, "\n  returning:   ");  expr_display(fp, con->returning, 0);
	fprintf(fp, "\n  returnval:   "); bvec_display(fp, con->returnval);
    }
    if (con->bad_args != zero()) {
	fprintf(fp, "\n  bad args:    ");  expr_display(fp, con->bad_args, 0);
    }
    if (con->mem_error != zero()) { 
	fprintf(fp, "\n  memory violation:   ");  expr_display(fp, con->mem_error, 0);
    }
    if (con->div_error != zero()) { 
	fprintf(fp, "\n  zero divide:   ");  expr_display(fp, con->div_error, 0);
    }
    if (con->shift_error != zero()) { 
	fprintf(fp, "\n  big shift:   ");  expr_display(fp, con->shift_error, 0);
    }
    if (con->bad_args != zero()) {
	fprintf(fp, "\n  bad args:    ");  expr_display(fp, con->breaking, 0);    }
    fprintf(fp, "\n");
}
#endif

static context_ptr init_context()
{
    context_ptr con = malloc(sizeof(context_ele));
    con->default_only = 0;
    con->casting = 0;
    con->normal = one();
    con->switching = zero();
    con->continuing = zero();
    con->breaking = zero();
    con->returning = zero();
    con->bad_args = zero();
    con->mem_error = zero();
    con->div_error = zero();
    con->shift_error = zero();
    con->switchval = int_const(0L);
    con->returnval = mask_size(int_const(0L), ret_wsize, ret_dtype != DATA_SIGNED);
    return con;
}

void free_context(context_ptr con)
{
    if (con)
	free(con);
}
 
context_ptr clone_context(context_ptr con)
{
    context_ptr new_con     = init_context();
    new_con->default_only   = con->default_only;
    new_con->casting        = con->casting;
    new_con->normal         = con->normal;
    new_con->switching      = con->switching;
    new_con->continuing     = con->continuing;
    new_con->breaking       = con->breaking;
    new_con->returning      = con->returning;
    new_con->bad_args       = con->bad_args;
    new_con->mem_error      = con->mem_error;
    new_con->div_error      = con->div_error;
    new_con->shift_error    = con->shift_error;
    new_con->switchval      = con->switchval;
    new_con->returnval      = con->returnval;
    return new_con;
}
    
static context_ptr merge_contexts(context_ptr con1, context_ptr con2)
{
    context_ptr new_con = init_context(con1);
    new_con->default_only = con1->default_only && con2->default_only; /* Should both be the same */
    new_con->casting = con1->casting + con2->casting;
    new_con->normal = or_op(con1->normal, con2->normal);
    /* Can pick up switch cases along different branches */
    new_con->switching = and_op(con1->switching, con2->switching);
    new_con->continuing = or_op(con1->continuing, con2->continuing);
    new_con->breaking = or_op(con1->breaking, con2->breaking);
    new_con->returning = or_op(con1->returning, con2->returning);
#if DEBUG
    printf("Merging return contexts: ");
    expr_display(stdout, con1->returning, 0);
    printf("+");
    expr_display(stdout, con2->returning, 0);
    printf(" gives: ");
    expr_display(stdout, new_con->returning, 0);
    printf("\n");
#endif
    new_con->mem_error = or_op(con1->mem_error, con2->mem_error);
    new_con->div_error = or_op(con1->div_error, con2->div_error);
    new_con->shift_error = or_op(con1->shift_error, con2->shift_error);
    /* Both bad args values should be the same ... */
    new_con->bad_args = or_op(con1->bad_args, con2->bad_args);
    /* In all cases where split on switch, have same switchval */
    new_con->switchval = con1->switchval;
    new_con->returnval =
	int_mux(con1->returning, con1->returnval, con2->returnval);
    return new_con;
}

static void evalerror(char *msg)
{
  fprintf(ERRFILE, "Error: Symbolic evaluation error: %s\n", msg);
  exit(1);
}

static int check_casting(int old_wsize, data_t old_dtype, int new_wsize, data_t new_dtype) {
  if (old_wsize != new_wsize)
    return 1;
  if (old_dtype != new_dtype)
    return 1;
  return 0;
}

static char msg_buf[1024];
static void evalserror(char *msg, char *other)
{
  sprintf(msg_buf, msg, other);
  evalerror(msg_buf);
}

static unsigned long max_ulong(int wsize)
{
  if (wsize == 0)
    return 0;
  return ((1 << (wsize-1)) << 1) - 1;
}

static long max_long(int wsize)
{
  if (wsize == 0)
    return 0;
  return (1 << (wsize-1)) - 1;
}

static long min_long(int wsize)
{
  if (wsize == 0)
    return 0;
  return -(1 << (wsize-1));
}

/* Determine min. word size that can handle range of values */
static int get_wsize(long minval, unsigned long maxval, int isunsigned)
{
  int wsize;
  if (isunsigned) {
    for (wsize = 0; wsize < LSIZE; wsize++) {
      unsigned long highval = max_ulong(wsize);
      if (maxval <= highval) {
	return wsize;
      }
    }
  } else {
    for (wsize = 1; wsize < LSIZE; wsize++) {
      long highval = max_long(wsize);
      long int lowval = min_long(wsize);
      if (minval >= lowval && (long) maxval <= highval) {
	return wsize;
      }
    }
  }
  return LSIZE; /* Couldn't find smaller range */
}

void init_ast_eval(char *argpattern)
{
  arg_acount = 64;
  pass = 1;
  arg_buf = calloc(arg_acount, sizeof(stack_ele));
  pattern_cnt = 0;
  args_in_range = one();
  if (argpattern) {
      /* Have string of type specifiers for arguments.
	 Need to set them up */
      char *pat = argpattern;
      while (*pat) {
	  int isunsigned = 0;
	  int restrict_range = 0;
	  int nwsize = 0;
	  long int minval = min_long(LSIZE); 
	  long unsigned maxval = max_long(LSIZE);
	  char *newpat = NULL;
	  if (*pat == '[') {
	    /* Specification of range constraint */
	    restrict_range = 1;
	    pat++;
	    minval = strtol(pat, &newpat, 0);
	    pat = newpat;
	    if (minval >= 0)
	      isunsigned = 1;
	    if (*pat == ',')
	      pat++;
	    else {
	      evalserror("Invalid type qualfier: '%s'", strsave(argpattern));
	    }
	    maxval = strtoul(pat, &newpat, 0);
	    pat = newpat;
	    if (*pat == ']')
	      pat++;
	    else {
	      evalserror("Invalid type qualfier: '%s'", strsave(argpattern));
	    }
	    if (*pat == ':')
	      pat++;
	    else if (*pat)
	      evalserror("Invalid type qualifier: '%s'", strsave(argpattern));
	  } else {
	    if (*pat == 'u'||*pat == 't') {
	      restrict_range = 1;
	      minval = 0;
	      maxval = max_ulong(LSIZE);
	      isunsigned = (*pat == 'u');
	      pat++;
	    }
	    nwsize = strtol(pat, &newpat, 10);
	    if (nwsize != 0) {
	      restrict_range = 1;
	      if (nwsize > LSIZE || nwsize <= 0)
		evalserror("Invalid type qualifier: '%s'", strsave(argpattern));
	      if (isunsigned) {
		minval = 0;
		maxval = max_ulong(nwsize);
	      } else {
		minval = min_long(nwsize);
		maxval = max_long(nwsize);
	      }
	    }
	    pat = newpat;
	    if (*pat == ':')
	      pat++;
	    else if (*pat)
	      evalserror("Invalid type qualifier: '%s'", strsave(argpattern));
	    if (pattern_cnt >= arg_acount) {
	      arg_acount *= 2;
	      arg_buf = realloc(arg_buf, arg_acount * sizeof(stack_ele));
	    }
	  }
#if DEBUG
	  if (restrict_range)
	    printf("Restricting range to %s[%ld,%lu]\n",
		   isunsigned ? "u" : "", minval, maxval);
	  else
	    printf("No range restriction\n");
#endif
	  arg_buf[pattern_cnt].restrict_range = restrict_range;
	  arg_buf[pattern_cnt].dtype = isunsigned ? DATA_UNSIGNED : DATA_SIGNED;
	  arg_buf[pattern_cnt].minval = minval;
	  arg_buf[pattern_cnt].maxval = maxval;
	  pattern_cnt++;
      }
  }
  init_mem();
}


#define MAXSTR 1024
      char str_buf[MAXSTR];

/* Create function argument. */
void make_arg(node_ptr vnode)
{
    char *fullname;
    int wsize = vnode->wsize;
    int isunsigned = vnode->dtype != DATA_SIGNED;
    long int minval = min_long(wsize);
    long unsigned maxval = isunsigned ? max_ulong(wsize) : max_long(wsize);
    bvec_ptr val;
    int check_valid = 0;

    if (pass == 1) {
        if (arg_cnt < pattern_cnt && arg_buf[arg_cnt].restrict_range) {
	    /* May modify to have fewer bits */
  	    isunsigned = arg_buf[arg_cnt].dtype != DATA_SIGNED;
	    minval = arg_buf[arg_cnt].minval;
	    maxval = arg_buf[arg_cnt].maxval;
	    wsize = get_wsize(minval, maxval, isunsigned);
#if 1
	    printf("wsize = %d\n", wsize);
#endif
	    
	    check_valid = 1;
	}
#if 1
	sprintf(str_buf, "arg-%s", vnode->name);
#else
	sprintf(str_buf, "arg-%d", arg_cnt+1);
#endif
	fullname = strsave(str_buf);
	val = int_pi(fullname, wsize, isunsigned);
	if (arg_cnt >= arg_acount) {
	    arg_acount *= 2;
	    arg_buf = realloc(arg_buf, arg_acount*sizeof(stack_ele));
	}
	arg_buf[arg_cnt].var = vnode;
	arg_buf[arg_cnt].val = val;
	arg_buf[arg_cnt].minval = minval;
	arg_buf[arg_cnt].maxval = maxval;
	arg_buf[arg_cnt].dtype = isunsigned ? DATA_UNSIGNED: DATA_SIGNED;
	vnode->val = val;
	vnode->isdefined = one();
    } else {
	arg_buf[arg_cnt].var = vnode;
	vnode->val = arg_buf[arg_cnt].val;
	vnode->isdefined = one();
    }
    arg_cnt++;
    if (check_valid) {
      bvec_ptr bminval = int_const(minval);
      bvec_ptr bmaxval = uint_const(maxval);
      op_ptr in_range = isunsigned ?
	and_op(int_ule(bminval, val), int_ule(val, bmaxval)) :
	and_op(int_le(bminval, val), int_le(val, bmaxval));
      args_in_range = and_op(args_in_range, in_range);
    }
}

/* Assign value to local variable, or to LHS array reference */
/* Return 1 if assignment causes implicit cast */
static int assign_value(node_ptr varnode, node_ptr valnode, op_ptr context)
{
    bvec_ptr val = change_type(valnode->val, valnode->wsize, valnode->dtype,
			       varnode->wsize, varnode->dtype);
    int casting = check_casting(valnode->wsize, valnode->dtype, varnode->wsize, varnode->dtype);
    bvec_ptr var = varnode->val;
    bvec_ptr new_val = int_mux(context, val, var);

#if DEBUG
    if (varnode->ntype != E_AVAR && varnode->ntype != E_LVAR && varnode->ntype != E_AREF)
      fprintf(stdout,
	      "Internal Error: Trying to assign value to node of type %s\n",
	      node_type_name(varnode->ntype));
    fprintf(stdout, "Node:");
    show_node(stdout, varnode, 1);
#endif
    varnode->isdefined = or_op(varnode->isdefined, context);
    varnode->val = new_val;
#if DEBUG
    printf("Assigning value ");
    bvec_display(stdout, val);
    printf("\n  to '%s' under context:", varnode->name);
    expr_display(stdout, context, 0);
    printf("\nGives:");
    bvec_display(stdout, new_val);
    printf("\nIs Defined:");
    expr_display(stdout, varnode->isdefined, 0);
    printf("\n");
#endif   
    return casting;
}

/* Inner step of array initialization. */
static context_ptr fill_array(node_ptr anode, node_ptr inode, node_ptr index_list, context_ptr con, int level)
{
  context_ptr result;
  if (inode->ntype == E_SEQUENCE) {
    /* Still working way down levels */
    /* Evaluate next level down */
    context_ptr con1 = fill_array(anode, inode->children[0], index_list, con, level+1);
    /* Find index element for this level */
    int i;
    node_ptr index = index_list;
    for (i = 0; i < level; i++) {
      index = index_list->children[1];
    }
    if (inode->children[1]) {
      /* More to go at this level. */
      index->val = int_add(index->val, int_const(1));
      result = fill_array(anode, inode->children[1], index_list, con1, level);
      free_context(con1);
    } else {
      /* Have hit the end of this level.  Reset the index to 0 */
      index->val = int_const(0);
      result = con1;
    }
  } else {
    result = write_array(anode, con, index_list, inode->val, big_endian);
  }
  return result;
}

/* Initialize array */
static context_ptr init_array(node_ptr anode, node_ptr inode, context_ptr con)
{
  node_ptr index_list = NULL;
  node_ptr dim = anode->children[0];
  char *zero = "0";
  /* Generate index list having same length as dim list, and with all 0 values */
  while (dim) {
    index_list = new_node2(E_ADIM, IOP_NONE, make_ast_num(zero), index_list);
    dim = dim->children[1];
  }
  return fill_array(anode, inode, index_list, con, 0);
}

/* Evaluation of function. */
static context_ptr eval_step(node_ptr node, context_ptr con)
{
    context_ptr con1, result;
    node_ptr child0 = node->children[0];
    node_ptr child1 = node->children[1];
    node_ptr child2 = node->children[2];
    bvec_ptr val0, val1, val;
    bvec_ptr nval0, nval1;
    int wsize0, wsize1;
    int wsize;
    data_t dtype0, dtype1, dtype;
    int casting = 0;
    /* Special casting rules for shift operations */
    int scasting = 0;


#if DEBUG
    printf("Evaluating node of type %s\n", node_type_name(node->ntype));
#endif

    switch(node->ntype) {
    case E_BINOP:     // Binary operation (two children)
	con1 = eval_step(child0, con);
	result = eval_step(child1, con1);
	free_context(con1);
	val0 = child0->val; val1 = child1->val;
	wsize0 = child0->wsize; wsize1 = child1->wsize;
	dtype0 = child0->dtype; dtype1 = child1->dtype;
	if (dtype0 != DATA_FLOAT && wsize0 < ISIZE) {
	  /* Integral promotion */
	  val0 = change_type(val0, wsize0, dtype0, ISIZE, dtype0);
	  wsize0 = ISIZE;
	  scasting = casting = 1;
	}
	if (dtype1 != DATA_FLOAT && wsize1 < ISIZE) {
	  /* Integral promotion */
	  val1 = change_type(val1, wsize1, dtype1, ISIZE, dtype1);
	  wsize1 = ISIZE;
	  scasting = casting = 1;
	}
	/* Convert to float if necessary */
	if (dtype0 == DATA_FLOAT && dtype1 != DATA_FLOAT) {
	  val1 = change_type(val1, wsize1, dtype1, FLOAT_SIZE, DATA_FLOAT);
	  dtype1 = DATA_FLOAT;
	  scasting = casting = 1;
	}
	if (dtype1 == DATA_FLOAT && dtype0 != DATA_FLOAT) {
	  val0 = change_type(val0, wsize0, dtype0, FLOAT_SIZE, DATA_FLOAT);
	  dtype0 = DATA_FLOAT;
	  scasting = casting = 1;
	}
	/* Default cases */
	/* Include arithmetic promotion */
	wsize = MAX(wsize0, wsize1);
	dtype =
	  dtype0 == DATA_FLOAT ? DATA_FLOAT :
	  dtype0 == DATA_UNSIGNED ? DATA_UNSIGNED :
	  dtype1 == DATA_UNSIGNED ? DATA_UNSIGNED :
	  DATA_SIGNED;
	casting += check_casting(wsize0, dtype0, wsize, dtype);
	casting += check_casting(wsize1, dtype1, wsize, dtype);
	/* Prepare arguments */
	nval0 = (dtype == dtype0 && wsize == wsize0) ? val0 : change_type(val0, wsize0, dtype0, wsize, dtype);
	nval1 = (dtype == dtype1 && wsize == wsize1) ? val1 : change_type(val1, wsize1, dtype1, wsize, dtype);
	switch(node->op) {
	case IOP_ADD:
	  if (dtype == DATA_FLOAT)
	    evalerror("Floating point addition not supported");
	  else
	    val = int_add(nval0, nval1);
	  break;
	case IOP_SUB:
	  if (dtype == DATA_FLOAT)
	    evalerror("Floating point subtraction not supported");
	  else
	    val = int_add(nval0, int_negate(nval1));
	  break;
	case  IOP_AND:
	  if (dtype == DATA_FLOAT)
	    evalerror("Invalid floating point operation");
	  else
	    val = int_and(nval0, nval1);
	  break;
	case  IOP_XOR:
	  if (dtype == DATA_FLOAT)
	    evalerror("Invalid floating point operation");
	  else
	    val = int_xor(nval0, nval1);
	  break;
	case  IOP_LSHIFT:
	  if (dtype == DATA_FLOAT)
	    evalerror("Invalid floating point operation");
	  else {
	    wsize = wsize0;
	    dtype = dtype0;
	    val = int_shiftleft(val0, val1, wsize);
	    casting = scasting;
	  }
	  break;
	case  IOP_RSHIFT:
	  if (dtype == DATA_FLOAT)
	    evalerror("Invalid floating point operation");
	  else {
	    wsize = wsize0;
	    dtype = dtype0;
	    val = dtype == DATA_SIGNED ?
	      int_shiftrightarith(val0, val1, wsize)
	      :	int_shiftrightlogical(val0, val1, wsize);
	    casting = scasting;
	  }
	  break;
	case  IOP_MUL:
	  if (dtype == DATA_FLOAT) {
	    if (WSIZE < 48)
	      evalerror("Floating point multiply unsupported with this word size");
	    else
	      val = float_mult(nval0, nval1);
	  } else
	    val = int_mult(nval0, nval1);
	  break;
	case  IOP_DIV:
	  if (dtype == DATA_FLOAT)
	    evalerror("Invalid floating point operation");
	  else
	    val = int_div(nval0, nval1, dtype != DATA_SIGNED);
	  break;
	case  IOP_REM:
	  if (dtype == DATA_FLOAT)
	    evalerror("Invalid floating point operation");
	  else
	    val = int_rem(nval0, nval1, dtype != DATA_SIGNED);
	  break;
	case  IOP_NONE:
	    evalerror("Unexpected nop in binary operation");
	    break;
	case  IOP_EQUAL:
 	    wsize = ISIZE;
	    dtype = DATA_SIGNED;
	    val = dtype == DATA_FLOAT ?
		bool2int(float_eq(nval0, nval1)):
		bool2int(int_eq(nval0, nval1));
	    break;
	case  IOP_LESS:
 	    wsize = ISIZE;
	    val = bool2int(dtype == DATA_SIGNED ? int_lt(nval0, nval1) :
			   dtype == DATA_FLOAT  ? float_lt(nval0, nval1) :
			   int_ult(nval0, nval1));
	    dtype = DATA_SIGNED;
	    break;
	case  IOP_LESSEQUAL:
	  if (dtype == DATA_FLOAT)
	    evalerror("Invalid floating point operation");
	  else {
 	    wsize = ISIZE;
	    dtype = DATA_SIGNED;
	    val = bool2int(dtype == DATA_SIGNED ? int_le(nval0, nval1) : int_ule(nval0, nval1));
	  }
	  break;
	default:
	    evalerror("Unknown binary operation");
	    break;
	}
	node->val = mask_size(val, wsize, dtype != DATA_SIGNED);
	node->wsize = wsize;
	node->dtype = dtype;
	result->casting += casting;

	break;
    case E_UNOP:      // Unary operation  (one child)
	result = eval_step(child0, con);
	val0 = child0->val;
	wsize = child0->wsize;
	dtype = child0->dtype;
	if (dtype != DATA_FLOAT && wsize < ISIZE) {
	  /* Integral promotion */
	  val0 = change_type(val0, wsize, dtype, ISIZE, dtype);
	  wsize = ISIZE;
	  result->casting = 1;
	}
	switch(node->op) {
	case  IOP_NEG:
	  if (dtype == DATA_FLOAT)
	    val = float_negate(val0);
	  else
	    val = int_negate(val0);
	  break;
	case  IOP_NOT:
	  if (dtype == DATA_FLOAT)
	    evalerror("Invalid floating point operation");
	  else 
	    val = int_not(val0);
	  break;
	case  IOP_ISZERO:
	    val = bool2int(not_op(int_isnonzero(val0)));
	    wsize = ISIZE;
	    dtype = DATA_SIGNED;
	    break;
	default:
	    evalerror("Unknown unary operation");
	    break;
	}
        node->val = mask_size(val, wsize, dtype != DATA_SIGNED);
	node->wsize = wsize;
	node->dtype = dtype;
	result->casting += casting;
	break;
    case E_ASSIGN:    // Assignment
      if (child0->ntype == E_AREF) {
	// Assignment to array element
	context_ptr con_r = eval_step(child1, con);
	context_ptr con_l = eval_step(child0->children[1], con_r);
	result = write_array(child0->children[0], con_l, child0->children[1], child1->val, big_endian);
	free_context(con_r); free_context(con_l);
      } else if (child0->ntype == E_LAVAR) {
	// Array initialization
	context_ptr con1 = eval_step(child1, con);
	result = init_array(child0, child1, con1);
	free_context(con1);
	/* No value for node */
	break;
      } else { // Assignment to variable
	result = eval_step(child1, con);
      }
      result->casting += assign_value(child0, child1, result->normal);
      node->val = child0->val;
      node->wsize = child0->wsize;
      node->dtype = child0->dtype;
      break;
    case E_PASSIGN:   // Postassignment (as in x++) (variable, expression children.  Value is that of variable)
      if (child0->ntype == E_AREF) {
	// Assignment to array element
	context_ptr con_r = eval_step(child1, con);
	context_ptr con_l = eval_step(child0->children[1], con_r);
	result = write_array(child0->children[0], con_l, child0->children[1], child1->val, big_endian);
	free_context(con_r); free_context(con_l);
      } else { // Assignment to variable
	result = eval_step(child1, con);
      }
      node->val = child0->val;
      node->wsize = child0->wsize;
      node->dtype = child0->dtype;
      result->casting = assign_value(child0, child1, result->normal);
      break;
    case E_QUESCOLON: // Conditional expression (test, then, else children)
	{
	    context_ptr con_t = eval_step(child0, con);
	    context_ptr con_e = clone_context(con_t);
	    op_ptr test = int_isnonzero(child0->val);
	    context_ptr res_t, res_e;
	    bvec_ptr val_t, val_e;
	    data_t dtype1, dtype2, dtype;
	    con_t->normal = and_op(con_t->normal, test);
	    con_e->normal = and_op(con_e->normal, not_op(test));
	    res_t = eval_step(child1, con_t);
	    res_e = eval_step(child2, con_e);
	    result = merge_contexts(res_t, res_e);
	    free_context(con_t), free_context(con_e); free_context(res_t); free_context(res_e);
	    dtype1 = child1->dtype;
	    dtype2 = child2->dtype;
	    dtype = dtype1 == DATA_FLOAT ? DATA_FLOAT :
	      dtype2 == DATA_FLOAT ? DATA_FLOAT :
	      dtype1 == DATA_UNSIGNED ? DATA_UNSIGNED :
	      dtype2 == DATA_UNSIGNED ? DATA_UNSIGNED :
	      DATA_SIGNED;
	    node->wsize = dtype == DATA_FLOAT ? FLOAT_SIZE :
	      child1->wsize > child2->wsize ? child1->wsize :
	      child2->wsize;
	    node->dtype = dtype;
	    val_t = change_type(child1->val, child1->wsize, child1->dtype, node->wsize, node->dtype);
	    val_e = change_type(child2->val, child2->wsize, child2->dtype, node->wsize, node->dtype);
	    node->val = int_mux(test, val_t, val_e);
	    result->casting += check_casting(child1->wsize, child1->dtype, node->wsize, node->dtype);
	    result->casting += check_casting(child2->wsize, child2->dtype, node->wsize, node->dtype);
	}
	break;
    case E_AVAR:      // Argument variable
	result = clone_context(con);
	break;
    case E_LVAR:      // Local variable
#if DEBUG
	printf("Setting define_use_ok.\n");
	printf("  Was: "); expr_display(stdout, define_use_ok, 0);
	printf("\n  Context: "); expr_display(stdout, con->normal, 0);
	printf("\n  Var: %s, Defined: ", node->name); expr_display(stdout, node->isdefined, 0);
#endif
	define_use_ok = and_op(define_use_ok,  // must have con->normal ==> node->isdefined
			       or_op(not_op(con->normal), node->isdefined));
#if DEBUG
	printf("\n  Gives: "); expr_display(stdout, define_use_ok, 0);
	printf("\n");
#endif
	result = clone_context(con);
	break;
    case E_LAVAR:   // Local array
      /* This shouldn't happen */
      evalerror("Internal Error.  Array variable referenced without index");
      break;
    case E_ADIM:  // Array dimension or index
      if (child1) {
	context_ptr con_l = eval_step(child0, con);
	result = eval_step(child1, con_l);
	free_context(con_l);
      } else {// Terminal case
	result = eval_step(child0, con);
      }
      node->val = change_type(child0->val, child0->wsize, child0->dtype, ISIZE, DATA_SIGNED);
      node->wsize = ISIZE; // Int index
      node->dtype = DATA_SIGNED;
      break;
    case E_AREF:   // Array reference on RHS
      {
	context_ptr con_r = eval_step(child1, con); // Evaluate index expression
	result = read_array(child0, con_r, child1, big_endian, &node->val);
	node->wsize = child0->wsize;
	node->dtype = child0->dtype;
	free_context(con_r);
      }
      break;
    case E_CONST:     // Numeric constant
	result = clone_context(con);
	break;
    case E_CAND:      // && (two children)
	{
	  context_ptr con_t = eval_step(child0, con);
	  context_ptr con_e = clone_context(con_t);
	  context_ptr con_end;
	  op_ptr test0 = int_isnonzero(child0->val);
	  op_ptr test1;
	  con_t->normal = and_op(con_t->normal, test0);
	  con_end = eval_step(child1, con_t);
	  con_e->normal = and_op(con_e->normal, not_op(test0));
	  test1 = int_isnonzero(child1->val);
	  node->val = bool2int(and_op(test0, test1));
	  result = merge_contexts(con_end, con_e);
	  free_context(con_t); free_context(con_e); free_context(con_end);
	  /* && returns int */
	  node->wsize = ISIZE;
	  node->dtype = DATA_SIGNED;
	}
	break;
    case E_CAST:      // Type cast (one child)
        result = eval_step(child0, con);
	node->val = change_type(child0->val, child0->wsize, child0->dtype, node->wsize, node->dtype);
	result->casting += check_casting(child0->wsize, child0->dtype, node->wsize, node->dtype);
	break;
    case E_SEQUENCE:  // Expression sequence (due to commas or array initialization) (two children)
	con1 = eval_step(child0, con);
	if (child1) {
	  result = eval_step(child1, con1);
	  free_context(con1);
	  node->val = child1->val;
	  node->wsize = child1->wsize;
	  node->dtype = child1->dtype;
	} else {
	  result = con1;
	}
	break;
	/* Statement types.  No associated value. */
    case E_FUNCALL: // Function call.  Function name & (single) argument as children.
      {
	char *fun_name = child0->name;
	result = eval_step(child1, con);
	/* Right now, only recognize "pseudo-casting" functions */
	if (strcmp(fun_name, "f2u") == 0) {
	  node->val = change_type(child1->val, FLOAT_SIZE, DATA_UNSIGNED, ISIZE, DATA_UNSIGNED);
	  node->wsize = ISIZE;
	  node->dtype = DATA_UNSIGNED;
	  result->casting = 1;
	} else if (strcmp(fun_name, "u2f") == 0) {
	  node->val = change_type(child1->val, FLOAT_SIZE, DATA_FLOAT, FLOAT_SIZE, DATA_FLOAT);
	  node->wsize = FLOAT_SIZE;
	  node->dtype = DATA_FLOAT;
	  result->casting = 1;
	} else if (strcmp(fun_name, "fix_nan") == 0) {
	  node->val = float_fix_nan(child1->val);
	  node->wsize = FLOAT_SIZE;
	  node->dtype = DATA_FLOAT;
	} else if (strcmp(fun_name, "isnanf") == 0 || strcmp(fun_name, "isnan") == 0) {
	  node->val = float_isnan(child1->val);
	  node->wsize = ISIZE;
	  node->dtype = DATA_SIGNED;
	}
	else {
	  evalerror("Unrecognized function");
	}
      }
      break;
      
      
    case S_NOP:       // No operation (no children)
	result = clone_context(con);
	break;
    case S_SEQUENCE:  // Statement sequence (two children)
	con1 = eval_step(child0, con);
        result = eval_step(child1, con1);
	free_context(con1);
	break;
    case S_IFTHEN:    // If-then-else statement. (test, then, else children)
	{
	    context_ptr con_t = eval_step(child0, con);
	    context_ptr con_e = clone_context(con_t);
	    op_ptr test = int_isnonzero(child0->val);
	    context_ptr res_t, res_e;
	    con_t->normal = and_op(con_t->normal, test);
	    con_e->normal = and_op(con_e->normal, not_op(test));
	    res_t = eval_step(child1, con_t);
	    res_e = eval_step(child2, con_e);
	    result = merge_contexts(res_t, res_e);
	    free_context(con_t), free_context(con_e); free_context(res_t); free_context(res_e);
	}
	break;
    case S_WHILE:     // While (test, body children)
	{
	    /* Context pointer used at start of loop */
	    context_ptr con_enter = clone_context(con);
	    /* Building up final context for loop */
	    context_ptr con_exit = clone_context(con);
	    int i;
	    con_exit->normal = zero();
	    for (i = 0; i < unroll_limit && con_enter->normal != zero(); i++) {
		context_ptr con_l = eval_step(child0, con_enter);
		context_ptr con_nl = clone_context(con_l);
		context_ptr con_end, con_nexit;

		op_ptr test = int_isnonzero(child0->val);
		con_l->normal = and_op(con_l->normal, test);
		con_nl->normal = and_op(con_nl->normal, not_op(test));
		
		con_end = eval_step(child1, con_l);
		/* Cases where exit loop */
		con_nexit = merge_contexts(con_exit, con_nl);
		free_context(con_exit);
		con_exit = con_nexit;

		free_context(con_l); free_context(con_enter); free_context(con_nl);
		con_enter = con_end;
	    }
	    loop_ok = and_op(loop_ok, not_op(con_enter->normal));
	    /* Must merge both normal exiting case with other possible exit modes (break, return) */
	    result = merge_contexts(con_exit, con_enter);
	}
	break;
    case S_RETURN:    // return (return value child)
	result = eval_step(child0, con);
	result->returnval = int_mux(result->returning, result->returnval,
				    change_type(child0->val, child0->wsize, child0->dtype, ret_wsize, ret_dtype));
	result->returning = or_op(result->returning, result->normal);
	result->normal = zero();
	result->casting += check_casting(child0->wsize, child0->dtype, ret_wsize, ret_dtype);
	break;
    case S_BREAK:     // break (no children)
	result = clone_context(con);
	result->breaking = or_op(result->breaking, result->normal);
	result->normal = zero();
	break;
    case S_CONTINUE:  // continue (no children)
	result = clone_context(con);
	result->continuing = or_op(result->continuing, result->normal);
	result->normal = zero();
	break;
    case S_SWITCH:    // switch (expression, body children)
	{
	    context_ptr con_e, con_d;
	    op_ptr hold_normal;
	    con_e = eval_step(child0, con);
	    val0 = change_type(child0->val, child0->wsize, child0->dtype, ISIZE, DATA_SIGNED);

   	    con_e->switching = con_e->normal;
	    con_e->normal = zero();
	    con_e->switchval = val0;
	    con_e->default_only = 0;

	    /* Evaluate normal cases */
	    con_d = eval_step(child1, con_e);
	    free_context(con_e);

	    /* Evaluate default cases */
	    con_d->default_only = 1;
	    hold_normal = con_d->normal;
	    con_d->normal = zero();
	    result = eval_step(child1, con_d);
	    /* Collect any incomplete cases */
	    result->normal = or_op(or_op(hold_normal, result->normal), result->switching);
	    result->switching = con->switching;
	    result->switchval = con->switchval;
	    result->default_only = con->default_only;
	    free_context(con_d);
	}
	break;
    case S_CASE:      // Case branch (value child.  No child for default case)

	if (node->degree == 1 && !con->default_only) {
	    op_ptr match;
	    bvec_ptr cval;
	    result = eval_step(child0, con);  // con doesn't matter, since constant expression
	    cval = change_type(child0->val, child0->wsize, child0->dtype, ISIZE, DATA_SIGNED);
	    match = int_eq(cval, result->switchval);
	    result->normal = or_op(result->normal, and_op(result->switching, match));
	    result->switching = and_op(result->switching, not_op(match));
	} else if (node->degree == 0 && con->default_only) {
	    /* Execute default case */
	    result = clone_context(con);
	    result->normal = result->switching;
	    result->switching = zero();
	} else {
	    result = clone_context(con);
	}
	break;
    case S_CATCHB: // Catch any breaks
	{
	    op_ptr old_break = con->breaking;
	    con->breaking = zero();
	    result= eval_step(child0, con);
	    result->normal = or_op(result->normal, result->breaking);
	    result->breaking = old_break;
	}
	break;
    case S_CATCHC:
	{
	    op_ptr old_continue = con->continuing;
	    con->continuing = zero();
	    result= eval_step(child0, con);
	    result->normal = or_op(result->normal, result->continuing);
	    result->continuing = old_continue;
	}
	break;
    case S_DECL:      // Local variable declaration (variable child)
	if (child0->ntype == E_AVAR) {
	    make_arg(child0);
	} else if (child0->ntype == E_LVAR) {
	    /* Newly declared local variable */
	    child0->isdefined = zero();
	    child0->val = int_const(0L);
	} else if (child0->ntype == E_LAVAR) {
	  add_array(child0);
	  result = eval_step(child0->children[0], con); // Evaluate dimension declarations
	} else {
	    evalerror("Internal Error.  Improper declaration structure");
	}
	result = clone_context(con);
	break;
    case S_UNDECL:     // Local variable elimination (variable child)
      if (child0->ntype == E_LVAR) {
	child0->isdefined = zero();
	child0->val = int_const(0L);
      } else if (child0->ntype == E_LAVAR) {
	remove_array(child0);
      }
      result = clone_context(con);
      break;  /* I don't think there's anything to do here! */
    case E_VAR:       // Generic variable.  Only used when variable first created.
    default:
	evalerror("Unexpected node type");
	break;
    }
#if DEBUG
    printf("Evaluation of ");
    show_node(stdout, node, 1);
    printf("Gives:\n");
    show_context(stdout, result);
    printf("Value:");
    bvec_display(stdout, node->val);
    printf("\n");
#endif
    return result;
}

bvec_ptr eval_ast(node_ptr fnode, node_ptr rtnode, int arg_unroll_limit, eval_status_ptr statusp)
{
    context_ptr con = init_context();
    context_ptr new_con;
    bvec_ptr result;
    
    /* Extract return information */
    ret_dtype = rtnode->dtype;
    ret_wsize = rtnode->wsize;

    /* Adjust to constrain argument ranges */
    con->normal = args_in_range;
    con->bad_args = not_op(args_in_range);
    define_use_ok = loop_ok = one();
    unroll_limit = arg_unroll_limit;
    arg_cnt = 0;
    new_con = eval_step(fnode, con);
    result = new_con->returnval;
#if DEBUG
    printf("  define use  OK: "); expr_display(stdout, define_use_ok, 0);
    printf("\n  loop        OK: "); expr_display(stdout, loop_ok, 0);
    printf("\n  not continuing: "); expr_display(stdout, new_con->continuing, 1);
    printf("\n  not   breaking: "); expr_display(stdout, new_con->breaking, 1);
    printf("\n  bad args:       "); expr_display(stdout, new_con->bad_args, 1);
    printf("\n");
#endif    
    if (statusp) {
      op_ptr eval_error = or_op(new_con->mem_error, or_op(new_con->div_error, new_con->shift_error));
      op_ptr incomplete = or_op(new_con->breaking, new_con->continuing);
      op_ptr good_stuff = and_op(new_con->returning, and_op(define_use_ok, loop_ok));
      statusp->all_ok =
	or_op(new_con->bad_args,
		and_op(good_stuff,
		       not_op(or_op(eval_error, incomplete))));
      statusp->incomplete_loop = not_op(loop_ok);
      statusp->uninitialized_variable = not_op(define_use_ok);
      statusp->missing_return = not_op(new_con->returning);
      statusp->uncaught_break = new_con->breaking;
      statusp->uncaught_continue = new_con->continuing;
      statusp->mem_error = new_con->mem_error;
      statusp->div_error = new_con->div_error;
      statusp->shift_error = new_con->shift_error;
      statusp->bad_args = new_con->bad_args;
      statusp->casting = new_con->casting;
    }
    free_context(con); free_context(new_con);
    /* Not needed?
    if (pass == 1)
	final_arg_cnt = arg_cnt;
    */
    pass++;
    return result;
}

