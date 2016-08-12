%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

  int yylex();
  void yyerror (char *);

  // the AST:
  Prog_t tree;

  %}

%union{
  int intval;
  string strval;
  Type_t typeval;
  Dec_t decval;
  List_t decsval;
  Exp_t expval;
  Stm_t stmval;
  List_t stmsval;
  Prog_t progval;
 }

// terminals
%token <intval> INTNUM
%token <strval> ID
%token AND BOOL FALSE INT OR 
PRINTB PRINTI TRUE

// nonterminals
%type <progval> prog
%type <decval> dec
%type <decsval> decs
%type <stmval> stm
%type <stmsval> stms
%type <expval> exp
%type <typeval> type

%left AND OR
%left '+' '-'
%left '*' '/'

%start prog

%%

prog: '{' decs stms '}' {tree = Prog_new ($2, $3); return 0;}
;

decs: dec decs  {$$ = List_new ($1, $2);}
|               {$$ = 0;}
;

dec: type ID ';' {$$ = Dec_new ($1, $2);}
;

type: BOOL       {$$ = TYPE_BOOL;}
| INT            {$$ = TYPE_INT;}
;

stms: stm stms {$$ = List_new ($1, $2);}
|              {$$ = 0;}
;

stm: ID '=' exp ';'      {$$ = Stm_Assign_new ($1, $3);}
| PRINTI '(' exp ')' ';' {$$ = Stm_Printi_new ($3);}
| PRINTB '(' exp ')' ';' {$$ = Stm_Printb_new ($3);}
;

exp: INTNUM    {$$ = Exp_Int_new ($1);} 
| TRUE         {$$ = Exp_True_new ();}
| FALSE        {$$ = Exp_False_new ();}
| ID           {$$ = Exp_Id_new ($1);}
| exp '+' exp  {$$ = Exp_Add_new ($1, $3);}
| exp '-' exp  {$$ = Exp_Sub_new ($1, $3);}
| exp '*' exp  {$$ = Exp_Times_new ($1, $3);}
| exp '/' exp  {$$ = Exp_Divide_new ($1, $3);}
| exp AND exp  {$$ = Exp_And_new ($1, $3);}
| exp OR exp   {$$ = Exp_Or_new ($1, $3);}
| '(' exp ')'  {$$ = $2;}
;


%%

void yyerror (char *s)
{
  fprintf (stderr, "%s\n", s);
  return;
}


