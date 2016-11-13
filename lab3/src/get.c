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
semaphore_t bufs_empty;     ///< initial value: 1, key: 1
semaphore_t bufs_full;      ///< initial value: 0, key: 2

int main(void) {
    LOG("get pid = %d\n", getpid());

    char ch;                ///< character read from src file
    FILE *fp;               ///< src file pointer
    int bufs_sid;           ///< shm id of shared memory as S buffer
    char *bufs_map;         ///< map address of shm to as S buffer

    // get semaphores
    bufs_empty = semnew(1, 1, 0);
    bufs_full  = semnew(2, 0, 0);

    LOG("get semid: %d, %d\n",
            bufs_empty->semid, bufs_full->semid);

    // get shm
    bufs_sid = shmget(bufs_key, 2, IPC_CREAT | 0666);

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

    LOG("get: before loop\n");

    // get data from src file to S buffer
    while (1) {
        LOG("get: before P\n");
        bufs_empty->P(bufs_empty);
        LOG("get: after P\n");

        if ((ch = fgetc(fp)) != EOF) {
            bufs_map[0] = ch;       // write character into S buffer
            LOG("get: %c\n", ch);
            LOG("get: before V\n");
            bufs_full->V(bufs_full);
            LOG("get: after V\n");
        } else {
            bufs_full->V(bufs_full);
            break;
        }
    }

    // close src file
    if (fp != NULL) {
        fclose(fp);
    }

    // detach shm
    shmdt(bufs_map);

    return 0;
}
