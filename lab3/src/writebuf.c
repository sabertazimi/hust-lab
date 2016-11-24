/*!
 * \file writebuf.c
 * \brief write data from src file to shared buffer
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-11-17
 * \license MIT
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/shm.h>
#include "semaphore/semaphore.h"

#define BUF_SIZE 10         ///< size of shared buffer

const key_t buf_key = 233;  ///< key of shared memory to buffer
semaphore_t buf_notfull;      ///< initial value: 1, key: 1
semaphore_t buf_notempty;       ///< initial value: 0, key: 2
semaphore_t mutex;          ///< mutex for buf_map[2](number of data)

int main(int argc, char **argv) {
    FILE *fp;               ///< src file pointer
    int buf_sid;            ///< shm id of shared memory as buffer
    char *buf_map;          ///< map address of shm to as buffer

    // get semaphores
    buf_notfull = semnew(1, 1);
    buf_notempty  = semnew(2, 0);
    mutex = semnew(3, 1);

    // get shm
    buf_sid = shmget(buf_key, BUF_SIZE+4, IPC_CREAT | 0666);

    if (buf_sid == -1) {
        perror("shmget error\n");
        return -1;
    }

    // attach shm
    buf_map = (char *)shmat(buf_sid, NULL, 0);

    // open src file
    if (argc <= 1) {
        if ((fp = fopen("./default.src", "a+")) == NULL) {
            perror("fopen error\n");
            return -1;
        }
    } else {
        if ((fp = fopen(argv[1], "a+")) == NULL) {
            perror("fopen error\n");
            return -1;
        }
    }

    // get data from src file to buffer
    while (1) {
        // test whether buf is full or not
        while (buf_map[2] == BUF_SIZE) {
            buf_notfull->P(buf_notfull);
        }

        // get write buf pointer
        int iwrite = buf_map[0];

        // write data to buffer, move write pointer
        char ch;
        if (fread(&ch, sizeof(char), 1, fp) <= 0) {
            // set end flag
            buf_map[3] = 1;
        }
        buf_map[4+iwrite++] = ch;
        iwrite %= BUF_SIZE;
        buf_map[0] = iwrite;

        // add number of data
        mutex->P(mutex);
        buf_map[2]++;
        mutex->V(mutex);

        fprintf(stdout, "write %c from src file to buffer... \n", ch);

        // break condition: read the end of file
        if (buf_map[3] == 1) {
            buf_notempty->V(buf_notempty);
            break;
        } else {
            buf_notempty->V(buf_notempty);
        }
    }

    // close src file
    if (fp != NULL) {
        fclose(fp);
    }

    usleep(500);

    return 0;
}
