%{
#include <stdio.h>
#include "gen-hash.h"
#include "boolnet.h"
#include "ast.h"
#define YYSTYPE node_ptr
#include "simplec.tab.h"
int count_returns(char *s);
void yyerror(const char *str);


extern YYSTYPE yylval;
extern int lineno;
%}
%%
\/\/[^\n]*\n                  lineno++;  /* C++ style comments */
\/\*([^*]|(\*)+[^*/])*(\*)+\/        { lineno += count_returns(yytext); } /* C-style */
[ \r\t\f]             ;
[\n]                  lineno++;
int                   return(INT);
void                  return(VOID);
const                 ;
register              ;
volatile              ;
signed                ;
static                ;
float                 return(FLOAT);
unsigned              return(UNSIGNED);
char                  return(CHAR);
short                 return(SHORT);
long                  return(LONG);
return                return(RETURN);
break                 return(BREAK);
continue              return(CONTINUE);
switch                return(SWITCH);
case                  return(CASE);
default               return(DEFAULT);
sizeof                return(SIZEOF);
if return(IF);
else return(ELSE);
while return(WHILE);
do return(DO);
for return(FOR);
[0-9]+[\.][0-9]*                yylval = make_ast_num(yytext); return(NUM);
[0-9]*[\.][0-9]+                     yylval = make_ast_num(yytext); return(NUM);
[0-9]*[\.][0-9]*[eE][+-]?[0-9]+       yylval = make_ast_num(yytext); return(NUM);
[1-9][0-9]*[eE][+-]?[0-9]+                 yylval = make_ast_num(yytext); return(NUM);
[1-9][0-9]*[lLuU]*                   yylval = make_ast_num(yytext); return(NUM);
0[0-7]*[lLuU]*                       yylval = make_ast_num(yytext); return(NUM);
0(x|X)[0-9a-fA-F][0-9a-fA-F]*[lLuU]* yylval = make_ast_num(yytext); return(NUM);
[_a-zA-Z][a-zA-Z0-9_]*               yylval = get_ast_var(yytext); return(VAR);

";"                   return(SEMI);
","                   return(COMMA);
"("                   return(LPAREN);
")"                   return(RPAREN);
"{"                   return(LBRACE);
"}"                   return(RBRACE);
"["                   return(LBRACK);
"]"                   return(RBRACK);

"="                   return(ASSIGN);
"^="                  return(CARATASSIGN);
"&="                  return(AMPASSIGN);
"*="                  return(STARASSIGN);
"+="                  return(PLUSASSIGN);
"-="                  return(MINUSASSIGN);
"|="                  return(BARASSIGN);
"<<="                 return(LEFTSHIFTASSIGN);
">>="                 return(RIGHTSHIFTASSIGN);
"/="                  return(SLASHASSIGN);
"%="                  return(PERCENTASSIGN);

"++"                  return(PLUSPLUS);
"--"                  return(MINUSMINUS);


"&&"                  return(AMPAMP);
"||"                  return(BARBAR);
"~"                   return(TILDE);
"!"                   return(BANG);
"^"                   return(CARAT);
"&"                   return(AMP);
"|"                   return(BAR);
"*"                   return(STAR);
"-"                   return(MINUS);
"+"                   return(PLUS);
"/"                   return(SLASH);
"%"                   return(PERCENT);

"<<"                  return(LESSLESS);
">>"                  return(GREATERGREATER);

":"                   return(COLON);
"?"                   return(QUESTION);


"!="                  return(NOTEQUAL);
"=="                  return(EQUAL);
"<"                   return(LESS);
"<="                  return(LESSEQUAL);
">"                   return(GREATER);
">="                  return(GREATEREQUAL);

%%


