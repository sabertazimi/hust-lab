%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <time.h>
#include "gen-hash.h"
#include "boolnet.h"
#include "ast.h"
#define YYSTYPE node_ptr

#define DEBUG 0

/* Current line number.  Maintained by lex */
int lineno = 1;
#define ERRLIM 0

int errlim = ERRLIM;
int timelim = 0; /* Max number of seconds for BDD checker (0 means infinity) */

int errcnt = 0;

FILE *outfile = NULL;
FILE *infofile = NULL;
extern FILE *yyin;

char *infilename = NULL;
/* Optional pattern giving type information about arguments */
char *argpattern = NULL;
char *function_name = NULL;
node_ptr function_body = NULL;
node_ptr return_type = NULL;
/* Current type of declared variables */
node_ptr default_type = NULL;

int yyparse(void);
int yylex(void);

/* Utility functions */
/* Handle timeouts */
void timeout_handler(int sig)
{
  fprintf(infofile, "Timeout: Checking exceeded %d seconds\n", timelim);
  exit(0);
}

/* Finishing message */
 void finish()
 {
   exit(0);
 } 

void yyerror(const char *str)
{
  fprintf(stdout, "Error, %s:%d: %s\n",
	  infilename ? infilename : "", lineno, str);
  if (++errcnt > errlim) {
      fprintf(stdout, "Too many errors, aborting\n");
      exit(1);
  }
  exit(1);
}

static char errmsg[1024];
void yyserror(const char *str, char *other)
{
    sprintf(errmsg, str, other);
    yyerror(errmsg);
}

int yywrap()
{
  return 1;
}

/* Count number of newlines in string */  
int count_returns(char *s) {
  int result = 0;
  int c = 0;
  while ((c = *s++) != '\0')
    result += (c == '\n');
  return result;
}

static void usage(char *name)
{
  fprintf(stdout, "Usage: %s [-r][-s][-a argpattern] f1.c f2.c ... [-o out.cnf][-e errlim][-u unrolllim] [-t timelim]\n", name);
  fprintf(stdout, " -r: Only test for runtime errors (uninitialized vars., etc.)\n");  
  fprintf(stdout, " -s: Set up SAT problem, rather than using BDDs\n");
  fprintf(stdout, " -u lim: Limit maximum number of times loop is repeated\n");
  fprintf(stdout, " -t secs: Limit number of seconds for BDD checking\n");
  fprintf(stdout, " -a argpattern: Specify argument ranges\n");
  fprintf(stdout, " -C: Disable casting (implicit & explicit) in first code file\n");
  fprintf(stdout, " -d dumpfile: Dump counterexample BDD\n");
  fprintf(stdout, "Argpattern of form pat1:pat2:...:patn\n");
  fprintf(stdout, "Possible patterns:\n");
  fprintf(stdout, "  Default: Same as t%d\n", LSIZE);
  fprintf(stdout, "  tK: K-bit, two's complement representation\n");
  fprintf(stdout, "  uK: K-bit, unsigned representation\n");
  fprintf(stdout, "  [lower,upper]: Give specific value range\n");
  fprintf(stdout, " -o outfile: Specify output CNF file\n");
  exit(0);
}

