/*
 * pmm.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef KERN_MM_PMM_H
#define KERN_MM_PMM_H

#include <multiboot.h>

#define STACK_SIZE      8192

// max mem size: 512MB
#define PMM_MAX_SIZE    0x20000000

// single page size: 4KB(2^12)
#define PMM_PAGE_SIZE   0x1000

// number of pages
#define PAGE_MAX_SIZE (PMM_MAX_SIZE/PMM_PAGE_SIZE)

// align to 4096
#define PHY_PAGE_MASK   0xfffff000

// variables defined in kernel.ld
extern uint8_t kern_start[];
extern uint8_t kern_end[];
extern uint32_t kern_stack_top;

// number of free pages
extern uint32_t phy_page_count;

void show_memory_map(void);
void pmm_init(void);
uint32_t pmm_alloc_page(void);
void pmm_free_page(uint32_t addr);

#endif /* !KERN_MM_PMM_H */
