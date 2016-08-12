%{
    #define YYSTYPE double
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>

    int yylex(void);
    void yyerror(char *s);
%}

%token num

%left '+' '-'
%left '*' '/'

%%

lines: line
     | line lines
     ;

line: exp '\n' {
        printf("value=%.10g\n",$1);
    }
    | exit '\n'
    ;


exp: num            { $$ = $1; }
   | exp '+' exp    { $$ = $1 + $3;}
   | exp '-' exp    { $$ = $1 - $3;}
   | exp '/' exp    { $$ = $1 / $3;}
   | exp '*' exp    { $$ = $1 * $3;}
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

int yylex(void) {
    int c;

    while ((c = getchar()) == ' ' || c == '\t') {
        ;
    }

    if (c == '.' || isdigit(c)) {
        ungetc(c, stdin);
        scanf("%lf", &yylval);
        return num;
    }

    if (c == EOF) {
        return 0;
    }

    return c;
}

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    yyparse();
    return;
}

int main(int argc, char **argv) {
    return yyparse();
}
