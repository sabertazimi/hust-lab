/*************************************************************************
	> File Name: gdt.c
	> Author: 
	> Mail: 
	> Created Time: 2016年09月15日 星期四 18时01分29秒
 ************************************************************************/

#include<system.h>

struct gdt_entry {
    unsigned short limit_low;
    unsigned short base_low;
    unsigned char base_middle;
    unsigned char access;
    unsigned char granularity;
    unsigned char base_high;
} __attribute__((packed));

/* use `lgdt` instr to load gdt_ptr into cr3 register */
struct gdt_ptr {
    unsigned short limit;
    unsigned int base;
} __attribute__((packed));

/* three items */
struct gdt_entry gdt[3];

/* gdt base address and limit */
struct gdt_ptr gp;

/* function in boot.asm: reset cr3 register */
extern void gdt_flush(void);

void gdt_set_gate(int num, unsigned long base, unsigned long limit, unsigned char access, unsigned char gran) {
    gdt[num].base_low = (base & 0xFFFF);
    gdt[num].base_middle = (base >> 16) & 0xFFFF;
    gdt[num].base_high = (base >> 24)& 0xFFFF;
    gdt[num].limit_low = (limit & 0xFFFF);
    gdt[num].granularity = (limit >> 16) & 0x0F;
    gdt[num].granularity |= (gran & 0xF0);
    gdt[num].access = access;
}

void gdt_install(void) {
    gp.limit = (sizeof(struct gdt_entry) * 3 ) - 1;
    gp.base = (unsigned int)&gdt;

    /* 简单进行开启了分段机制, 将所有内存全部归为一个段
     * 仅仅用作学习原理, 在实际应用中, 这样的分段没有任何意义
     */

    /* Null description */
    gdt_set_gate(0, 0, 0, 0, 0);
    /* code segment */
    gdt_set_gate(1, 0, 0xFFFFFFFF, 0x9A, 0xCF);
    /* data segment */
    gdt_set_gate(2, 0, 0xFFFFFFFF, 0x92, 0xCF);

    /* set new gdt */
    gdt_flush();
}

