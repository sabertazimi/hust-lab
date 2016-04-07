#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "gen-hash.h"
#include "boolnet.h"
#include "util.h"
#include "cudd.h"

#define DEBUG 0

#if DEBUG
static void show_unique(FILE *fp);
#endif

/* Create unique versions of Boolean zero & one */
static op_ptr zero_op = NULL;
static op_ptr one_op = NULL;
int next_id = 1; /* Generate unique ID for each created node */
int curr_pass = 0; /* Globally identify current pass of DF traversal */
static int op_cnt = 0; /* Count of Boolean operations */
static int int_op_cnt = 0; /* Count of Integer operations */

/* Keep track of primary inputs */
/* Boolean */
int bpi_cnt = 0;
int bpi_acount = 0;  // Buffer Size
op_ptr *bpi_buf = NULL;

#if 0
/* Unique table for all operations */
op_ptr *unique_buf = NULL;
int unique_cnt = 0;
int unique_acount = 0;
#endif

hash_table_ptr unique_tab = NULL;

typedef struct {
  char *name;
  bvec_ptr val;
  int wordsize;  
  data_t dtype;
} ipi_ele, *ipi_ptr;

/* Integer */
static int ipi_cnt =0;
static int ipi_acount = 0;  // Buffer Size
static ipi_ele *ipi_buf = NULL;

static op_ptr new_node(int arity)
{
  op_ptr result = (op_ptr) malloc(sizeof(op_ele));
  result->nargs = arity;
  if (arity > 0) {
    result->args = (op_ptr *) calloc(arity, sizeof(op_ptr));
    result->invert_args = (char *) calloc(arity, sizeof(char));
  } else {
    result->args = NULL;
    result->invert_args = NULL;
  }
  result->output_id = 0;
  result->creation_id = next_id++;
  result->pass = curr_pass;
  result->name = NULL;
  result->unique = 0;
  return result;
}

static void free_node(op_ptr arg)
{
#if 0
  if (arg->nargs) {
    free((void *) arg->args);
    free((void *) arg->invert_args);
  }
  free(arg);
#endif
}

/* Are two operations isomorphic */
static int same_op(op_ptr arg1, op_ptr arg2)
{
    int i;
    int same = 1;
    int nargs = arg1->nargs;
    if (arg1->op != arg2->op || nargs != arg2->nargs)
	return 0;
    if (arg1->op == OP_PI || arg1->op == OP_IPI)
	return !strcmp(arg1->name, arg2->name);
    if (arg1->nargs == 0)
	return 1; /* Should be zero */
    for (i = 0; same && i < nargs; i++) {
	same = arg1->invert_args[i] == arg2->invert_args[i] &&
	    arg1->args[i]->creation_id == arg2->args[i]->creation_id;
    }
    return same;
}

/* Comparison function for hash table */
int op_eq(hash_ele_ptr e1, hash_ele_ptr e2)
{
    op_ptr arg1 = (op_ptr) e1;
    op_ptr arg2 = (op_ptr) e2;
    return same_op(arg1, arg2);
}

static int key_vals[10];

int op_h(hash_ele_ptr ele)
{
    int i;
    op_ptr arg = (op_ptr) ele;
    int nargs = arg->nargs;
    int kcnt = 0;
    if (arg->op == OP_PI || arg->op == OP_IPI)
	return hash_string(arg->name);
    key_vals[kcnt++] = arg->op;
    for (i = 0; i < nargs; i++) {
	int val = arg->args[i]->creation_id;
	if (arg->invert_args[i])
	    val = -val;
	key_vals[kcnt++] = val;
    }
    return hash_int_array(key_vals, kcnt);
}


/* This function should hash a new node and decide whether
   or not to keep it. */
static op_ptr canonize(op_ptr arg)
{
#if 0
    int i;
#endif
    op_ptr harg;
    if (arg->unique)
	return arg;
    harg = (op_ptr) find_hash(unique_tab, (hash_ele_ptr) arg);
    if (harg) {
	free_node(arg);
	return harg;
    }
#if 0    
    for (i = 0; i < unique_cnt; i++)
	if (same_op(arg, unique_buf[i])) {
	    if (hele != unique_buf[i]) {
		fprintf(stdout, "HASH Error.  Hash table entry %p, array entry %p\n", hele, unique_buf[i]);
		fprintf(stdout, "Looking for: ");
		expr_display(stdout, arg, 0);
		fprintf(stdout, "\n");
	    }
	    free_node(arg);
	    return unique_buf[i];
	}
    if (unique_cnt >= unique_acount) {
	unique_acount *= 2;
	unique_buf = realloc(unique_buf, unique_acount * sizeof(op_ptr));
    }
#endif
#if 0
    if (harg) {
	fprintf(stdout,
		"HASH Error.  Hash table entry %p, No array entry.\n", hele);
        fprintf(stdout, "Looking for: ");
	expr_display(stdout, arg, 0);
	fprintf(stdout, "\n");
    }
#endif
    insert_hash(unique_tab, (hash_ele_ptr) arg);
#if 0
    unique_buf[unique_cnt++] = arg;
#endif
    arg->unique = 1;
    return arg;
}

#define MAXSTR 1024
static char name_buf[MAXSTR];
char *strsave(char *s)
{
    if (s) {
	char *result = malloc(strlen(s)+1);
	return strcpy(result, s);
    }
    return NULL;
}

/* Display Boolean value as 0, 1, or X (for non-constant value) */
char op_char(op_ptr arg)
{
  if (arg == one())
    return '1';
  else if (arg == zero())
    return '0';
  return 'X';
}


static char *suffix_name(char *root, int suffix)
{
    sprintf(name_buf, "%s.%d", root, suffix);
    return strsave(name_buf);
}

/* Debugging help: Display Boolean expression */
void expr_display(FILE *fp, op_ptr arg, int invert)
{
    if (!arg) {
	fprintf(fp, "NULL");
	return;
    }
    switch(arg->op) {
	int i;
    case OP_ZERO:
	fprintf(fp, invert ? "1" : "0");
	break;
    case OP_AND:
    case OP_XOR:
	fprintf(fp, "%s(", invert ? "!" : "");
	for (i = 0; i < arg->nargs; i++) {
	    if (i > 0)
		fprintf(fp, " %c ", arg->op == OP_AND ? '&' : '^');
	    expr_display(fp, arg->args[i], arg->invert_args[i]);
	}
	fprintf(fp, ")");
	break;
    case OP_PI:
    case OP_IPI:
	if (invert)
	    fprintf(fp, "!");
	if (arg->name)
	    fprintf(fp, arg->name);
	else
	    fprintf(fp, "PI%d", arg->creation_id);
	break;
    case OP_BUF:
	expr_display(fp, arg->args[0], invert ^ arg->invert_args[0]);
	break;
    default:
	fprintf(fp, "Unexpected Operator %d", arg->op);
    }
}

static FILE *dp_file = NULL;

void h_display(hash_ele_ptr ele)
{
    op_ptr arg = (op_ptr) ele;
    fprintf(dp_file, "  ");
    expr_display(dp_file, arg, 0);
    fprintf(dp_file, "\n");
}

/* This is just here as a debugging function */
#if DEBUG
static void show_unique(FILE *fp)
{
    fprintf(fp, "Hash table entries:\n");
    dp_file = fp;
    apply_hash(unique_tab, h_display);
}
#endif

static void init_bool()
{
  zero_op = new_node(0);
  zero_op->op = OP_ZERO;
  zero_op->unique = 1;
  one_op = new_node(1);
  one_op->op = OP_BUF;
  one_op->args[0] = zero_op;
  one_op->invert_args[0] = 1;
  one_op->unique = 1;
#if 0
  unique_acount = 64;
  unique_buf = calloc(unique_acount, sizeof(op_ptr));
  unique_cnt = 0;
  unique_buf[unique_cnt++] = zero_op;
  unique_buf[unique_cnt++] = one_op;
#endif
  unique_tab = new_hash(op_h, op_eq);
  insert_hash(unique_tab, (hash_ele_ptr) zero_op);
  insert_hash(unique_tab, (hash_ele_ptr) one_op);
  bpi_acount = 64;
  bpi_buf = calloc(bpi_acount, sizeof(op_ptr));
  ipi_acount = 64;
  ipi_buf = calloc(ipi_acount, sizeof(ipi_ele));
}

/* Create a new PI */
op_ptr new_pi(char *name) {
  int i;
  op_ptr result;
  char *savename = NULL;
  if (!zero_op)
    init_bool();

  /* Check if this PI already defined */
  for (i = 0; i < bpi_cnt; i++)
    if (!strcmp(name, bpi_buf[i]->name))
      return bpi_buf[i];

  /* Otherwise, need to create it */
  if (name)
      savename = strsave(name);
  result = new_node(0);
  result->op = OP_PI;
  result->name = savename;
  if (bpi_acount <= bpi_cnt) {
      bpi_acount *= 2;
      bpi_buf = realloc(bpi_buf, bpi_acount * sizeof(op_ptr));
  }
  bpi_buf[bpi_cnt++] = result;
#if 0
  if (unique_acount <= unique_cnt) {
      unique_acount *= 2;
      unique_buf = realloc(unique_buf, unique_acount * sizeof(op_ptr));
  }
  unique_buf[unique_cnt++] = result;
#endif
  insert_hash(unique_tab, (hash_ele_ptr) result);
#if 0
    printf("Adding unique operation #%d: ", unique_cnt);
    expr_display(stdout, result, 0);
    printf("\n");
#endif
  result->unique = 1;
  return result;
}

/* Return zero node */
op_ptr zero()
{
  if (!zero_op)
    init_bool();
  return zero_op;
}

/* Return one node */
op_ptr one()
{
  if (!zero_op)
    init_bool();
  return one_op;
}

/* See if two arguments are either equal or complements of each other */
/* Return: -1 if complements, 0 if not same, 1 if equal */
static int same_or_complement(op_ptr arg1, op_ptr arg2)
{
  int invert1 = 0;
  int invert2 = 0;
  if (arg1->op == OP_BUF) {
    invert1 = arg1->invert_args[0];
    arg1 = arg1->args[0];
  }
  if (arg2->op == OP_BUF) {
    invert2 = arg2->invert_args[0];
    arg2 = arg2->args[0];
  }
  if (arg1 == arg2) {
    return (invert1 == invert2) ? 1 : -1;
  }
  return 0;
}

