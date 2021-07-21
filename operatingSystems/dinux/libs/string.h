/*
 * string.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef LIBS_STRING_H
#define LIBS_STRING_H

#include <defs.h>

/* string libs */
int strcmp(const char *str1, const char *str2);
char *strcpy(char *dest, const char *src);
char *strcat(char *dest, const char *src);
int strlen(const char *src);

#endif /* !LIBS_STRING_H */
