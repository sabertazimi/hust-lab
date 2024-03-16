%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "location.h"
    #include "errors/errors.h"
    #include "libs/List.h"
    #include "syntax/Tree.h"

    #undef YYDEBUG
    #define YYDEBUG 1
    #define YYERROR_VERBOSE 1

    extern char *yytext;
    int yylex(void);

    /// \brief return value will be ignored
    int yyerror(const char *msg);

    // enable/disable state machine working result output
    // yydebug = 1;

    int parse_failed;
    int proposed_solution(const char *sol);

    Program *tree;
%}

%defines
%error-verbose
%locations

%union {
    int num_val;
    char *str_val;
    TypeLiteral *type_val;
    Expr *expr_val;
    List <Expr *> *exprs_val;
    LValue *Lvalue_val;
    List <VarDef *> *formals_val;
    List <Expr *> *actuals_val;
    VarDef *var_def_val;
    List <VarDef *> *vars_val;
    FuncDef *func_def_val;
    Node *field_val;
    List <Node *>* fields_val;
    Node *stmt_val;
    List <Node *> *stmts_val;
    ClassDef* class_def_val;
    List <ClassDef *>* class_defs_val;
    Program *prog_val;
}

%token END
%token NIL
%token BOOL INT STRING FUNCTION VOID    ///< hidden type: function type
%token OP_AND OP_OR OP_LE OP_GE OP_EQ OP_NE OP_ARROW
%token CLASS EXTENDS NEW THIS
%token IF ELSE FOR WHILE RETURN
%token PRINT READINTEGER READLINE

%token <num_val> CONSTANT_BOOL CONSTANT_INT
%token <str_val> CONSTANT_STRING
%token <str_val> IDENTIFIER

%type <type_val> type
%type <expr_val> expr receiver call constant
%type <exprs_val> exprs
%type <Lvalue_val> lvalue
%type <formals_val> formals
%type <actuals_val> actuals
%type <var_def_val> var_def var
%type <vars_val> vars
%type <func_def_val> func_def
%type <field_val> field
%type <fields_val> fields
%type <stmt_val> stmt stmt_block simple_stmt if_stmt while_stmt for_stmt return_stmt print_stmt
%type <stmts_val> stmts
%type <class_def_val> class_def
%type <class_defs_val> class_defs
%type <prog_val> program

/* to eliminate S/R conflict */
%left OP_OR
%left OP_AND 
%nonassoc OP_EQ OP_NE
%nonassoc OP_LE OP_GE '<' '>'
%left  '+' '-'
%left  '*' '/' '%'
%nonassoc UNEG '!'
%nonassoc '[' '.'
%nonassoc ')' NOELSE
%nonassoc ELSE

%left error

%start program

%%

program
    : class_defs END
    {
        @$ = @1;
        tree = new Program($1, locdup(&@1));
    }
    ;

class_defs
    : class_defs class_def
    {
        @$ = @2;
        ($$ = $1)->append($2);
    }
    | class_def
    {
        @$ = @1;
        ($$ = new List<ClassDef *>())->append($1);
    }
    ;

class_def
    : CLASS IDENTIFIER '{' fields '}'
    {
        @$ = @2;
        $$ = new ClassDef($2, strdup(""), $4, locdup(&@2));
    }
    | CLASS IDENTIFIER EXTENDS IDENTIFIER '{' fields '}'
    {
        @$ = @2;
        $$ = new ClassDef($2, $4, $6, locdup(&@2));
    }
    /* error recovery */
    | error IDENTIFIER '{' fields '}'
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("expected keyword \"class\"");
    }
    | CLASS error '{' fields '}'
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("expected identifier as class name");
    }
    | CLASS IDENTIFIER error fields '}'
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("unmatched '{' or '}'");
    }
    | CLASS IDENTIFIER '{' fields error
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("unmatched '{' or '}'");
    }
    | error IDENTIFIER EXTENDS IDENTIFIER '{' fields '}'
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("expected keyword \"class\"");
    }
    | CLASS error EXTENDS IDENTIFIER '{' fields '}'
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("expected identifier as class name");
    }
    | CLASS IDENTIFIER error IDENTIFIER '{' fields '}'
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("expected keyword \"extends\"");
    }
    | CLASS IDENTIFIER EXTENDS error '{' fields '}'
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("expected identifier as class name");
    }
    | CLASS IDENTIFIER EXTENDS IDENTIFIER error fields '}'
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("unmatched '{' or '}'");
    }
    | CLASS IDENTIFIER EXTENDS IDENTIFIER '{' fields error
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("unmatched '{' or '}'");
    }
    ;

