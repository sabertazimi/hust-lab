#include <stdio.h>
#include "ast.h"
#include "semant.h"

extern void yyparse();
extern Prog_t tree;

int main (int argc, char **argv)
{
  printf ("lex and parse starting...\n");
  int v;
  /*
  while ((v=yylex())!=EOF)
    printf ("%d\n", v);
  printf ("%d\n", v);
  */
  yyparse();
  printf ("lex and parse finished\n");
  
  printf ("print the AST starting...\n");
  Prog_print (tree);
  printf ("print the AST finished\n");

  printf ("semantic analysis starting...\n");
  Semant_check(tree);
  printf ("semantic analysis finished\n");
  return 0;
}
