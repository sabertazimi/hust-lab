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
static semaphore_t seme;       ///< sync semaphore for evaluation
static semaphore_t semp;       ///< sync semaphore for print

void eval_thread(void *args) {
    int pid = *(pthread_t *)args;

    srand((unsigned)time(NULL));

    while (1) {
        usleep(SLEEP_MIN*1000 + rand() % ((SLEEP_MAX-SLEEP_MIN)*1000));

        semp->P(semp);

        if (addend  <= limit) {
            sum += addend;
            fprintf(stdout, "eval %d: sum gets %3d added\n", pid, addend);
            addend++;
            seme->V(seme);
        } else {
            fprintf(stdout, "eval %d: add done, addend = %3d, sum = %3d\n", pid, addend, sum);
            seme->V(seme);
            break;
        }

    }
}

void print_thread(void *args) {
    int pid = *(pthread_t *)args;

    srand((unsigned)time(NULL));

    while (1) {
        usleep(SLEEP_MIN*1000 + rand() % ((SLEEP_MAX-SLEEP_MIN)*1000));

        seme->P(seme);

        if (addend <= limit) {
            fprintf(stdout, "print %d: now, shared sum = %3d\n", pid, sum );
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

    // create print thread
    while ((ret = pthread_create(&print_pid, NULL, (void *)print_thread, &print_pid)) != 0);

    // wait for finish of threads
    pthread_join(eval_pid, NULL);
    pthread_join(print_pid, NULL);

    // remove semaphore
    semp->del(semp);
    seme->del(seme);

    return 0;
}
