/*
 * gdt.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include <gdt.h>
#include <stdlib.h>

#define GDT_LENGTH 5

extern uint32_t stack;      // kernel stack

gdt_entry_t gdt_entries[GDT_LENGTH];
gdt_ptr_t gdt_ptr;

static void gdt_set_gate(int32_t num, uint32_t base,
        uint32_t limit, uint8_t access, uint8_t gran) {
    gdt_entries[num].base_low       = base & 0xffff;
    gdt_entries[num].base_middle    = (base >> 16) & 0xff;
    gdt_entries[num].base_high      = (base >> 24) & 0xff;

    gdt_entries[num].limit_low      = limit & 0xffff;
    gdt_entries[num].granularity    = (limit >> 16) & 0x0f;

    gdt_entries[num].granularity    |= gran & 0xf0;
    gdt_entries[num].access         = access;
}

void gdt_init(void) {
    gdt_ptr.limit = sizeof(gdt_entry_t) * GDT_LENGTH - 1;
    gdt_ptr.base = (uint32_t)&gdt_entries;

    gdt_set_gate(0, 0, 0, 0, 0);                    // compatiable to intel 386
    gdt_set_gate(1, 0, 0xffffffff, 0x9a, 0xcf);     // code segment
    gdt_set_gate(2, 0, 0xffffffff, 0x92, 0xcf);     // data segment
    gdt_set_gate(3, 0, 0xffffffff, 0xfa, 0xcf);     // user code segment
    gdt_set_gate(4, 0, 0xffffffff, 0xf2, 0xcf);     // user data segment

    gdt_flush((uint32_t)&gdt_ptr);

#ifdef KERN_DEBUG
    printk_color(RC_BLACK, RC_GREEN, "gdt_init        >>>>>>>>>> [OK]\n");
#endif
}
