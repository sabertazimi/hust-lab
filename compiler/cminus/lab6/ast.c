#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

// "constructors"
Exp_t Exp_Int_new (int n)
{
  Exp_Int p = malloc (sizeof (*p));
  p->kind = EXP_INT;
  p->n = n;
  return (Exp_t)p;
}

Exp_t Exp_Add_new (Exp_t left, Exp_t right)
{
  Exp_Add p = malloc (sizeof (*p));
  p->kind = EXP_ADD;
  p->left = left;
  p->right = right;
  return (Exp_t)p;
}

Exp_t Exp_Minus_new (Exp_t left, Exp_t right)
{
  Exp_Minus p = malloc (sizeof (*p));
  p->kind = EXP_MINUS;
  p->left = left;
  p->right = right;
  return (Exp_t)p;
}

Exp_t Exp_Times_new (Exp_t left, Exp_t right)
{
  Exp_Times p = malloc (sizeof (*p));
  p->kind = EXP_TIMES;
  p->left = left;
  p->right = right;
  return (Exp_t)p;
}

Exp_t Exp_Divide_new (Exp_t left, Exp_t right)
{
  Exp_Divide p = malloc (sizeof (*p));
  p->kind = EXP_DIVIDE;
  p->left = left;
  p->right = right;
  return (Exp_t)p;
}

// all operations on "Exp"
void Exp_print (Exp_t exp)
{
  switch (exp->kind){
  case EXP_INT:{
    Exp_Int p = (Exp_Int)exp;
    printf ("%d", p->n);
    return;
  }
  case EXP_ADD:{
    Exp_Add p = (Exp_Add)exp;
    printf ("(");
    Exp_print (p->left);
    printf (") + (");
    Exp_print (p->right);
    printf (")");
    return;
  }
  case EXP_MINUS:{
    Exp_Minus p = (Exp_Minus)exp;
    printf ("(");
    Exp_print (p->left);
    printf (") - (");
    Exp_print (p->right);
    printf (")");
    return;
  }
  case EXP_TIMES:{
    Exp_Times p = (Exp_Times)exp;
    printf ("(");
    Exp_print (p->left);
    printf (") * (");
    Exp_print (p->right);
    printf (")");
    return;
  }
  case EXP_DIVIDE:{
    Exp_Divide p = (Exp_Divide)exp;
    printf ("(");
    Exp_print (p->left);
    printf (") / (");
    Exp_print (p->right);
    printf (")");
    return;
  }

  default:
    return;
  }
}



