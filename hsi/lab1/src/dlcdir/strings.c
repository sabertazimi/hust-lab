/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  strings.c,v
 * Revision 1.5  1995/04/21  05:44:48  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.4  1995/01/06  16:49:09  rcm
 * added copyright message
 *
 * Revision 1.3  1994/12/20  09:24:20  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.2  1994/10/28  18:53:07  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Wed Apr 28 18:24:09 EDT 1993
 *
 *
 *
 * Copyright (c) 1994 MIT Laboratory for Computer Science
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE MIT LABORATORY FOR COMPUTER SCIENCE BE LIABLE
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * Except as contained in this notice, the name of the MIT Laboratory for
 * Computer Science shall not be used in advertising or otherwise to
 * promote the sale, use or other dealings in this Software without prior
 * written authorization from the MIT Laboratory for Computer Science.
 * 
 *************************************************************************/
#if 0
#pragma ident "strings.c,v 1.5 1995/04/21 05:44:48 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "basics.h"

#define TABLE_SIZE  231

typedef struct eT {
    char *string;
    struct eT *next;
} entryType;

PRIVATE entryType *hash_table[TABLE_SIZE];

/*  copy_string:
    Copy string to create location, and return the create location.
*/
PRIVATE char *copy_string(const char *string)
{
    char *new_string;

    new_string = HeapNewArray(char, strlen(string)+1);
    return strcpy(new_string, string);
}

/* hash table function */
PRIVATE short hash_function(const char *string)
{
    unsigned short i, k;
    unsigned long val;

    assert(string != NULL);
    
    val = (short) string[0] + 1;
    for(i = 1; i < 8; i++) {
	if (string[i] == 0) break;
	k = string[i] & 0x3f;
	val *= k + 7;
    }
    return((short)(val % TABLE_SIZE));
}


GLOBAL char *UniqueString(const char *string)
{
    short bucket = hash_function(string);
    entryType *entry;

    for (entry = hash_table[bucket]; entry != NULL; entry = entry->next)
      if (strcmp(string, entry->string) == 0)
	return(entry->string);

    /* not found */
    entry = HeapNew(entryType);

    entry->string = copy_string(string);
    entry->next = hash_table[bucket];
    hash_table[bucket] = entry;

    return(entry->string);
}

