#include "monitor/watchpoint.h"
#include "monitor/expr.h"

#define NR_WP 32

static WP wp_pool[NR_WP];
static WP *head, *free_;

void init_wp_pool() {
  int i;
  for (i = 0; i < NR_WP; i ++) {
    wp_pool[i].NO = i;
    wp_pool[i].next = &wp_pool[i + 1];
  }
  wp_pool[NR_WP - 1].next = NULL;

  head = NULL;
  free_ = wp_pool;
}

WP* new_wp(char *expr) {
  if (free_ == NULL) {
    assert(0);
  }

  Log("%s", expr);

  WP* next = free_->next;
  free_->next = head;
  head = free_;
  free_ = next;
  return head;
}

bool free_wp(int NO) {
  WP* prev = head;
  WP* cur = head;

  while (cur != NULL) {
    if (cur->NO == NO) {
      if (prev == cur) {
        // head pointer
        head = cur->next;
      } else {
        // non-head pointer
        prev->next = cur->next;
      }

      cur->next = free_;
      free_ = cur;
      return true;
    }

    prev = cur;
    cur = cur->next;
  }

  return false;
}

/* TODO: Implement the functionality of watchpoint */


