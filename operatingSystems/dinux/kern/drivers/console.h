/*
 * console.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@gamil.com>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef KERN_DRIVERS_CONSOLE_H
#define KERN_DRIVERS_CONSOLE_H

#include <defs.h>

#define VGA_BUFFER_WIDTH  80
#define VGA_BUFFER_HEIGHT 25

#define VGA_COLOR(back, fore) (((back) << 4)| ((fore) & 0xf))
#define VGA_CHAR(ascii, back, fore) (((ascii) & 0xff) | (VGA_COLOR(back, fore) << 8))

typedef enum real_color {
    RC_BLACK = 0,
    RC_BLUE,
    RC_GREEN,
    RC_CYAN,
    RC_RED,
    RC_MAGENTA,
    RC_BROWN,
    RC_LIGHT_GREY,
    RC_DARK_GREY,
    RC_LIGHT_BLUE,
    RC_LIGHT_GREEN,
    RC_LIGHT_CYAN,
    RC_LIGHT_RED,
    RC_LIGHT_MAGENTA,
    RC_LIGHT_BROWN,
    RC_WHITE
} real_color_t;

void console_clear(void);
void console_putc_color(char c, real_color_t back, real_color_t fore);
void console_write(char *str);
void console_write_color(char *str, real_color_t back, real_color_t fore);
void console_write_hex(uint32_t n, real_color_t back, real_color_t fore);
void console_write_dec(uint32_t n, real_color_t back, real_color_t fore);

#endif /* !KERN_DRIVERS_CONSOLE_H */
