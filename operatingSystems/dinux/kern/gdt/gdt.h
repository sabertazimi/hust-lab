/*
 * gdt.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef KERN_GDT_GDT_H
#define KERN_GDT_GDT_H

#include <defs.h>

typedef struct gdt_entry_t {
    uint16_t limit_low;
    uint16_t base_low;
    uint8_t base_middle;
    uint8_t access;
    uint8_t granularity;
    uint8_t base_high;
} __attribute__((packed)) gdt_entry_t;

typedef struct gdt_ptr_t {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed)) gdt_ptr_t;

void gdt_init(void);

// update gdt(assembly function)
extern void gdt_flush(uint32_t);

#endif /* !KERN_GDT_GDT_H */
