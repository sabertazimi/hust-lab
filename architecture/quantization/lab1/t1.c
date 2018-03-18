/*
 * t1.c
 * Copyright (C) 2017 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

int main(void) {
    struct timeval t1, t2;
    double timeuse = 0.0;

    gettimeofday(&t1, NULL);

    system("./t1_s1");

    gettimeofday(&t2, NULL);
    timeuse = t2.tv_sec - t1.tv_sec + (t2.tv_usec - t1.tv_usec)/1000000.0;

    printf("t1_s1: %fsecs\n", timeuse);

    gettimeofday(&t1, NULL);

    system("./t1_s2");

    gettimeofday(&t2, NULL);
    timeuse = t2.tv_sec - t1.tv_sec + (t2.tv_usec - t1.tv_usec)/1000000.0;

    printf("t1_s2: %fsecs\n", timeuse);

    return 0;
}

