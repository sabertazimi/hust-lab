%{

    #include <stdio.h>
    #include "calculate.tab.h"

    int yywrap(void) {
        return 1;
    }

%}

%%

"+"    return ADD;
"-"    return SUB;
"*"    return MUL;
"/"    return DIV;
"\n"   return CR;

([1-9][0-9]*)|0|([0-9]+\.[0-9]+) {
    double temp;
    sscanf(yytext, "%lf", &temp);
    yylval.double_value = temp;
    return DOUBLE_LITERAL;
}

[ \t];

. {
    fprintf(stderr, "Lexical error near %s.\n", yytext);
}

%%
