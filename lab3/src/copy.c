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

const key_t bufs_key = 234; ///< key of shared memory to S buffer
const key_t buft_key = 235; ///< key of shared memory to T buffer
semaphore_t bufs_empty;     ///< initial value: 1, key: 0
semaphore_t bufs_full;      ///< initial value: 0, key: 1
semaphore_t buft_empty;     ///< initial value: 1, key: 2
semaphore_t buft_full;      ///< initial value: 0, key: 3

int main(void) {
    LOG("copy pid = %d\n", getpid());

    char ch;        ///< ch from S buffer
    int bufs_sid;           ///< shm id of shared memory as S buffer
    int buft_sid;           ///< shm id of shared memory as T buffer
    char *bufs_map;         ///< map address of shm to as S buffer
    char *buft_map;         ///< map address of shm to as T buffer

    // get semaphores
    bufs_empty = semnew(0, 1);
    bufs_full  = semnew(1, 0);
    buft_empty = semnew(2, 1);
    buft_full  = semnew(3, 0);

    // get shm
    bufs_sid = shmget(bufs_key, 0, 0);
    buft_sid = shmget(buft_key, 0, 0);

    // attach shm
    bufs_map = (char *)shmat(bufs_sid, NULL, 0);
    buft_map = (char *)shmat(buft_sid, NULL, 0);

    // copy data from S buffer to T buffer
    while (1) {
        bufs_full->P(bufs_full);

        // read data from S buffer
        if (bufs_map[0] != EOF) {
            ch = bufs_map[0];           // write character into ch
            bufs_empty->V(bufs_empty);
        } else {
            bufs_empty->V(bufs_empty);
            break;
        }

        buft_empty->P(buft_empty);

        // write data into T buffer
        if (ch != EOF) {
            buft_map[0] = ch;           // write character into T buffer
            buft_full->V(buft_full);
        } else {
            buft_full->V(buft_full);
            break;
        }
    }

    // detach shm
    shmdt(bufs_map);
    shmdt(buft_map);

    return 0;
}