int main(int argc, char **argv)
{
    /* When have single function, Check whether always returns 1 */
    bvec_ptr ref_rval = int_const(1); 
    bvec_ptr new_rval;
    /* AST for function */
    node_ptr fnode;
    /* Do all functions satisfy runtime constraints? */
    op_ptr all_runtime = one();
    /* What are the conditions for out of range arguments */
    op_ptr bad_args = zero();
    /* Do all of the function results match? */
    op_ptr all_rm = one();
    /* Latest computation of runtime and results match */
    op_ptr runtime;
    op_ptr rm;
    eval_status_ele status;
    int runtime_only = 0;
    int cnt = 0;
    int use_bdds = 1;
    int cast_ok = 1;
    int i;
    int unroll_limit = 33;
    int found_runtime_error = 0;
    char *dumpfilename = NULL;

    clock_t start_time = clock();


    argpattern = NULL;
    outfile = stdout;
    infofile = stdout;

    default_type = cast_node(ISIZE, DATA_SIGNED, NULL);
    return_type = cast_node(ISIZE, DATA_SIGNED, NULL);

    /* Make two passes through arguments.  First, pick up all options */
    for (i = 1; i < argc; i++) {
	if (argv[i][0] != '-')
	  continue;
	/* Parse options */
	switch (argv[i][1]) {
	case 'h': usage(argv[0]);
	  break;
	case 'r': runtime_only = 1;
	  break;
	case 's': use_bdds = 0;
	  break;
	case 'C': cast_ok = 0;
	  break;
        case 'u': unroll_limit = atoi(argv[++i]);
          break;
        case 't': timelim = atoi(argv[++i]);
          break;
	case 'd': dumpfilename = argv[++i];
	  break;
	case 'o': 
	  outfile = fopen (argv[++i], "w");
	  if (!outfile) {
	    yyserror("Couldn't open output file '%s'", argv[i]);
	    exit(1);
	  }
	  break;
	case 'a':
	  argpattern = argv[++i];
	  break;
	case 'e':
	  errlim = atoi(argv[++i]);
	  break;
	default:
	  usage(argv[0]);
	  break;
	}
    }
    /* Set up signal handler when using BDDs */
    if (timelim > 0) {
      signal(SIGALRM, timeout_handler);
    }
    /* Second pass.  Process C files */
    init_ast_gen();
    init_ast_eval(argpattern);
    
    for (i = 1; i < argc; i++) {
      if (*argv[i] == '-') {
	char opt = argv[i][1];
	if (opt == 'a' || opt == 'o' || opt == 'e' || opt == 'u' || opt == 't' || opt == 'd')
	  i++;
	continue;
      }
      infilename = strsave(argv[i]);
      yyin = fopen(infilename, "r");
      if (!yyin) {
	yyserror("Couldn't open file '%s'", infilename);
	exit(1);
      }
      init_ast_gen();
      lineno = 1;
      if (yyparse())
	exit(1);
      new_rval = eval_ast(function_body, return_type, unroll_limit, &status);
      if (cnt == 0 && !cast_ok && status.casting > 0) {
	fprintf(infofile, "Disallowed casting in file %s\n", infilename);
      }
      runtime = status.all_ok;
      bad_args = status.bad_args;
      if (runtime != one()) {
	  if (use_bdds) {
	      if (timelim > 0) {
	          alarm(timelim);
	      }
	      if (gen_solve(NULL, not_op(runtime))) {
		  fprintf(infofile, "Runtime error(s) in file %s\n", infilename);
		  found_runtime_error = 1;
		  if (timelim > 0) alarm(timelim);
		  if (gen_solve(NULL, status.incomplete_loop)) {
		      fprintf(infofile, "Loop failed to terminate within %d iterations: ",
			      unroll_limit);
		      gen_solve(infofile, status.incomplete_loop);
		      finish();
		  }
		  if (timelim > 0) alarm(timelim);
		  if (gen_solve(NULL, status.uninitialized_variable)) {
		      fprintf(infofile, "Variable used before being initialized: ");
		      gen_solve(infofile, status.uninitialized_variable);
		      finish();
		  }
		  if (timelim > 0) alarm(timelim);
		  if (gen_solve(NULL, status.missing_return)) {
		      fprintf(infofile, "No return executed: ");
		      gen_solve(infofile, status.missing_return);
		      finish();
		  }
		  if (timelim > 0) alarm(timelim);
		  if (gen_solve(NULL, status.uncaught_break)) {
		      fprintf(infofile, "Uncaught break statement: ");
		      gen_solve(infofile, status.uncaught_break);
		      finish();
		  }
		  if (timelim > 0) alarm(timelim);
		  if (gen_solve(NULL, status.uncaught_continue)) {
		      fprintf(infofile, "Uncaught continue statement: ");
		      gen_solve(infofile, status.uncaught_continue);
		      finish();
		  }
		  if (timelim > 0) alarm(timelim);
		  if (gen_solve(NULL, status.mem_error)) {
		      fprintf(infofile, "Memory or array referencing error: ");
		      gen_solve(infofile, status.mem_error);
		      finish();
		  }
		  if (timelim > 0) alarm(timelim);
		  if (gen_solve(NULL, status.div_error)) {
		      fprintf(infofile, "Zero divide error: ");
		      gen_solve(infofile, status.div_error);
		      finish();
		  }
		  if (timelim > 0) alarm(timelim);
		  if (gen_solve(NULL, status.shift_error)) {
		      fprintf(infofile, "Invalid shift error: ");
		      gen_solve(infofile, status.shift_error);
		      finish();
		  }
	      }
	  } else {
	      fprintf(infofile, "Warning: possible runtime error in file %s\n",
		infilename);
	      if (status.incomplete_loop != zero())
		  fprintf(infofile,
			  "  Loop possibly did not terminate within %d iterations\n", unroll_limit);
	      if (status.uninitialized_variable != zero())
		  fprintf(infofile,
			  "  Possibly used variable that had not been initialized\n");
	      if (status.missing_return != zero())
		  fprintf(infofile,
			  "  Possibly failed to execute return statement\n");
	      if (status.uncaught_break != zero())
		  fprintf(infofile,
			  "  Possibly failed to catch break statement\n");
	      if (status.uncaught_continue != zero())
		  fprintf(infofile,
			  "  Possibly failed to catch continue statement\n");
	      if (status.mem_error != zero())
		  fprintf(infofile,
			  "  Possible memory or array referencing error\n");
	      if (status.div_error != zero())
		  fprintf(infofile,
			  "  Possible zero divide error\n");
	      if (status.shift_error != zero())
		  fprintf(infofile,
			  "  Possible shift error\n");
	  }
      }

      all_runtime = and_op(runtime, all_runtime);
      cnt++;
      if (!runtime_only) {
	rm = or_op(bad_args, int_eq(ref_rval, new_rval));
	if (cnt == 1) {
	  /* Save this as reference value
	     in case do further comparisons */
	  ref_rval = new_rval;
	}
	if (cnt == 2) {
	  /* Special case of switching from single predicate function
	     to comparing multiple functions */
	  all_rm = rm;
	} else
	  all_rm = and_op(all_rm, rm);
      }
    }

    if (use_bdds) {
      op_ptr check;
      if (!found_runtime_error) {
	fprintf(infofile, "Bug Condition ");
	if (timelim > 0) {
	  alarm(timelim);
	}
	check = not_op(and_op(all_rm, all_runtime));
	gen_solve(infofile, check);
	if (dumpfilename != NULL) {
	  /* Dump vector of nonzero functions */
	  int dump_cnt = ISIZE;
	  int i;
	  while (dump_cnt > 1 && ref_rval->bits[dump_cnt-1] == zero())
	    dump_cnt--;
	  FILE *fp = fopen(dumpfilename, "w");
	  op_ptr *funct_set = calloc(sizeof(op_ptr), dump_cnt);
	  char **funct_names = calloc(sizeof(char *), dump_cnt);
	  for (i = 0; i < dump_cnt; i++) {
	    char buf[16];
	    funct_set[i] = ref_rval->bits[i];
	    sprintf(buf, "F_%d", i);
	    funct_names[i] = strsave(buf);
	  }
	  if (!fp) {
	    fprintf(stderr, "Couldn't open dump file '%s'\n", dumpfilename);
	    exit(1);
	  }
	  dump_blif(fp, dump_cnt, funct_set, funct_names);
	  fclose(fp);
	}
      }
    }
    else
      gen_cnf(outfile, infofile, not_op(and_op(all_rm, all_runtime)));
    fprintf(infofile, "Time: %.2f sec.\n",
	    (clock() - start_time)/(double) CLOCKS_PER_SEC);
    finish();
    return 0;
}

