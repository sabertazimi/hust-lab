#ifndef __WATCHPOINT_H__
#define __WATCHPOINT_H__

#include "common.h"

typedef struct watchpoint {
  int NO;
  struct watchpoint *next;

  /* TODO: Add more members if necessary */

  char exprStr[256];
  uint32_t oldval;
} WP;

WP* new_wp(char *expr);
bool free_wp(int NO);
WP *get_watchpoints(void);
void print_watchpoints(void);

#endif
