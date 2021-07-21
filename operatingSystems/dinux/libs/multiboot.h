/*
 * multiboot.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef LIBS_MULTIBOOT_H
#define LIBS_MULTIBOOT_H

#include <defs.h>

typedef struct multiboot_t {
    uint32_t flags;         // multiboot version info

    /*
     * memory information provided by BIOS
     */
    uint32_t mem_lower;
    uint32_t mem_upper;

    uint32_t boot_device;
    uint32_t cmdline;       // kernel cli
    uint32_t mods_count;
    uint32_t mods_addr;

    /*
     * elf section header of kernel
     */
    uint32_t num;
    uint32_t size;
    uint32_t addr;
    uint32_t shndx;

    /*
     * memory mapping info provided by BIOS
     * addr: point to start address of buffer for link list for mmap_entry_t
     * length: buffer total size
     */
    uint32_t mmap_length;
    uint32_t mmap_addr;

    uint32_t drives_length;     // length of first device
    uint32_t drives_addr;       // physical address of first device
    uint32_t config_table;      // ROM config table
    uint32_t boot_loader_name;
    uint32_t apm_table;
    uint32_t vbe_control_info;
    uint32_t vbe_mode_info;
    uint32_t vbe_mode;
    uint32_t vbe_interface_seg;
    uint32_t vbe_interface_off;
    uint32_t vbe_interface_len;
} __attribute__((packed)) multiboot_t;

///< type: 1 represents RAM, other represents I/O device mapping to memory
typedef struct mmap_entry_t {
    uint32_t size;
    uint32_t base_addr_low;
    uint32_t base_addr_high;
    uint32_t length_low;
    uint32_t length_high;
    uint32_t type;
} __attribute__((packed)) mmap_entry_t;

extern multiboot_t *mboot_ptr_tmp;  ///< from boot.S: valid before setting up of pages
extern multiboot_t *glb_mboot_ptr;  ///< from entry.c: valid after setting up of pages

#endif /* !LIBS_MTIBOOT_H */
