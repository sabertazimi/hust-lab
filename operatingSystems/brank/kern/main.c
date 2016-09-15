/*************************************************************************
	> File Name: main.c
	> Author: sabertazimi
	> Mail: sabertazimi@gmail.com
	> Created Time: 2016年09月15日 星期四 16时31分42秒
 ************************************************************************/

#include <system.h>

#define NULL 0

unsigned char *memcpy(unsigned char *dest, const unsigned char *src, int count) {
    if (dest == NULL || src == NULL || count <= 0) return dest;

    for (int i = 0; i < count; i++) {
        dest[i] = src[i];
    }

    return dest;
}

unsigned char *memset(unsigned char *dest, unsigned char val, int count) {
    if (dest == NULL || count <= 0) return dest;

    for (int i = 0; i < count; i++) {
        dest[i] = val;
    }

    return dest;
}

unsigned short *memsetw(unsigned short *dest, unsigned short val, int count) {
    if (dest == NULL || count <= 0) return dest;

    for (int i = 0; i < count; i++) {
        dest[i] = val;
    }

    return dest;
}

int strlen(const char *str) {
    int len = 0;
    if (str == NULL) return len;
    while(str[len++]);
    return len - 1;
}

unsigned char inportb(unsigned short _port) {
    unsigned char rv;

    __asm__ __volatile__ (
            "inb %1, %0"
            : "=a" (rv)
            : "dN" (_port)
        );

    return rv;
}

void outportb(unsigned short _port, unsigned char _data) {
    __asm__ __volatile__ (
            "outb %1, %0"
            :
            : "dN" (_port), "a" (_data)
        );
}

int main(void) {
    gdt_install();
    init_video();
    puts((unsigned char *)("Hello World!\n"));
    for (;;) ;

    return 0;
}
