/*
 * vm.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include <stdio.h>
#include "vm.h"
#define MEM_SIZE 100

struct mem {
  int stack[MEM_SIZE];
  int bottom;
  int top;
};

void Vm_run(struct List_t *list) {
  struct List_t * p = list->next;

  struct mem m;
  m.bottom = 0;
  m.top = -1;

  while (p && p->instr) {
    switch (p->instr->kind) {
    case STACK_ADD: {
      m.stack[m.top-1] += m.stack[m.top];
      m.top--;
      break;
    }
    case STACK_MINUS: {
      m.stack[m.top-1] -= m.stack[m.top];
      m.top--;
      break;
    }
    case STACK_TIMES: {
      m.stack[m.top-1] *= m.stack[m.top];
      m.top--;
      break;
    }
    case STACK_DIVIDE: {
      m.stack[m.top-1] /= m.stack[m.top];
      m.top--;
      break;
    }
    case STACK_PUSH: {
      struct Stack_Push *sp = (struct Stack_Push *)p->instr;
      m.top++;
      m.stack[m.top] = sp->i;
      break;
    }
    default:
      break;
    }

    p = p->next;
  }

  printf("Outpu: %d", m.stack[m.top]);
}
