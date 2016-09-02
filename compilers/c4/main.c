/*
 * main.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
#include <unistd.h>
#include "c4.h"
#include "vm.h"


int main(int argc, char **argv) {
    int i, fd;

    argc--;
    argv++;

    poolsize = 1024 * 256;
    line = 1;

    if ((fd = open(*argv, 0)) < 0) {
        printf("could not open(%s)\n", *argv);
        return -1;
    }

    if (!(src = old_src = malloc(poolsize))) {
        printf("could not malloc(%d) for source area\n", poolsize);
        return -1;
    }

    // read source code
    if ((i = read(fd, src, poolsize - 1)) <= 0) {
        printf("read() returned %d\n", i);
        return -1;
    }

    src[i] = 0; // EOF character
    close(fd);

    if (vm_init() != 0) {
        printf("virtual machine set up failure\n");
        return -1;
    }

    program();
    return eval();
}