/* Check for absorption condition where other_arg contained in this_arg
   with possible complementations.  Return NULL when absorption rule
   does not apply.  Return result when absorption rule does apply
*/
static op_ptr absorb(op_ptr this_arg, int this_invert,
		     op_ptr other_arg, int other_invert)
{
  int i;
  if (this_arg->op != OP_AND || this_arg->nargs != 2)
    return NULL;
  if (other_invert)
      other_arg = not_op(other_arg);
  for (i = 0; i < 2; i++) {
    op_ptr match_arg, alt_arg;
    int sense;
    match_arg = this_arg->args[i];
    if (this_arg->invert_args[i])
      match_arg = not_op(match_arg);
    alt_arg = this_arg->args[1-i];
    if (this_arg->invert_args[1-i])
      alt_arg = not_op(alt_arg);
    sense = same_or_complement(match_arg, other_arg);
    if (sense) {
#if 0
      printf("Sense = %d, this_invert = %d\n", sense, this_invert);
      printf("Match arg: "); expr_display(stdout, match_arg, 0);
      printf("\nOther arg: "); expr_display(stdout, other_arg, 0);
      printf("\nAlt   arg: "); expr_display(stdout, alt_arg, 0);
      printf("\n");
#endif
    }
    if (sense == -1) {
      if (this_invert) {
	/* a & !(!a & b) --> a */
	return other_arg;
      } else {
	/* a & (!a & b) --> 0 */
	return zero();
      }
    } else if (sense == 1) {
      if (this_invert) {
	/* a & !(a & b) --> a & !b */
	return and_op(other_arg, not_op(alt_arg));
      } else {
	/* a & (a & b) --> a & b */
	return and_op(other_arg, alt_arg);
      }
    }
  }
  return NULL;
}

/* Boolean operations */
op_ptr and_op(op_ptr arg1, op_ptr arg2) {
  int invert1 = 0;
  int invert2 = 0;
  op_ptr result;
  /* Put in standard order */
  if (arg1->creation_id > arg2->creation_id) {
    op_ptr temp = arg1;
    arg1 = arg2;
    arg2 = temp;
  }
  /* Scan through inverters or buffers */
  if (arg1->op == OP_BUF) {
    invert1 = arg1->invert_args[0];
    arg1 = arg1->args[0];
  }
  if (arg2->op == OP_BUF) {
    invert2 = arg2->invert_args[0];
    arg2 = arg2->args[0];
  }
  /* Do special cases.  Shouldn't have either argument = 1 */
  if (arg1 == zero_op) {
      return invert1 ?
	  (invert2 ? not_op(arg2) : arg2)
	  : zero_op; /* 1 & b -> b / 0 & b -> 0 */
  }
  if (arg2 == zero_op)
    return invert2 ?
	(invert1 ? not_op(arg1) : arg1)
	: zero_op; /* a & 1 -> a / a & 0 -> 0 */
  if (arg1 == arg2) {
    if (invert1 != invert2)
      return zero_op;
    if (invert1)
      return not_op(arg1);
    return arg1;
  }
  if ((result = absorb(arg1, invert1, arg2, invert2)) != NULL)
    return result;
  if ((result = absorb(arg2, invert2, arg1, invert1)) != NULL)
    return result;
  /* Really need to create node */
  result = new_node(2);
  result->op = OP_AND;
  result->args[0] = arg1; result->invert_args[0] = invert1;
  result->args[1] = arg2; result->invert_args[1] = invert2;
  return canonize(result);
}

op_ptr not_op(op_ptr arg) {
  op_ptr result;
  if (arg->op == OP_BUF && arg->invert_args[0]) {
      return arg->args[0];
  }
  result = new_node(1);
  result->op = OP_BUF;
  result->args[0] = arg;
  result->invert_args[0] = 1;
  return canonize(result);
}

op_ptr or_op(op_ptr arg1, op_ptr arg2) {
  return not_op(and_op(not_op(arg1), not_op(arg2)));
}

op_ptr xor_op(op_ptr arg1, op_ptr arg2) {
  op_ptr result;
  int invert = 0;
  /* Put in standard order */
  if (arg1->creation_id > arg2->creation_id) {
    op_ptr temp = arg1;
    arg1 = arg2;
    arg2 = temp;
  }
  /* Scan through inverters */
  if (arg1->op == OP_BUF) {
    invert ^= arg1->invert_args[0];
    arg1 = arg1->args[0];
  }
  if (arg2->op == OP_BUF) {
    invert ^= arg2->invert_args[0];
    arg2 = arg2->args[0];
  }
  /* Do special cases */
  if (arg1 == zero_op) {
      return invert ? not_op(arg2) : arg2; /* 1 ^ b -> !b / 0 ^ b -> b */
  }
  if (arg2 == zero_op) {
      return invert ? not_op(arg1) : arg1; /* a ^ 1 -> !a / a ^ 0 -> a */
  }
  if (arg1 == arg2)
    return invert ? one_op : zero_op; /* a ^ !a -> 1 / a ^ a -> 0 */
  /* Really need to create node */
  result = new_node(2);
  result->op = OP_XOR;
  result->args[0] = arg1; result->invert_args[0] = 0;
  result->args[1] = arg2; result->invert_args[1] = 0;
  if (invert)
      return not_op(canonize(result));
    else
      return canonize(result);
}

op_ptr ite_op(op_ptr iarg, op_ptr targ, op_ptr earg)
{
  /* Special cases */
  if (targ == earg)
    return targ;
  else
    return or_op(and_op(iarg, targ), and_op(not_op(iarg), earg));
}


/********************** Integer stuff **************************************/
static bvec_ptr new_vec()
{
    bvec_ptr result = (bvec_ptr) malloc(sizeof(bvec_ele));
    return result;
}

void free_vec(bvec_ptr vec)
{
  /* free((void *) vec); */
}

void bvec_char(char *dest, bvec_ptr v, int width)
{
  int i;
  for (i = width-1; i >= 0; i--)
    *dest++ = op_char(v->bits[i]);
  *dest++ = '\0';
}

void bvec_display(FILE *fp, bvec_ptr v)
{
  int i;
  fprintf(fp, "[");
  for (i = WSIZE-1; i >= 0; i--) {
    if (i != WSIZE-1)
      fprintf(fp, " ");
    expr_display(fp, v->bits[i], 0);
  }
  fprintf(fp, "]");
}

#if 0
/* Debug */
static void show_name_bufs(char *context)
{
    int i;
    printf("c %s. %d named pis:\n", context, ipi_cnt);
    for (i = 0; i < ipi_cnt; i++)
	printf("c buf '%s'\n", ipi_buf[i].name);
}
#endif

/* Floating point helpers */

#define EXP_SIZE 8
#define BIAS ((1<<(EXP_SIZE-1))-1)
#define EXP_MASK ((1<<EXP_SIZE)-1)
#define FRAC_SIZE 23
#define FRAC_MASK ((1<<FRAC_SIZE)-1)
/* Generic NaN fraction */
#define QNAN_FRAC (1<<(FRAC_SIZE-1))
#define QNAN_VAL ((EXP_MASK<<FRAC_SIZE)|QNAN_FRAC)

/* Floating point helpers */
static unsigned f2u(float f)
{
  union {
    unsigned u;
    float f;
  } u;
  u.f = f;
  return u.u;
}

/* Expand from 1 bit to word size */
bvec_ptr bool2int(op_ptr arg) {
  int i;
  bvec_ptr result = new_vec();
  result->bits[0] = arg;
  for (i = 1; i < WSIZE; i++)
    result->bits[i] = zero();
  return result;
}

/* Create vector of Boolean PIs. */
bvec_ptr int_pi(char *name, int wsize, int isunsigned) 
{
  int i;
  op_ptr fill_bit = zero();
  bvec_ptr result = new_vec();

  /* Initialize the bits to be Boolean variables */
  for (i = 0; i < wsize; i++) {
    char *bitname = suffix_name(name, i);
    result->bits[i] = new_pi(bitname);
    result->bits[i]->op = OP_IPI;
  }
  if (!isunsigned)
      fill_bit = result->bits[wsize-1];
  for (i = wsize; i < WSIZE; i++) {
      result->bits[i] = fill_bit;
  }
  if (ipi_acount <= ipi_cnt) {
    ipi_acount *= 2;
    ipi_buf = realloc(ipi_buf, ipi_acount * sizeof(ipi_ele));
  }
  ipi_buf[ipi_cnt].val = result;
  ipi_buf[ipi_cnt].name = name;
  ipi_buf[ipi_cnt].wordsize = wsize;
  ipi_buf[ipi_cnt].dtype = isunsigned ? DATA_UNSIGNED : DATA_SIGNED;
  ipi_cnt++;
  return result;
}

/* Create vector of zero/ones encoding integer constant */
bvec_ptr int_const(llong val)
{
  bvec_ptr result;
  int i, b;
  int w = sizeof(llong) * CSIZE;
  if (w > WSIZE)
    w = WSIZE;
  result = new_vec();
  for (i = 0; i < w; i++) {
    b = (val >> i) & 0x1;
    result->bits[i] = b ? one() : zero();
  }
  for (i = w; i < WSIZE; i++)
    result->bits[i] = b ? one() : zero();
  return result;
}

/* Create vector of zero/ones encoding unsigned integer constant */
bvec_ptr uint_const(ullong val)
{
  bvec_ptr result;
  int i, b;
  int w = sizeof(ullong) * CSIZE;
  if (w > WSIZE)
    w = WSIZE;
  result = new_vec();
  for (i = 0; i < w; i++) {
    b = (val >> i) & 0x1;
    result->bits[i] = b ? one() : zero();
  }
  for (i = w; i < WSIZE; i++)
    result->bits[i] = zero();
  return result;
}

/* Create vector of zero/ones encoding floating point constant */
bvec_ptr float_const(float fval)
{
  return uint_const(f2u(fval));
}

bvec_ptr int_add(bvec_ptr vec1, bvec_ptr vec2)
{
  bvec_ptr result = new_vec();
  int i;
  op_ptr carry = zero();
  int_op_cnt++;
  for (i = 0; i < WSIZE; i++) {
    op_ptr bit1 = vec1->bits[i];
    op_ptr bit2 = vec2->bits[i];
    result->bits[i] = xor_op(carry, xor_op(bit1, bit2));
    carry = or_op(and_op(bit1, bit2), and_op(carry, or_op(bit1, bit2)));
  }
  return result;
}

