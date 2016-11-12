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
#include <pthread.h>
#include <unistd.h>
#include "utils/utils.h"
#include "semaphore/semaphore.h"

static const int num_windows = 10;  ///< number of windows selling tickets
static int num_tickets = 100;       ///< number of available tickets
static semaphore_t mutex;           ///< mutex for adding/subing num_tickets

void window(void *args) {
    srand((unsigned)time(NULL));

    int id = *(int *)args;

    while (1) {
        sleep(rand() % 3);

        mutex->P(mutex);

        if (num_tickets <= 0) {
            mutex->V(mutex);
            break;
        } else {
            num_tickets--;
            LOG("window %d sell out 1 ticket, now available %d\n", id, num_tickets);
            mutex->V(mutex);
        }
    }
}

int main(void) {
    int ret;                                ///< return value of pthread_create function
    int windows_id[num_windows];            ///< No. id for every single window
    pthread_t windows_pid[num_windows];     ///< thread id for every single window

    srand((unsigned)time(NULL));

    // create semaphore
    mutex = semnew(1);
    // LOG("Main: semid %d\n", mutex->semid);
    // LOG("Main: semval %d\n", mutex->semval);

    for (int i = 0; i < num_windows; i++) {
        windows_id[i] = i + 1;
        while ((ret = pthread_create(&windows_pid[i], NULL, (void *)window, &windows_id[i])) != 0);
        LOG("create No.%d window with pid %d\n", windows_id[i], windows_pid[i]);
        sleep(rand() % 2);
    }

    // wait for sub-thread finish
    for (int i = 0; i < num_windows; i++) {
        pthread_join(windows_pid[i], NULL);
    }

    // remove semaphore
    mutex->del(mutex);

    return 0;
}

