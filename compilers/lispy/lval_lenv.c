/*
 * lval_lenv.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include "lispy.h"

lenv *lenv_new(void) {
    lenv *e = (lenv *)malloc(sizeof(lenv));
    e->count = 0;
    e->syms = NULL;
    e->vals = NULL;
    return e;
}

void lenv_del(lenv *e) {
    for (int i = 0; i < e->count; i++) {
        free(e->syms[i]);
        lval_del(e->vals[i]);
    }

    free(e->syms);
    free(e->vals);
    free(e);
}

lval *lenv_get(lenv *e, lval *k) {
    for (int i = 0; i < e->count; i++) {
        if (strcmp(e->syms[i], k->sym) == 0) {
            return lval_copy(e->vals[i]);
        }
    }

    return lval_err("Unfound symbol '%s'", k->sym);
}

void lenv_put(lenv *e, lval *k, lval *v) {
    for (int i = 0; i < e->count; i++) {
        if (strcmp(e->syms[i], k->sym) == 0) {
            lval_del(e->vals[i]);
            e->vals[i] = lval_copy(v);
            return;
        }
    }

    e->count++;
    e->syms = (char **)realloc(e->syms, sizeof(char *) * e->count);
    e->vals = (lval **)realloc(e->vals, sizeof(lval *) * e->count);

    e->syms[e->count - 1] = (char *)malloc(strlen(k->sym) + 1);
    strcpy(e->syms[e->count - 1], k->sym);
    e->vals[e->count - 1] = lval_copy(v);
}


