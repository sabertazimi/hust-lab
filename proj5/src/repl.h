/*!
 * \file repl.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2017
 * \license MIT
 */

#ifndef REPL_H
#define REPL_H

typedef struct option option_t;

struct option {
    int color_scheme;
};

#define REPL_COLOREND       \033[0m
#define REPL_COLORBEGIN     \033[1m
#define REPL_BALCK          \033[30m
#define REPL_RED            \033[31m
#define REPL_GREEN          \033[32m
#define REPL_BROWN          \033[33m
#define REPL_BLUE           \033[34m
#define REPL_PURPLE         \033[35m
#define REPL_CYAN           \033[36m
#define REPL_LIGHTGRAY      \033[37m

int repl(option_t *opts);

#endif /* !REPL_H */

