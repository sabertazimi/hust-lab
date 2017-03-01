/*!
 * \file dragondev_test.c
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2017
 * \license MIT
 */

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(void) {
    int dragondev;
    char buf[10];

    dragondev = open("/dev/dragondev", O_RDWR);

    if (dragondev == -1) {
        perror("Test failed.\n");
        exit(0);
    }

    read(dragondev, buf, 10);

    for (int i = 0; i < 10; i++) {
        printf("%d\n", buf[i]);
    }

    close(dragondev);
}


