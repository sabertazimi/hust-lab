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

const key_t sem_key = 233;    ///< key of shared memory to store semaphores
const key_t bufs_key = 234;   ///< key of shared memory to S buffer
const key_t buft_key = 235;   ///< key of shared memory to T buffer
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
    int bufs_sid;           ///< shm id of shared memory as S buffer
    int buft_sid;           ///< shm id of shared memory as T buffer
    semaphore_t *sem_map;   ///< map address of shm to store semaphores
    char *bufs_map;         ///< map address of shm to as S buffer
    char *buft_map;         ///< map address of shm to as T buffer

    // create semaphore
    bufs_empty = semnew(1);
    bufs_full  = semnew(0);
    buft_empty = semnew(1);
    buft_full  = semnew(0);

    // create shm
    sem_sid = shmget(sem_key, 4096, IPC_CREAT | IPC_EXCL | 0600);
    bufs_sid = shmget(bufs_key, 4096, IPC_CREAT | IPC_EXCL | 0600);
    buft_sid = shmget(buft_key, 4096, IPC_CREAT | IPC_EXCL | 0600);

    if (sem_sid == -1 || bufs_sid == -1 || buft_sid == -1) {
        perror("shmget error\n");
        return -1;
    }

    LOG("sem_sid = %d, bufs_sid = %d, buft_sid = %d\n",
            sem_sid, bufs_sid, buft_sid);

    // attach shm
    sem_map  = (semaphore_t *)shmat(sem_sid, NULL, 0);
    bufs_map = (char *)shmat(bufs_sid, NULL, 0);
    buft_map = (char *)shmat(buft_sid, NULL, 0);

    // write data to shm
    // write pointing address of semaphore into sem_shm
    // wrie empty characters into bufs_shm and buft_shm
    sem_map[0] = bufs_empty;
    sem_map[1] = bufs_full;
    sem_map[2] = buft_empty;
    sem_map[3] = buft_full;
    memset(bufs_map, '\0', 4096);
    memset(buft_map, '\0', 4096);

    // detach shm
    shmdt(sem_map);
    shmdt(bufs_map);
    shmdt(buft_map);

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

                // remove shm
                shmctl(sem_sid, IPC_RMID, 0);
                shmctl(bufs_sid, IPC_RMID, 0);
                shmctl(buft_sid, IPC_RMID, 0);

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
