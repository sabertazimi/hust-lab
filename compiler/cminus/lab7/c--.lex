%{
#include <stdio.h>
#include <string.h>
#include "ast.h"
#include "c--.tab.h"

  char *clone (char *s)
  {
    char *p = malloc (strlen(s)+1);
    strcpy (p, s);
    return p;
  }
%}

ALPHA [a-zA-Z_]
DIGIT [0-9]
NUM {DIGIT}+
IDS ({ALPHA}({ALPHA}|{DIGIT})*)

%%
" "    {continue;}
"\n"   {continue;}
"("    {return '(';}
")"    {return ')';}
"{"    {return '{';}
"}"    {return '}';}
";"    {return ';';}
"+"    {return '+';}
"-"    {return '-';}
"*"    {return '*';}
"/"    {return '/';}
"="    {return '=';}
"&&"   {return AND;}
"||"   {return OR;}
"int"  {return INT;}
"bool" {return BOOL;}
"true" {return TRUE;}
"false" {return FALSE;}
"printi" {return PRINTI;}
"printb" {return PRINTB;}
{NUM}  {yylval.intval = atoi(yytext); return INTNUM;}
{IDS}  {yylval.strval = clone(yytext); return ID;}
.      {fprintf (stderr, "illegal char: %s\n", yytext); exit (0);}

%%

int yywrap ()
{
  return 0;
}