bvec_ptr int_negate(bvec_ptr vec1)
{
  bvec_ptr result = new_vec();
  int i;
  op_ptr carry = one();
  int_op_cnt++;
  for (i = 0; i < WSIZE; i++) {
    op_ptr bit = not_op(vec1->bits[i]);
    result->bits[i] = xor_op(bit, carry);
    carry = and_op(carry, bit);
  }
  return result;
}

bvec_ptr int_not(bvec_ptr vec)
{
  bvec_ptr result = new_vec();
  int i;
  int_op_cnt++;
  for (i = 0; i < WSIZE; i++) {
    result->bits[i] = not_op(vec->bits[i]);
  }
  return result;
}

bvec_ptr int_and(bvec_ptr vec1, bvec_ptr vec2)
{
  bvec_ptr result = new_vec();
  int i;
  int_op_cnt++;
  for (i = 0; i < WSIZE; i++) {
    result->bits[i] = and_op(vec1->bits[i], vec2->bits[i]);
  }
  return result;
}

bvec_ptr int_or(bvec_ptr vec1, bvec_ptr vec2)
{
  bvec_ptr result = new_vec();
  int i;
  int_op_cnt++;
  for (i = 0; i < WSIZE; i++) {
    result->bits[i] = or_op(vec1->bits[i], vec2->bits[i]);
  }
  return result;
}

bvec_ptr int_xor(bvec_ptr vec1, bvec_ptr vec2)
{
  bvec_ptr result = new_vec();
  int i;
  int_op_cnt++;
  for (i = 0; i < WSIZE; i++) {
    result->bits[i] = xor_op(vec1->bits[i], vec2->bits[i]);
  }
  return result;
}

/* Shift vector left by fixed value s */
static bvec_ptr lshift(bvec_ptr vec, int s)
{
  int i;
  bvec_ptr result = new_vec();
  int_op_cnt++;
  for (i = 0; i < s && i < WSIZE; i++)
    result->bits[i] = zero();
  for (i = s; i < WSIZE; i++)
    result->bits[i] = vec->bits[i-s];
  return result;
}

/* Shift vector right  by fixed value s */
static bvec_ptr rshift(bvec_ptr vec, int s, int arithmetic)
{
  int i;
  bvec_ptr result = new_vec();
  op_ptr fill_bit = arithmetic ? vec->bits[WSIZE-1] : zero();
  int_op_cnt++;
  for (i = WSIZE-1; i >= WSIZE-s && i >= 0; i--)
    result->bits[i] = fill_bit;
  for (i = WSIZE-s-1; i >= 0; i--)
    result->bits[i] = vec->bits[i+s];
  return result;
}


bvec_ptr int_mult(bvec_ptr vec1, bvec_ptr vec2)
{
  bvec_ptr result = int_const(0L);
  bvec_ptr zero = int_const(0L);
  int i;
  for (i = 0; i < WSIZE; i++) {
    bvec_ptr oresult = result;
    bvec_ptr pp = int_mux(vec1->bits[i], lshift(vec2, i), zero);
    result = int_add(result, pp);
    free_vec(oresult);
    free_vec(pp);
  }
  return result;
}

bvec_ptr int_div(bvec_ptr vec1, bvec_ptr vec2, int isunsigned)
{
  op_ptr vs1 = isunsigned ? zero() : vec1->bits[WSIZE-1];
  op_ptr vs2 = isunsigned ? zero() : vec2->bits[WSIZE-1];
  /* make both positive */
  bvec_ptr lo = int_mux(vs1, int_negate(vec1), vec1);
  bvec_ptr divisor = int_mux(vs2, int_negate(vec2), vec2);
  bvec_ptr ndivisor = int_negate(divisor);
  bvec_ptr hi = int_const(0);
  bvec_ptr quo = int_const(0);
  int i;
  for (i = 0; i < WSIZE; i++) {
    op_ptr sub;
    /* Shift hi:lo <<= 1; quo <<= 1 */
    hi = lshift(hi, 1);
    hi->bits[0] = lo->bits[WSIZE-1];
    lo = lshift(lo, 1);
    lo->bits[0] = zero();
    quo = lshift(quo, 1);
    /* Conditional subtraction */
    sub = not_op(int_ult(hi, divisor));
    hi = int_mux(sub, int_add(hi, ndivisor), hi);
    quo->bits[0] = sub;
  }
  return int_mux(xor_op(vs1, vs2), int_negate(quo), quo);
}


bvec_ptr int_rem(bvec_ptr vec1, bvec_ptr vec2, int isunsigned)
{
  op_ptr vs1 = isunsigned ? zero() : vec1->bits[WSIZE-1];
  op_ptr vs2 = isunsigned ? zero() : vec2->bits[WSIZE-1];
  /* make both positive */
  bvec_ptr lo = int_mux(vs1, int_negate(vec1), vec1);
  bvec_ptr divisor = int_mux(vs2, int_negate(vec2), vec2);
  bvec_ptr ndivisor = int_negate(divisor);
  bvec_ptr hi = int_const(0);
  int i;
  for (i = 0; i < WSIZE; i++) {
    op_ptr sub;
    /* Shift hi:lo <<= 1 */
    hi = lshift(hi, 1);
    hi->bits[0] = lo->bits[WSIZE-1];
    lo = lshift(lo, 1);
    /* Conditional subtraction */
    sub = not_op(int_ult(hi, divisor));
    hi = int_mux(sub, int_add(hi, ndivisor), hi);
  }
  return int_mux(vs1, int_negate(hi), hi);
}

bvec_ptr int_shiftleft(bvec_ptr vec1, bvec_ptr vec2, int wsize) {
  int i;
  bvec_ptr result = vec1;
  for (i = 0; (1<<i) < wsize; i++) {
    bvec_ptr svec = lshift(result, 1<<i);
    bvec_ptr oresult = result;
    result = int_mux(vec2->bits[i], svec, result);
    if (oresult != vec1)
      free_vec(oresult);
    free_vec(svec);
  }
  return result;
}

bvec_ptr int_shiftrightarith(bvec_ptr vec1, bvec_ptr vec2, int wsize) {
  int i;
  bvec_ptr result = vec1;
  for (i = 0; (1<<i) < wsize; i++) {
    bvec_ptr svec = rshift(result, 1<<i, 1);
    bvec_ptr oresult = result;
    result = int_mux(vec2->bits[i], svec, result);
    if (oresult != vec1)
      free_vec(oresult);
    free_vec(svec);
  }
  return result;
}

bvec_ptr int_shiftrightlogical(bvec_ptr vec1, bvec_ptr vec2, int wsize) {
  int i;
  bvec_ptr result = vec1;
  for (i = 0; (1<<i) < wsize; i++) {
    bvec_ptr svec = rshift(result, 1<<i, 0);
    bvec_ptr oresult = result;
    result = int_mux(vec2->bits[i], svec, result);
    if (oresult != vec1)
      free_vec(oresult);
    free_vec(svec);
  }
  return result;
}

bvec_ptr int_mux(op_ptr cntl, bvec_ptr vec1, bvec_ptr vec2)
{
  bvec_ptr result;
  int i;
  if (cntl == one())
      return vec1;
  if (cntl == zero())
      return vec2;

  result = new_vec();
  int_op_cnt++;
  for (i = 0; i < WSIZE; i++) {
    op_ptr bit1 = vec1->bits[i];
    op_ptr bit2 = vec2->bits[i];
    result->bits[i] = or_op(and_op(cntl, bit1), and_op(not_op(cntl), bit2));
  }
  return result;
}

/** Conversion from (unsigned) integer to float */
static bvec_ptr cvt_to_float(bvec_ptr val, int new_wsize, int isunsigned)
{
  bvec_ptr result;
  bvec_ptr ebits; /* Holds exponent bits */
  bvec_ptr m1 = int_const(-1);
  op_ptr sign;
  op_ptr sticky = zero();
  op_ptr fracb, lsb;
  op_ptr renormalize;

  int i;
  if (new_wsize != FLOAT_SIZE) {
    fprintf(ERRFILE, "Error: Unexpected floating point size %d\n", new_wsize);
    exit(1);
  }
  /* Set the sign bit */
  if (isunsigned) {
    sign = zero();
  } else {
    sign = val->bits[WSIZE-1];
    /* Get absolute value of val */
    val = int_mux(sign, int_negate(val), val);
  }
  /* Initialize the exponent bits */
  ebits = uint_const(BIAS + WSIZE - 1);
  /* Normalize to put 1 in MSB of val */
  for (i = 0; i < WSIZE; i++) {
    op_ptr msb = val->bits[WSIZE-1];
    ebits = int_mux(msb, ebits, int_add(ebits, m1));
    val = int_mux(msb, val, lshift(val, 1));
  }
  /* Possibly zero */
  ebits = int_mux(val->bits[WSIZE-1], ebits, uint_const(0));
  /* Remove implied one */
  val->bits[WSIZE-1] = zero();
  /* Collect sticky bit */
  for (i = 0; i < (WSIZE-FLOAT_SIZE) + EXP_SIZE - 1; i++) {
    sticky = or_op(sticky, val->bits[i]);    
  }
  fracb = val->bits[i];
  lsb = val->bits[i+1];
  /* Now start building fraction */
  result = rshift(val, (WSIZE-FLOAT_SIZE) + EXP_SIZE, 0);
  /* Round */
  result = int_add(result, bool2int(and_op(fracb, or_op(sticky, lsb))));
  /* May need to renormalize */
  renormalize = result->bits[FRAC_SIZE];
  result->bits[FRAC_SIZE] = zero();
  ebits = int_mux(renormalize, int_add(ebits, int_const(1)), ebits);
  result = int_mux(renormalize, rshift(result, 1, 0), result);
  /* Insert exponent & sign bits */
  for (i = 0; i < EXP_SIZE; i++)
    result->bits[i+FRAC_SIZE] = ebits->bits[i];
  result->bits[FLOAT_SIZE - 1] = sign;
  for (i = FLOAT_SIZE; i < WSIZE; i++)
    result->bits[i] = zero();
  return result;
}

