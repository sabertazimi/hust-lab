#include <stdlib.h>
#include <stdio.h>

int main(void) {
    int i;
    char c;

    // xor cx, 63h
    // sub cx, [0025]
    // 观察数据段，得到密码长度的密文为ds:[0025] =  0x64
    int len = 0x64 ^ 0x63;

    printf("Password Length:%d\n", len);

    // sub ax, 26h
    // mul dl           // dl = 2
    // 验证密码为将输入密码转为暗文进行比较
    // 加密方式: (pwd - 26)* 2 = secret
    // 第一个密码为立即寻址方式
    // cmp al, 0x6密文为0x6
    // cmp al, [bx+di] // bx = 1, di = 25h
    // 其余密文存放在ds:[0026]开始的６个字节内
    // 分别为0x86, 0x96, 0x9e, 0x86, 0x9c, 0x7a
    printf("Password: ");
    for (i = 0;i < 255;i++) {
        c = (char)i;
        if ((c - 38) * 2 == 6) {
            printf("%c", c);
        }
    }
    for (i = 0;i < 255;i++) {
        c = (char)i;
        if ((c - 38) * 2 == 0x86) {
            printf("%c", c);
        }
    }
    for (i = 0;i < 255;i++) {
        c = (char)i;
        if ((c - 38) * 2 == 0x96) {
            printf("%c", c);
        }
    }
    for (i = 0;i < 255;i++) {
        c = (char)i;
        if ((c - 38) * 2 == 0x9e) {
            printf("%c", c);
        }
    }
    for (i = 0;i < 255;i++) {
        c = (char)i;
        if ((c - 38) * 2 == 0x86) {
            printf("%c", c);
        }
    }
    for (i = 0;i < 255;i++) {
        c = (char)i;
        if ((c - 38) * 2 == 0x9c) {
            printf("%c", c);
        }
    }
    for (i = 0;i < 255;i++) {
        c = (char)i;
        if ((c - 38) * 2 == 0x7a) {
            printf("%c\n", c);
        }
    }

    // 查看数据段存储的姓名密文(后接多个连续0)
    // 0x2f, 0x10, 0x1b, 0x12, 0x2f
    // 0x75(u) ^ 0x2f
    // 0x75 ^ 0x10
    // 0x75 ^ 0x1b
    // 0x75 ^ 0x12
    // 0x75 ^ 0x2f
    printf("Name: ");
    printf("%c", 0x75^0x2f);
    printf("%c", 0x75^0x10);
    printf("%c", 0x75^0x1b);
    printf("%c", 0x75^0x12);
    printf("%c\n", 0x75^0x2f);

    // 查看数据段存储的成绩密文(前接多个连续0，3字节)
    // 0x2b, 0x11, 0x33
    //> 0x71(q) ^ 0x2b
    // 90
    //> 0x75(u) ^ 0x11
    // 100
    //> 0x69(i) ^ 0x33
    // 90
    printf("Grade: ");
    printf("%d\t", 0x71^0x2b);
    printf("%d\t", 0x75^0x11);
    printf("%d\n", 0x69^0x33);
}
