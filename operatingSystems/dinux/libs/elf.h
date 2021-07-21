/*
 * elf.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef LIBS_ELF_H
#define LIBS_ELF_H

#include <defs.h>
#include <multiboot.h>

#define ELF32_ST_TYPE(i) ((i) & 0xf)

typedef struct elf_section_header_t {
    uint32_t name;
    uint32_t type;
    uint32_t flags;
    uint32_t addr;
    uint32_t offset;
    uint32_t size;
    uint32_t link;
    uint32_t info;
    uint32_t addralign;
    uint32_t entsize;
} __attribute__((packed)) elf_section_header_t;

typedef struct elf_symbol_t {
    uint32_t name;      // not point to string address, but offset from strtab base address
    uint32_t value;
    uint32_t size;
    uint8_t  info;
    uint8_t  other;
    uint16_t  shndx;
} __attribute__((packed)) elf_symbol_t;

typedef struct elf_t {
    elf_symbol_t *symtab;
    uint32_t     symtabsz;
    const char   *strtab;
    uint32_t     strtabsz;
} elf_t;

elf_t elf_from_multiboot(multiboot_t *mb);
const char *elf_lookup_symbol(uint32_t addr, elf_t *elf);

#endif /* !LIBS_ELF_H*/
