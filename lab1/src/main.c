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

void thread(void) {
    srand((unsigned)time(NULL));

    for (int i = 0; i < 3; i++) {
        LOG("This is a pthread: %d\n", i);
        sleep(rand() % 2);
    }
}

int main(void) {
    int ret;
    pthread_t id;

    // error recovery loop
    while ((ret = pthread_create(&id, NULL, (void *)thread, NULL)) != 0);

    for (int i = 0; i < 3; i++) {
        LOG("This is a main process: %d\n", i);
        sleep(1);
    }

    pthread_join(id, NULL);

    return 0;
}



