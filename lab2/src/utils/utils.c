/*!
 * \file utils.c
 * \brief some simple utils functions
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-11-11
 * \license MIT
 */

#include <stdio.h>
#include <stdarg.h>
#include "utils/utils.h"

static char errmsg[1000];   ///< message buffer for vsnprintf

void logger(const char *fmt, ...) {
    // print error message
    va_list args;
    va_start(args, fmt);
    vsnprintf(errmsg, 1000, fmt, args);
    va_end(args);
    fprintf(stderr, "[log]: %s", errmsg);
}