/*
  Conversion from float to unsigned integer.  Experiments show that
  overflow handled as modular arithmetic.  Simply want lower new_wsize
  bits of the integer value.
*/
static bvec_ptr cvt_float_unsigned(bvec_ptr val, int old_wsize, int new_wsize)
{
  bvec_ptr ebits;
  bvec_ptr frac;
  bvec_ptr shiftr, shiftl;
  bvec_ptr result;
  op_ptr shiftup;
  op_ptr rtzero; /* Round to zero */
  op_ptr otzero; /* Overflow to zero */
  op_ptr sign = val->bits[FLOAT_SIZE - 1];
  int i;
  if (old_wsize != FLOAT_SIZE) {
    fprintf(ERRFILE, "Error: Incorrect float size %d\n", old_wsize);
    exit(1);
  }
  ebits = mask_size(rshift(val, FRAC_SIZE, 0), EXP_SIZE, 1);
  /* Move fraction to high end of word */
  frac = lshift(val, WSIZE-FRAC_SIZE-1);
  /* Add leading one bit */
  frac->bits[WSIZE-1] = one();
  /* Shift right into appropriate place */
  shiftr = int_add(int_negate(ebits), int_const(BIAS+WSIZE-1));
  /* If shift more than word size, want to zero out fraction */
  rtzero = int_lt(int_const(WSIZE-1), shiftr);
  shiftup = int_lt(shiftr, int_const(0));
  frac = int_mux(rtzero, int_const(0), frac);
  shiftr = int_mux(or_op(shiftup, rtzero), int_const(0), shiftr);
  frac = int_shiftrightlogical(frac, shiftr, WSIZE);
  /* Shift left into appropriate place */
  shiftl = int_mux(shiftup, int_negate(shiftr), int_const(0));
  /* Overflow to zero when left shift more than word size */
  otzero = int_lt(int_const(WSIZE-1), shiftl);
  shiftl = int_mux(otzero, int_const(0), shiftl);
  frac = int_mux(otzero, int_const(0), frac);
  frac = int_shiftleft(frac, shiftl, WSIZE);
  /* Negate if sign = 1 */
  result = int_mux(sign, int_negate(frac), frac);
  /* Zero out high order bits */
  for (i = new_wsize; i < WSIZE; i++)
    result->bits[i] = zero();
  return result;
}

/** Conversion from float to signed integer */
static bvec_ptr cvt_float_int(bvec_ptr val, int old_wsize, int new_wsize)
{
  bvec_ptr result;
  bvec_ptr ebits;
  bvec_ptr frac;
  bvec_ptr shift;
  bvec_ptr ovf_val;
  bvec_ptr max_val = int_const((1LLU << (new_wsize-1)) - 1);
  bvec_ptr min_val = int_negate(int_const(1LLU << (new_wsize-1)));
  int i;

  op_ptr rtzero;
  op_ptr sign = val->bits[FLOAT_SIZE - 1];
  op_ptr ovf;
  op_ptr sbit;
  if (old_wsize != FLOAT_SIZE) {
    fprintf(ERRFILE, "Error: Incorrect float size %d\n", old_wsize);
    exit(1);
  }
  ebits = mask_size(rshift(val, FRAC_SIZE, 0), EXP_SIZE, 1);
  /* Move fraction to high end of word */
  frac = lshift(val, WSIZE-FRAC_SIZE-1);
  /* Add leading one bit */
  frac->bits[WSIZE-1] = one();
  /* Shift into appropriate place */
  shift = int_add(int_negate(ebits), int_const(BIAS+WSIZE-1));
  /* If shift more than wordsize, want to zero out fraction */
  rtzero = int_lt(int_const(WSIZE-1), shift);
  frac = int_mux(rtzero, int_const(0), frac);
  ovf = int_lt(shift, int_const(0));
  shift = int_mux(or_op(rtzero, ovf), int_const(0), shift);
  frac = int_shiftrightlogical(frac, shift, WSIZE);
  ovf_val = uint_const(1ULL << (new_wsize-1));
  frac = int_mux(sign, int_negate(frac), frac);
  ovf = or_op(ovf, or_op(int_lt(max_val, frac), int_lt(frac, min_val)));
  result = int_mux(ovf, ovf_val, frac);
  /* Sign extension */
  sbit = result->bits[new_wsize-1];
  for (i = new_wsize; i < WSIZE; i++)
    result->bits[i] = sbit;
  return result;
}

/* Cast data to a different data type */
bvec_ptr change_type(bvec_ptr val, int old_wsize, data_t old_dtype,
		     int new_wsize, data_t new_dtype)
{
  bvec_ptr result;
  op_ptr fill_bit;
  int i;
  int_op_cnt++;
  if (old_dtype == DATA_FLOAT  && new_dtype != DATA_FLOAT) {
    if (new_dtype == DATA_UNSIGNED)
      return cvt_float_unsigned(val, old_wsize, new_wsize);
    else
      return cvt_float_int(val, old_wsize, new_wsize);
  } else if (old_dtype != DATA_FLOAT && new_dtype == DATA_FLOAT)
    return cvt_to_float(val, new_wsize, old_dtype == DATA_UNSIGNED);
  result = new_vec();
  if (old_dtype == DATA_FLOAT && new_dtype == DATA_FLOAT) {
    if (old_wsize != new_wsize) {
      fprintf(ERRFILE, "Error.  Incompatible floating point word sizes.  Old = %d, New = %d\n", old_wsize, new_wsize);
      exit(1);
    }
    for (i = 0; i < new_wsize; i++)
      result->bits[i] = val->bits[i];
  }
  /* These are just integer conversions */
  else if (new_wsize <= old_wsize) {
    for (i = 0; i < new_wsize; i++)
      result->bits[i] = val->bits[i];
  } else {
    fill_bit = old_dtype != DATA_SIGNED ? zero() : val->bits[old_wsize-1];
    for (i = 0; i < old_wsize; i++)
      result->bits[i] = val->bits[i];
    for (i = old_wsize; i < new_wsize; i++)
      result->bits[i] = fill_bit;
  }
  fill_bit = new_dtype != DATA_SIGNED ? zero() : result->bits[new_wsize-1];
  for (i = new_wsize; i < WSIZE; i++) {
    result->bits[i] = fill_bit;
  }
  return result;
}

bvec_ptr mask_size(bvec_ptr val, int wsize, int isunsigned)
{
    bvec_ptr result = new_vec();
    op_ptr fill_bit = zero();
    int i;
    int_op_cnt++;
    for (i = 0; i < wsize; i++)
      result->bits[i] = val->bits[i];
    if (!isunsigned)
	fill_bit = val->bits[wsize-1];
    for (i = wsize; i < WSIZE; i++) {
	result->bits[i] = fill_bit;
    }
    return result;
}

/* Create unsigned byte by little endian order */
bvec_ptr extract_byte(bvec_ptr val, int offset)
{
  int i;
  int s = CSIZE*offset;
  bvec_ptr sval = rshift(val, s, 0);
  int_op_cnt++;
  for (i = CSIZE; i < WSIZE; i++)
    sval->bits[i] = zero();
  return sval;
}

/* Replace selected byte within word */
bvec_ptr replace_byte(bvec_ptr word, bvec_ptr byte, int offset)
{
  int i;
  int s = offset * CSIZE;
  bvec_ptr result = new_vec();
  int_op_cnt++;
  for (i = 0; i < WSIZE; i++)
    result->bits[i] = word->bits[i];
  for (i = 0; i < CSIZE; i++)
    result->bits[i+s] = byte->bits[i];
  return result;
}

op_ptr get_sign(bvec_ptr v)
{
  return v->bits[FLOAT_SIZE-1];
}

static bvec_ptr get_exp(bvec_ptr v)
{
  bvec_ptr result = rshift(v, FRAC_SIZE, 0);
  /* Mask sign bit */
  result = int_and(result, int_const(EXP_MASK));
  return result;
}

static bvec_ptr get_frac(bvec_ptr v)
{
  bvec_ptr result = int_and(v, uint_const(FRAC_MASK));
  return result;
}

static op_ptr is_nan(bvec_ptr exp, bvec_ptr frac)
{
  return and_op(int_eq(exp, uint_const(EXP_MASK)),
		int_isnonzero(frac));
}

static op_ptr is_inf(bvec_ptr exp, bvec_ptr frac)
{
  return and_op(int_eq(exp, uint_const(EXP_MASK)),
		not_op(int_isnonzero(frac)));
}

static bvec_ptr pack_float(op_ptr sign, bvec_ptr exp, bvec_ptr frac)
{
  bvec_ptr result;
  frac = int_and(int_const(FRAC_MASK), frac);
  exp = int_and(int_const(EXP_MASK), exp);
  result = int_or(frac, lshift(exp, FRAC_SIZE));
  result->bits[FLOAT_SIZE-1] = sign;
  return result;
}

bvec_ptr float_fix_nan(bvec_ptr v)
{
  bvec_ptr frac = get_frac(v);
  bvec_ptr exp = get_exp(v);
  op_ptr nan = is_nan(exp, frac);
  bvec_ptr result = int_mux(nan, uint_const(QNAN_VAL), v);
  return result;
}

bvec_ptr float_isnan(bvec_ptr v)
{
  bvec_ptr frac = get_frac(v);
  bvec_ptr exp = get_exp(v);
  op_ptr val = is_nan(exp, frac);
  return bool2int(val);
}

/* Floating point operations */
bvec_ptr float_negate(bvec_ptr v)
{
  bvec_ptr mask = uint_const(1u<<(FLOAT_SIZE-1));
  bvec_ptr result = int_xor(v, mask);
  return float_fix_nan(result);
}

op_ptr float_eq(bvec_ptr v1, bvec_ptr v2)
{
  bvec_ptr frac1 = get_frac(v1);
  bvec_ptr exp1 = get_exp(v1);
  op_ptr nan1 = is_nan(exp1, frac1);
  op_ptr zero1 = not_op(or_op(int_isnonzero(frac1), int_isnonzero(exp1)));

  bvec_ptr frac2 = get_frac(v2);
  bvec_ptr exp2 = get_exp(v2);
  op_ptr nan2 = is_nan(exp2, frac2);
  op_ptr zero2 = not_op(or_op(int_isnonzero(frac2), int_isnonzero(exp2)));

  op_ptr result =
      and_op(not_op(or_op(nan1, nan2)), // One of the arguments is NaN
	     or_op(and_op(zero1, zero2), // Both are 0
		   int_eq(v1, v2))); // Integer equality
  return result;
}

