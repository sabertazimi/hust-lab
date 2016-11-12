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
static semaphore_t seme;       ///< sync semaphore for evaluation
static semaphore_t semp;       ///< sync semaphore for print

void eval_thread(void *args) {
    int pid = *(pthread_t *)args;

    srand((unsigned)time(NULL));

    while (1) {
        sleep(rand() % 2);

        semp->P(semp);

        if (number < limit) {
            number++;
            LOG("%d: number get 1 added\n", pid);
            seme->V(seme);
        } else {
            LOG("%d: number reachs limit %3d\n", pid, number);
            seme->V(seme);
            break;
        }

    }
}

void print_thread(void *args) {
    int pid = *(pthread_t *)args;

    srand((unsigned)time(NULL));

    while (1) {
        sleep(rand() % 2);

        seme->P(seme);

        if (number < limit) {
            fprintf(stdout, "%d: now, the value of shared number is %3d\n", pid, number);
            semp->V(semp);
        } else {
            semp->V(semp);
            break;
        }
    }
}

int main(void) {
    int ret;                            ///< return value of pthread_create function
    pthread_t eval_pid, print_pid;      ///< thread id for every single window

    // create semaphore
    // start eval_thread first
    seme = semnew(0);
    semp = semnew(1);

    // create evaluation thread
    while ((ret = pthread_create(&eval_pid, NULL, (void *)eval_thread, &eval_pid)) != 0);
    LOG("create eval thread with pid %d\n", eval_pid);

    // create print thread
    while ((ret = pthread_create(&print_pid, NULL, (void *)print_thread, &print_pid)) != 0);
    LOG("create print thread with pid %d\n", print_pid);

    // wait for finish of threads
    pthread_join(eval_pid, NULL);
    pthread_join(print_pid, NULL);

    // remove semaphore
    semp->del(semp);
    seme->del(seme);

    return 0;
}
