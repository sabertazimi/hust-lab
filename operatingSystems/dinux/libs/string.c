/*
 * string.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include <string.h>

inline int strcmp(const char *str1, const char *str2) {
    while (*str1 != '\0' && *str1 == *str2) {
        str1++;
        str2++;
    }

    int ret = (int)(*str1 - *str2);
    return ret > 0 ? 1
        : ret == 0 ? 0
        : -1;
}

inline char *strcpy(char *dest, const char *src) {
    while (*src) {
        *dest++ = *src++;
    }

    *dest = '\0';
    return dest;
}

inline char *strcat(char *dest, const char *src) {
    while (*dest) {
        dest++;
    }

    while (*src) {
        *dest++ = *src++;
    }

    *dest = '\0';
    return dest;
}

inline int strlen(const char *src) {
    int nr_char = 0;

    while (*src) {
        src++;
        nr_char++;
    }

    return nr_char;
}

