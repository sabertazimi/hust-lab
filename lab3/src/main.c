/*!
 * \file main.c
 * \brief entry file for shm lab
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
#include <sys/wait.h>
#include "semaphore/semaphore.h"

#define BUF_SIZE 10         ///< size of shared buffer

const key_t buf_key = 233;  ///< key of shared memory to buffer
semaphore_t buf_notfull;      ///< initial value: 1, key: 1
semaphore_t buf_notempty;       ///< initial value: 0, key: 2
semaphore_t mutex;          ///< mutex for buf_map[2](number of data)

int main(int argc, char **argv) {
    int status;             ///< wait status

    pid_t writebuf_pid;     ///< return pid of fork function
    pid_t readbuf_pid;      ///< return pid of fork function

    int buf_sid;            ///< shm id of shared memory as buffer
    char *buf_map;          ///< map address of shm to as buffer

    // create semaphore
    buf_notfull = semnew(1, 1);
    buf_notempty  = semnew(2, 0);
    mutex = semnew(3, 1);

    // create shm
    // buf[0] stores write pointer, buf[1] stores read pointer, buf[2] stores number of data, buf[3:BUF_SIZE+2] stores truly data
    buf_sid = shmget(buf_key, BUF_SIZE+3, IPC_CREAT | 0666);

    // get shm failed
    if (buf_sid == -1) {
        perror("shmget error\n");
        return -1;
    }

    // attach shm
    buf_map = (char *)shmat(buf_sid, NULL, 0);

    // wrie empty characters into buf_shm
    memset(buf_map, '\0', BUF_SIZE+3);

    // detach shm
    shmdt(buf_map);

    fprintf(stdout, "start copy data... \n");

    while ((writebuf_pid = fork()) == -1) ;
    if (writebuf_pid == 0) {            // sub
        execlp("./writebuf", "writebuf", argv[1], argv[2], argv[argc], NULL);
    } else {                            // main
        while ((readbuf_pid = fork()) == -1) ;
        if (readbuf_pid == 0) {         // sub
            execlp("./readbuf", "readbuf", argv[1], argv[2], argv[argc], NULL);
        } else {                        // main
            // wait for finish of children process
            for (int i = 0; i < 2; i++) {
                waitpid(-1, &status, 0);
            }

            fprintf(stdout, "done.\n");

            // remove shm
            shmctl(buf_sid, IPC_RMID, 0);

            // remove semaphore
            buf_notfull->del(buf_notfull);
            buf_notempty->del(buf_notempty);
            mutex->del(mutex);

            return 0;
        }
    }
}
