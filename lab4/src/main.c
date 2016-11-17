/*!
 * \file main.c
 * \brief entry file for linux file api lab
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-11-18
 * \license MIT
 */

#include <unistd.h>
#include <sys/stat.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dirent.h>

void printdir(char *dir, int depth) {
    DIR *dp;                    ///< for directory info
    struct dirent *entry;       ///< for directory item info
    struct stat statbuf;        ///< for file info

    // opendir
    if ((dp = opendir(dir)) == NULL) {
        perror("open dir failed\n");
        return;
    }

    // change current dir
    if (chdir(dir) < 0) {
        perror("chdir error\n");
        return;
    }

    while ((entry = readdir(dp)) != NULL) {
        lstat(entry->d_name, &statbuf);

        // a dir item
        if (S_ISDIR(statbuf.st_mode)) {
            if(strcmp(entry->d_name, "..") == 0 || strcmp(entry->d_name, ".") == 0) {
                continue;
            } else {
                // recursion
                printf("%2d\t", depth);
                printf("%s\n", entry->d_name);
                printdir(entry->d_name, depth + 1);
            }
        } else {
        // a file item
            printf("%2d\t", depth);
            printf("%s\n", entry->d_name);
        }
    }

    // return to upper dir
    if (chdir("..") < 0) {
        perror("chdir error\n");
        return;
    }

    // closedir
    closedir(dp);
}

int main(int argc, char **argv) {
    if (argc <= 1) {
        char cwd_buf[80];
        if (getcwd(cwd_buf, 80) == NULL) {
            perror("getcwd error\n");
            exit(-1);
        } else {
            printdir(cwd_buf, 0);
        }
    } else {
        for (int i = 1; i < argc; i++) {
            printdir(argv[i], 0);
        }
    }

    return 0;
}
