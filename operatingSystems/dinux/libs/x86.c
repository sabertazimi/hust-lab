/*
 * x86.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include <x86.h>

inline void outb(uint16_t port, uint8_t data) {
    asm volatile(
            "outb %1, %0"
            :
            : "dN" (port), "a" (data)
            );
}

inline void outw(uint16_t port, uint16_t data) {
    asm volatile(
            "outw %1, %0"
            :
            : "dN" (port), "a" (data)
            );
}

inline uint8_t inb(uint16_t port) {
    uint8_t data;

    asm volatile(
            "inb %1, %0"
            : "=a" (data)
            : "dN" (port)
            );

    return data;
}

inline uint16_t inw(uint16_t port) {
    uint16_t data;

    asm volatile(
            "inw %1, %0"
            : "=a" (data)
            : "dN" (port)
            );

    return data;
}

