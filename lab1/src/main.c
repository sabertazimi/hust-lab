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

void thread(void) {
    srand((unsigned)time(NULL));

    for (int i = 0; i < 3; i++) {
        LOG("Pthread: %d\n", i);
        sleep(rand() % 2);
    }

    // create semaphore
    semaphore_t sem = semnew(5);
    LOG("Pthread: semid %d\n", sem->semid);
    LOG("Pthread: semval %d\n", sem->semval);
    sem->del(sem->self);
}

int main(void) {
    int ret;
    pthread_t id;

    // error recovery loop
    while ((ret = pthread_create(&id, NULL, (void *)thread, NULL)) != 0);

    for (int i = 0; i < 3; i++) {
        LOG("Main: %d\n", i);
        sleep(1);
    }

    // create semaphore
    semaphore_t sem = semnew(5);
    LOG("Main: semid %d\n", sem->semid);
    LOG("Main: semval %d\n", sem->semval);
    sem->del(sem->self);

    sem = semnew(10);
    LOG("Main: semid %d\n", sem->semid);
    LOG("Main: semval %d\n", sem->semval);
    sem->del(sem->self);

    pthread_join(id, NULL);

    return 0;
}



