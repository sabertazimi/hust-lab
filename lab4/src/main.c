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
#include <sys/types.h>
#include <pwd.h>
#include <grp.h>
#include <time.h>
#include <sys/stat.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dirent.h>

static char cwd_buf[80];

/// \brief get info of directory entry
void printinfo(struct stat sb) {
    // print type of entry
    switch (sb.st_mode & S_IFMT) {
        case S_IFBLK:
            fprintf(stdout, "b");
            break;
        case S_IFCHR:
            fprintf(stdout, "c");
            break;
        case S_IFDIR:
            fprintf(stdout, "d");
            break;
        case S_IFIFO:
            fprintf(stdout, "p");
            break;
        case S_IFLNK:
            fprintf(stdout, "l");
            break;
        case S_IFREG:
            fprintf(stdout, "-");
            break;
        case S_IFSOCK:
            fprintf(stdout, "s");
            break;
        default:
            break;
    }

    // print permission of directory entry
    if(sb.st_mode & S_IRUSR) {
        fprintf(stdout, "r");
    } else {
        fprintf(stdout, "-");
    }
    if (sb.st_mode & S_IWUSR) {
        fprintf(stdout, "w");
    } else {
        fprintf(stdout, "-");
    }
    if (sb.st_mode & S_IXUSR) {
        fprintf(stdout, "x");
    } else {
        fprintf(stdout, "-");
    }
    if (sb.st_mode & S_IRGRP) {
        fprintf(stdout, "r");
    } else {
        fprintf(stdout, "-");
    }
    if (sb.st_mode & S_IWGRP) {
        fprintf(stdout, "w");
    } else {
        fprintf(stdout, "-");
    }
    if (sb.st_mode & S_IXGRP) {
        fprintf(stdout, "x");
    } else {
        fprintf(stdout, "-");
    }
    if (sb.st_mode & S_IROTH) {
        fprintf(stdout, "r");
    } else {
        fprintf(stdout, "-");
    }
    if (sb.st_mode & S_IWOTH) {
        fprintf(stdout, "w");
    } else {
        fprintf(stdout, "-");
    }
    if (sb.st_mode & S_IXOTH) {
        fprintf(stdout, "x ");
    } else {
        fprintf(stdout, "- ");
    }

    fprintf(stdout, "%ld ", (long) sb.st_nlink);

    // print id info of directory entry
    struct passwd *uid = getpwuid(sb.st_uid);
    struct group *gid = getgrgid(sb.st_gid);
    fprintf(stdout, "%s %s ", uid->pw_name, gid->gr_name);

    // print size of directory entry
    fprintf(stdout, "%lld ", (long long)sb.st_size);

    // print update time of directory entry
    char *time = ctime(&sb.st_atime);
    time[strlen(time) - 1]='\0';    // change '\n' to '\0'
    fprintf(stdout, "%s ", time);
}


void printdir(char *dir, int depth) {
    DIR *dp;                    ///< for directory info
    struct dirent *entry;       ///< for directory item info
    struct stat statbuf;        ///< for file info
    char cur_dir[80];           ///< current directory full name

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

    // get full name of current directory
    if (getcwd(cur_dir, 80) == NULL) {
        perror("getcwd error\n");
        exit(-1);
    }

    // if current directory is work directory, then print '.'
    if (strcmp(dir, cwd_buf) == 0) {
        fprintf(stdout, ".:\n");
    } else {
    // else print true name
        char *cwd_substr;

        if ((cwd_substr = strstr(cur_dir, cwd_buf)) != NULL) {
            // current directory is the child of current work directory
            // replace full name to './...' style
            memset(cwd_substr, '.', 1);
            memset(cwd_substr+1, '\0', 1);
            strcat(cwd_substr, cwd_substr + strlen(cwd_buf));

            fprintf(stdout, "%s:\n", cur_dir);
        } else {
            fprintf(stdout, "%s:\n", cur_dir);
        }
    }

    while ((entry = readdir(dp)) != NULL) {
        lstat(entry->d_name, &statbuf);

        // a dir item
        if (S_ISDIR(statbuf.st_mode)) {
            if(strcmp(entry->d_name, "..") == 0 || strcmp(entry->d_name, ".") == 0) {
                continue;
            } else {
                // recursion
                fprintf(stdout, "%2d ", depth);
                printinfo(statbuf);
                fprintf(stdout, "%s\n\n", entry->d_name);
                printdir(entry->d_name, depth + 1);
                fprintf(stdout, "\n");
            }
        } else {
        // a file item
            fprintf(stdout, "%2d ", depth);
            printinfo(statbuf);
            fprintf(stdout, "%s\n", entry->d_name);
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
    // get current work directory
    if (getcwd(cwd_buf, 80) == NULL) {
        perror("getcwd error\n");
        exit(-1);
    }

    if (argc <= 1) {
        printdir(cwd_buf, 0);
    } else {
        for (int i = 1; i < argc; i++) {
            printdir(argv[i], 0);
        }
    }

    return 0;
}
