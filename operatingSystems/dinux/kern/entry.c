/*
* entry.c
* Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
*
* Distributed under terms of the MIT license.
*/

#include <stdlib.h>
#include <gdt.h>
#include <idt.h>
#include <drivers.h>
#include <mm.h>
#include <process.h>

#ifdef KERN_DEBUG
#include <spec.h>
#endif

multiboot_t *glb_mboot_ptr;     ///< valid after setting up of pages
char kern_stack[STACK_SIZE];    ///< valid after setting up of pages
uint32_t kern_stack_top;

__attribute__((section(".init.data"))) pgd_t *pgd_tmp  = (pgd_t *)0x1000;
__attribute__((section(".init.data"))) pgd_t *pte_low  = (pgd_t *)0x2000;
__attribute__((section(".init.data"))) pgd_t *pte_high = (pgd_t *)0x3000;

int flag = 0;

int thread(void *arg) {
    while (1) {
        if (flag == 1) {
            printk_color(RC_BLACK, RC_GREEN, "B");
            flag = 0;
        }
    }
    
    return 0;
}

void kern_entry(void);
int kern_init(void);

__attribute__((section(".init.text"))) void kern_entry(void) {
    pgd_tmp[0] = (uint32_t)pte_low | PAGE_PRESENT | PAGE_WRITE;
    pgd_tmp[PGD_INDEX(PAGE_OFFSET)] = (uint32_t)pte_high | PAGE_PRESENT | PAGE_WRITE;

    // 映射内核虚拟地址 4MB 到物理地址的前 4MB
    for (int i = 0; i < 1024; i++) {
        pte_low[i] = (i << 12) | PAGE_PRESENT | PAGE_WRITE;
    }

    // 映射 0x00000000-0x00400000 的物理地址到虚拟地址 0xC0000000-0xC0400000
    for (int i = 0; i < 1024; i++) {
        pte_high[i] = (i << 12) | PAGE_PRESENT | PAGE_WRITE;
    }

    // 设置临时页表
    asm volatile ("mov %0, %%cr3" : : "r" (pgd_tmp));

    uint32_t cr0;

    // 启用分页，将 cr0 寄存器的分页位置为 1 就好
    asm volatile ("mov %%cr0, %0" : "=r" (cr0));
    cr0 |= 0x80000000;
    asm volatile ("mov %0, %%cr0" : : "r" (cr0));

    // 切换内核栈
    kern_stack_top = ((uint32_t)kern_stack + STACK_SIZE) & 0xFFFFFFF0;
    asm volatile ("mov %0, %%esp\n\t"
                "xor %%ebp, %%ebp" : : "r" (kern_stack_top));

    // 更新全局 multiboot_t 指针
    glb_mboot_ptr = mboot_ptr_tmp + PAGE_OFFSET;

    kern_init();
}

int kern_init(void) {

    console_clear();

    #ifdef KERN_DEBUG
    if (mem_spec()) {
        printk_color(RC_BLACK, RC_GREEN, "mem_spec        >>>>>>>>>> [OK]\n") ;
    } else {
        printk_color(RC_BLACK, RC_RED, "mem_spec        >>>>>>>>>> [ER]\n") ;
    }

    if (string_spec()) {
        printk_color(RC_BLACK, RC_GREEN, "string_spec     >>>>>>>>>> [OK]\n") ;
    } else {
        printk_color(RC_BLACK, RC_RED, "string_spec     >>>>>>>>>> [ER]\n") ;
    }
    #endif

    #ifdef KERN_DEBUG
    debug_init();
    // panic("panic test");
    #endif

    gdt_init();
    idt_init();
    timer_init(1000);
    keyboard_init();

    #ifdef KERN_DEBUG
    printk("\nAuthor: sabertazimi\n");
    printk("Email: sabertazimi@gmail.com\n");
    printk("Hello, Dinux!\n");
    printk("@time 2016.9.21\n\n");

    print_regs();
    printk("\n");

    printk("kernel in memory start: 0x%08X\n", kern_start);
    printk("kernel in memory end  : 0x%08X\n", kern_end);
    printk("kernel in memory used : %d KB\n\n", (kern_end - kern_start + 1023)/1024);

    show_memory_map();
    pmm_init();
    vmm_init();
    heap_init();
    #endif

    #ifdef KERN_DEBUG
    uint32_t alloc_addr = NULL;

    printk_color(RC_BLACK, RC_GREEN, "\nThe count of physical memory page is: %u\n\n", phy_page_count);
    printk_color(RC_BLACK, RC_LIGHT_BROWN, "Test physical memory alloc: \n");
    alloc_addr = pmm_alloc_page();
    printk_color(RC_BLACK, RC_LIGHT_BROWN, "Alloc physical addr: 0x%08X\n", alloc_addr);
    alloc_addr = pmm_alloc_page();
    printk_color(RC_BLACK, RC_LIGHT_BROWN, "Alloc physical addr: 0x%08X\n", alloc_addr);
    alloc_addr = pmm_alloc_page();
    printk_color(RC_BLACK, RC_LIGHT_BROWN, "Alloc physical addr: 0x%08X\n", alloc_addr);
    alloc_addr = pmm_alloc_page();
    printk_color(RC_BLACK, RC_LIGHT_BROWN, "Alloc physical addr: 0x%08X\n", alloc_addr);
    
    heap_checkpoint();
    #endif
    
    sched_init();
    kernel_thread(thread, NULL);
    
    asm volatile("sti");
    
    while (1) {
        if (flag == 0) {
            printk_color(RC_BLACK, RC_RED, "A");
            flag = 1;
        }
    }

    while (1) {
        asm volatile ("hlt");
    }

    return 0;
}
