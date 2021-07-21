/*
 * debug.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include <debug.h>

static elf_t kernel_elf;

static void print_stack_trace(void) {
    uint32_t *ebp,
             *eip;

    asm volatile (
            "mov %%ebp, %0"
            : "=r" (ebp)
            );

    while (ebp) {
        eip = ebp + 1;
        printk(">>>> [0x%x] %s\n", *eip, elf_lookup_symbol(*eip, &kernel_elf));

        // back frame
        ebp = (uint32_t *)*ebp;
    }
}

void debug_init(void) {
    kernel_elf = elf_from_multiboot(glb_mboot_ptr);

#ifdef KERN_DEBUG
    printk_color(RC_BLACK, RC_GREEN, "debug_init      >>>>>>>>>> [OK]\n");
#endif
}

void panic(const char *msg) {
    printk("*** kernel panic: %s\n", msg);
    print_stack_trace();
    printk("***\n");

    while (1);
}

void print_regs(void) {
    static int round = 0;
    uint16_t cs,
             ds,
             es,
             ss;

    asm volatile (
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m" (cs), "=m" (ds), "=m" (es), "=m" (ss)
            );

    printk("%d: @ring %d\n", round, cs & 0x3);
    printk("%d: cs = %d\n", round, cs);
    printk("%d: ds = %d\n", round, ds);
    printk("%d: es = %d\n", round, es);
    printk("%d: ss = %d\n", round, ss);
    ++round;
}
