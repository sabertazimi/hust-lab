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

static int number = 0;          ///< shared number
static const int limit = 100;   ///< max value of shared number
static semaphore_t mutex;       ///< mutex for adding/subing num_tickets

void eval_thread(void *args) {
    int pid = *(pthread_t *)args;

    srand((unsigned)time(NULL));

    while (1) {
        sleep(rand() % 3);

        mutex->P(mutex);

        if (number < limit) {
            number++;
            LOG("%d: number get 1 added\n", pid);
            mutex->V(mutex);
        } else {
            LOG("%d: number reachs limit %3d\n", pid, number);
            mutex->V(mutex);
            break;
        }

    }
}

void print_thread(void *args) {
    int pid = *(pthread_t *)args;

    srand((unsigned)time(NULL));

    while (1) {
        sleep(rand() % 3);

        mutex->P(mutex);

        if (number < limit) {
            fprintf(stdout, "now, the value of shared number is %3d\n", number);
            mutex->V(mutex);
        } else {
            mutex->V(mutex);
            break;
        }
    }
}

int main(void) {
    int ret;                            ///< return value of pthread_create function
    pthread_t eval_pid, print_pid;      ///< thread id for every single window

    srand((unsigned)time(NULL));

    // create semaphore
    mutex = semnew(1);

    // create evaluation thread
    while ((ret = pthread_create(&eval_pid, NULL, (void *)eval_thread, &eval_pid)) != 0);
    LOG("create eval thread with pid %d\n", eval_pid);

    sleep(rand() % 2);

    // create print thread
    while ((ret = pthread_create(&print_pid, NULL, (void *)print_thread, &print_pid)) != 0);
    LOG("create print thread with pid %d\n", print_pid);

    // wait for finish of threads
    pthread_join(eval_pid, NULL);
    pthread_join(print_pid, NULL);

    // remove semaphore
    mutex->del(mutex);

    return 0;
}