fields
    : fields field
    {
        @$ = @2;
        ($$ = $1)->append($2);
    }
    | field
    {
        @$ = @1;
        ($$ = new List<Node *>())->append($1);
    }
    ;

field
    : var_def
    {
        @$ = @1;
        $$ = $1;
    }
    | func_def
    {
        @$ = @1;
        $$ = $1;
    }
    ;

var_def
    : var ';'
    {
        @$ = @1;
        $$ = $1;
    }
    | var error
    {
        @$ = @1;
        $$ = $1;
        proposed_solution("expected ';' or expected '=' as assign operator");
    }
    ;


var
    : type IDENTIFIER
    {
        @$ = @2;
        $$ = new VarDef($2, $1, locdup(&@2));
    }
    /* error recovery */
    | type error
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("expected identifier as variable name");
    }
    ;

type
    : INT
    {
        @$ = @1;
        $$ = new TypeBasic(TYPE_INT, locdup(&@1));
    }
    | BOOL
    {
        @$ = @1;
        $$ = new TypeBasic(TYPE_BOOL, locdup(&@1));
    }
    | STRING
    {
        @$ = @1;
        $$ = new TypeBasic(TYPE_STRING, locdup(&@1));
    }
    | VOID
    {
        @$ = @1;
        $$ = new TypeBasic(TYPE_VOID, locdup(&@1));
    }
    | CLASS IDENTIFIER
    {
        @$ = @2;
        $$ = new TypeClass($2, locdup(&@2));
    }
    | type '[' ']'
    {
        @$ = @1;
        $$ = new TypeArray($1, locdup(&@1));
    }
    /* error recovery */
    | error IDENTIFIER
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("unkown type");
    }
    | CLASS error
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("expected identifier as class name");
    }
    ;

func_def
    : type IDENTIFIER '=' '(' formals ')' OP_ARROW stmt_block ';'
    {
        @$ = @2;
        $$ = new FuncDef($2, $1, $5, (Block *)$8, locdup(&@2));
    }
    /* error recovery */
    | type error '=' '(' formals ')' OP_ARROW stmt_block ';'
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("expected identifier as variable name");
    }
    | type IDENTIFIER '=' '(' formals ')' error stmt_block  ';'
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("expected '=>' as function defination");
    }
    | type IDENTIFIER '=' '(' formals ')' OP_ARROW stmt_block error
    {
        @$ = @2;
        $$ = 0;
        proposed_solution("expected ';'");
    }
    ;

formals
    : vars
    {
        @$ = @1;
        $$ = $1;
    }
    | VOID
    {
        @$ = @1;
        $$ = new List<VarDef *>();
    }
    | /* empty */
    {
        $$ = new List<VarDef *>();
    }
    ;

vars
    : vars ',' var
    {
        @$ = @3;
        ($$ = $1)->append($3);
    }
    | var
    {
        @$ = @1;
        ($$ = new List<VarDef *>())->append($1);
    }
    /* error recovery */
    | vars error var
    {
        @$ = @3;
        ($$ = $1)->append($3);
        proposed_solution("expected ',' as separator");
    }
    | vars ',' error
    {
        @$ = @2;
        $$ = $1;
        proposed_solution("unexpected ','");
    }
    ;

actuals
    : exprs
    {
        @$ = @1;
        $$ = $1;
    }
    | /* empty */
    {
        $$ = new List<Expr *>();
    }
    ;

exprs
    : exprs ',' expr
    {
        @$ = @3;
        ($$ = $1)->append($3);
    }
    | expr
    {
        @$ = @1;
        ($$ = new List<Expr *>())->append($1);
    }
    /* error recovery */
    | exprs error expr
    {
        @$ = @3;
        ($$ = $1)->append($3);
        proposed_solution("expected ',' as separator");
    }
    | exprs ',' error
    {
        @$ = @3;
        $$ = $1;
        proposed_solution("unexpected ','");
    }
    ;

stmt_block
    : '{' stmts '}'
    {
        @$ = @1;
        $$ = new Block($2, locdup(&@1));
    }
    ;

stmts
    : stmts stmt
    {
        @$ = @2;
        ($$ = $1)->append($2);
    }
    | /* empty */
    {
        $$ = new List<Node *>();
    }
    ;

