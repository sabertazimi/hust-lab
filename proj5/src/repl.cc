/*!
 * \file repl.c
 * \brief read eval print loop (command line prompt)
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2017
 * \license MIT
 */

#include <stdio.h>
#include "repl.h"

Option::Option(int cs = 0) {
    color_scheme = cs;
}

Option::~Option() {
    color_scheme = 0;
}

int repl(option_t *opt) {
    fprintf(stdout, "color scheme: %d\n", opt->color_scheme);
    return 0;
}