int old_main(int argc, char **argv)
{
  int i;
  init_ast_eval(NULL);
  init_ast_gen();
  default_type = cast_node(ISIZE, DATA_SIGNED, NULL);
  return_type = cast_node(ISIZE, DATA_SIGNED, NULL);
  for (i = 1; i < argc; i++) {
    infilename = strsave(argv[i]);
    yyin = fopen(infilename, "r");
    if (!yyin) {
      yyserror("Couldn't open file '%s'", infilename);
      exit(1);
    }
    lineno = 1;
    if (yyparse())
      exit(1);
    printf("Function %s:\n", function_name);
    show_node(stdout, function_body, 1);
  }
}

%}

%token VAR INT FLOAT VOID UNSIGNED LONG SHORT CHAR NUM SEMI COMMA LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK
  ASSIGN CARATASSIGN AMPASSIGN STARASSIGN PLUSASSIGN MINUSASSIGN BARASSIGN
  LEFTSHIFTASSIGN RIGHTSHIFTASSIGN SLASHASSIGN PERCENTASSIGN
  PLUSPLUS MINUSMINUS
  AMPAMP BARBAR TILDE BANG CARAT AMP BAR STAR PLUS MINUS SLASH PERCENT
  LESSLESS GREATERGREATER COLON QUESTION
  NOTEQUAL EQUAL LESS LESSEQUAL GREATER GREATEREQUAL
  RETURN IF ELSE WHILE DO FOR BREAK CONTINUE CASE SWITCH DEFAULT SIZEOF

