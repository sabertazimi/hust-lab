#include <stdio.h>
#include "ast.h"
#include "stack.h"
#include "vm.h"

extern Exp_t tree;
extern struct List_t *instrs;
void yyparse ();

int main (int argc, char **argv)
{
  yyparse();

  Exp_print (tree);
  printf("\n");

  stack_init();

  compile(tree);
  printf("\n");

  List_print(instrs);
  printf("\n");

  Vm_run(instrs);
  printf("\n");
  return 0;
}
