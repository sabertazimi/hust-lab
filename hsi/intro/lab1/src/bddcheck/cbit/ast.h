/* Abstract syntax tree from C functions */

typedef enum {
  /* Expression types.  Each of these has an associated value */
  E_BINOP,     // Binary operation (two children)
  E_UNOP,      // Unary operation  (one child)
  E_ASSIGN,    // Assignment       (variable, expression children.  Value is that of expression)
  E_PASSIGN,   // Postassignment (as in x++) (variable, expression children.  Value is that of variable)
  E_QUESCOLON, // Conditional expression (test, then, else children)
  E_VAR,       // Generic variable.  Only used when variable first created.
  E_AREF,      // Array reference.  Array & index list (chain of ADIM's) as children
  E_AVAR,      // Argument variable
  E_LVAR,      // Local variable
  E_LAVAR,     // Local array variable.  Dim list (chain of ADIM's) as child.  Use val field to hold total allocation.
  E_PTR,       // Pointer variable.  Value (array, or variable) as child.
  E_DEREF,     // Pointer dereference.  Pointer as child.
  E_ADIM,      // Dimension of array (both declaration and index).  size/index & continued dimensions as children (NULL at final dimension)
  E_CONST,     // Numeric constant
  E_CAND,      // && (two children)
  E_CAST,      // Type cast (one child)
  E_SEQUENCE,  // Expression sequence (due to commas) (two children)
  E_FUNCALL,   // Function call.  Function name & argument expression as children
  /* Statement types.  No associated value. */
  S_NOP,       // No operation (no children)
  S_SEQUENCE,  // Statement sequence (two children)
  S_IFTHEN,    // If-then-else statement. (test, then, else children)
  S_WHILE,     // While (test, body children)
  S_RETURN,    // return (return value child)
  S_BREAK,     // break (no children)
  S_CONTINUE,  // continue (no children)
  S_SWITCH,    // switch (expression, body, default children)
  S_CASE,      // Case branch (value child.  No child for default case)
  S_CATCHB,    // Catch any break's within child
  S_CATCHC,    // Catch any continue's within child
  S_DECL,      // Local array or scalar variable declaration (variable child)
  S_UNDECL,    // Local array or scalar variable elimination (variable child)
  N_CNT        // Count of number of node types 
} node_t; 

/* String names for node types */
char *node_type_name(node_t n);

/* Supported operations on integers */
typedef enum {
  IOP_ADD, IOP_SUB, IOP_NEG, IOP_AND, IOP_XOR, IOP_NOT, IOP_ISZERO, IOP_LSHIFT,
  IOP_RSHIFT, IOP_MUL, IOP_DIV, IOP_REM, IOP_EQUAL, IOP_LESS, IOP_LESSEQUAL, IOP_NONE
} iop_t;


typedef struct NELE node_ele, *node_ptr;

struct NELE {
  node_t ntype;
  iop_t op; /* For BINOP/UNOP expressions */
  data_t dtype; /* signed / unsigned / float */
  int wsize;
  int degree;
  bvec_ptr val;
  char *name;   /* For variable */
  op_ptr isdefined; /* For local variable during execution */
  node_ptr children[3]; /* Maximum degree allowed */
};

/********************************* Generation of AST from C Program **********************************/

void init_ast_gen();

extern int LLSIZE;     /* Size of long long (bits) */
extern int LSIZE;     /* Size of long (bits) */
extern int FSIZE;     /* Size of float (bits) */
extern int ISIZE;     /* Size of int (bits) */
extern int PSIZE;     /* Size of pointer (bits) */
extern int SSIZE;     /* Size of short (bits) */

node_ptr new_node(node_t ntype, iop_t op, int degree);
node_ptr new_node0(node_t ntype, iop_t op);
node_ptr new_node1(node_t ntype, iop_t op, node_ptr c0);
node_ptr new_node2(node_t ntype, iop_t op, node_ptr c0, node_ptr c1);
node_ptr new_node3(node_t ntype, iop_t op, node_ptr c0, node_ptr c1, node_ptr c2);

