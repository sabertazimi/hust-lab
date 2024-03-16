/*!
 * \file location.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "location.h"

yyltype *locdup(yyltype *loc) {
    yyltype * p = (yyltype *)malloc(sizeof(yyltype));
    p->first_line = loc->first_line;
    p->first_column = loc->first_column;
    p->last_line = loc->last_line;
    p->last_column = loc->last_column;
    return p;
}

int loccmp(yyltype *l, yyltype *r) {
    if (l->first_line > r->first_line) {
        return 1;
    }

    if (l->first_line < r->first_line) {
        return -1;
    }

    if (l->first_column > r->first_column) {
        return 1;
    }

    if (l->first_column < r->first_column) {
        return -1;
    }

    return 0;
}
