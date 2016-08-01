#include "monitor/watchpoint.h"
#include "monitor/expr.h"

#define NR_WP 32

static WP wp_pool[NR_WP];
static WP *head, *free_;

void init_wp_pool(void) {
	int i;
	for(i = 0; i < NR_WP; i ++) {
		wp_pool[i].NO = i;
		wp_pool[i].next = &wp_pool[i + 1];
	}
	wp_pool[NR_WP - 1].next = NULL;

	head = NULL;
	free_ = wp_pool;
}

/* TODO: Implement the functionality of watchpoint */

WP *new_wp(void) {
	// have no enough watchpoints
	if (!free_) {
		return NULL;
	}

	WP *new = free_;
	free_ = free_->next;

	new->next = head;
	head = new;

	return new;
}

bool free_wp(int no) {
	WP *pre = NULL, *p = head;

	while (p && p->NO != no) {
		pre = p;
		p = p->next;
	}

	// all watchpoints have been freed
	if (!p) {
		return false;
	}

	// whether to free head watchpoint or not
	if (!pre) {
		head = p->next;
	} else {
		pre->next = p->next;
	}

	p->next = free_;
	free_ = p;

	return true;
}

void print_watchpoints(void) {
	if (!head) {
		printf("\033[1m\033[31mNo watchpoints\n\033[0m");
		return ;
	}

	WP *p = head;

	printf("\033[1m\033[35mNum\tWhat\n");
	while (p) {
		printf("%3d\t%s\n", p->NO, p->str);
		p = p->next;
	}
	printf("\n\033[0m");
}

int check_watchpoints(void) {
	int changed = 0;
	WP *p = head;

	while (p) {
		bool success;
		uint32_t new_val = expr(p->str, &success);

		if(!success) {
			assert(0);
		} else if(new_val != p->old_val) {
			printf("\033[1m\033[35mwatchpoint NO.%d: %s\n",p->NO, p->str);
			printf("old value: %u\n", p->old_val);
			printf("new value: %u\n", new_val);
			printf("\n\033[0m");

			p->old_val = new_val;
			changed += 1;
		}

		p = p->next;
	}

	return changed;
}

