/*
 * vargs.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef LIBS_VARGS_H
#define LIBS_VARGS_H

/*
 * #define va_list char *
 * #define va_start(p, first)   (p = (va_list)&first + sizeof(first))
 * #define va_arg(p, next)      (*(next *)((p += sizeof(next)) - sizeof(next)))
 * #define va_end(p)            (p = (va_list)NULL)
 */

typedef __builtin_va_list va_list;

#define va_start(ap, last)      (__builtin_va_start(ap, last))
#define va_arg(ap, type)        (__builtin_va_arg(ap, type))
#define va_end(ap)

#endif /* !LIBS_VARGS_H */
