/*************************************************************************
	> File Name: system.h
	> Author: sabertazimi
	> Mail: sabertazimi@gmail.com
	> Created Time: 2016年09月15日 星期四 16时43分18秒
 ************************************************************************/

#ifndef _SYSTEM_H
#define _SYSTEM_H

#define NULL 0
typedef int size_t;

struct regs

{
    unsigned int gs, fs, es, ds;
    unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eax;
    unsigned int int_no, err_code;
    unsigned int eip, cs, eflags, useresp, ss;    
};

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

/* def in idt.c */
extern void idt_set_gate(unsigned char num, unsigned long base, unsigned short sel, unsigned char flags);
extern void idt_install();

/* def in isrs.c */
extern void isrs_install();

/* def in irq.c */
extern void irq_install_handler(int irq, void (*handler)(struct regs *r));
extern void irq_uninstall_handler(int irq);
extern void irq_install();

/* def in timer.c */
extern void timer_wait(int ticks);
extern void timer_install();

/* def in keybord.c */
extern void keyboard_install();

#endif
