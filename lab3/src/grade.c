/*************************************************************************
	> File Name: grade.c
	> Author: Yilong Liu
	> Mail: sabertazimi@gmail.com
    > License: HPL(Homework Public License)
	> Created Time: 2016年03月22日 星期二 14时22分34秒
 ************************************************************************/

#include <stdio.h>
#include <stdlib.h>

#define NUM 3

typedef struct __student__ {
    char name[10];
    char chinese;
    char math;
    char english;
} student;

int main (void) {
    student stu[NUM] = [
        {"saber", 90, 80, 85},
        {"archer", 80, 75 ,85},
        {"lancer", 70, 80, 75}
    ];

    
    return 0;
}

