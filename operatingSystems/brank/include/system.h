/*************************************************************************
	> File Name: system.h
	> Author: sabertazimi
	> Mail: sabertazimi@gmail.com
	> Created Time: 2016年09月15日 星期四 16时43分18秒
 ************************************************************************/

#ifndef _SYSTEM_H
#define _SYSTEM_H

#define NULL 0

/* def in main.c */
extern unsigned char *memcpy();
unsigned char *memset(unsigned char *dest, unsigned char val, int count);
unsigned short *memsetw(unsigned short *dest, unsigned short val, int count);
int strlen(const char *str);
unsigned char inportb(unsigned short _port);
void outportb(unsigned short _port, unsigned char _data);

/* def in scrn.c */
extern void cls(void);
extern void putch(unsigned char c);
extern void puts(unsigned char *str);
extern void settextcolor(unsigned char forecolor, unsigned char backcolor);
extern void init_video(void);

/* def in gdt.c */
extern void gdt_set_gate(int num, unsigned long base, unsigned long limit, unsigned char access, unsigned char gran);
extern void gdt_install();

#endif
