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

const key_t sem_key = 233;    ///< key of shared memory to store semaphores
const key_t bufs_key = 234;   ///< key of shared memory to S buffer
semaphore_t bufs_empty;     ///< initial value: 1, key: 0
semaphore_t bufs_full;      ///< initial value: 0, key: 1

int main(void) {
    LOG("get pid = %d\n", getpid());

    char ch;                ///< character read from file
    FILE *fp;               ///< file pointer

    int sem_sid;            ///< shm id of shared memory to store semaphores
    int bufs_sid;           ///< shm id of shared memory as S buffer
    semaphore_t *sem_map;   ///< map address of shm to store semaphores
    char *bufs_map;         ///< map address of shm to as S buffer

    // get shm
    sem_sid  = shmget(sem_key, 0, 0);
    bufs_sid = shmget(bufs_key, 0, 0);

    if (sem_sid == -1 || bufs_sid == -1) {
        perror("shmget error\n");
        return -1;
    }

    // attach shm
    sem_map  = (semaphore_t *)shmat(sem_sid, NULL, 0);
    bufs_map = (char *)shmat(sem_sid, NULL, 0);

    // get semaphores
    bufs_empty = semnew(0, 1);
    bufs_full  = semnew(1, 0);

    // open file
    if ((fp = fopen("./src.dat", "a+")) == NULL) {
        perror("fopen error\n");
        return -1;
    }

    LOG("start to while loop\n");

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
    shmdt(sem_map);
    shmdt(bufs_map);

    return 0;
}