/* Operator precedence and associativity */

%right ASSIGN CARATASSIGN AMPASSIGN STARASSIGN PLUSASSIGN MINUSASSIGN BARASSIGN LEFTSHIFTASSIGN RIGHTSHIFTASSIGN SLASHASSIGN PERCENTASSIGN
%left BARBAR
%left AMPAMP
%left BAR
%left CARAT
%left AMP
%left EQUAL NOTEQUAL
%left LESS LESSEQUAL GREATER GREATEREQUAL
%left LESSLESS GREATERGREATER
%left PLUS MINUS
%left STAR SLASH PERCENT

%%

funct: type VAR LPAREN arglist RPAREN LBRACE statements RBRACE
   { return_type = $1; function_name = $2->name;
     function_body = flush_decls(new_node2(S_SEQUENCE, IOP_NONE, $4, flush_decls($7))); }   
     ;

type:
        UNSIGNED           { $$=cast_node(ISIZE, DATA_UNSIGNED, NULL); }
      | UNSIGNED LONG      { $$=cast_node(LSIZE, DATA_UNSIGNED, NULL); }
      | LONG UNSIGNED      { $$=cast_node(LSIZE, DATA_UNSIGNED, NULL); }
      | UNSIGNED LONG LONG      { $$=cast_node(LLSIZE, DATA_UNSIGNED, NULL); }
      | LONG LONG UNSIGNED      { $$=cast_node(LLSIZE, DATA_UNSIGNED, NULL); }
      | UNSIGNED SHORT INT { $$=cast_node(SSIZE, DATA_UNSIGNED, NULL); }
      | SHORT UNSIGNED INT { $$=cast_node(SSIZE, DATA_UNSIGNED, NULL); }
      | UNSIGNED SHORT     { $$=cast_node(SSIZE, DATA_UNSIGNED, NULL); }
      | SHORT UNSIGNED     { $$=cast_node(SSIZE, DATA_UNSIGNED, NULL); }
      | UNSIGNED CHAR      { $$=cast_node(CSIZE, DATA_UNSIGNED, NULL); }
      | CHAR UNSIGNED      { $$=cast_node(CSIZE, DATA_UNSIGNED, NULL); }
      | UNSIGNED INT       { $$=cast_node(ISIZE, DATA_UNSIGNED, NULL); }
      | LONG UNSIGNED INT  { $$=cast_node(LSIZE, DATA_UNSIGNED, NULL); }
      | UNSIGNED LONG INT  { $$=cast_node(LSIZE, DATA_UNSIGNED, NULL); }
      | LONG LONG UNSIGNED INT  { $$=cast_node(LLSIZE, DATA_UNSIGNED, NULL); }
      | UNSIGNED LONG LONG INT  { $$=cast_node(LLSIZE, DATA_UNSIGNED, NULL); }
      | SHORT INT          { $$=cast_node(SSIZE, DATA_SIGNED, NULL); }
      | SHORT              { $$=cast_node(SSIZE, DATA_SIGNED, NULL); }
      | CHAR               { $$=cast_node(CSIZE, DATA_SIGNED, NULL); }
      | INT                { $$=cast_node(ISIZE, DATA_SIGNED, NULL); }
      | LONG INT           { $$=cast_node(LSIZE, DATA_SIGNED, NULL); }
      | LONG               { $$=cast_node(LSIZE, DATA_SIGNED, NULL); }
      | LONG LONG INT      { $$=cast_node(LLSIZE, DATA_SIGNED, NULL); }
      | LONG LONG          { $$=cast_node(LLSIZE, DATA_SIGNED, NULL); }
      | FLOAT              { $$=cast_node(FLOAT_SIZE, DATA_FLOAT, NULL); }
      | type STAR          { $$=new_node1(E_PTR, IOP_NONE, $1); }
      ;

