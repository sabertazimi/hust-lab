/*
 * vm.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include "vm.h"

int vm_init(void) {
    if (!(text = old_text = malloc(poolsize))) {
        printf("could not malloc(%d) for text area\n", poolsize);
        return -1;
    }

    if (!(data = malloc(poolsize))) {
        printf("could not malloc(%d) for data area\n", poolsize);
        return -1;
    }

    if (!(stack = malloc(poolsize))) {
        printf("could not malloc(%d) for stack area\n", poolsize);
        return -1;
    }

    memset(text, 0, poolsize);
    memset(data, 0, poolsize);
    memset(stack, 0, poolsize);

    bp = sp = (int *)((int)stack + poolsize);
    ax = 0;

    return 0;
}

int eval(void) {
    int op,
        *tmp;

    while (1) {
        if (op == IMM) {
            ax = *pc++;
        } else if (op == LC) {
            ax = *(char *)ax;
        } else if (op == LI) {
            ax = *(int *)ax;
        } else if (op == SC) {
            *(char *)*sp++ = ax;
        } else if (op == SI) {
            *(int *)*sp++ = ax;
        } else if (op == PUSH) {
            *--sp = ax;
        } else if (op == JMP) {
            pc = (int *)*pc;
        } else if (op == JZ) {
            // jump if ax is zero
            pc = ax ? pc + 1 : (int *)*pc;
        } else if (op == JNZ) {
            // jump if ax isn't zero
            pc = ax ? (int *)*pc : pc + 1;
        } else if (op == CALL) {
            // push address of caller
            *--sp  = (int)(pc + 1);
            // jump to callee
            pc = (int *)*pc;
        } else if (op == RET) {
            pc = (int *)*sp++;
        }
    }

    return 0;
}
