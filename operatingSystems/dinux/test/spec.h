/*
 * spec.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef TEST_SPEC_H
#define TEST_SPEC_H

#include <defs.h>
#include <console.h>

#define assert_equal(function, result, expect, info)            \
    do {                                                        \
        if (result != expect) {                                 \
            printk_color(RC_BLACK, RC_RED,                      \
                    "In function <%s> : expect <%s>\n",         \
                    function, info);                            \
            return FALSE;                                       \
        }                                                       \
    } while (0)

#define assert_nequal(function, result, expect, info)           \
    do {                                                        \
        if (result == expect) {                                 \
            printk_color(RC_BLACK, RC_RED,                      \
                    "In function <%s> : expect <%s>\n",         \
                    function, info);                            \
            return FALSE;                                       \
        }                                                       \
    } while (0)

int mem_spec(void);
int string_spec(void);

#endif /* !TEST_SPEC_H */