arglist: /* empty */            { $$=new_node0(S_NOP, IOP_NONE); }
       | VOID                   { $$=new_node0(S_NOP, IOP_NONE); }
       | type VAR               { $$=declare_var($1, $2, 0); }
       | arglist COMMA type VAR { $$=sequence_node($1, declare_var($3, $4, 0)); }
       ;

statements: /* empty */       { $$=new_node0(S_NOP, IOP_NONE); }
       | statements statement { $$=sequence_node($1, $2); }
       ;

statement: 
       type decllist SEMI { apply_type($1, $2); $$=$2; }
       | cexpr SEMI { $$=$1; }
       | SEMI                 { $$=new_node0(S_NOP, IOP_NONE); }
       | RETURN cexpr SEMI    { $$=new_node1(S_RETURN, IOP_NONE, $2); }
       | BREAK SEMI           { $$=new_node1(S_BREAK, IOP_NONE, $2); }
       | CONTINUE SEMI        { $$=new_node1(S_CONTINUE, IOP_NONE, $2); }
       | WHILE LPAREN cexpr RPAREN statement { $$=new_node1(S_CATCHB, IOP_NONE,
							    new_node2(S_WHILE, IOP_NONE, $3,
								      new_node1(S_CATCHC, IOP_NONE, $5))); }
       | DO statement WHILE LPAREN cexpr RPAREN SEMI 
                    { $$=new_node1(S_CATCHB, IOP_NONE,
				   sequence_node(new_node1(S_CATCHC, IOP_NONE, $2),
						 new_node2(S_WHILE, IOP_NONE, $5,
							   new_node1(S_CATCHC, IOP_NONE, $2)))); }
       | FOR LPAREN cexpr SEMI cexpr SEMI cexpr RPAREN statement
                    { $$=sequence_node($3,
				       new_node1(S_CATCHB, IOP_NONE,
						 new_node2(S_WHILE, IOP_NONE, $5,
							   sequence_node(new_node1(S_CATCHC, IOP_NONE, $9), $7)))); }
       | IF LPAREN cexpr RPAREN statement ELSE statement { $$=new_node3(S_IFTHEN, IOP_NONE, $3, $5, $7); }
       | IF LPAREN cexpr RPAREN statement                { $$=new_node3(S_IFTHEN, IOP_NONE, $3, $5, new_node0(S_NOP, IOP_NONE)); }
       | LBRACE statements RBRACE { $$=flush_decls($2); }
       | SWITCH LPAREN cexpr RPAREN statement
                          { $$=new_node1(S_CATCHB, IOP_NONE, new_node2(S_SWITCH, IOP_NONE, $3, $5)); }
       | CASE qexpr COLON statement { $$=sequence_node(new_node1(S_CASE, IOP_NONE, $2), $4); }
       | DEFAULT COLON statement { $$=sequence_node(new_node0(S_CASE, IOP_NONE), $3); }
       ;

decllist:
       decl                  { $$ = $1; } 
       | adecl               { $$ = $1; }
       | decllist COMMA decl { $$=sequence_node($1, $3); }
       | decllist COMMA adecl   { $$=sequence_node($1, $3); }
       ;

decl:
       VAR { $$ = declare_var(default_type, $1, 1); }
       | decl LBRACK expr RBRACK { add_array_dim($1->children[0], $3); $$ = $1; }
       | decl LBRACK RBRACK { add_array_dim($1->children[0], make_ast_num("-1"));  $$ = $1; }
       ;

