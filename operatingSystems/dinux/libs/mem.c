/*
 * mem.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include <mem.h>

inline void memcpy(uint8_t *dest, const uint8_t *src, uint32_t len) {
    while (len != 0) {
        *dest++ = *src++;
        len--;
    }
}

inline void memset(void *dest, uint8_t val, uint32_t len) {
    uint8_t *dst = (uint8_t *)dest;

    while (len != 0) {
        *dst++ = val;
        len--;
    }
}

inline void bzero(void *dest, uint32_t len) {
    memset(dest, 0, len);
}
