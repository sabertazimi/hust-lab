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
#include <string.h>
#include <unistd.h>
#include <sys/shm.h>
#include <sys/wait.h>
#include "utils/utils.h"
#include "semaphore/semaphore.h"

const key_t bufs_key = 234; ///< key of shared memory to S buffer
const key_t buft_key = 235; ///< key of shared memory to T buffer
semaphore_t bufs_empty;     ///< initial value: 1, key: 1
semaphore_t bufs_full;      ///< initial value: 0, key: 2
semaphore_t buft_empty;     ///< initial value: 1, key: 3
semaphore_t buft_full;      ///< initial value: 0, key: 4

int main(void) {
    int status;             ///< wait status

    pid_t get_pid;          ///< return pid of fork function
    pid_t copy_pid;         ///< return pid of fork function
    pid_t put_pid;          ///< return pid of fork function

    int bufs_sid;           ///< shm id of shared memory as S buffer
    int buft_sid;           ///< shm id of shared memory as T buffer
    char *bufs_map;         ///< map address of shm to as S buffer
    char *buft_map;         ///< map address of shm to as T buffer

    // create semaphore
    bufs_empty = semnew(1, 1);
    bufs_full  = semnew(2, 0);
    buft_empty = semnew(3, 1);
    buft_full  = semnew(4, 0);

    // create shm
    bufs_sid = shmget(bufs_key, 2, IPC_CREAT | 0666);
    buft_sid = shmget(buft_key, 2, IPC_CREAT | 0666);

    // get shm failed
    if (bufs_sid == -1 || buft_sid == -1) {
        perror("shmget error\n");
        return -1;
    }

    // attach shm
    bufs_map = (char *)shmat(bufs_sid, NULL, 0);
    buft_map = (char *)shmat(buft_sid, NULL, 0);

    // write data into shm
    // wrie empty characters into bufs_shm and buft_shm
    memset(bufs_map, '\0', 2);
    memset(buft_map, '\0', 2);

    // detach shm
    shmdt(bufs_map);
    shmdt(buft_map);

    LOG("start copy data... \n");

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

                LOG("done.\n");

                // remove shm
                shmctl(bufs_sid, IPC_RMID, 0);
                shmctl(buft_sid, IPC_RMID, 0);

                // remove semaphore
                bufs_empty->del(bufs_empty);
                bufs_full->del(bufs_full);
                buft_empty->del(buft_empty);
                buft_full->del(buft_full);

                return 0;
            }
        }
    }
}
