/* 
 * gencookie.c - cookie generator
 *
 * Generate "cookie" from a string, i.e., a number that
 * is not likely to match one generated for a different string.
 *
 * We require cookies to have properties that make it possible to
 * receive them embedded in strings.  In particular, none of the bytes
 * of a cookie can match the ASCII code for '\n'.
 *
 * Copyright (c) 2002, R. Bryant and D. O'Hallaron, All rights reserved.
 */


#include <stdlib.h>
#include "gencookie.h"

/* Create a cookie based on login ID */

/* View string as number expressed in some large radix */
#define RADIX 103
unsigned hash(char *s)
{
    unsigned val = 0;
    while(*s) {
	val = val * RADIX + *s++;
    }
    return val;
}

/* Make sure this is an OK cookie.
   Cannot contain any byte equal to 0x0A (ASCII code for '\n').
   Also, make sure leading hex digit is nonzero, so that it has
   a unique hexadecimal representation.
*/
int check(unsigned c)
{
    int i;
    if (((c >> 28) & 0xF) == 0)
	return 0;
    for (i = 0; i < 32; i+=8)
	if (((c >> i) & 0xFF) == '\n')
	    return 0;
    return 1;
}

unsigned gencookie(char *s)
{
    unsigned val;
    srand(hash(s));
    do
	val = rand();
    while (!check(val));
    return val;
}


