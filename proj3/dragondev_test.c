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
    char buf[1];
    
    dragondev = open("/dev/dragondev", O_RDWR);
    if (dragondev == -1) {
        perror("Test failed.\n");
        exit(0);
    }
    
    for (int i = 1; i <= 127; i++) {
        buf[0] = i;
        printf("write_size = %d\t", (int)write(dragondev, buf, 1));
    }
    
    close(dragondev);
    printf("\n\n");
    
    dragondev = open("/dev/dragondev", O_RDWR);
    if (dragondev == -1) {
        perror("Test failed.\n");
        exit(0);
    }
    
    for (int i = 1; i <= 127; i++) {
        printf("read_size = %d, ", (int)read(dragondev, buf, 1));
        printf("%c\n", buf[0]);
    }
    
    close(dragondev);
    
    return 0;
}