/* Create sequencing node */
node_ptr sequence_node(node_ptr s0, node_ptr s1);

/* Create a casting node */
node_ptr cast_node(int wsize, data_t dtype, node_ptr enode);
/* Declare a variable:
   Cast to type given by first node.
   Set type to E_LVAR (islocal = 1), or E_AVAR (islocal = 0)
   Push onto stack of variables.
   Returns declaration node with variable as child
*/
node_ptr declare_var(node_ptr tnode, node_ptr vnode, int islocal);

/* Create numeric value.  Initializes bits to constant values */
node_ptr make_ast_num(char *sval);

/* Create constant node from sizeof declaration, given type */
node_ptr sizeof_node(node_ptr tnode);

/* Create numeric value.  Initializes bits to constant values */
node_ptr make_ast_num(char *sval);

/* Get existing variable, or create new one.  If created, has type E_VAR */
node_ptr get_ast_var(char *name);

/* Check that variable has been declared */
void check_ast_var(node_ptr vnode);

/* Apply type to set of declared variables */
void apply_type(node_ptr tnode, node_ptr dnode);

/* Look for self-reference in assignment to newly declared variable */
void self_check(node_ptr dnode, node_ptr enode);

/* Add one more dimension to right of array declaration. */
void add_array_dim(node_ptr sofar, node_ptr dimval);

/* Add one more reference to right of array declaration */
node_ptr add_array_ref(node_ptr sofar, node_ptr dimval);

/* Flush declarations contained within block of code.  Append as S_UNDECL's to block */
node_ptr flush_decls(node_ptr snode);

/**************** Symbolic evaluation of an AST ****************************/
/** Implemented in file ast-eval.c **/

/* Data structure for representing evaluation status */
typedef struct {
    int default_only; /* Looking for default case of switch statement */
    op_ptr normal; /* Normal control flow */
    op_ptr switching; /* Encountered switch (evolves as evaluate body) */
    op_ptr continuing; /* Encountered continue */
    op_ptr breaking; /* Encountered break */
    op_ptr returning; /* Encountered return */
    op_ptr bad_args; /* Arguments don't meet range constraints */
    op_ptr mem_error;   /* Have violated memory or array access */
    op_ptr div_error;   /* Have attempted divide by 0  */
    op_ptr shift_error;   /* Have attempted big shift  */
    bvec_ptr switchval; /* Value from switch expression */
    bvec_ptr returnval; /* Return value */
    int casting; /* Did casting occur (either implicit or explicit) */
} context_ele, *context_ptr;

context_ptr new_context();
void free_context(context_ptr con);
context_ptr clone_context(context_ptr con);


/* Initialize the evaluator.  Give argument restrictions as pattern string */
void init_ast_eval(char *argpattern);

/* Information for showing problems with evaluation */
typedef struct{
    op_ptr all_ok;  // == one() when everything OK
    /* Rest indicate error conditions */
    op_ptr incomplete_loop;         // Loop did not terminate within unrolling
    op_ptr uninitialized_variable;  // Define use violation
    op_ptr missing_return;          // No return executed
    op_ptr uncaught_break;          // Uncaught break statement
    op_ptr uncaught_continue;       // Uncaught continue statement
    op_ptr mem_error;                // Invalid memory or array reference
    op_ptr div_error;                // Divide by 0
    op_ptr shift_error;              // Invalid shift amount
    /* bad_args indicates conditions where args out of range.
       Not considered an error condition, but rather where result not expected to match */
    op_ptr bad_args;
    int casting;                     // Indicates whether casting (either implicit or explicit) occurs
} eval_status_ele, *eval_status_ptr;


/* Perform symbolic evaluation of AST.
   If status nonnull, will update fields with evaluation status information.
*/
bvec_ptr eval_ast(node_ptr fnode, node_ptr rtnode, int unroll_limit, eval_status_ptr statusp);



/******************************* Displaying AST *********************************************/
/** Implemented in file ast-gen.c **/
void show_node(FILE *fp, node_ptr node, int toplevel);

