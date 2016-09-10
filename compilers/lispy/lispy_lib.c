/*
 * lval_lib.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
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
        "Function 'head' passed too many arguments: "
        "Got %i, Expected %i.",
        a->count, 1);
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'head' passed incorrect type for argument 0: "
        "Got %s, Expected %s.",
        ltype_name(a->cell[0]->type), ltype_name(LVAL_QEXPR));
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
        "Function 'tail' passed too many arguments: "
        "Got %i, Expected %i.",
        a->count, 1);
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'tail' passed incorrect type for argument 0: "
        "Got %s, Expected %s.",
        ltype_name(a->cell[0]->type), ltype_name(LVAL_QEXPR));
    LASSERT(a, a->cell[0]->count != 0,
        "Function 'tail' passed {}.");

    lval *v = lval_take(a, 0);
    lval_del(lval_pop(v, 0));
    return v;
}

lval *builtin_eval(lenv *e, lval *a) {
    LASSERT(a, a->count == 1,
        "Function 'eval' passed too many arguments: "
        "Got %i, Expected %i.",
        a->count, 1);
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'eval' passed incorrect type for argument 0: "
        "Got %s, Expected %s.",
        ltype_name(a->cell[0]->type), ltype_name(LVAL_QEXPR));

    lval *x = lval_take(a, 0);
    x->type = LVAL_SEXPR;
    return lval_eval(e, x);
}

lval *builtin_join(lenv *e, lval *a) {
    for (int i = 0; i < a->count; i++) {
        LASSERT(a, a->cell[i]->type == LVAL_QEXPR,
            "Function 'join' passed incorrect type for argument %i: "
            "Got %s, Expected %s.",
            i, ltype_name(a->cell[i]->type), ltype_name(LVAL_QEXPR));
    }

    lval *x = lval_pop(a, 0);

    while (a->count) {
        lval *y = lval_pop(a, 0);
        x = lval_join(x, y);
    }

    lval_del(a);
    return x;
}

lval *builtin_cons(lenv *e, lval *a) {
    LASSERT(a, a->count == 2,
        "Function 'cons' passed too many arguments: "
        "Got %i, Expected %i.",
        a->count, 2);
    LASSERT(a, a->cell[0]->type == LVAL_NUM,
        "Function 'cons' passed incorrect type for argument 0: "
        "Got %s, Expected %s.",
        ltype_name(a->cell[0]->type), ltype_name(LVAL_NUM));
    LASSERT(a, a->cell[1]->type == LVAL_QEXPR,
        "Function 'cons' passed incorrect type for argument 1: "
        "Got %s, Expected %s.",
        ltype_name(a->cell[1]->type), ltype_name(LVAL_QEXPR));
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
        "Function 'len' passed too many arguments: "
        "Got %i, Expected %i.",
        a->count, 1);
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'len' passed incorrect type for argument 0: "
        "Got %s, Expected %s.",
        ltype_name(a->cell[0]->type), ltype_name(LVAL_QEXPR));

    lval *v = lval_pop(a, 0);
    lval *x = lval_num(v->count);

    lval_del(a);
    lval_del(v);
    return x;
}

lval *builtin_init(lenv *e, lval *a) {
    LASSERT(a, a->count == 1,
        "Function 'init' passed too many arguments: "
        "Got %i, Expected %i.",
        a->count, 1);
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'init' passed incorrect type for argument 0: "
        "Got %s, Expected %s.",
        ltype_name(a->cell[0]->type), ltype_name(LVAL_QEXPR));
    LASSERT(a, a->cell[0]->count != 0,
        "Function 'init' passed {}.");

    lval *x = lval_pop(a, 0);
    lval_del(lval_pop(x, x->count - 1));

    return x;
}

lval *builtin_last(lenv *e, lval *a) {
    LASSERT(a, a->count == 1,
        "Function 'last' passed too many arguments: "
        "Got %i, Expected %i.",
        a->count, 1);
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'last' passed incorrect type for argument 0: "
        "Got %s, Expected %s.",
        ltype_name(a->cell[0]->type), ltype_name(LVAL_QEXPR));
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
            int type = a->cell[i]->type;
            lval_del(a);
            return lval_err("Function '%s' passed incorrect type for argument %i: "
                    "Got %s, Expected %s.",
                    op, i, ltype_name(type), ltype_name(LVAL_NUM));
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

lval *builtin_lambda(lenv *e, lval *a) {
    LASSERT(a, a->count == 2,
        "Function '\\' passed too many arguments: "
        "Got %i, Expected %i.",
        a->count, 2);
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function '\\' passed incorrect type for argument 0: "
        "Got %s, Expected %s.",
        ltype_name(a->cell[0]->type), ltype_name(LVAL_QEXPR));
    LASSERT(a, a->cell[1]->type == LVAL_QEXPR,
        "Function '\\' passed incorrect type for argument 1: "
        "Got %s, Expected %s.",
        ltype_name(a->cell[1]->type), ltype_name(LVAL_QEXPR));

    for (int i = 0; i < a->cell[0]->count; i++) {
        LASSERT(a, a->cell[0]->cell[i]->type == LVAL_SYM,
            "Cannot define non-symbol: "
            "Got %s, Expected %s.",
            ltype_name(a->cell[0]->cell[i]->type), ltype_name(LVAL_SYM));
    }

    lval *formals = lval_pop(a, 0);
    lval *body = lval_pop(a, 0);
    lval_del(a);

    return lval_lambda(formals, body);
}

static lval *builtin_var(lenv *e, lval *a, char *func) {
    LASSERT(a, a->cell[0]->type == LVAL_QEXPR,
        "Function 'def' passed incorrect type for argument 0: "
        "Got %s, Expected %s.",
        ltype_name(a->cell[0]->type), ltype_name(LVAL_QEXPR));

    lval *syms = a->cell[0];

    for (int i = 0; i < syms->count; i++) {
        LASSERT(a, syms->cell[i]->type == LVAL_SYM,
            "Function 'def' cannot define non-symbol: "
            "Got %s, Expected %s.",
            ltype_name(a->cell[i]->type), ltype_name(LVAL_SYM));
    }

    LASSERT(a, syms->count == a->count - 1,
        "Function 'def' cannot define incorrect number of values to symbols: "
        "Got %i, Expected %i.",
        a->count - 1, syms->count);

    for (int i = 0; i < syms->count; i++) {
        if (strcmp(func, "def") == 0) {
            lenv_def(e, syms->cell[i], a->cell[i + 1]);
        }
        if (strcmp(func, "=") == 0) {
            lenv_put(e, syms->cell[i], a->cell[i + 1]);
        }
    }

    lval_del(a);
    return lval_sexpr();
}

lval *builtin_def(lenv *e, lval *a) {
    return builtin_var(e, a, "def");
}

lval *builtin_put(lenv *e, lval *a) {
    return builtin_var(e, a, "=");
}

static lval *builtin_ord(lenv *e, lval *a, char *op) {
    LASSERT(a, a->count == 2,
        "Function '%s' passed too many arguments: "
        "Got %i, Expected %i.",
        op, a->count, 2);
    LASSERT(a, a->cell[0]->type == LVAL_NUM,
        "Function '%s' passed incorrect type for argument 0: "
        "Got %s, Expected %s.",
        op, ltype_name(a->cell[0]->type), ltype_name(LVAL_NUM));
    LASSERT(a, a->cell[1]->type == LVAL_NUM,
        "Function '%s' passed incorrect type for argument 1: " "Got %s, Expected %s.",
        op, ltype_name(a->cell[1]->type), ltype_name(LVAL_NUM));

    int r;

    if (strcmp(op, ">") == 0) {
        r = (a->cell[0]->num > a->cell[1]->num);
    }
    if (strcmp(op, "<") == 0) {
        r = (a->cell[0]->num < a->cell[1]->num);
    }
    if (strcmp(op, ">=") == 0) {
        r = (a->cell[0]->num >= a->cell[1]->num);
    }
    if (strcmp(op, "<=") == 0) {
        r = (a->cell[0]->num <= a->cell[1]->num);
    }

    lval_del(a);

    return lval_num(r);
}

lval *builtin_gt(lenv *e, lval *a) {
    return builtin_ord(e, a, ">");
}

lval *builtin_lt(lenv *e, lval *a) {
    return builtin_ord(e, a, "<");
}

lval *builtin_ge(lenv *e, lval *a) {
    return builtin_ord(e, a, ">=");
}

lval *builtin_le(lenv *e, lval *a) {
    return builtin_ord(e, a, "<=");
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
    lenv_add_builtin(e, "\\", builtin_lambda);
    lenv_add_builtin(e, "def", builtin_def);
    lenv_add_builtin(e, "=", builtin_put);
}

