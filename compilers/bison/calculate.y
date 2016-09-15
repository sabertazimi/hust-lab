%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #define YYDEBUG 1

    int yylex(void);
    int yyerror(char const *str);
%}

%union {
    int int_value;
    double double_value;
}

%token <double_value>   DOUBLE_LITERAL;
%token ADD SUB MUL DIV CR
%type <double_value> exp

%left ADD SUB
%left MUL DIV

%%

lines: line
     | line lines
     ;

line: exp CR {
        printf(">> value=%.10g\n",$1);
    }
    | exit CR 
    | error CR {
        yyclearin;
        yyerrok;
    }
    ;


exp: DOUBLE_LITERAL { $$ = $1; }
   | exp ADD exp    { $$ = $1 + $3;}
   | exp SUB exp    { $$ = $1 - $3;}
   | exp DIV exp    { $$ = $1 / $3;}
   | exp MUL exp    { $$ = $1 * $3;}
   | '(' exp ')'    { $$ = $2;}
   ;

exit: 'e'     { exit(0); }
    | 'q'     { exit(0); }
    | 'e' xit { exit(0); }
    | 'q' uit { exit(0); }
    ;

xit: 'x' it;
uit: 'u' it;
it: 'i' t;
t: 't';

%%

int yyerror(char const *str) {
    extern char *yytext;
    fprintf(stderr, "Parser error near.\n");
    memset(yytext, '\0', strlen(yytext));
    return 0;
}

int main(int argc, char **argv) {
    extern int yyparse(void);
    extern FILE *yyin;
    FILE *fp;

    if (argc > 1 && (fp = fopen(argv[1], "r")) != NULL) {
        yyin = fp;
    }

    if (yyparse()) {
        fprintf(stderr, "Bison panic.\n");
        exit(1);
    }

    fclose(fp);
    return 0;
}
