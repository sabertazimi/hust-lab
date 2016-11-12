/*!
 * \file main.c
 * \brief entry file for pthread lab
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-11-11
 * \license MIT
 */

#undef DEBUG
#define DEBUG   ///< macro for enable/disable debug functions
// #undef DEBUG

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "utils/utils.h"
#include "semaphore/semaphore.h"

semaphore_t bufs_empty;     ///< initial value: 1
semaphore_t bufs_full;      ///< initial value: 0
semaphore_t buft_empty;     ///< initial value: 1
semaphore_t buft_full;      ///< initial value: 0

int main(void) {
    pid_t get_pid;          ///< return pid of fork function
    pid_t copy_pid;         ///< return pid of fork function
    pid_t put_pid;          ///< return pid of fork function

    // create semaphore
    bufs_empty = semnew(1);
    bufs_full  = semnew(0);
    buft_empty = semnew(1);
    buft_full  = semnew(0);

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
                LOG("end of main process\n");
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
