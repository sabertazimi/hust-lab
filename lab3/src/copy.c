/*!
 * \file copy.c
 * \brief entry file for copy program
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-11-12
 * \license MIT
 */

#undef DEBUG
#define DEBUG   ///< macro for enable/disable debug functions
// #undef DEBUG

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/shm.h>
#include "utils/utils.h"
#include "semaphore/semaphore.h"

const key_t sem_key = 233;    ///< key of shared memory to store semaphores
const key_t bufs_key = 234;   ///< key of shared memory to S buffer
const key_t buft_key = 235;   ///< key of shared memory to T buffer
semaphore_t bufs_empty;     ///< initial value: 1, key: 0
semaphore_t bufs_full;      ///< initial value: 0, key: 1
semaphore_t buft_empty;     ///< initial value: 1, key: 2
semaphore_t buft_full;      ///< initial value: 0, key: 3

int main(void) {
    int sem_sid;            ///< shm id of shared memory to store semaphores
    fprintf(stdout, "copy pid = %d\n", getpid());
    return 0;
}
