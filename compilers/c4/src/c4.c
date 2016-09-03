/*
 * c4.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include "lexer.h"
#include "c4.h"

int program(void) {
    next();

    while (token > 0) {
        printf("token is: %c\n", token);
        next();
    }

    return 0;
}


int expression(int level) {
    return 0;
}


