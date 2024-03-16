/*!
 * \file utils.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "errors/utils.h"

static char errmsg[1000];       ///< error message buffer

void dragon_report(yyltype *loc, const char *fmt, ...) {
    // print location information
    fprintf(stderr, ">>> %d:%d: ", loc->first_line, loc->first_column);

    // print error message
    va_list args;
    va_start(args, fmt);
    vsnprintf(errmsg, 1000, fmt, args);
    va_end(args);
    fprintf(stderr, "%s\n", errmsg);

    // print source code
    srcbuf_print(loc->first_line);

    // print ^, to highlight error position
    for (int i = 1; i < loc->first_column; i++) {
        fprintf(stderr, " ");
    }
    for (int i = loc->first_column - 1; i < loc->last_column; i++) {
        fprintf(stderr, "^");
    }
    fprintf(stderr, "\n");
}

void dragon_log(const char *fmt, ...) {
    // print error message
    va_list args;
    va_start(args, fmt);
    vsnprintf(errmsg, 1000, fmt, args);
    va_end(args);
    fprintf(stderr, ">>> log: %s\n", errmsg);
}