op_ptr float_lt(bvec_ptr v1, bvec_ptr v2)
{
  bvec_ptr frac1 = get_frac(v1);
  bvec_ptr exp1 = get_exp(v1);
  op_ptr sign1 = get_sign(v1);
  op_ptr nan1 = is_nan(exp1, frac1);
  op_ptr zero1 = not_op(or_op(int_isnonzero(frac1), int_isnonzero(exp1)));

  bvec_ptr frac2 = get_frac(v2);
  bvec_ptr exp2 = get_exp(v2);
  op_ptr sign2 = get_sign(v2);
  op_ptr nan2 = is_nan(exp2, frac2);
  op_ptr zero2 = not_op(or_op(int_isnonzero(frac2), int_isnonzero(exp2)));

  op_ptr result =
    and_op(not_op(or_op(or_op(nan1, nan2),      // One of the arguments is NaN
			and_op(zero1, zero2))), // Both are zeros
	   or_op(and_op(sign1, not_op(sign2)),  // v1 <= 0, v2 >= 0
		 and_op(not_op(xor_op(sign1, sign2)), // Both same sign and ...
			int_ult(v1, v2))));            //  v1 < v2 with unsigned comparison
  return result;
}

bvec_ptr float_mult(bvec_ptr v1, bvec_ptr v2)
{
  op_ptr sign1 = get_sign(v1);
  bvec_ptr exp1 = get_exp(v1);
  bvec_ptr frac1 = get_frac(v1);
  op_ptr sign2 = get_sign(v2);
  bvec_ptr exp2 = get_exp(v2);
  bvec_ptr frac2 = get_frac(v2);

  /* To hold computed product */
  op_ptr sign = xor_op(sign1, sign2);
  bvec_ptr exp = uint_const(0);
  bvec_ptr new_exp;
  bvec_ptr frac = uint_const(0);
  /* Handle special cases */
  op_ptr is_nan1 = is_nan(exp1, frac1);
  op_ptr is_nan2 = is_nan(exp2, frac2);
  op_ptr is_inf1 = is_inf(exp1, frac1);
  op_ptr is_inf2 = is_inf(exp2, frac2);
  op_ptr is_zero1 = not_op(or_op(int_isnonzero(exp1), int_isnonzero(frac1)));
  op_ptr is_zero2 = not_op(or_op(int_isnonzero(exp2), int_isnonzero(frac2)));
  op_ptr done = zero();

  /* NaN * anything, anything * NaN */
  {
    op_ptr either_nan = or_op(is_nan1, is_nan2);
    exp = int_mux(done, exp, int_const(EXP_MASK));
    frac = int_mux(done, frac, int_const(QNAN_FRAC));
    sign = ite_op(either_nan, zero(), sign);
    done = or_op(done, either_nan);
  }
  /* Infinity * 0 or 0 * infinity */
  {
    op_ptr iz = and_op(is_inf1, is_zero2);
    op_ptr zi = and_op(is_inf2, is_zero1);
    op_ptr new_nan = or_op(iz, zi);
    exp = int_mux(done, exp, uint_const(EXP_MASK));
    frac = int_mux(done, frac, int_const(QNAN_FRAC));
    sign = ite_op(new_nan, zero(), sign);
    done = or_op(done, new_nan);
  }
  /* Infinity * anything */
  {
    exp = int_mux(done, exp, exp1);
    frac = int_mux(done, frac, frac1);
    done = or_op(done, is_inf1);
  }
  /* Anything * Infinity */
  {
    exp = int_mux(done, exp, exp2);
    frac = int_mux(done, frac, frac2);
    done = or_op(done, is_inf2);
  }
  /* Zero * Anything */
  {
    exp = int_mux(done, exp, exp1);
    frac = int_mux(done, frac, frac1);
    done = or_op(done, is_zero1);
  }
  /* Anything * Zero */
  {
    exp = int_mux(done, exp, exp2);
    frac = int_mux(done, frac, frac2);
    done = or_op(done, is_zero2);
  }
  /* Normal computation */
  {
    /* Unbiased exponents */
    op_ptr norm1 = int_isnonzero(exp1);
    op_ptr norm2 = int_isnonzero(exp2);
    bvec_ptr uexp1 = int_mux(norm1,
			     int_add(exp1, int_const(-BIAS)),
			     int_const(1-BIAS));
    bvec_ptr uexp2 = int_mux(norm2,
			     int_add(exp2, int_const(-BIAS)),
			     int_const(1-BIAS));
    bvec_ptr uexp;
    bvec_ptr prod;
    int i;
    /* Prepare arguments to be normalized with 1 in bit position FRAC_SIZE */
    /* Insert leading 1 if normalized */
    frac1 = int_or(frac1, lshift(bool2int(norm1), FRAC_SIZE));
    /* For denormalized, shift left until normalized */
    for(i = 0; i < FRAC_SIZE; i++) {
      frac1 = int_mux(norm1, frac1, lshift(frac1, 1));
      uexp1 = int_mux(norm1, uexp1, int_add(uexp1, int_const(-1)));
      norm1 = or_op(norm1, frac1->bits[FRAC_SIZE]);
    }
    /* Insert leading 1 if normalized */
    frac2 = int_or(frac2, lshift(bool2int(norm2), FRAC_SIZE));    
    /* For denormalized, shift left until normalized */
    for(i = 0; i < FRAC_SIZE; i++) {
      frac2 = int_mux(norm2, frac2, lshift(frac2, 1));
      uexp2 = int_mux(norm2, uexp2, int_add(uexp2, int_const(-1)));
      norm2 = or_op(norm2, frac2->bits[FRAC_SIZE]);
    }
    /* Multiply the two products */
    prod = int_mult(frac1, frac2);
    uexp = int_add(int_add(uexp1, uexp2), int_const(1));
    /* Shift to get 1 bit in MSB of 2*FRAC_SIZE-bit product */
    {
      op_ptr shift_up = not_op(prod->bits[2*FRAC_SIZE+1]);
      prod = int_mux(shift_up, lshift(prod, 1), prod);
      uexp = int_add(uexp, int_negate(bool2int(shift_up)));
    }
    /* Handle overflow / underflow */
    {
      new_exp = int_add(uexp, int_const(BIAS));
      op_ptr ovf = int_le(int_const(EXP_MASK), new_exp);
      op_ptr udf = int_lt(new_exp, int_const(-FRAC_SIZE));
      exp = int_mux(done, exp, int_const(EXP_MASK));
      frac = int_mux(done, frac, int_const(0));
      done = or_op(done, ovf);
      exp = int_mux(done, exp, int_const(0));
      frac = int_mux(done, frac, int_const(0));
      done = or_op(done, udf);
    }
    /* Round result */
    {
      bvec_ptr lsbpos = int_mux(int_le(new_exp, int_const(0)),
				int_add(int_negate(new_exp), int_const(FRAC_SIZE+2)),
				int_const(FRAC_SIZE+1));
      bvec_ptr fracpos = int_add(lsbpos, int_const(-1));
      bvec_ptr stickymask = int_add(int_shiftleft(int_const(1), fracpos, WSIZE), int_const(-1));
      bvec_ptr sprod = int_shiftrightlogical(prod, lsbpos, WSIZE);
      op_ptr lsb = sprod->bits[0];
      op_ptr fbit = int_shiftrightlogical(prod, fracpos, WSIZE)->bits[0];
      op_ptr sticky = int_isnonzero(int_and(prod, stickymask));
      op_ptr round = and_op(fbit, or_op(lsb, sticky));
      op_ptr shiftdown, makenorm;
      prod = sprod;
      prod = int_add(prod, bool2int(round));
      /* Rounding causes overflow into FRAC_SIZE+1 */
      shiftdown = prod->bits[FRAC_SIZE+1];
      prod = int_mux(shiftdown, rshift(prod, 1, 0), prod);
      new_exp = int_add(new_exp, bool2int(shiftdown));
      /* Take care of case when rounding converted denorm. to norm. */
      makenorm = and_op(int_le(new_exp, int_const(0)), prod->bits[FRAC_SIZE]);
      new_exp = int_mux(makenorm, int_const(1), new_exp);
    }
    /* Prepare final value */
    {
      op_ptr ovf = int_le(int_const(EXP_MASK), new_exp);
      op_ptr denormalize = int_le(new_exp, int_const(0));
      exp = int_mux(done, exp, int_const(EXP_MASK));
      frac = int_mux(done, frac, int_const(0));
      done = or_op(done, ovf);
      exp = int_mux(done, exp, int_const(0));
      frac = int_mux(done, frac, prod);
      done = or_op(done, denormalize);
      /* Knock off leading one */
      prod->bits[FRAC_SIZE] = zero();
      exp = int_mux(done, exp, new_exp);
      frac = int_mux(done, frac, prod);
    }
  }
  /* Assemble final result */
  return pack_float(sign, exp, frac);
}


op_ptr int_eq(bvec_ptr vec1, bvec_ptr vec2)
{
  op_ptr nresult = zero();
  int i;
#if 0  
  printf("Comparing vectors:  \n");
  bvec_display(stdout, vec1);
  printf("\n  ");
  bvec_display(stdout, vec2);
  printf("\n  ");  
#endif
  int_op_cnt++;
  for (i = 0; i < WSIZE; i++) {
    op_ptr bit1 = vec1->bits[i];
    op_ptr bit2 = vec2->bits[i];
    nresult = or_op(nresult, xor_op(bit1, bit2));
#if 0
    printf("result = ");
    expr_display(stdout, nresult, 1);
    printf("\n");
#endif
  }
  return not_op(nresult);
}

op_ptr int_lt(bvec_ptr vec1, bvec_ptr vec2)
{
  op_ptr result = zero();
  int i;
  op_ptr bit1;
  op_ptr bit2;
  int_op_cnt++;
  for (i = 0; i < WSIZE-1; i++) {
    bit1 = vec1->bits[i];
    bit2 = vec2->bits[i];
    result = or_op(and_op(not_op(bit1), bit2),
		   and_op(result, not_op(xor_op(bit1, bit2))));
  }
  /* Now we have the sign bit */
  bit1 = vec1->bits[WSIZE-1];
  bit2 = vec2->bits[WSIZE-1];
  result = or_op(and_op(bit1, not_op(bit2)),
		 and_op(result, not_op(xor_op(bit1, bit2))));
  return result;
}

