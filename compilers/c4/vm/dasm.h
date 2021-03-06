/*
 * dasm.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef DASM_H
#define DASM_H

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#define POOL_SIZE (1024 * 256)

// instructions
enum {
    IMM,    // IMM <num> : set ax to num
    LI,     // LI  <int> : load int  (ax hold address of int )
    LC,     // LC  <char>: load char (ax hold address of char)
    SI,     // SI  <int> : store int (st hold address of int )
    SC,     // SC  <char>: store char(st hold address of char)
    PUSH,   // PUSH
    JMP,    // JMP <address>
    JZ,     // JZ <address>
    JNZ,    // JNZ <address>
    CALL,   // CALL <address>
    ENT,    // ENT <frame_size>
    ADJ,    // ADJ <frame_size>
    LEV,    // LEV
    LEA,    // LEA <offset>
    OR,
    XOR,
    AND,
    EQ,
    NE,
    LT,
    GT,
    LE,
    GE,
    SHL,
    SHR,
    ADD,
    SUB,
    MUL,
    DIV,
    MOD,
    OPEN,
    READ,
    CLOS,
    PRTF,
    MALC,
    MSET,
    MCMP,
    EXIT
};

// memory management
int *text,
    *old_text,
    *stack;
char *data;

// registers
int *pc,
    *bp,
    *sp,
    ax,
    cycle;

// source code
char *src,
     *old_src;

int vm_init(void);
int eval(int *pc);

#endif /* !DASM_H */
