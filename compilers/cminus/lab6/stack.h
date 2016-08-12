/*
 * stack.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef STACK_H
#define STACK_H

#include "ast.h"

enum Stack_Kind_t {
  STACK_ADD,
  STACK_MINUS,
  STACK_TIMES,
  STACK_DIVIDE,
  STACK_PUSH
};

struct Stack_t
{
  enum Stack_Kind_t kind;
};

struct Stack_Add
{
  enum Stack_Kind_t kind;
};

struct Stack_Minus
{
  enum Stack_Kind_t kind;
};

struct Stack_Times
{
  enum Stack_Kind_t kind;
};

struct Stack_Divide
{
  enum Stack_Kind_t kind;
};

struct Stack_Push
{
  enum Stack_Kind_t kind;
  int i;
};

struct List_t
{
  struct Stack_t *instr;
  struct List_t *next;
};

void compile (struct Exp_t *exp);
void List_print (struct List_t *list);
void stack_init(void);

#endif /* !STACK_H */
