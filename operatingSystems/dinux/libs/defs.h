/*
 * type.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef LIBS_TYPE_H
#define LIBS_TYPE_H

#define KERN_DEBUG

#ifndef NULL
    #define NULL ((void *)0)
#endif

#ifndef TRUE
    #define TRUE 1
#endif

#ifndef FALSE
    #define FALSE 0
#endif

// #define __packed   __attribute__((packed))
// #define __noinline __attribute__((noinline))
// #define __noreturn __attribute__((noreturn))

typedef unsigned int    size_t;
typedef unsigned int   uint32_t;
typedef          int   int32_t;
typedef unsigned short uint16_t;
typedef          short int16_t;
typedef unsigned char  uint8_t;
typedef          char  int8_t;
typedef          int   bool;

typedef int32_t pid_t;

#endif /* !LIBS_TYPE_H */
