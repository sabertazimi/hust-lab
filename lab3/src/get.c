/*!
 * \file get.c
 * \brief entry file for get program
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
semaphore_t bufs_empty;     ///< initial value: 1, key: 0
semaphore_t bufs_full;      ///< initial value: 0, key: 1

int main(void) {
    LOG("get pid = %d\n", getpid());

    char ch;                ///< character read from src file
    FILE *fp;               ///< src file pointer
    int bufs_sid;           ///< shm id of shared memory as S buffer
    char *bufs_map;         ///< map address of shm to as S buffer

    // get semaphores
    bufs_empty = semnew(0, 1);
    bufs_full  = semnew(1, 0);

    // get shm
    bufs_sid = shmget(bufs_key, 0, 0);

    if (bufs_sid == -1) {
        perror("shmget error\n");
        return -1;
    }

    // attach shm
    bufs_map = (char *)shmat(bufs_sid, NULL, 0);

    // open src file
    if ((fp = fopen("./src.dat", "a+")) == NULL) {
        perror("fopen error\n");
        return -1;
    }

    // get data from src file to S buffer
    while (1) {
        bufs_empty->P(bufs_empty);

        if ((ch = fgetc(fp)) != EOF) {
            bufs_map[0] = ch;       // write character into S buffer
            LOG("get: %c\n", ch);
            bufs_full->V(bufs_full);
        } else {
            bufs_full->V(bufs_full);
            break;
        }
    }

    // detach shm
    shmdt(bufs_map);

    return 0;
}
