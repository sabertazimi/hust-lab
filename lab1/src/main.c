/*
 * main.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

void thread(void) {
    srand((unsigned)time(NULL));

    for (int i = 0; i < 3; i++) {
        fprintf(stdout, "This is a pthread: %d\n", i);
        sleep(rand() % 2);
    }
}

int main(void) {
    int ret;
    pthread_t id;

    // error recovery loop
    while ((ret = pthread_create(&id, NULL, (void *)thread, NULL)) != 0);

    for (int i = 0; i < 3; i++) {
        fprintf(stdout, "This is the main process: %d\n", i);
        sleep(1);
    }

    pthread_join(id, NULL);

    return 0;
}