stmt
    : var_def
    {
        @$ = @1;
        $$ = $1;
    }
    | simple_stmt ';'
    {
        @$ = @1;
        $$ = $1;
    }
    | if_stmt
    {
        @$ = @1;
        $$ = $1;
    }
    | while_stmt
    {
        @$ = @1;
        $$ = $1;
    }
    | for_stmt
    {
        @$ = @1;
        $$ = $1;
    }
    | return_stmt ';'
    {
        @$ = @1;
        $$ = $1;
    }
    | print_stmt ';'
    {
        @$ = @1;
        $$ = $1;
    }
    | stmt_block
    {
        @$ = @1;
        $$ = $1;
    }
    /* error recovery */
    | simple_stmt error
    {
        @$ = @1;
        $$ = $1;
        proposed_solution("expected ';'");
    }
    | return_stmt error
    {
        @$ = @1;
        $$ = $1;
        proposed_solution("expected ';'");
    }
    | print_stmt error
    {
        @$ = @1;
        $$ = $1;
        proposed_solution("expected ';'");
    }
    ;

simple_stmt
    : lvalue '=' expr
    {
        @$ = @2;
        $$ = new Assign($1, $3, locdup(&@2));
    }
    | call
    {
        @$ = @1;
        $$ = new Exec($1, locdup(&@1));
    }
    ;

if_stmt
    : IF '(' expr ')' stmt %prec NOELSE
    {
        @$ = @1;
        $$ = new If($3, $5, 0, locdup(&@1));
    }
    | IF '(' expr ')' stmt ELSE stmt
    {
        @$ = @1;
        $$ = new If($3, $5, $7, locdup(&@1));
    }
    /* error recovery */
    | IF error expr ')' stmt %prec NOELSE
    {
        @$ = @1;
        $$ = 0;
        proposed_solution("unmatched '(' or ')'");
    }
    | IF '(' expr error stmt %prec NOELSE
    {
        @$ = @1;
        $$ = 0;
        proposed_solution("unmatched '(' or ')'");
    }
    ;

while_stmt
    : WHILE '(' expr ')' stmt
    {
        @$ = @1;
        $$ = new WhileLoop($3, $5, locdup(&@1));
    }
    /* error recovery */
    | WHILE error expr ')' stmt
    {
        @$ = @1;
        $$ = 0;
        proposed_solution("unmatched '(' or ')'");
    }
    | WHILE '(' expr error stmt
    {
        @$ = @1;
        $$ = 0;
        proposed_solution("unmatched '(' or ')'");
    }
    ;

for_stmt
    : FOR '(' simple_stmt ';' expr ';' simple_stmt ')' stmt
    {
        @$  = @1;
        $$  = new ForLoop($3, $5, $7, $9, locdup(&@1));
    }
    /* error recovery */
    | FOR error simple_stmt ';' expr ';' simple_stmt ')' stmt
    {
        @$ = @1;
        $$ = 0;
        proposed_solution("unmatched '(' or ')'");
    }
    | FOR '(' error ';' expr ';' simple_stmt ')' stmt
    {
        @$ = @1;
        $$ = 0;
        proposed_solution("expected ';' as separator between initializer and boolean expression");
    }
    | FOR '(' simple_stmt error expr ';' simple_stmt ')' stmt
    {
        @$ = @1;
        $$ = 0;
        proposed_solution("expected ';' as separator between initializer and boolean expression");
    }
    | FOR '(' simple_stmt ';' expr error simple_stmt ')' stmt
    {
        @$ = @1;
        $$ = 0;
        proposed_solution("expected ';' as separator between boolean expression and assignment");
    }
    | FOR '(' simple_stmt ';' expr ';' simple_stmt error stmt
    {
        @$ = @1;
        $$ = 0;
        proposed_solution("unmatched '(' or ')'");
    }
    ;

return_stmt
    : RETURN
    {
        @$ = @1;
        $$ = new Return(0, locdup(&@1));
    }
    | RETURN expr
    {
        @$ = @1;
        $$ = new Return($2, locdup(&@1));
    }
    ;

print_stmt
    : PRINT '(' exprs ')'
    {
        @$ = @1;
        $$ = new Print($3, locdup(&@1));
    }
    /* error recovery */
    | PRINT error exprs ')' ';'
    {
        @$ = @3;
        $$ = 0;
        proposed_solution("unmatched '(' or ')'");
    }
    | PRINT '(' exprs error ';'
    {
        @$ = @3;
        $$ = 0;
        proposed_solution("unmatched '(' or ')'");
    }
    ;

lvalue
    : receiver IDENTIFIER
    {
        if ($1 == 0) {
            @$ = @2;
        } else {
            @$ = @1;
        }

        $$ = new Ident($1, $2, locdup(&@2));
    }
    | expr '[' expr ']'
    {
        $$ = new Indexed($1, $3, locdup(&@1));
    }
    ;