adecl:
        decl ASSIGN aexpr { self_check($1, $3);
  	                    $$ = sequence_node($1, new_node2(E_ASSIGN, IOP_NONE, $1->children[0], $3)); }
      | decl ASSIGN iexpr { self_check($1, $3);
  	                    $$ = sequence_node($1, new_node2(E_ASSIGN, IOP_NONE, $1->children[0], $3)); }
      ;         

vexpr:
       VAR      { check_ast_var($1); $$=$1; }
       | vexpr LBRACK expr RBRACK { $$=add_array_ref($1, $3); }
       ;

uexpr:
       vexpr                 { $$=$1; }
       | NUM                 { $$=$1; }
       | LPAREN cexpr RPAREN { $$=$2; }
       | LPAREN type RPAREN uexpr { $$=cast_node($2->wsize, $2->dtype, $4); }
       | BANG uexpr          { $$=new_node1(E_UNOP, IOP_ISZERO, $2); }
       | TILDE uexpr         { $$=new_node1(E_UNOP, IOP_NOT, $2); }
       | MINUS uexpr         { $$=new_node1(E_UNOP, IOP_NEG, $2); } 
       | SIZEOF LPAREN type RPAREN { $$=sizeof_node($3); } 
       | vexpr PLUSPLUS   { check_ast_var($1); $$=new_node2(E_PASSIGN, IOP_NONE, $1, new_node2(E_BINOP, IOP_ADD, $1, make_ast_num("1"))); }
       | vexpr MINUSMINUS { check_ast_var($1); $$=new_node2(E_PASSIGN, IOP_NONE, $1, new_node2(E_BINOP, IOP_SUB, $1, make_ast_num("1"))); }
       | MINUSMINUS vexpr { check_ast_var($2); $$=new_node2(E_ASSIGN, IOP_NONE, $2, new_node2(E_BINOP, IOP_SUB, $2, make_ast_num("1"))); }
       | PLUSPLUS vexpr   { check_ast_var($2); $$=new_node2(E_ASSIGN, IOP_NONE, $2, new_node2(E_BINOP, IOP_ADD, $2, make_ast_num("1"))); }
       | AMP vexpr { check_ast_var($2); $$=new_node1(E_DEREF, IOP_NONE, $2); }
       | STAR vexpr { check_ast_var($2); $$=new_node1(E_PTR, IOP_NONE, $2); }
       | VAR LPAREN cexpr RPAREN { $$=new_node2(E_FUNCALL, IOP_NONE, $1, $3); }
       ;

expr:
       uexpr                  { $$=$1; }
       | expr STAR expr       { $$=new_node2(E_BINOP, IOP_MUL, $1, $3); }
       | expr PLUS expr       { $$=new_node2(E_BINOP, IOP_ADD, $1, $3); }
       | expr MINUS expr      { $$=new_node2(E_BINOP, IOP_SUB, $1, $3); }
       | expr SLASH expr       { $$=new_node2(E_BINOP, IOP_DIV, $1, $3); }
       | expr PERCENT expr       { $$=new_node2(E_BINOP, IOP_REM, $1, $3); }
       | expr LESSLESS expr       { $$=new_node2(E_BINOP, IOP_LSHIFT, $1, $3); }
       | expr GREATERGREATER expr { $$=new_node2(E_BINOP, IOP_RSHIFT, $1, $3); }
       | expr LESS expr       { $$=new_node2(E_BINOP, IOP_LESS, $1, $3); }
       | expr LESSEQUAL expr  { $$=new_node2(E_BINOP, IOP_LESSEQUAL, $1, $3); }
       | expr GREATER expr    { $$=new_node2(E_BINOP, IOP_LESS, $3, $1); }
       | expr GREATEREQUAL expr { $$=new_node2(E_BINOP, IOP_LESSEQUAL, $3, $1); }
       | expr EQUAL expr      { $$=new_node2(E_BINOP, IOP_EQUAL, $1, $3); }
       | expr NOTEQUAL expr   { $$=new_node1(E_UNOP, IOP_ISZERO, new_node2(E_BINOP, IOP_EQUAL, $1, $3)); }
       | expr AMP expr        { $$=new_node2(E_BINOP, IOP_AND, $1, $3); }
       | expr CARAT expr      { $$=new_node2(E_BINOP, IOP_XOR, $1, $3); }
       | expr BAR expr        { $$=new_node1(E_UNOP, IOP_NOT,
					     new_node2(E_BINOP, IOP_AND,
						       new_node1(E_UNOP, IOP_NOT, $1),
						       new_node1(E_UNOP, IOP_NOT, $3))); }
       | expr AMPAMP expr     { $$=new_node2(E_CAND, IOP_NONE, $1, $3); }
       | expr BARBAR expr     { $$=new_node1(E_UNOP, IOP_ISZERO,
					     new_node2(E_CAND, IOP_NONE,
						       new_node1(E_UNOP, IOP_ISZERO, $1),
						       new_node1(E_UNOP, IOP_ISZERO, $3))); }
       ;