op_ptr int_le(bvec_ptr vec1, bvec_ptr vec2)
{
  op_ptr result = one();
  int i;
  op_ptr bit1;
  op_ptr bit2;
  int_op_cnt++;
  for (i = 0; i < WSIZE-1; i++) {
    bit1 = vec1->bits[i];
    bit2 = vec2->bits[i];
    result = or_op(and_op(not_op(bit1), bit2),
		   and_op(result, not_op(xor_op(bit1, bit2))));
  }
  /* Now we have the sign bit */
  bit1 = vec1->bits[WSIZE-1];
  bit2 = vec2->bits[WSIZE-1];
  result = or_op(and_op(bit1, not_op(bit2)),
		 and_op(result, not_op(xor_op(bit1, bit2))));
  return result;
}

op_ptr int_ult(bvec_ptr vec1, bvec_ptr vec2)
{
  op_ptr result = zero();
  int i;
  op_ptr bit1;
  op_ptr bit2;
  int_op_cnt++;
  for (i = 0; i < WSIZE; i++) {
    bit1 = vec1->bits[i];
    bit2 = vec2->bits[i];
    result = or_op(and_op(not_op(bit1), bit2),
		   and_op(result, not_op(xor_op(bit1, bit2))));
  }
  return result;
}

op_ptr int_ule(bvec_ptr vec1, bvec_ptr vec2)
{
  op_ptr result = one();
  int i;
  op_ptr bit1;
  op_ptr bit2;
  int_op_cnt++;
  for (i = 0; i < WSIZE; i++) {
    bit1 = vec1->bits[i];
    bit2 = vec2->bits[i];
    result = or_op(and_op(not_op(bit1), bit2),
		   and_op(result, not_op(xor_op(bit1, bit2))));
  }
  return result;
}

op_ptr int_isnonzero(bvec_ptr vec)
{
  int i = 0;
  op_ptr result = zero();
  int_op_cnt++;
  for (i = 0; i < WSIZE; i++)
    result = or_op(result, vec->bits[i]);
  return result;
}

/********************** Output Generation ***********************************/
void show_const(FILE *fp, bvec_ptr v, int wsize, int isunsigned)
{
  char bitstring[WSIZE+1];
  int i;
  int val = 0;
  int val_ok = 1;
  for (i = 0; i < wsize; i++) {
    if (v->bits[i] == zero()) {
      bitstring[i] = '0';
    } else if (v->bits[i] == one()) {
      bitstring[i] = '1';
      if (isunsigned || i < wsize-1)
	val = val + (1<<i);
      else
	val = val - (1<<i);
    } else {
      bitstring[i] = 'X';
      val_ok = 0;
    }
  }
  bitstring[wsize] = 0;
  if (!val_ok)
    fprintf(fp, "[%s]", bitstring);
  if (isunsigned)
    fprintf(fp, "%uu", val);
  else
    fprintf(fp, "%d", val);
}


/* Generic DFS traversal of network.  Give functions pre_funct and
   post_funct to actually do things */
typedef void (*node_fun_t)(op_ptr, int);

static void df_traverse(op_ptr arg, int invert,	node_fun_t post_fun)
{
  int i;
  int nargs = arg->nargs;
  if (!arg)
    return;
  if (arg->pass == curr_pass)
    return;
  op_cnt++;
  for (i = 0; i < nargs; i++)
#if 0
      df_traverse(arg->args[i], arg->invert_args[i], post_fun);
#else
      df_traverse(arg->args[i], 0, post_fun);
#endif
  post_fun(arg, invert);
  arg->pass = curr_pass;
}

/* Assign CNF vars, count clauses & vars */
int nvars = 0;
int nclauses = 0;

/* Output file for CNF */
FILE *outfp;

/* Assign IDs to primary inputs */
static void label_pis()
{
  int i;
  for (i = 0; i < bpi_cnt; i++) {
    op_ptr arg = bpi_buf[i];
    arg->output_id = ++nvars;
    if (arg->name)
      fprintf(outfp, "c BPI %d %s\n", nvars, arg->name);
  }
  for (i = 0; i < ipi_cnt; i++) {
    bvec_ptr vec = ipi_buf[i].val;
    char *name = ipi_buf[i].name;
    int wsize = ipi_buf[i].wordsize;
    int isunsigned = ipi_buf[i].dtype == DATA_UNSIGNED;
    int j;
    fprintf(outfp, "c IPI %s ", name);
    for (j = 0; j < wsize; j++) {
      int id = vec->bits[j]->output_id;
      fprintf(outfp, "%d%s", j < wsize-1 || isunsigned ? id : -id,
	      j < wsize-1 ? ":" : "");
    }
    fprintf(outfp, "\n");
  }
}

/* Function used in pass that gets ready to generate CNF */
static void setup_cnf(op_ptr arg, int invert)
{
  switch(arg->op) {
  case OP_AND:
    arg->output_id = ++nvars;
    nclauses +=  1 + arg->nargs;
    break;
  case OP_XOR:
    arg->output_id = ++nvars;
    nclauses += (1 << arg->nargs);
    break;
  case OP_PI:
  case OP_IPI:
    /* Already handled in previous pass */
    break;
  case OP_ZERO:
  case OP_BUF:
    /* Should not happen. Fall through to error */
  default:
    fprintf(ERRFILE, "Error. Unexpected case in CNF generation\n");
    fprintf(ERRFILE, "Creation ID = %d, Operation = %d\n",
	    arg->creation_id, arg->op);
    break;
  }
}

/* Return decimal representation of node, possibly with inversion */
static int get_own_id(op_ptr arg, int invert)
{
  int id = arg->output_id;
  if (invert)
    id = -id;
  return id;
}

/* Return decimal representation of argument i literal, including inversions */
static int get_arg_id(op_ptr arg, int i, int invert)
{
  return get_own_id(arg->args[i], invert ^ arg->invert_args[i]);
}

/* Determine whether number has odd number of one's */
static int oddcount(unsigned x)
{
  int result = 0;
  while (x) {
    result ^= (x & 0x1);
    x >>= 1;
  }
  return result;
}

/* Generate local clauses for given operation, possibly with output inversion */
static void gen_op_clauses(op_ptr arg, int invert)
{
  int i, code, codelen, nargs;
  switch(arg->op) {
  case OP_AND:
    /* Spit out the big disjunct */
    for (i = 0; i < arg->nargs; i++)
      fprintf(outfp, "%d ", get_arg_id(arg, i, 1));
    fprintf(outfp, "%d 0\n", get_own_id(arg, invert));
    /* All the clauses of size two */
    for (i = 0; i < arg->nargs; i++) {
      fprintf(outfp, "%d %d 0\n", get_arg_id(arg, i, 0),
	      get_own_id(arg, !invert));
    }
    break;
  case OP_XOR:
    /* Must generate all clauses in which there are an odd number of 1's */
    nargs = arg->nargs;
    codelen = 1 << (nargs+1);
    for (code = 0; code < codelen; code++) {
      int invert_out = (code >> nargs) & 0x1;
      if (oddcount(code)) {
	for (i = 0; i < nargs; i++)
	  fprintf(outfp, "%d ", get_arg_id(arg, i, (code >> i) & 0x1));
	fprintf(outfp, "%d 0\n",
		get_own_id(arg, invert ^ invert_out));

      }
    }
    break;
  case OP_PI:
  case OP_IPI:
    /* Don't do anything here */
    break;
  case OP_ZERO:
  case OP_BUF:
    /* Should only happen at top level.  Fall through to error */
  default:
    fprintf(ERRFILE, "Error. Unexpected case in clause generation\n");
    fprintf(ERRFILE, "Creation ID = %d, Operation = %d\n",
	    arg->creation_id, arg->op);
    break;
  }
}

/* Generate CNF description of netlist */
void gen_cnf(FILE *fp, FILE *info_fp, op_ptr arg)
{
  int invert = 0;
  outfp = fp;
  if (!arg)
    return;
  /* Make first pass to assign output ids to PIs */
  nvars = 0;
  label_pis();
  if (arg->op == OP_BUF) {
    /* Remove top level inverter */
    invert = arg->invert_args[0];
    arg = arg->args[0];
  }
  switch (arg->op) {
    /* Handle special cases here */
  case OP_ZERO:
    if (invert) {
      /* Trivially satisfiable */
      fprintf(fp, "c tautology\n");
      fprintf(fp, "p cnf 1 1\n");
      fprintf(fp, "1 -1 0\n");
      fprintf(info_fp, "PI Vars: %d, CNF Vars: 0, CNF Clauses: 0\n", bpi_cnt);
      return;
    } else {
      /* Unsatisifable */
      fprintf(fp, "c unsatisfiable\n");
      fprintf(fp, "p cnf 1 2\n");
      fprintf(fp, "1 0\n");
      fprintf(fp, "-1 0\n");
      fprintf(info_fp, "PI Vars: %d, CNF Vars: 0, CNF Clauses: 1\n", bpi_cnt);
      return;
    }
  case OP_PI:
  case OP_IPI:
    if (arg->name)
      fprintf(fp, "c BPI 1 %s\n", arg->name);
    fprintf(fp, "p cnf 1 1\n");
    fprintf(fp, "%d 0\n", invert ? -1 : 1);
    return;
  default:
    break;
    /* Rest of them require traversal */
  }
  /* Make second pass to assign remaining output ids and compute counts */
  nclauses = 1;
  curr_pass++;
  df_traverse(arg, invert, setup_cnf);
  /* Generate header information */
  fprintf(outfp, "p cnf %d %d\n", nvars, nclauses);
  /* Make second pass to generate actual CNF */
  curr_pass++;
  op_cnt = 0;
  df_traverse(arg, invert, gen_op_clauses);
  /* Make final result true */
  if (arg->op != OP_ZERO)
    fprintf(outfp, "%d 0\n", get_own_id(arg, 0));
  fprintf(info_fp, "Integer Ops: %d\n",
	  int_op_cnt);
  fprintf(info_fp, "PI Vars: %d, Boolean Ops: %d\n",
	  bpi_cnt, op_cnt);
  fprintf(info_fp, "CNF Vars: %d, CNF Clauses: %d\n",
	  nvars, nclauses);
}

