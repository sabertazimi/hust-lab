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
#include <string.h>
#include <unistd.h>
#include <sys/shm.h>
#include "utils/utils.h"
#include "semaphore/semaphore.h"

const key_t buft_key = 235; ///< key of shared memory to T buffer
semaphore_t buft_empty;     ///< initial value: 1, key: 3
semaphore_t buft_full;      ///< initial value: 0, key: 4

int main(int argc, char **argv) {
    FILE *fp;               ///< dist file pointer
    int buft_sid;           ///< shm id of shared memory as T buffer
    char *buft_map;         ///< map address of shm to as T buffer

    // get semaphores
    buft_empty = semnew(3, 1);
    buft_full  = semnew(4, 0);

    // get shm
    buft_sid = shmget(buft_key, 2, IPC_CREAT | 0666);

    if (buft_sid == -1) {
        perror("shmget error\n");
        return -1;
    }

    // attach shm
    buft_map = (char *)shmat(buft_sid, NULL, 0);

    // open dist file
    if (argc < 2) {
        if ((fp = fopen("./default.dist", "w+")) == NULL) {
            perror("fopen error\n");
            return -1;
        }
    } else if (argc == 2) {
        if ((fp = fopen(strcat(argv[1], ".dist"), "w+")) == NULL) {
            perror("fopen error\n");
            return -1;
        }
    } else {
        if ((fp = fopen(argv[2], "w+")) == NULL) {
            perror("fopen error\n");
            return -1;
        }
    }

    // put data from T buffer to dist file
    while (1) {
        buft_full->P(buft_full);

        if (buft_map[0] == EOF) {
            buft_empty->V(buft_empty);
            break;
        } else {
            fputc(buft_map[0], fp);              // write character into dist file
            LOG("put %c from T buffer to dist file... \n", buft_map[0]);
            buft_empty->V(buft_empty);
        }
    }

    // close dist file
    if (fp != NULL) {
        fclose(fp);
    }

    // detach shm
    shmdt(buft_map);

    usleep(500);

    return 0;
}
