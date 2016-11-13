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
semaphore_t bufs_empty;     ///< initial value: 1, key: 1
semaphore_t bufs_full;      ///< initial value: 0, key: 2
semaphore_t buft_empty;     ///< initial value: 1, key: 3
semaphore_t buft_full;      ///< initial value: 0, key: 4

int main(void) {
    int bufs_sid;           ///< shm id of shared memory as S buffer
    int buft_sid;           ///< shm id of shared memory as T buffer
    char *bufs_map;         ///< map address of shm to as S buffer
    char *buft_map;         ///< map address of shm to as T buffer

    // get semaphores
    bufs_empty = semnew(1, 1);
    bufs_full  = semnew(2, 0);
    buft_empty = semnew(3, 1);
    buft_full  = semnew(4, 0);

    // get shm
    bufs_sid = shmget(bufs_key, 2, IPC_CREAT | 0666);
    buft_sid = shmget(buft_key, 2, IPC_CREAT | 0666);

    if (bufs_sid == -1 || buft_sid == -1) {
        perror("shmget error\n");
        return -1;
    }

    // attach shm
    bufs_map = (char *)shmat(bufs_sid, NULL, 0);
    buft_map = (char *)shmat(buft_sid, NULL, 0);

    // copy data from S buffer to T buffer
    while (1) {
        // read data from S buffer, write data into T buffer
        buft_empty->P(buft_empty);
        bufs_full->P(bufs_full);
        buft_map[0] = bufs_map[0];
        LOG("copy %c from S buffer to T buffer... \n", bufs_map[0]);

        // break condition
        if (bufs_map[0] == EOF) {
            bufs_empty->V(bufs_empty);
            buft_full->V(buft_full);
            break;
        } else {
            bufs_empty->V(bufs_empty);
            buft_full->V(buft_full);
        }
    }

    // detach shm
    shmdt(bufs_map);

    usleep(500);

    return 0;
}
