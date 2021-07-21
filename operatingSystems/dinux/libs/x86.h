/*
 * x86.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef LIBS_X86_H
#define LIBS_X86_H

#include <defs.h>

void outb(uint16_t port, uint8_t data);
void outw(uint16_t port, uint16_t data);
uint8_t inb(uint16_t port);
uint16_t inw(uint16_t port);

#endif /* !LIBS_X86_H */
