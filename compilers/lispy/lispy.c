/*
 * lispy.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include "lispy.h"

#ifdef _WIN32

static char buffer[2048];

char *readline(char *prompt) {
    fputs(prompt, stdout);
    fgets(buffer, 2048, stdin);
    char *cpy = malloc(strlen(buffer) + 1);
    strcpy(cpy, buffer);
    cpy[strlen(cpy) - 1] = '\0';
    return cpy;
}

void add_history(char *unused) {
    // empty function body
}

#else

#include <editline/readline.h>
#include <editline/history.h>

#endif

int main(int argc, char **argv) {
    mpc_parser_t *Number = mpc_new("number");
    mpc_parser_t *Symbol = mpc_new("symbol");
    mpc_parser_t *Sexpr = mpc_new("sexpr");
    mpc_parser_t *Qexpr = mpc_new("qexpr");
    mpc_parser_t *Expr = mpc_new("expr");
    mpc_parser_t *Lispy = mpc_new("lispy");

    mpca_lang(MPCA_LANG_DEFAULT,
        "                                                       \
            number : /-?[0-9]+/ ;                               \
            symbol : /[a-zA-Z0-9_+\\-*\\/\\\\=<>!&]+/ ;         \
            sexpr  : '(' <expr>* ')' ;                          \
            qexpr  : '{' <expr>* '}' ;                          \
            expr   : <number> | <symbol> | <sexpr> | <qexpr> ;  \
            lispy  : /^/ <expr>* /$/ ;                          \
        ",
        Number, Symbol, Sexpr, Qexpr, Expr, Lispy);

    puts("Lispy Version 1.0");
    puts("Press Ctrl+C to Exit\n");

    lenv *e = lenv_new();
    lenv_add_builtins(e);

    int init_flag = 0;

    while (1) {
        mpc_result_t r;

        if (!init_flag) {
            /* Add lib functions */
            mpc_parse("init", "def {fun} (\\ {args body} {def (head args) (\\ (tail args) body)})", Lispy, &r);
            lval_del(lval_eval(e, lval_read(r.output)));
            mpc_parse("init", "fun {unpack f xs} {eval (join (list f) xs)}", Lispy, &r);
            lval_del(lval_eval(e, lval_read(r.output)));
            mpc_parse("init", "fun {pack f & xs} {f xs}", Lispy, &r);
            lval_del(lval_eval(e, lval_read(r.output)));
            mpc_parse("init", "def {uncurry} pack", Lispy, &r);
            lval_del(lval_eval(e, lval_read(r.output)));
            mpc_parse("init", "def {curry} unpack", Lispy, &r);
            lval_del(lval_eval(e, lval_read(r.output)));

            mpc_ast_delete(r.output);
            init_flag = 1;
            continue;
        }

        char *input = readline("lispy> ");
        add_history(input);

        if (mpc_parse("<stdin>", input, Lispy, &r)) {
            lval *x = lval_eval(e, lval_read(r.output));
            lval_println(x);
            lval_del(x);

            mpc_ast_delete(r.output);
        } else {
            mpc_err_print(r.error);
            mpc_err_delete(r.error);
        }

        free(input);
    }

    mpc_cleanup(6, Number, Symbol, Sexpr, Qexpr, Expr, Lispy);

    return 0;
}
