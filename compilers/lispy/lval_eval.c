/*
 * lval_eval.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include "lispy.h"

lval *builtin_list(lval *a) {
    a->type = LVAL_QEXPR;
    return a;
}

lval *builtin_head(lval *a) {
    LASSERT(a, a->count == 1,
        "Function 'head' passed too many arguments.");
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'head' passed incorrect type.");
    LASSERT(a, a->cell[0]->count != 0,
        "Function 'head' passed {}.");

    lval *v = lval_take(a, 0);

    while (v->count > 1) {
        lval_del(lval_pop(v, 1));
    }

    return v;
}

lval *builtin_tail(lval *a) {
    LASSERT(a, a->count == 1,
        "Function 'tail' passed too many arguments.");
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'tail' passed incorrect type.");
    LASSERT(a, a->cell[0]->count != 0,
        "Function 'tail' passed {}.");

    lval *v = lval_take(a, 0);
    lval_del(lval_pop(v, 0));
    return v;
}

lval *builtin_eval(lval *a) {
    LASSERT(a, a->count == 1,
        "Function 'eval' passed too many arguments.");
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'eval' passed incorrect type.");

    lval *x = lval_take(a, 0);
    x->type = LVAL_SEXPR;
    return lval_eval(x);
}

lval *builtin_join(lval *a) {
    for (int i = 0; i < a->count; i++) {
        LASSERT(a, a->cell[i]->type == LVAL_QEXPR,
            "Function 'join' passed incorrect type.");
    }

    lval *x = lval_pop(a, 0);

    while (a->count) {
        x = lval_join(x, lval_pop(a, 0));
    }

    lval_del(a);
    return x;
}

lval *builtin_op(lval *a, char *op) {
    for (int i = 0; i < a->count; i++) {
        if (a->cell[i]->type != LVAL_NUM) {
            lval_del(a);
            return lval_err("Cannot operate on non-number.");
        }
    }

    lval *x = lval_pop(a, 0);

    if ((strcmp(op, "-") == 0) && a->count == 0) {
        x->num = -x->num;
    }

    while (a->count > 0) {
        lval *y = lval_pop(a, 0);

        if (strcmp(op, "+") == 0) {
            x->num += y->num;
        }
        if (strcmp(op, "-") == 0) {
            x->num -= y->num;
        }
        if (strcmp(op, "*") == 0) {
            x->num *= y->num;
        }
        if (strcmp(op, "/") == 0) {
            if (y->num == 0) {
                lval_del(x);
                lval_del(y);
                x = lval_err("Division By Zero.");
                break;
            }

            x->num /= y->num;
        }

        lval_del(y);
    }

    lval_del(a);
    return x;
}

lval *builtin(lval *a, char *func) {
    if (strcmp("list", func) == 0) {
        return builtin_list(a);
    }
    if (strcmp("head", func) == 0) {
        return builtin_head(a);
    }
    if (strcmp("tail", func) == 0) {
        return builtin_tail(a);
    }
    if (strcmp("join", func) == 0) {
        return builtin_join(a);
    }
    if (strcmp("eval", func) == 0) {
        return builtin_eval(a);
    }
    if (strstr("+-/*", func)) {
        return builtin_op(a, func);
    }

    lval_del(a);
    return lval_err("Unknown Function.");
}

lval *lval_eval_sexpr(lval *v) {
    for (int i = 0; i < v->count; i++) {
        v->cell[i] = lval_eval(v->cell[i]);
    }

    for (int i = 0; i < v->count; i++) {
        if (v->cell[i]->type == LVAL_ERR) {
            return lval_take(v, i);
        }
    }

    if (v->count == 0) {
        return v;
    }
    if (v->count == 1) {
        return lval_take(v, 0);
    }

    lval *f = lval_pop(v, 0);
    if (f->type != LVAL_SYM) {
        lval_del(f);
        lval_del(v);
        return lval_err("S-expression Does not start with symbol");
    }

    lval *result = builtin(v, f->sym);
    lval_del(f);
    return result;
}

lval *lval_eval(lval *v) {
    if (v->type == LVAL_SEXPR) {
        return lval_eval_sexpr(v);
    }

    return v;
}
