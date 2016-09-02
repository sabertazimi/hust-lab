/*
 * vm.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef VM_H
#define VM_H

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>

// instructions
enum {
    IMM,// IMM <num> : set ax to num
    LI, // LI  <int> : load int  (ax hold address of int )
    LC, // LC  <char>: load char (ax hold address of char)
    SI, // SI  <int> : store int (st hold address of int )
    SC, // SC  <char>: store char(st hold address of char)
    LEA,
    PUSH,
    JMP,
    JZ,
    JNZ,
    CALL,
    RET,
    ENT,
    ADJ,
    LEV,
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

int vm_init(void);
int eval(void);

#endif /* !VM_H */
