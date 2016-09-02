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

        /*
         * *pc  : get parameter of assembly instruction
         * *--sp: push
         * *sp++: pop
         */

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
        } else if (op == ENT) {
            // push bp
            *--sp = (int)bp;
            // mov sp, bp
            bp = sp;
            // set up stack for new call frame
            sp = sp - *pc++;
        } else if (op == ADJ) {
            sp = sp + *pc++;
        } else if (op == LEV) {
            sp = bp
            // pop bp
            bp = (int *)*sp++;
            // pop eip (ret)
            pc = (int *)*sp++;
        } else if (op == LEA) {
            // load address of arguments for callee
            ax = (int)(bp + *pc++);
        } else if (op == OR) {
            ax = *sp++ | ax;
        } else if (op == XOR)  {
            ax = *sp++ ^ ax;
        } else if (op == AND) {
            ax = *sp++ & ax;
        } else if (op == EQ) {
             ax = *sp++ == ax;
        } else if (op == NE) {
             ax = *sp++ != ax;
        } else if (op == LT) {
             ax = *sp++ < ax;
        } else if (op == LE) {
             ax = *sp++ <= ax;
        } else if (op == GT) {
             ax = *sp++ >  ax;
        } else if (op == GE) {
             ax = *sp++ >= ax;
        } else if (op == SHL) {
            ax = *sp++ << ax;
        } else if (op == SHR) {
            ax = *sp++ >> ax;
        } else if (op == ADD) {
            ax = *sp++ + ax;
        } else if (op == SUB) {
            ax = *sp++ - ax;
        } else if (op == MUL) {
            ax = *sp++ * ax;
        } else if (op == DIV) {
            ax = *sp++ / ax;
        } else if (op == MOD) {
            ax = *sp++ % ax;
        }
    }

    return 0;
}
