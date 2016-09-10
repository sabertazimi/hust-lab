/*
 * lval_new.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include "lispy.h"

lval *lval_num(long x) {
    lval *v = (lval *)malloc(sizeof(lval));
    v->type = LVAL_NUM;
    v->num = x;
    return v;
}

lval *lval_err(char *m) {
    lval *v = (lval *)malloc(sizeof(lval));
    v->type = LVAL_ERR;
    v->err = (char *)malloc(strlen(m) + 1);
    strcpy(v->err, m);
    return v;
}

lval *lval_sym(char *s) {
    lval *v = (lval *)malloc(sizeof(lval));
    v->type = LVAL_SYM;
    v->sym = (char *)malloc(strlen(s) + 1);
    strcpy(v->sym, s);
    return v;
}

lval *lval_sexpr(void) {
    lval *v = (lval *)malloc(sizeof(lval));
    v->type = LVAL_SEXPR;
    v->count = 0;
    v->cell = NULL;
    return v;
}

lval *lval_qexpr(void) {
    lval *v = (lval *)malloc(sizeof(lval));
    v->type = LVAL_QEXPR;
    v->count = 0;
    v->cell = NULL;
    return v;
}



