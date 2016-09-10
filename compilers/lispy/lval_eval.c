/*
 * lval_eval.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include "lispy.h"

lval *builtin_list(lenv *e, lval *a) {
    a->type = LVAL_QEXPR;
    return a;
}

lval *builtin_head(lenv *e, lval *a) {
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

lval *builtin_tail(lenv *e, lval *a) {
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

lval *builtin_eval(lenv *e, lval *a) {
    LASSERT(a, a->count == 1,
        "Function 'eval' passed too many arguments.");
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'eval' passed incorrect type.");

    lval *x = lval_take(a, 0);
    x->type = LVAL_SEXPR;
    return lval_eval(e, x);
}

lval *builtin_join(lenv *e, lval *a) {
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

lval *builtin_cons(lenv *e, lval *a) {
    LASSERT(a, a->count == 2,
        "Function 'cons' passed wrong number of arguments.");
    LASSERT(a, a->cell[0]->type == LVAL_NUM,
        "Function 'cons' passed incorrect type.");
    LASSERT(a, a->cell[1]->type == LVAL_QEXPR,
        "Function 'cons' passed incorrect type.");
    LASSERT(a, a->cell[1]->count != 0,
        "Function 'cons' passed {}.");

    lval *v = lval_pop(a, 0);
    lval *x = lval_qexpr();

    x = lval_add(x, v);
    x = lval_join(x, lval_pop(a, 0));

    lval_del(a);
    lval_del(v);
    return x;
}

lval *builtin_len(lenv *e, lval *a) {
    LASSERT(a, a->count == 1,
        "Function 'len' passed two many arguments.");
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'len' passed incorrect type.");

    lval *v = lval_pop(a, 0);
    lval *x = lval_num(v->count);

    lval_del(a);
    lval_del(v);
    return x;
}

lval *builtin_init(lenv *e, lval *a) {
    LASSERT(a, a->count == 1,
        "Function 'init' passed too many arguments.");
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'init' passed incorrect type.");
    LASSERT(a, a->cell[0]->count != 0,
        "Function 'init' passed {}.");

    lval *x = lval_pop(a, 0);
    lval_del(lval_pop(x, x->count - 1));

    return x;
}

lval *builtin_last(lenv *e, lval *a) {
    LASSERT(a, a->count == 1,
        "Function 'last' passed too many arguments.");
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'last' passed incorrect type.");
    LASSERT(a, a->cell[0]->count != 0,
        "Function 'last' passed {}.");

    lval *v = lval_pop(a, 0);
    lval *x = lval_pop(v, v->count - 1);

    lval_del(a);
    lval_del(v);
    return x;
}

static lval *builtin_op(lenv *e, lval *a, char *op) {
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

lval *builtin_add(lenv *e, lval *a) {
    return builtin_op(e, a, "+");
}

lval *builtin_sub(lenv *e, lval *a) {
    return builtin_op(e, a, "-");
}

lval *builtin_mul(lenv *e, lval *a) {
    return builtin_op(e, a, "*");
}

lval *builtin_div(lenv *e, lval *a) {
    return builtin_op(e, a, "/");
}

void lenv_add_builtin(lenv *e, char *name, lbuiltin func) {
    lval *k = lval_sym(name);
    lval *v = lval_fun(func);
    lenv_put(e, k, v);
    lval_del(k);
    lval_del(v);
}

void lenv_add_builtins(lenv *e) {
    lenv_add_builtin(e, "list", builtin_list);
    lenv_add_builtin(e, "head", builtin_head);
    lenv_add_builtin(e, "tail", builtin_tail);
    lenv_add_builtin(e, "eval", builtin_eval);
    lenv_add_builtin(e, "join", builtin_join);
    lenv_add_builtin(e, "cons", builtin_cons);
    lenv_add_builtin(e, "len", builtin_len);
    lenv_add_builtin(e, "init", builtin_init);
    lenv_add_builtin(e, "last", builtin_last);
    lenv_add_builtin(e, "+", builtin_add);
    lenv_add_builtin(e, "-", builtin_sub);
    lenv_add_builtin(e, "*", builtin_mul);
    lenv_add_builtin(e, "/", builtin_div);
}

lval *lval_eval_sexpr(lenv *e, lval *v) {
    for (int i = 0; i < v->count; i++) {
        v->cell[i] = lval_eval(e, v->cell[i]);
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
    if (f->type != LVAL_FUN) {
        lval_del(v);
        lval_del(f);
        return lval_err("First element is not a function.");
    }

    lval *result = f->fun(e, v);
    lval_del(f);
    return result;
}

lval *lval_eval(lenv *e, lval *v) {
    if (v->type == LVAL_SYM) {
        lval *x = lenv_get(e, v);
        lval_del(v);
        return x;
    }
    if (v->type == LVAL_SEXPR) {
        return lval_eval_sexpr(e, v);
    }

    return v;
}
