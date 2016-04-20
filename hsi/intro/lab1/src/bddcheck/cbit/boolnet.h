/* Code to generate CNF from Boolean & separation logic expressions */

/* General */

#define HAVE_LONGLONG 1

#if HAVE_LONGLONG
/* Might need to disable this when compiler doesn't support long long's */
typedef long long int llong;
typedef unsigned long long int ullong;
#else
typedef long int llong;
typedef unsigned long int ullong;
#endif

char *strsave(char *s);

/* Where should error output be directed */
#define ERRFILE stdout

/************** Boolean ***************************/
/* Two fundamental operator types: AND and XOR.
   Special types: PI for primary input,
   IPI for PI originating as bit in integer word,
   BUF for single argument,
   and ZERO for Boolean zero
*/
typedef enum {OP_ZERO, OP_AND, OP_XOR, OP_PI, OP_IPI, OP_BUF} op_t;

typedef struct OELE op_ele, *op_ptr;

struct OELE {
  hash_ele hash_stuff; /* Used by unique table */ 
  op_t op;
  int nargs;
  op_ptr *args;       /* Pointers to children */
  char *invert_args;  /* For each child, 1 if invert, 0 otherwise */
  int output_id;      /* Assigned when generating CNF */
  int creation_id;    /* Generated during creation.  Used for hashing */
  int pass;           /* Used to guide depth-first traversals */
  int unique;         /* Is this a canonical operation? */
  char *name;         /* For primary inputs */
};

/* Display Boolean value as 0, 1, or X (for non-constant value) */
char op_char(op_ptr arg);

/* Create a new PI */
op_ptr new_pi(char *name);

/* Print expression */
void expr_display(FILE *fp, op_ptr arg, int invert);

op_ptr zero();
op_ptr one();

/* Boolean operations */
op_ptr and_op(op_ptr arg1, op_ptr arg2);
op_ptr or_op(op_ptr arg1, op_ptr arg2);
op_ptr xor_op(op_ptr arg1, op_ptr arg2);
op_ptr not_op(op_ptr arg);
op_ptr ite_op(op_ptr iarg, op_ptr targ, op_ptr earg);

/************** Integer / float *******************************/

/*** Declare word sizes ***/
/* Maximum word size for interpreter (bits) [Must be multiple of CSIZE and >= 32]*/
#ifndef WSIZE
#define WSIZE 64
#endif

#define CSIZE 8    /* Size of byte */

#define FLOAT_SIZE 32 /* Size of float */


typedef enum { DATA_SIGNED, DATA_UNSIGNED, DATA_FLOAT } data_t;

/* Represent integers as array of Booleans */
typedef struct {
  op_ptr bits[WSIZE];
} bvec_ele, *bvec_ptr;

/* Free a bvec */
void free_vec(bvec_ptr v);
/* Print a bvec */
void bvec_display(FILE *fp, bvec_ptr v);

/* Quick 0/1/X display of bvec */
void bvec_char(char *dest, bvec_ptr v, int width);

/* Expand from 1 bit to word size */
bvec_ptr bool2int(op_ptr arg);

/* Create set of primary input variables */
bvec_ptr int_pi(char *name, int wsize, int isunsigned);


bvec_ptr int_const(llong val);
bvec_ptr uint_const(ullong val);
bvec_ptr float_const(float fval);

bvec_ptr int_add(bvec_ptr v1, bvec_ptr v2);
bvec_ptr int_negate(bvec_ptr v); /* Arithmetic negation */
bvec_ptr int_not(bvec_ptr v); /* Bitwise complement */
bvec_ptr int_and(bvec_ptr v1, bvec_ptr v2);
bvec_ptr int_or(bvec_ptr v1, bvec_ptr v2);
bvec_ptr int_xor(bvec_ptr v1, bvec_ptr v2);
bvec_ptr int_mult(bvec_ptr v1, bvec_ptr v2);
bvec_ptr int_div(bvec_ptr v1, bvec_ptr v2, int isunsigned);
bvec_ptr int_rem(bvec_ptr v1, bvec_ptr v2, int isunsigned);
bvec_ptr int_shiftleft(bvec_ptr v1, bvec_ptr v2, int wsize);
bvec_ptr int_shiftrightarith(bvec_ptr v1, bvec_ptr v2, int wsize);
bvec_ptr int_shiftrightlogical(bvec_ptr v1, bvec_ptr v2, int wsize);
bvec_ptr int_mux(op_ptr cntl, bvec_ptr v1, bvec_ptr v2);

bvec_ptr change_type(bvec_ptr val, int old_wsize, data_t old_dtype, int new_wsize, data_t new_dtype);
/* Set high order bits of word to either sign bit or zero */
bvec_ptr mask_size(bvec_ptr val, int wsize, int isunsigned);

/* Create unsigned byte by little endian order */
bvec_ptr extract_byte(bvec_ptr val, int offset);
/* Replace specified byte */
bvec_ptr replace_byte(bvec_ptr word, bvec_ptr byte, int offset);

/* Floating point operations */
bvec_ptr float_negate(bvec_ptr v);
bvec_ptr float_mult(bvec_ptr v1, bvec_ptr v2);
bvec_ptr float_fix_nan(bvec_ptr v);
bvec_ptr float_isnan(bvec_ptr v);

/* Predicates */
op_ptr int_eq(bvec_ptr v1, bvec_ptr v2);
op_ptr int_lt(bvec_ptr v1, bvec_ptr v2);
op_ptr int_le(bvec_ptr v1, bvec_ptr v2);
op_ptr int_ult(bvec_ptr v1, bvec_ptr v2);
op_ptr int_ule(bvec_ptr v1, bvec_ptr v2);
op_ptr int_isnonzero(bvec_ptr v);
op_ptr float_eq(bvec_ptr v1, bvec_ptr v2);
op_ptr float_lt(bvec_ptr v1, bvec_ptr v2);


/************* I/O **************************************/
void show_const(FILE *fp, bvec_ptr v, int wsize, int isunsigned);

void gen_cnf(FILE *fp, FILE *info_fp, op_ptr arg);

/* Determine if formula satisfiable (using BDDs).
   If so, optionally print satisfying solution to file.
   Return 1 iff satisfiable 
*/
int gen_solve(FILE *fp, op_ptr arg);

/* Read straightline program from file.
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
op_ptr straightline_read(FILE *fp);

