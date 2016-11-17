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
#include "semaphore/semaphore.h"

#define SLEEP_MIN 0             ///< minimal sleep ms value
#define SLEEP_MAX 100           ///< maximal sleep ms value

static int sum = 0;             ///< shared number
static int addend = 1;          ///< addend number
static const int limit = 100;   ///< max value of addend
static semaphore_t mutex;       ///< mutex for adding shared number

void eval_thread(void *args) {
    int pid = *(pthread_t *)args;

    srand((unsigned)time(NULL));

    while (1) {
        usleep(SLEEP_MIN*1000 + rand() % ((SLEEP_MAX-SLEEP_MIN)*1000));

        mutex->P(mutex);

        if (addend  <= limit) {
            sum += addend;
            fprintf(stdout, "eval %d: sum gets %3d added\n", pid, addend);
            addend++;
            mutex->V(mutex);
        } else {
            fprintf(stdout, "eval %d: add done, addend = %3d, sum = %3d\n", pid, addend, sum);
            mutex->V(mutex);
            break;
        }

    }
}

void print_thread(void *args) {
    int pid = *(pthread_t *)args;

    srand((unsigned)time(NULL));

    while (1) {
        usleep(SLEEP_MIN*1000 + rand() % ((SLEEP_MAX-SLEEP_MIN)*1000));

        mutex->P(mutex);

        if (addend <= limit) {
            fprintf(stdout, "print %d: now, shared sum = %3d\n", pid, sum );
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

    // create print thread
    while ((ret = pthread_create(&print_pid, NULL, (void *)print_thread, &print_pid)) != 0);

    // wait for finish of threads
    pthread_join(eval_pid, NULL);
    pthread_join(print_pid, NULL);

    // remove semaphore
    mutex->del(mutex);

    return 0;
}
