#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "semant.h"
#include "stack-machine.h"
#include "gen-stack.h"
#include "stack2x86.h"

#define DEBUG
#undef DEBUG

extern void yyparse();
extern Prog_t tree;

int main (int argc, char **argv)
{
  printf("\n====================\n");
  printf ("lex and parse starting...\n");
  int v;
  yyparse();
  printf ("lex and parse finished\n");

#ifdef DEBUG

  printf ("print the AST starting...\n");
  Prog_print (tree);
  printf ("print the AST finished\n");

#endif

  printf ("semantic analysis starting...\n");
  Semant_check(tree);
  printf ("semantic analysis finished\n");

  printf ("stack machine code generation starting...\n");
  Stack_Prog_t stack = Gen_stack(tree);
  printf ("stack machine code generation finished\n");

#ifdef DEBUG

  printf ("stack machine code output starting...\n");
  Stack_Prog_print(stack);
  printf ("stack machine code output finished\n");

#endif

  printf ("x86 code generation starting...\n");
  Stack2x86_print (stack);
  printf ("x86 code generation finished (writing to file \"stack.s\")\n");

#ifdef DEBUG
  system("cat stack.s");
#endif

  printf ("executable generation starting...\n");
  system ("gcc -Wall -g -m32 -o stack.exe stack.s");
  printf ("executable generation finished (writing to file \"stack.exe\")\n");

  printf("====================\n\n");
  return 0;
}
