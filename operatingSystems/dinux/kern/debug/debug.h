/*
 * debug.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef KERN_DEBUG_DEBUG_H
#define KERN_DEBUG_DEBUG_H

#include <console.h>
#include <vargs.h>
#include <elf.h>

#define assert(x, info)     \
    do {                    \
        if (!(x)) {         \
            panic(info);    \
        }                   \
    } while (0)

#define static_assert(x)    \
    switch (x) { case 0: case (x): ; }

void debug_init(void);
void panic(const char *msg);
void print_regs(void);

int printk(const char *format, ...);
int printk_color(real_color_t back, real_color_t fore, const char *format, ...);

#endif /* !KERN_DEBUG_DEBUG_H */