call
    : receiver IDENTIFIER '(' actuals ')'
    {
        if ($1 == 0) {
            @$ = @2;
        } else {
            @$ = @1;
        }

        $$ = new CallExpr($1, $2, $4, locdup(&@2));
    }
    ;

receiver
    : expr '.'
    {
        @$ = @1;
        $$ = $1;
    }
    | /* empty */
    {
        $$ = 0;
    }
    ; 

expr
    : lvalue
    {
        @$ = @1;
        $$ = $1;
    }
    | call
    {
        @$ = @1;
        $$ = $1;
    }
    | constant
    {
        @$ = @1;
        $$ = $1;
    }
    | expr '+' expr
    {
        @$ = @2;
        $$ = new Binary(EXPR_ADD, $1, $3, locdup(&@2));
    }
    | expr '-' expr
    {
        @$ = @2;
        $$ = new Binary(EXPR_SUB, $1, $3, locdup(&@2));
    }
    | expr '*' expr
    {
        @$ = @2;
        $$ = new Binary(EXPR_MUL, $1, $3, locdup(&@2));
    }
    | expr '/' expr
    {
        @$ = @2;
        $$ = new Binary(EXPR_DIV, $1, $3, locdup(&@2));
    }
    | expr '%' expr
    {
        @$ = @2;
        $$ = new Binary(EXPR_MOD, $1, $3, locdup(&@2));
    }
    | expr OP_EQ expr
    {
        @$ = @2;
        $$ = new Binary(EXPR_EQ, $1, $3, locdup(&@2));
    }
    | expr OP_NE expr
    {
        @$ = @2;
        $$ = new Binary(EXPR_NE, $1, $3, locdup(&@2));
    }
    | expr '<' expr
    {
        @$ = @2;
        $$ = new Binary(EXPR_LT, $1, $3, locdup(&@2));
    }
    | expr '>' expr
    {
        @$ = @2;
        $$ = new Binary(EXPR_GT, $1, $3, locdup(&@2));
    }
    | expr OP_LE expr
    {
        @$ = @2;
        $$ = new Binary(EXPR_LE, $1, $3, locdup(&@2));
    }
    | expr OP_GE expr
    {
        @$ = @2;
        $$ = new Binary(EXPR_GE, $1, $3, locdup(&@2));
    }
    | expr OP_AND expr
    {
        @$ = @2;
        $$ = new Binary(EXPR_AND, $1, $3, locdup(&@2));
    }
    | expr OP_OR expr
    {
        @$ = @2;
        $$ = new Binary(EXPR_OR, $1, $3, locdup(&@2));
    }
    | '(' expr ')'
    {
        @$ = @2;
        $$ = $2;
    }
    | '-' expr %prec UNEG
    {
        @$ = @1;
        $$ = new Unary(EXPR_NEG, $2, locdup(&@1));
    }
    | '!' expr
    {
        @$ = @1;
        $$ = new Unary(EXPR_NOT, $2, locdup(&@1));
    }
    | READINTEGER '(' ')'
    {
        @$ = @1;
        $$ = new ReadIntExpr(locdup(&@1));
    }
    | READLINE '(' ')'
    {
        @$ = @1;
        $$ = new ReadLineExpr(locdup(&@1));
    }
    | THIS
    {
        @$ = @1;
        $$ = new ThisExpr(locdup(&@1));
    }
    | NEW IDENTIFIER '(' ')'
    {
        @$ = @1;
        $$ = new NewClass($2, locdup(&@1));
    }
    | NEW type '[' expr ']'
    {
        @$ = @1;
        $$ = new NewArray($2, $4, locdup(&@1));
    }
    ;

constant
    : CONSTANT_INT
    {
        @$ = @1;
        $$ = new Constant(TYPE_INT, $1, locdup(&@1));
    }
    | CONSTANT_BOOL
    {
        @$ = @1;
        $$ = new Constant(TYPE_BOOL, $1, locdup(&@1));
    }
    | CONSTANT_STRING
    {
        @$ = @1;
        $$ = new Constant(TYPE_STRING, $1, locdup(&@1));
    }
    | NIL
    {
        @$ = @1;
		$$ = new Null(locdup(&@1));
    }
    ;

%%

int yyerror(const char *msg) {
    dragon_report(&yylloc, "%s", msg);
    memset(yytext, '\0', strlen(yytext));
    parse_failed = 1;
    return 0;
}

int proposed_solution(const char *sol) {
    fprintf(stderr, "    proposed solution: %s\n", sol);
    return 0;
}


