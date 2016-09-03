/*
 * vm.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include "c4.h"
#include "vm.h"

#define POOL_SIZE (1024 * 256)

int vm_init(void) {
    if (!(text = old_text = (int *)malloc(POOL_SIZE))) {
        printf("could not malloc(%d) for text area\n", POOL_SIZE);
        return -1;
    }

    if (!(data = (char *)malloc(POOL_SIZE))) {
        printf("could not malloc(%d) for data area\n", POOL_SIZE);
        return -1;
    }

    if (!(stack = (int *)malloc(POOL_SIZE))) {
        printf("could not malloc(%d) for stack area\n", POOL_SIZE);
        return -1;
    }

    memset(text, 0, POOL_SIZE);
    memset(data, 0, POOL_SIZE);
    memset(stack, 0, POOL_SIZE);

    bp = sp = (int *)((long)stack + POOL_SIZE);
    ax = 0;

    return 0;
}

int eval(int *pc) {
    int op = 0,
        *tmp;

    while (1) {

        /*
         * *pc  : get parameter of assembly instruction
         * *--sp: push
         * *sp++: pop
         */

        op = *pc++;

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
            sp = bp;
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
        } else if (op == EXIT) {
            printf("exit(%d)", *sp); return *sp;
        } else if (op == OPEN) {
            ax = open((char *)sp[1], sp[0]);
        } else if (op == CLOS) {
            ax = close(*sp);
        } else if (op == READ) {
            ax = read(sp[2], (char *)sp[1], *sp);
        } else if (op == PRTF) {
            tmp = sp + pc[1]; ax = printf((char *)tmp[-1], tmp[-2], tmp[-3], tmp[-4], tmp[-5], tmp[-6]);
        } else if (op == MALC) {
            ax = (int)malloc(*sp);
        } else if (op == MSET) {
            ax = (int)memset((char *)sp[2], sp[1], *sp);
        } else if (op == MCMP) {
            ax = memcmp((char *)sp[2], (char *)sp[1], *sp);
        } else {
            printf("unknown instruction: %d\n", op);
            return -1;
        }
    }

    return 0;
}