/** Solution using BDDs **/

/* Keep track of information to perform sequence of BDD operations */
typedef struct {
    /* Expression representation */
    op_ptr arg;
    /* BDD representation */
    DdNode *bdd_val;
    /* Position in eval_buf of last evaluation using this as argument */
    int lastuse;
    int satval;
} eval_ele, *eval_ptr;

/* BDD Manager */
static DdManager *bdd_manager;
int maxindex = 0;

/* Buffer of evaluations, in some valid evaluation order */
static eval_ele *eval_buf = NULL;
static int eval_cnt = 0;
static int eval_acount = 0;

/* Assign Generate evaluation information for PIs */
static void pi_vars()
{
  int i, j, w;
  for (i = 0; i < bpi_cnt; i++) {
    op_ptr arg = bpi_buf[i];
    if (arg->op != OP_PI)
	/* This will skip over bits that are part of integer words */
	continue;
    if (nvars >= eval_acount) {
	eval_acount *= 2;
	eval_buf = realloc(eval_buf, eval_acount * sizeof(eval_ele));
    }
    eval_buf[nvars].arg = arg;
    eval_buf[nvars].bdd_val = NULL;
    eval_buf[nvars].lastuse = nvars;
    eval_buf[nvars].satval = 0;
    arg->output_id = nvars;
    nvars++;
  }
  /* Do multiple passes through integer pis.  In each one, pick up
     PIs having word size within 8 bit range.
     Within each pass, interleave the bits, from MSB to LSB
  */
  for (w = 0; w <= WSIZE; w+=8) {
    for (j = w-1; j >= 0; j--) {
      for (i = 0; i < ipi_cnt; i++) {
	bvec_ptr vec = ipi_buf[i].val;
	int wsize = ipi_buf[i].wordsize;
	if (w-8 < wsize && wsize <= w && j < wsize) {
	  op_ptr arg = vec->bits[j];
	  if (nvars >= eval_acount) {
	    eval_acount *= 2;
	    eval_buf = realloc(eval_buf, eval_acount * sizeof(eval_ele));
	  }
	  eval_buf[nvars].arg = arg;
	  eval_buf[nvars].bdd_val = NULL;
	  eval_buf[nvars].lastuse = nvars;
	  eval_buf[nvars].satval = 0;
	  arg->output_id = nvars;
	  nvars++;
	}
      }
    }
  }
}

/* Function used in pass to generate buffer of BDD evaluations */
static void setup_eval(op_ptr arg, int invert)
{
    int i;
    if (arg->op == OP_PI || arg->op == OP_IPI)
      /* Already handled these */
      return;
    if (eval_cnt >= eval_acount) {
      eval_acount *= 2;
      eval_buf = realloc(eval_buf, eval_acount * sizeof(eval_ele));
    }
    eval_buf[eval_cnt].arg = arg;
    eval_buf[eval_cnt].bdd_val = NULL;
    eval_buf[eval_cnt].lastuse = eval_cnt;
    eval_buf[eval_cnt].satval = 0;
    arg->output_id = eval_cnt;
    for (i = 0; i < arg->nargs; i++) {
      op_ptr argarg = arg->args[i];
      eval_buf[argarg->output_id].lastuse = eval_cnt;
    }
    eval_cnt++;
}

/* Print solution based on satvals in eval_buf */
static void show_sat_val(FILE *fp)
{
    int i;
    for (i = 0; i < bpi_cnt; i++) {
	op_ptr arg = eval_buf[i].arg;
	if (arg->op == OP_PI) {
	    int bitval = eval_buf[arg->output_id].satval;
	    fprintf(fp, "%s:%d\n", arg->name, bitval);
	}
    }
    for (i = 0; i < ipi_cnt; i++) {
	int j;
	int val = 0;
	bvec_ptr vec = ipi_buf[i].val;
	int wsize = ipi_buf[i].wordsize;
	int isunsigned = ipi_buf[i].dtype == DATA_UNSIGNED;
	for (j = 0; j < wsize; j++) {
	    int bitval = eval_buf[vec->bits[j]->output_id].satval;
	    val += (1<<j) * (j < wsize-1 || isunsigned ? 1 : -1) * bitval;
	}
	if (isunsigned)
	    fprintf(fp, "%s:%u\n", ipi_buf[i].name, val);
	else 
	    fprintf(fp, "%s:%d\n", ipi_buf[i].name, val);
    }
}

/* Generate satisfying solution using BDDs.  Optionally print result to file.
 Return 1 iff satisfiable */
int gen_solve(FILE *fp, op_ptr arg)
{
    int i;
    int invert = 0;
    DdNode *result, *nresult;
    int satisfiable = 1;
    if (!arg) {
	fprintf(ERRFILE,
		"Error.  Trying to generate BDD from NULL operation\n");
	exit(1);
    }
    /* Initialize things */
    eval_acount = 64;
    eval_buf = calloc(eval_acount, sizeof(eval_ele));
    eval_cnt = 0;
    /* Assign output ids to PIs */
    nvars = 0;
    maxindex = 0;
    pi_vars();
    eval_cnt = nvars;
    curr_pass++;
    op_cnt = 0;
    df_traverse(arg, invert, setup_eval);
    /* Now have an evaluation buffer.  Let's evaluate it */
    bdd_manager = Cudd_Init(nvars,0,CUDD_UNIQUE_SLOTS,CUDD_CACHE_SLOTS,0);
    for (i = 0; i < eval_cnt; i++) {
	int j;
	op_ptr arg = eval_buf[i].arg;
	int index;
	switch (arg->op) {
	case OP_PI:
	case OP_IPI:
 	    result = Cudd_bddIthVar(bdd_manager, i);
	    Cudd_Ref(result);
	    eval_buf[i].bdd_val = result;
	    
	    index = Cudd_Regular(result)->index;
	    if (index > maxindex)
		maxindex = index;
#if 0
	    printf("%d PI %s%c\n",
		   i, arg->name ? arg->name : "??",
		   eval_buf[arg->output_id].lastuse == arg->output_id ? 'x' : ' ');
#endif
	    break;
	case OP_XOR:
	    result = Cudd_ReadLogicZero(bdd_manager);
	    Cudd_Ref(result);
	    for (j = 0; j < arg->nargs; j++) {
		op_ptr argarg = arg->args[j];
		int invert = arg->invert_args[j];
		DdNode *arg_bdd = eval_buf[argarg->output_id].bdd_val;
		if (invert)
		    arg_bdd = Cudd_Not(arg_bdd);
		nresult = Cudd_bddXor(bdd_manager, result, arg_bdd);
		Cudd_Ref(nresult);
		Cudd_RecursiveDeref(bdd_manager, result);
		result = nresult;
		if (eval_buf[argarg->output_id].lastuse == arg->output_id)
		    Cudd_RecursiveDeref(bdd_manager, arg_bdd);
	    }
	    eval_buf[i].bdd_val = result;
#if 0
	    printf("%d %s", i, "xor");
	    for (j = 0; j < arg->nargs; j++) {
	      op_ptr argarg = arg->args[j];
	      int invert = arg->invert_args[j];
	      printf(" %c%d%c", invert ? '!' : ' ',
		     argarg->output_id,
		     eval_buf[argarg->output_id].lastuse == arg->output_id ? 'x' : ' ');
	    }
	    printf("\n");
#endif
	    break;
	case OP_AND:
	    result = Cudd_ReadOne(bdd_manager);
	    Cudd_Ref(result);
	    for (j = 0; j < arg->nargs; j++) {
		op_ptr argarg = arg->args[j];
		int invert = arg->invert_args[j];
		DdNode *arg_bdd = eval_buf[argarg->output_id].bdd_val;
		if (invert)
		    arg_bdd = Cudd_Not(arg_bdd);
		nresult = Cudd_bddAnd(bdd_manager, result, arg_bdd);
		Cudd_Ref(nresult);
		Cudd_RecursiveDeref(bdd_manager, result);
		result = nresult;
		if (eval_buf[argarg->output_id].lastuse == arg->output_id)
		    Cudd_RecursiveDeref(bdd_manager, arg_bdd);
	    }
	    eval_buf[i].bdd_val = result;
#if 0
	    printf("%d %s", i, "and");
	    for (j = 0; j < arg->nargs; j++) {
	      op_ptr argarg = arg->args[j];
	      int invert = arg->invert_args[j];
	      printf(" %c%d%c", invert ? '!' : ' ',
		     argarg->output_id,
		     eval_buf[argarg->output_id].lastuse == arg->output_id ? 'x' : ' ');
	    }
	    printf("\n");
#endif
	    break;
	case OP_BUF:
	    result = eval_buf[arg->args[0]->output_id].bdd_val;
	    if (arg->invert_args[0])
		result = Cudd_Not(result);
	    Cudd_Ref(result);
	    if (eval_buf[arg->args[0]->output_id].lastuse == arg->output_id)
		Cudd_RecursiveDeref(bdd_manager, result);
	    eval_buf[i].bdd_val = result;
#if 0
	    printf("%d %s", i, "buf");
	    for (j = 0; j < arg->nargs; j++) {
	      op_ptr argarg = arg->args[j];
	      int invert = arg->invert_args[j];
	      printf(" %c%d%c", invert ? '!' : ' ',
		     argarg->output_id,
		     eval_buf[argarg->output_id].lastuse == arg->output_id ? 'x' : ' ');
	    }
	    printf("\n");
#endif
	    break;
	case OP_ZERO:
	    result = Cudd_ReadLogicZero(bdd_manager);
	    Cudd_Ref(result);
	    eval_buf[i].bdd_val = result;
#if 0
	    printf("%d 0\n", i);
#endif
	    break;
	default:
#if 0
	    printf("%d BADOP: %d\n", i, arg->op);
#endif
	    fprintf(ERRFILE, "Error.  Unexpected operation %d encountered\n", arg->op);
	    exit(1);
	}
    }
    /* Get the final BDD */
    result = eval_buf[eval_cnt-1].bdd_val;
    if (result == Cudd_ReadLogicZero(bdd_manager)) {
	if (fp)
	    fprintf(fp, "Unsatisfiable\n");
	satisfiable = 0;
    }
    else {
	char *buf = malloc(sizeof(char) * (maxindex+1));
	if (fp)
	    fprintf(fp, "Satisfiable\n");
	if (Cudd_bddPickOneCube(bdd_manager, result, buf)) {
	    int i;
	    for (i = 0; i < nvars; i++) {
		int index = Cudd_Regular(eval_buf[i].bdd_val)->index;
		if (buf[index] == 2)
		    buf[index] = 0;
		eval_buf[i].satval = buf[index];
	    }
	    if (fp)
		show_sat_val(fp);
	}
	free(buf);
    }
    if (fp) {
      fprintf(fp, "Integer Ops: %d\n", int_op_cnt);
      fprintf(fp, "PI Vars: %d, Boolean Ops: %d\n", bpi_cnt, op_cnt);
    }
#if 0
    Cudd_Quit(bdd_manager);
    free(eval_buf);
#endif
    return satisfiable;
}

