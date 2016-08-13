#include <stdio.h>
#include "ast.h"
#include "semant.h"

#define DEBUG
#undef DEBUG

extern void yyparse();
extern Prog_t tree;

int main (int argc, char **argv) {
  printf("lex and parse starting...\n");
  int v;

#ifdef DEBUG

  while ((v = yylex()) != EOF) {
    printf("%d\n", v);
  }

  printf("%d\n", v);

#endif

  yyparse();
  printf("lex and parse finished\n\n");

  printf("print the AST starting...\n");
  Prog_print(tree);
  printf("print the AST finished\n\n");

  printf("semantic analysis starting...\n");
  Semant_check(tree);
  printf("semantic analysis finished\n\n");
  return 0;
}
