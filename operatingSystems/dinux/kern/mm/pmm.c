/*
 * pmm.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include <x86.h>
#include <stdlib.h>
#include <pmm.h>

///< each element: start addr of physical page
static uint32_t pmm_stack[PAGE_MAX_SIZE+1];

///< point top of pmm_stack(free page stack)
static uint32_t pmm_stack_top;

///< number of free pages
uint32_t phy_page_count;

void show_memory_map(void) {
    uint32_t mmap_addr = glb_mboot_ptr->mmap_addr;
    uint32_t mmap_length = glb_mboot_ptr->mmap_length;

    printk("Memory map:\n");

    for (mmap_entry_t *mmap = (mmap_entry_t *)mmap_addr;
            (uint32_t)mmap < mmap_addr + mmap_length; mmap++) {
        printk("base_addr = 0x%X%08X, length = 0x%X%08X, type = 0x%X\n",
            (uint32_t)mmap->base_addr_high, (uint32_t)mmap->base_addr_low,
            (uint32_t)mmap->length_high, (uint32_t)mmap->length_low,
            (uint32_t)mmap->type);
    }
}

void pmm_init(void) {
    // cache start/end addr
    mmap_entry_t *mmap_start_addr = (mmap_entry_t *)glb_mboot_ptr->mmap_addr;
    mmap_entry_t *mmap_end_addr = (mmap_entry_t *)glb_mboot_ptr->mmap_addr + glb_mboot_ptr->mmap_length;

    mmap_entry_t * map_entry;

    for (map_entry = mmap_start_addr; map_entry < mmap_end_addr; map_entry++) {
        // normal memory(type 1)
        if (map_entry->type == 1 && map_entry->base_addr_low == 0x100000) {
            // real page start addr
            uint32_t page_addr = map_entry->base_addr_low + (uint32_t)(kern_end - kern_start);

            // memory struct array length
            uint32_t length = map_entry->base_addr_low + map_entry->length_low;

            while (page_addr < length && page_addr <= PMM_MAX_SIZE) {
                pmm_free_page(page_addr);
                page_addr += PMM_PAGE_SIZE;
                phy_page_count++;
            }
        }
    }
}

uint32_t pmm_alloc_page(void) {
    assert(pmm_stack_top != 0, "out of memory");

    uint32_t page = pmm_stack[pmm_stack_top--];

    return page;
}

void pmm_free_page(uint32_t addr) {
    assert(pmm_stack_top != PAGE_MAX_SIZE, "out of pmm_stack");

    pmm_stack[++pmm_stack_top] = addr;
}

