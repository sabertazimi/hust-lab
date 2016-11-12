/*!
 * \file put.c
 * \brief entry file for put program
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

const key_t buft_key = 235; ///< key of shared memory to T buffer
semaphore_t buft_empty;     ///< initial value: 1, key: 2
semaphore_t buft_full;      ///< initial value: 0, key: 3

int main(void) {
    LOG("put pid = %d\n", getpid());

    char ch;                ///< character read from dist file
    FILE *fp;               ///< dist file pointer
    int buft_sid;           ///< shm id of shared memory as T buffer
    char *buft_map;         ///< map address of shm to as T buffer

    // get semaphores
    buft_empty = semnew(2, 1);
    buft_full  = semnew(3, 0);

    // get shm
    buft_sid = shmget(buft_key, 0, 0);

    if (buft_sid == -1) {
        perror("shmget error\n");
        return -1;
    }

    // attach shm
    buft_map = (char *)shmat(buft_sid, NULL, 0);

    // open dist file
    if ((fp = fopen("./dist.dat", "a+")) == NULL) {
        perror("fopen error\n");
        return -1;
    }

    // put data from T buffer to dist file
    while (1) {
        buft_full->P(buft_full);

        if ((ch = buft_map[0]) != EOF) {
            fputc(ch, fp);              // write character into dist file
            LOG("put: %c\n", ch);
            buft_empty->V(buft_empty);
        } else {
            buft_empty->V(buft_empty);
            break;
        }
    }

    // detach shm
    shmdt(buft_map);

    return 0;
}
