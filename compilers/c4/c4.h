/*
 * c4.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef C4_H
#define C4_H

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>

int token;
char *src, *old_src;
int poolsize;
int line;

int program(void);
int next(void);
int expression(int level);
int eval(void);

#endif /* !C4_H */
