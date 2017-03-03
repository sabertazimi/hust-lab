/*!
 * \file inode.c
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2017
 * \license MIT
 */

#include "inode.h"

bool is_dir(inode_t *node) {
    return node->readdir != 0 && node->finddir != 0;
}

bool is_file(inode_t *node) {
    return node->read != 0 && node->write != 0 && node->open != 0 && node->close != 0;
}
