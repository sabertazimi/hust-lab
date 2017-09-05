#ifndef __WATCHPOINT_H__
#define __WATCHPOINT_H__

#include "common.h"

typedef struct watchpoint {
  int NO;
  struct watchpoint *next;

  /* TODO: Add more members if necessary */

  bool free;
  char exprStr[256];
  uint32_t oldval;
} WP;

WP* new_wp(char *expr);
bool free_wp(int NO);
WP *get_head_list(void);
WP *get_free_list(void);

#endif
