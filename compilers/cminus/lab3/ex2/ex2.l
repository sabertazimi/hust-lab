%{
    #include <iostream>
    #include <cstdlib>
    using namespace std;
    int num_lines = 0;
    int num_chars = 0;
%}

%%

[0-9]+          { cout<<"INT("<<strtol(yytext, 0, 10)<<")"; };
"if"            { cout<<"IF keyword"; };
"exit"          { exit(0); };
"quit"          { exit(0); };
[a-zA-Z]+       { cout<<"ID("<<strdup(yytext)<<")"; };
[ \t];
\n              { cout<<"\n"; ++num_chars; ++num_lines; };
.               { ++num_chars; };

%%

int yywrap(void) {
    return 1;
}

int main(int argc, char **argv) {
    yylex();
    printf("# of lines = %d, # of chars = %d\n", num_lines, num_chars);
}
