/*************************************************************************
	> File Name: grade.c
	> Author: Yilong Liu
	> Mail: sabertazimi@gmail.com
    > License: HPL(Homework Public License)
	> Created Time: 2016年03月22日 星期二 14时22分34秒
 ************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM 3

typedef struct __student__ {
    char name[10];
    char chinese;
    char math;
    char english;
    char grade;
} student;

int main (void) {
    student stu[NUM];
    short grade;
    char *input = (char *)malloc(sizeof(char) * 10);
    char quit = ' ';
    int i;

    student stu0 = {"saber", 90, 80, 85, 86};
    student stu1 = {"archer", 80, 75, 85, 79};
    student stu2 = {"lancer", 70, 80, 75, 73};
    stu[0] = stu0;
    stu[1] = stu1;
    stu[2] = stu2;

    while (quit != 'q') {
        printf("请输入学生姓名:\n");
        scanf("%s", input);

        for (i = 0;i < NUM;i++) {
            if (!strcmp(input, stu[i].name)) {
                grade =((short)(stu[i].chinese) * 2 + (short)(stu[i].math) + (short)(stu[i].english) / 2) /3.5;
                stu[i].grade  = (char)grade;
                break;
            }
        }

        if (i == 3) {
            printf("未找到学生, 请重新输入学生姓名\n");
        } else {
            if (stu[i].grade > 90) {
                printf("学生成绩等级: A\n");
            } else if (stu[i].grade > 80) {
                printf("学生成绩等级: B\n");
            } else if (stu[i].grade > 70) {
                printf("学生成绩等级: C\n");
            } else if (stu[i].grade > 60) {
                printf("学生成绩等级: D\n");
            } else {
                printf("学生成绩等级: E\n");
            }
        }

        printf("请输入任意键继续进行(q结束):");
        getchar();
        scanf("%c", &quit);
    }

    return 0;
}
