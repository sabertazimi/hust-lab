#ifndef __WATCHPOINT_H__
#define __WATCHPOINT_H__

#include "common.h"

typedef struct watchpoint {
	int NO;
	struct watchpoint *next;

	/* TODO: Add more members if necessary */

	unsigned int old_val;
	char str[32];

} WP;

void init_wp_list(void);
WP *new_wp(void);
bool free_wp(int);
void print_watchpoints(void);
int check_watchpoints(void);

#endif
