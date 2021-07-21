/*
 * timer.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include <x86.h>
#include <stdlib.h>
#include <idt.h>
#include <sched.h>
#include <timer.h>

static void timer_handler(pt_regs *regs) {

    schedule();

    // static uint32_t tick = 0;
    // tick++;
    // if (tick % 1000 == 0) {
    //     printk_color(RC_BLACK, RC_GREEN, "Tick: %d\n", tick/1000); */
    // }
}

void timer_init(uint32_t frequency) {
    register_interrupt_handler(IRQ0, timer_handler);

    // Port range of Intel 8253/8254 PIT chip: 40h ~ 43h
    // input frequency: 1193180(interrupt times per second)
    uint32_t divisor = 1193180 / frequency;

    // D7 D6 D5 D4 D3 D2 D1 D0
    // 0  0  1  1  0  1  1  0
    // set 8253/8254 chip work under mode 3
    outb(0x43, 0x36);

    uint8_t low = (uint8_t)(divisor & 0xff);
    uint8_t high = (uint8_t)((divisor >> 8) & 0xff);

    outb(0x40, low);
    outb(0x40, high);

#ifdef KERN_DEBUG
    printk_color(RC_BLACK, RC_GREEN, "timer_init      >>>>>>>>>> [OK]\n");
#endif
}

