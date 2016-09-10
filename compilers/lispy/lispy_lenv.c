/*
 * lval_lenv.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include "lispy.h"

lenv *lenv_new(void) {
    lenv *e = (lenv *)malloc(sizeof(lenv));
    e->par = NULL;
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

    if (e->par) {
        return lenv_get(e->par, k);
    } else {
        return lval_err("Unfound symbol '%s'", k->sym);
    }
}

/* Global variables */
void lenv_def(lenv *e, lval *k, lval *v) {
    while (e->par) {
        e = e->par;
    }

    lenv_put(e, k, v);
}

/* Local variables */
void lenv_put(lenv *e, lval *k, lval *v) {
    for (int i = 0; i < e->count; i++) {
        if (strcmp(e->syms[i], k->sym) == 0) {
            lval_del(e->vals[i]);
            e->vals[i] = lval_copy(v);
            return;
        }
    }

    e->count++;
    e->vals = (lval **)realloc(e->vals, sizeof(lval *) * e->count);
    e->syms = (char **)realloc(e->syms, sizeof(char *) * e->count);

    e->vals[e->count - 1] = lval_copy(v);
    e->syms[e->count - 1] = (char *)malloc(strlen(k->sym) + 1);
    strcpy(e->syms[e->count - 1], k->sym);
}

lenv *lenv_copy(lenv *e) {
    lenv *n = (lenv *)malloc(sizeof(lenv));

    n->par = e->par;
    n->count = e->count;
    n->syms = (char **)malloc(sizeof(char *) * n->count);
    n->vals = (lval **)malloc(sizeof(lval *) * n->count);

    for (int i = 0; i < e->count; i++) {
        n->syms[i] = (char *)malloc(strlen(e->syms[i]) + 1);
        strcpy(n->syms[i], e->syms[i]);
        n->vals[i] = lval_copy(e->vals[i]);
    }

    return n;
}

