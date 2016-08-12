/*
 * stack.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include <stdio.h>
#include <stdlib.h>
#include "stack.h"

static struct Stack_t *Stack_Add_new ()
{
  struct Stack_Add *p = malloc (sizeof(*p));
  p->kind = STACK_ADD;
  return (struct Stack_t *)p;
}

static struct Stack_t *Stack_Minus_new ()
{
  struct Stack_Add *p = malloc (sizeof(*p));
  p->kind = STACK_MINUS;
  return (struct Stack_t *)p;
}

static struct Stack_t *Stack_Times_new ()
{
  struct Stack_Add *p = malloc (sizeof(*p));
  p->kind = STACK_TIMES;
  return (struct Stack_t *)p;
}

static struct Stack_t *Stack_Divide_new ()
{
  struct Stack_Add *p = malloc (sizeof(*p));
  p->kind = STACK_DIVIDE;
  return (struct Stack_t *)p;
}

static struct Stack_t *Stack_Push_new (int i)
{
  struct Stack_Push *p = malloc (sizeof(*p));
  p->kind = STACK_PUSH;
  p->i = i;
  return (struct Stack_t *)p;
}

static struct List_t *List_new (struct Stack_t *instr, struct List_t *next)
{
  struct List_t *p = malloc (sizeof (*p));
  p->instr = instr;
  p->next = next;
  return p;
}

struct List_t *instrs;
struct List_t *tail;

static void emit (struct Stack_t *instr)
{
  tail->next = List_new (instr, 0);
  tail = tail->next;
}

void compile (struct Exp_t *exp)
{
  switch (exp->kind){
  case EXP_INT:{
    struct Exp_Int *p = (struct Exp_Int *)exp;
    emit (Stack_Push_new (p->n));
    break;
  }
  case EXP_ADD:{
    struct Exp_Add *sp = (struct Exp_Add *)exp;
    compile (sp->left);
    compile (sp->right);
    emit (Stack_Add_new ());
    break;
  }
  case EXP_MINUS:{
    struct Exp_Minus *sp = (struct Exp_Minus *)exp;
    compile (sp->left);
    compile (sp->right);
    emit (Stack_Minus_new ());
    break;
  }
  case EXP_TIMES:{
    struct Exp_Times *sp = (struct Exp_Times *)exp;
    compile (sp->left);
    compile (sp->right);
    emit (Stack_Times_new ());
    break;
  }
  case EXP_DIVIDE:{
    struct Exp_Divide *sp = (struct Exp_Divide *)exp;
    compile (sp->left);
    compile (sp->right);
    emit (Stack_Divide_new ());
    break;
  }
  default:
    break;
  }
}


void List_print(struct List_t *list)
{
  struct List_t *p = list->next;

  while (p && p ->instr) {
    switch (p->instr->kind) {
    case STACK_ADD: {
      printf("ADD\n");
      break;
    }
    case STACK_MINUS: {
      printf("MINUS\n");
      break;
    }
    case STACK_TIMES: {
      printf("TIMES\n");
      break;
    }
    case STACK_DIVIDE: {
      printf("DIVIDE\n");
      break;
    }
    case STACK_PUSH: {
      struct Stack_Push *sp = (struct Stack_Push *)p->instr;
      printf("PUSH %d\n", sp->i);
      break;
    }
    default:
      break;
    }

    p = p->next;
  }
}

void stack_init(void) {
    instrs = List_new(0, 0);
    tail = instrs;
}

