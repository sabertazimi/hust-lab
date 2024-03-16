/*!
 * \file srcbuf.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "errors/srcbuf.h"

using namespace std;

/// \brief static(singleton pattern) source buffer
typedef struct srcbuf {
    vector<char *> *buf;    ///< list_t <char *>: store source code
    int  cnt_line;          ///< number of line in buffer
} srcbuf_t;

static srcbuf_t srcbuf;

void srcbuf_init(void) {
    srcbuf.cnt_line = 0;
    srcbuf.buf = new vector<char *>();
}

void srcbuf_append(const char *src) {
    srcbuf.cnt_line += 1;
    srcbuf.buf->push_back(strdup(src));
}

const char * srcbuf_get(int num_line) {
    // argument check
    if (num_line <= 0 || num_line > srcbuf_length()) num_line = 1;

    return (*(srcbuf.buf))[num_line - 1];
}

int srcbuf_length(void) {
    return srcbuf.cnt_line;
}

static int srcbuf_printable(int num_line) {
    const char * src = srcbuf_get(num_line);

    for (unsigned i = 0; i < strlen(src); i++) {
        if (src[i] != ' ' && src[i] != '\t' && src[i] != '\n') {
            return 1;
        }
    }

    // characters in buffer are all whitespece
    return 0;
}

void srcbuf_print(int num_line) {
    if (srcbuf_printable(num_line)) {
        fprintf(stderr , "%s\n", srcbuf_get(num_line));
    }
}
