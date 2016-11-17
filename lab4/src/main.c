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
    DIR *dp;
    struct dirent *entry;
    struct stat statbuf;

    if ((dp = 打开dir目录) 不成功) {
        打印出错信息;
        返回;
    }

    将dir设置为当前目录;

    while (读到一个目录项) {
        以该目录项的名字为参数,调用lstat得到该目录项的相关信息;

        if (是目录) {
            if (目录项的名字是”..”或”.”) {
                跳过该目录项;
            } else {
                打印目录项的深度、目录名等信息
                递归调用printdir,打印子目录的信息,其中的depth+4;
            }
        } else {
            打印文件的深度、文件名等信息
        }
    }

    返回父目录;
    关闭目录项;
}
