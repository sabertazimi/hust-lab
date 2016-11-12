/*!
 * \file main.c
 * \brief entry file for pthread lab
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
#include <sys/wait.h>
#include "utils/utils.h"
#include "semaphore/semaphore.h"

const key_t sem_key = 233;    ///< key of shared memory to store semaphores
semaphore_t bufs_empty;     ///< initial value: 1
semaphore_t bufs_full;      ///< initial value: 0
semaphore_t buft_empty;     ///< initial value: 1
semaphore_t buft_full;      ///< initial value: 0

int main(void) {
    int status;             ///< wait status
    pid_t get_pid;          ///< return pid of fork function
    pid_t copy_pid;         ///< return pid of fork function
    pid_t put_pid;          ///< return pid of fork function
    int sem_sid;            ///< shm id of shared memory to store semaphores

    // create semaphore
    bufs_empty = semnew(1);
    bufs_full  = semnew(0);
    buft_empty = semnew(1);
    buft_full  = semnew(0);

    // create
    while ((sem_sid = shmget(sem_key, 4096, IPC_CREAT | IPC_EXCL | 0600)) == -1);


    while ((get_pid = fork()) == -1) ;
    if (get_pid == 0) {                     // sub
        execlp("./get", "get", NULL);
    } else {                                // main
        while ((copy_pid = fork()) == -1) ;
        if (copy_pid == 0) {                // sub
            execlp("./copy", "copy", NULL);
        } else {                            // main
            while ((put_pid = fork()) == -1) ;
            if (put_pid == 0) {             // sub
                execlp("./put", "put", NULL);
            } else {                        // main
                // wait for finish of children process
                for (int i = 0; i < 3; i++) {
                    waitpid(-1, &status, 0);
                }

                LOG("end of chilren process\n");

                // remove semaphore
                bufs_empty->del(bufs_empty);
                bufs_full->del(bufs_full);
                buft_empty->del(buft_empty);
                buft_full->del(buft_full);

                LOG("end of main process\n");
                return 0;
            }
        }
    }
}
