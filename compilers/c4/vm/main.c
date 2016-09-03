/*
 * main.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include "dasm.h"

#define DEBUG
// #undef DEBUG

#define DEBUG_VM
// #undef DEBUG_VM

int main(int argc, char **argv) {
    int i;

#ifndef DEBUG_VM
    int fd;

    argc--;
    argv++;
#endif

#ifndef DEBUG_VM
    if ((fd = open(*argv, 0)) < 0) {
        printf("could not open(%s)\n", *argv);
        return -1;
    }

    if (!(src = old_src = malloc(POOL_SIZE))) {
        printf("could not malloc(%d) for source area\n", POOL_SIZE);
        return -1;
    }

    // read source code
    if ((i = read(fd, src, POOL_SIZE - 1)) <= 0) {
        printf("read() returned %d\n", i);
        return -1;
    }

    src[i] = 0; // EOF character
    close(fd);
#endif

    if (vm_init() != 0) {
        printf("virtual machine set up failure\n");
        return -1;
    }

#ifdef DEBUG
    i = 0;
    text[i++] = IMM;
    text[i++] = 10;
    text[i++] = PUSH;
    text[i++] = IMM;
    text[i++] = 20;
    text[i++] = ADD;
    text[i++] = PUSH;
    text[i++] = EXIT;
    pc = text;
#endif

    return eval(pc);
}

