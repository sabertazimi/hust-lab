/*!
 * \file readbuf.c
 * \brief read data from shared buffer to dist file
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-11-17
 * \license MIT
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/shm.h>
#include "semaphore/semaphore.h"

#define BUF_SIZE 10         ///< size of shared buffer

const key_t buf_key = 233;  ///< key of shared memory to buffer
semaphore_t buf_notfull;      ///< initial value: 1, key: 1
semaphore_t buf_notempty;       ///< initial value: 0, key: 2
semaphore_t mutex;          ///< mutex for buf_map[2](number of data)

int main(int argc, char **argv) {
    FILE *fp;               ///< dist file pointer
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

    // put data from buffer to dist file
    while (1) {
        // test whether there is empty or not
        while (buf_map[2] == 0) {
            buf_notempty->P(buf_notempty);
        }

        // get buffer read pointer
        int iread = buf_map[1];

        // write to dist file from buffer, move read pointer
        char ch = buf_map[4+iread++];
        iread %= BUF_SIZE;
        buf_map[1] = iread;

        // sub number of data
        mutex->P(mutex);
        buf_map[2]--;
        mutex->V(mutex);

        // break condition: buffer empty && writebuf finish
        if (buf_map[2] <= 0 && buf_map[3] == 1 ) {
            buf_notfull->V(buf_notfull);
            break;
        } else {
            fputc(ch, fp);              // write character into dist file
            fprintf(stdout, "read %c from buffer to dist file... \n", ch);
            buf_notfull->V(buf_notfull);
        }
    }

    // close dist file
    if (fp != NULL) {
        fclose(fp);
    }

    // detach shm
    shmdt(buf_map);

    usleep(500);

    return 0;
}