qexpr: 
       expr                   { $$=$1; }
       | expr QUESTION qexpr COLON qexpr { $$=new_node3(E_QUESCOLON, IOP_NONE, $1, $3, $5); }
       ;

aexpr:
       qexpr                   { $$ = $1; }
       | vexpr ASSIGN aexpr      { check_ast_var($1); $$=new_node2(E_ASSIGN, IOP_NONE, $1, $3); }   
       | vexpr CARATASSIGN aexpr { check_ast_var($1); $$=new_node2(E_ASSIGN, IOP_NONE, $1,
					      new_node2(E_BINOP, IOP_XOR, $1, $3)); }
       | vexpr AMPASSIGN aexpr   { check_ast_var($1); $$=new_node2(E_ASSIGN, IOP_NONE, $1,
					      new_node2(E_BINOP, IOP_AND, $1, $3)); }
       | vexpr STARASSIGN aexpr  { check_ast_var($1); $$=new_node2(E_ASSIGN, IOP_NONE, $1,
					      new_node2(E_BINOP, IOP_MUL, $1, $3)); }
       | vexpr PLUSASSIGN aexpr  { check_ast_var($1); $$=new_node2(E_ASSIGN, IOP_NONE, $1,
					      new_node2(E_BINOP, IOP_ADD, $1, $3)); }
       | vexpr SLASHASSIGN aexpr  { check_ast_var($1); $$=new_node2(E_ASSIGN, IOP_NONE, $1,
					      new_node2(E_BINOP, IOP_DIV, $1, $3)); }
       | vexpr PERCENTASSIGN aexpr  { check_ast_var($1); $$=new_node2(E_ASSIGN, IOP_NONE, $1,
					      new_node2(E_BINOP, IOP_REM, $1, $3)); }
       | vexpr MINUSASSIGN aexpr { check_ast_var($1); $$=new_node2(E_ASSIGN, IOP_NONE, $1,
			                      new_node2(E_BINOP, IOP_SUB, $1, $3)); }
       | vexpr BARASSIGN aexpr   { check_ast_var($1); $$=new_node2(E_ASSIGN, IOP_NONE, $1,
					      new_node1(E_UNOP, IOP_NOT,
							new_node2(E_BINOP, IOP_AND,
								  new_node1(E_UNOP, IOP_NOT, $1),
								  new_node1(E_UNOP, IOP_NOT, $3)))); }
       | vexpr LEFTSHIFTASSIGN aexpr { check_ast_var($1); $$=new_node2(E_ASSIGN, IOP_NONE, $1,
					      new_node2(E_BINOP, IOP_LSHIFT, $1, $3)); }
       | vexpr RIGHTSHIFTASSIGN aexpr { check_ast_var($1); $$=new_node2(E_ASSIGN, IOP_NONE, $1,
					      new_node2(E_BINOP, IOP_RSHIFT, $1, $3)); }
       ;

/* Comma-separated lists */
cexpr:
       aexpr                        { $$=$1; }
     | cexpr COMMA aexpr            { $$=new_node2(E_SEQUENCE, IOP_NONE, $1, $3); }
     ;

/* Array initializations */
iexpr:
      aexpr                          { $$=$1; }
      | LBRACE iexprlist RBRACE      { $$=$2; }
      ;

iexprlist:
        iexpr                        { $$=new_node2(E_SEQUENCE, IOP_NONE, $1, NULL); }
      | iexpr COMMA iexprlist        { $$=new_node2(E_SEQUENCE, IOP_NONE, $1, $3); }
      ;
