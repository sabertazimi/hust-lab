/*!
 * \file main.c
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2017
 * \license MIT
 */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "inode.h"
#include "repl.h"

#undef NDEBUG

int main(int argc, char **argv) {
    bool dir = false;
    inode *node = new inode();

    node->readdir = (readdir_type_t)0x1000;
    node->finddir = (finddir_type_t)0x2000;
    dir = is_dir(node);
    assert(dir == true);

    node->readdir = 0;
    dir = is_dir(node);
    assert(dir == false);

    option_t *opt = (option_t *)malloc(sizeof(option_t));
    if (argc > 1) {
        opt->color_scheme = atoi(argv[1]);
    }
    repl(opt);

    return 0;
}

