/*
 * lispy.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include "lispy.h"

#ifdef _WIN32

static char buffer[2048];

char *readline(char *prompt) {
    fputs(prompt, stdout);
    fgets(buffer, 2048, stdin);
    char *cpy = malloc(strlen(buffer) + 1);
    strcpy(cpy, buffer);
    cpy[strlen(cpy) - 1] = '\0';
    return cpy;
}

void add_history(char *unused) {
    // empty function body
}

#else

#include <editline/readline.h>
#include <editline/history.h>

#endif

int main(int argc, char **argv) {
    printf("lispy > ");
    return 0;
}
