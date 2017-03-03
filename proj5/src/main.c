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

#undef NDEBUG

int main(int argc, char **argv) {
    bool dir = false;
    inode_t *node = (inode_t *)malloc(sizeof(inode_t));

    node->readdir = 0x1000;
    node->finddir = 0x2000;
    dir = is_dir(node);
    assert(dir == true);

    node->readdir = 0;
    dir = is_dir(node);
    assert(dir == false);

    return 0;
}

