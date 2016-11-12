/*!
 * \file main.c
 * \brief entry file for pthread lab
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-11-11
 * \license MIT
 */

#undef DEBUG
#define DEBUG   ///< macro for enable/disable debug functions
// #undef DEBUG

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "utils/utils.h"
#include "semaphore/semaphore.h"

int main(void) {
    fprintf(stdout, "copy pid = %d\n", getpid());
    return 0;
}
