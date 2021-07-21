/*
 * keyboard.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include <x86.h>
#include <stdlib.h>
#include <idt.h>
#include <keyboard.h>

/*
 * 键盘当前状态信息(相关位被设置即为有效)
 *
 * 0: control
 * 1: alt
 * 2: alt-gr
 * 3: left shift
 * 4: right shift
 * 5: caps_lock
 * 6: scroll_lock
 * 7: num_lock
 */
#define CONTROL         0x1
#define ALT             0x2
#define ALTGR           0x4
#define LSHIFT          0x8
#define RSHIFT          0x10
#define CAPSLOCK        0x20
#define SCROLLLOCK      0x40
#define NUMLOCK         0x80

// 8 位键盘码置 1, 表示其对应的断开码
#define RELEASED_MASK   0x80

typedef struct keymap {
    uint8_t scancodes[128];         // 键盘扫描码的映射
    uint8_t capslock_scancodes[128];
    uint8_t shift_scancodes[128];
    uint8_t control_map[8];
    uint8_t controls;               // 键盘的控制状态信息
} keymap_t;

static keymap_t us_keymap = {
    //normal keys
    {
        /* first row - indices 0 to 14 */
        0, 27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b',
        /* second row - indices 15 to 28 */
        '\t', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n', //Enter key
        /* 29 = Control, 30 - 41: third row */
        0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`',
        /* fourth row, indices 42 to 54, zeroes are shift-keys*/
        0, '\\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0,
        '*',
        /* Special keys */
        0,    // ALT - 56
        ' ', // Space - 57
        0,    // Caps lock - 58
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // F1 to F10 - 59 to 68
        0, // Num lock - 69
        0, // Scroll lock - 70
        0, // Home - 71
        72, // Up arrow - 72  TODO
        0, // Page up - 73
        '-',
        0, // Left arrow - 75
        0,
        0, // Right arrow -77
        '+',
        0, // End - 79
        80, // Dowm arrow - 80  TODO
        0, // Page down - 81
        0, // Insert - 82
        0, // Delete - 83
        0, 0, 0,
        0, // F11 - 87
        0, // F12 - 88
        0, // All others undefined
    },
    // caps
    {
        /* first row - indices 0 to 14 */
        0, 27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b',
        /* second row - indices 15 to 28 */
        '\t', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '\n',
        /* 29 = Control, 30 - 41: third row */
        0, 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ';', '\'', '`',
        /* fourth row, indices 42 to 54, zeroes are shift-keys*/
        0, '|', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.', '/', 0, '*',
        /* Special keys */
        0,   // ALT - 56
        ' ', // Space - 57
        0,   // Caps lock - 58
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // F1 to F10 - 59 to 68
        0, // Num lock - 69
        0, // Scroll lock - 70
        0, // Home - 71
        0, // Up arrow - 72
        0, // Page up - 73
        '-',
        0, // Left arrow - 75
        0,
        0, // Right arrow -77
        '+',
        0, // End - 79
        0, // Dowm arrow - 80
        0, // Page down - 81
        0, // Insert - 82
        0, // Delete - 83
        0, 0, 0,
        0, // F11 - 87
        0, // F12 - 88
        0, // All others undefined
    },
    // shift
    {
        /* first row - indices 0 to 14 */
        0, 27, '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '\b',
        /* second row - indices 15 to 28 */
        '\t', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '\n',
        /* 29 = Control, 30 - 41: third row */
        0, 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', '"', '~',
        /* fourth row, indices 42 to 54, zeroes are shift-keys*/
        0, '|', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<', '>', '?', 0, '*',
        /* Special keys */
        0,   // ALT - 56
        ' ', // Space - 57
        0,   // Caps lock - 58
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // F1 to F10 - 59 to 68
        0, // Num lock - 69
        0, // Scroll lock - 70
        0, // Home - 71
        0, // Up arrow - 72
        0, // Page up - 73
        '-',
        0, // Left arrow - 75
        0,
        0, // Right arrow -77
        '+',
        0, // End - 79
        0, // Dowm arrow - 80
        0, // Page down - 81
        0, // Insert - 82
        0, // Delete - 83
        0, 0, 0,
        0, // F11 - 87
        0, // F12 - 88
        0, // All others undefined
    },
    // control_map
    {
        29, // Ctrl
        56, // Alt
        0,  // AltGr
        42, // left Shift
        54, // right Shift
        58, // Caps lock
        70, // Scroll lock
        69  // Num lock
    },
    // 键盘的控制键信息初始化为 0
    0
};

/* Handles the keyboard interrupt */
static void keyboard_handler(pt_regs *regs) {
    /* Read from the keyboard's data buffer */
    uint8_t scancode = inb(0x60);

    keymap_t *layout = &us_keymap;

    // 判断按下/抬起
    if (scancode & RELEASED_MASK) {
        for (uint32_t i = 0; i < 5; i++) {
            if(layout->control_map[i] == (scancode & ~RELEASED_MASK)) {
                layout->controls &= ~(1 << i);
                return;
            }
        }
    // 当键被按下
    } else {
        // 逐一检查各个控制位
        for (uint32_t i = 0; i < 8; i++) {
            // 如果当前键是控制键，则给相关控制位置 1
            // 如果已有该标志位，则给相关控制位清 0
            if (layout->control_map[i] == scancode) {
                if (layout->controls & 1 << i) {
                    layout->controls &= ~(1 << i);
                } else {
                    layout->controls |= (1 << i);
                }

                return;
            }
        }

        /* 根据控制键切换字符集 */

        uint8_t *scancodes = layout->scancodes;
        // 如果此时按下了 shift 键，切换到 shift 扫描码
        if ((layout->controls & (LSHIFT | RSHIFT)) && !(layout->controls & CONTROL)) {
            scancodes = layout->shift_scancodes;
        }
        // 如果此时处于大写锁定状态，切换到大写锁定的扫描码
        if ((layout->controls & (CAPSLOCK)) && !(layout->controls & CONTROL)) {
            scancodes = layout->capslock_scancodes;
        }

        /* 根据控制键切换字符集 */

        // 打印字符
        printk("%c", scancodes[scancode]);
    }
}

/* Installs the keyboard handler into IRQ1 */
void keyboard_init(void) {
    register_interrupt_handler(IRQ1, keyboard_handler);

#ifdef KERN_DEBUG
    printk_color(RC_BLACK, RC_GREEN, "keyboard_init   >>>>>>>>>> [OK]\n");
#endif
}