/* Dump BDD in BLIF format */
void dump_blif(FILE *fp, int funct_cnt, op_ptr *funct_set, char **funct_names)
{
  char **var_names = calloc(sizeof(char *), bpi_cnt);
  DdNode **funct_bdds = calloc(sizeof(DdNode *), funct_cnt);
  int i, j;
  /* Create variable names */
  for (i = 0; i < bpi_cnt; i++) {
    int cpos;
    char *name = strsave((eval_buf[i].arg)->name + 4); // Skip past prefix 'Arg-'
    /* Convert final '.' to '_' */
    for (cpos = strlen(name); cpos >= 0; cpos--) {
      if (name[cpos] == '.') {
	name[cpos] = '_';
	break;
      }
    }
    var_names[i] = name;
  }
  /* Get the BDDs */
  for (i = 0; i < funct_cnt; i++) {
    for (j = eval_cnt-1; j >= 0; j--) {
      if (eval_buf[j].arg == funct_set[i]) {
	funct_bdds[i] = eval_buf[j].bdd_val;
	break;
      } else if (eval_buf[j].arg == not_op(funct_set[i])) {
	funct_bdds[i] = Cudd_Not(eval_buf[j].bdd_val);
	break;
      }
    }
    if (!funct_bdds[i]) {
      fprintf(ERRFILE, "Error: Couldn't find BDD for output %d\n", i);
      exit(1);
    }
  }
  if (!Cudd_DumpBlif(bdd_manager, funct_cnt, funct_bdds, var_names, funct_names, NULL, fp)) {
    fprintf(ERRFILE, "Error: couldn't dump DAG file\n");
    exit(1);
  }
  free(var_names);
  free(funct_bdds);
}


/* Read in straightline Boolean program
   Formats:
   # ANYTHING              Comment
   ID b [NAME]             Boolean variable
   ID i MAXVAL [NAME]      Integer variable
   ID c VAL                Integer constant
   ID ~ BARG               Complement
   qa BARG                 Universal quantifier
   qe BARG                 Existential quantifier
   ID & BARG1 ... BARGN    And
   ID | BARG1 ... BARGN    Or
   ID ^ BARG1 ... BARGN    Xor
   ID = IARG1 IARG2        Equality
   ID < IARG1 IARG2        Less than
   ID <= IARG1 IARG2       Less than or equal to

   Where:
   ID is sequentially numbered identifier (starting from 1)
   BARG is either ID or -ID, where ID is the ID of a Boolean value
   IARG is the ID of an integer value
*/

#define LINE_LEN 1024
/* Structure to hold results of straightline program */
typedef struct {
    op_ptr boolval;
    bvec_ptr intval;
    int isbool;
} line_ele, *line_ptr;

op_ptr straightline_read(FILE *fp)
{
  int curr_id = 0;
  int line = 0;
  char line_buf[LINE_LEN];
  int acount = 128;
  line_ptr nodes = (line_ptr) calloc(acount, sizeof(line_ele));
  op_ptr result = NULL;
  bvec_ptr iresult = NULL;

  while (fgets(line_buf, LINE_LEN, fp)) {
    char opc;
    char *tok = strtok(line_buf, " \t\n\r");
    int id = 0;
    int isbool = 1;
    line ++;
    if (tok && *tok != '#')
      id = atoi(tok);
    else
	/* Blank or comment line */
	continue;
    curr_id++;
    if (id != curr_id) {
      fprintf(ERRFILE, "Error, line %d: Got ID %d, Expected ID %d\n",
	      line, id, curr_id);
      return NULL;
    }
    tok = strtok(NULL, " \t\n\r");
    /* This is a hack to turn '<=' into single character '[' */
    if (!strcmp(tok, "<="))
	tok = "[";
    if (strlen(tok) != 1) {
      fprintf(ERRFILE, "Error, line %d: Invalid Op '%s'\n",
	      line, tok);
      return NULL;
    }
    opc = *tok;
    if (opc == 'b') {
      /* Boolean primary input */
      char num_name[8];
      char *name = strtok(NULL, " \t\n\r");
      if (!name) {
	sprintf(num_name, "%d", curr_id);
	name = num_name;
      }
      result = new_pi(name);
    }
    else if (opc == '0')
      result = zero();
    else if (opc == '1') 
      result = one();

    /* Boolean operations */
    else if (opc == '!' || opc == '~' || opc == '&' || opc == '|' || opc == '^') {
      int argid = 0;
      int invert = 0;
      /* Need at least one argument */
      tok = strtok(NULL, " \t\n\r");
      if (tok)
	argid = atoi(tok);
      if (argid < 0) {
	argid = -argid;
	invert = 1;
      }
      if (argid == 0 || argid >= id) {
	fprintf(ERRFILE, "Error, line %d: Invalid argument '%s'\n",
		line, tok ? tok : "");
	return NULL;
      }
      if (!nodes[argid].isbool) {
	  fprintf(ERRFILE, "Error, line %d: Argument %s not Boolean\n",
		  line, tok);
	  return NULL;
      }
      result = nodes[argid].boolval;
      if (invert)
	result = not_op(result);
      if (opc == '~' || opc == '!')
	result = not_op(result);
      else {
	/* Get remaining arguments */
	while ((tok = strtok(NULL, " \t\n\r")) != NULL) {
	  op_ptr arg;
	  argid = atoi(tok);
	  invert = 0;
	  if (argid < 0) {
	    invert = 1;
	    argid = -argid;
	  }
	  if (argid == 0 || argid >= id) {
	    fprintf(ERRFILE, "Error, line %d: Invalid argument '%s'\n",
		    line, tok ? tok : "");
	    return NULL;
	  }
	  if (!nodes[argid].isbool) {
	      fprintf(ERRFILE, "Error, line %d: Argument %s not Boolean\n",
		      line, tok);
	      return NULL;
	  }
	  arg = nodes[argid].boolval;
	  if (invert)
	    arg = not_op(arg);
	  if (opc == '&')
	    result = and_op(result, arg);
	  else if (opc == '|')
	    result = or_op(result, arg);
	  else if (opc == '^')
	    result = xor_op(result, arg);
	  else {
	    fprintf(ERRFILE, "Error, line %d: Invalid operator '%c'\n",
		    line, opc);
	    return NULL;
	  }
	}
      }
      /* Integer cases */
    } else if (opc == 'i') {
	int limit = -1;
	char num_name[8];
	char *name;
	isbool = 0;
	tok = strtok(NULL, " \t\n\r");
	if (tok)
	    limit = atoi(tok);
	if (limit < 0) {
	    fprintf(ERRFILE, "Error, line %d: Must specify nonnegative integer limit\n",
		    line);
	    return NULL;
	}
	name = strtok(NULL, " \t\n\r");
	if (!name) {
	    sprintf(num_name, "%d", curr_id);
	    name = num_name;
	}
	iresult = int_pi(name, WSIZE, 0);
    } else if (opc == 'c') {
	/* Integer constant */
	isbool = 0;
	tok = strtok(NULL, " \t\n\r");
	if (!tok) {
	    fprintf(ERRFILE, "Error: Line %d.  Must give value for integer constant\n",
		    line);
	    return NULL;
	}
	iresult = int_const(atoi(tok));
    } else if (opc == '+' || opc == '=' || opc == '<' || opc == '[') {
	/* Integer addition or comparison */
	int argid1 = 0;
	int argid2 = 0;
	bvec_ptr arg1, arg2;
	tok = strtok(NULL, " \t\n\r");
	if (tok)
	    argid1 = atoi(tok);
	if (!tok || argid1 <= 0 || argid1 >= id || nodes[argid1].isbool) {
	    fprintf(ERRFILE, "Error, Line %d.  Invalid integer argument '%s'\n",
		    line, tok ? tok : "");
	    return NULL;
	}
	arg1 = nodes[argid1].intval;
	tok = strtok(NULL, " \t\n\r");
	if (tok)
	    argid2 = atoi(tok);
	if (!tok || argid2 <= 0 || argid2 >= curr_id || nodes[argid2].isbool) {
	    fprintf(ERRFILE, "Error, Line %d.  Invalid integer argument '%s'\n",
		    line, tok ? tok : "");
	    return NULL;
	}
	arg2 = nodes[argid2].intval;
	if (opc == '+') {
	    isbool = 0;
	    iresult = int_add(arg1, arg2);
	} else if (opc == '=')
	    result = int_eq(arg1, arg2);
	else if (opc == '<')
	    result = int_lt(arg1, arg2);
	else
	    result = int_le(arg1, arg2);
    } else {
	fprintf(ERRFILE, "Error, line %d.  Unknown operation '%s'\n",
		line, tok);
	return NULL;
    }
    /* Got a result.  Now store it away */
    if (id >= acount) {
      acount *= 2;
      nodes = (line_ptr) realloc(nodes, acount*sizeof(line_ele));
    }
    nodes[curr_id].isbool = isbool;
    nodes[curr_id].boolval = result;
    nodes[curr_id].intval = iresult;
#if 0
    /* Debugging */
    if (isbool) {
	printf("c ID %d: ", curr_id);
	expr_display(stdout, result, 0);
	printf("\n");
    } else {
	printf("c ID %d: ", curr_id);
	bvec_display(stdout, iresult);
	printf("\n");
    }
#endif
  }
  /* Return final node */
  if (nodes[curr_id].isbool) {
      result = nodes[curr_id].boolval;
      free(nodes);
      return result;
  }
  fprintf(ERRFILE, "Error  Line %d.  Final result must be Boolean\n", line);
  free(nodes);
  return NULL;
}


