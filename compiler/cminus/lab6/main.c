#include "ast.h"

extern Exp_t tree;
void yyparse ();

int main (int argc, char **argv)
{
  yyparse();
  Exp_print (tree);
  return 0;
}
