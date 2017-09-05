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
    wp_pool[i].exprStr[0] = '\0';
    wp_pool[i].oldval = 0;
  }
  wp_pool[NR_WP - 1].next = NULL;

  head = NULL;
  free_ = wp_pool;
}

/* TODO: Implement the functionality of watchpoint */

WP* new_wp(char *exprStr) {
  if (free_ == NULL) {
    Warn("No more space for a new watchpoint");
    return NULL;
  }

  bool success = true;
  uint32_t val = expr(exprStr, &success);

  if (success == false) {
    return NULL;
  }

  WP* next = free_->next;
  free_->next = head;
  head = free_;
  free_ = next;

  // initlize
  strncpy(head->exprStr, exprStr, strlen(exprStr));
  head->oldval = val;

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

      // reset
      free_->exprStr[0] = '\0';
      free_->oldval = 0;

      return true;
    }

    prev = cur;
    cur = cur->next;
  }

  return false;
}

void print_watchpoints(void) {
  if (head == NULL) {
    Info("No watchpoints");
    return;
  }

  Info("Num\tWhat");

  for (WP *trav = head; trav != NULL; trav = trav->next) {
      Info("%d\t%s", trav->NO, trav->exprStr);
  }
}

bool check_watchpoints(void) {
  bool is_changed = false;

  for (WP *trav = head; trav != NULL; trav = trav->next) {
    bool success = true;
    int newval = expr(trav->exprStr, &success);

    // checking watchpoint
    if (newval != trav->oldval) {
      Info("Watchpoint No.%d: %s", trav->NO, trav->exprStr);
      Info("Old value = %d (0x%x)", trav->oldval, trav->oldval);
      Info("New value = %d (0x%x)\n", newval, newval);

      trav->oldval = newval;
      is_changed = true;
    }
  }

  return is_changed;
}

