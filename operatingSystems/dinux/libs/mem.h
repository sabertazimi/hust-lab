/*
 * mem.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef LIBS_MEM_H
#define LIBS_MEM_H

#include <defs.h>

/* memory libs */
void memcpy(uint8_t *dest, const uint8_t *src, uint32_t len);
void memset(void *dest, uint8_t val, uint32_t len);
void bzero(void *dest, uint32_t len);

#endif /* !LIBS_MEM_H */
