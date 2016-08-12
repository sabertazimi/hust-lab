%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
  int yylex(void); // this function will be called in the parser
  void yyerror(char *);

  Exp_t tree;

  %}

%union{
  Exp_t exp;
 }

%type <exp> digit exp program


%left '+' '-'
%left '*' '/'

%start program

%%

program: exp {tree = $1;}
;

exp: digit     {$$ = $1;}
| exp '+' exp  {$$ = Exp_Add_new ($1, $3);}
| exp '-' exp  {$$ = Exp_Minus_new ($1, $3);}
| exp '*' exp  {$$ = Exp_Times_new ($1, $3);}
| exp '/' exp  {$$ = Exp_Divide_new ($1, $3);}
| '(' exp ')'  {$$ = $2;}
;

digit: '0'  {$$ = Exp_Int_new (0);}
| '1'       {$$ = Exp_Int_new (1);}
| '2'       {$$ = Exp_Int_new (2);}
| '3'       {$$ = Exp_Int_new (3);}
| '4'       {$$ = Exp_Int_new (4);}
| '5'       {$$ = Exp_Int_new (5);}
| '6'       {$$ = Exp_Int_new (6);}
| '7'       {$$ = Exp_Int_new (7);}
| '8'       {$$ = Exp_Int_new (8);}
| '9'       {$$ = Exp_Int_new (9);}
;

%%

int yylex (void)
{
  int c = getchar();
  return c;
}

// bison needs this function to report
// error message
void yyerror(char *err)
{
  printf(">> ");
  return;
}

