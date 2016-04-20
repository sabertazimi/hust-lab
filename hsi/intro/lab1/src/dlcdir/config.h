/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  config.h,v
 * Revision 1.10  1995/04/21  05:44:11  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.9  1995/02/13  02:00:08  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.8  1995/01/25  02:16:18  rcm
 * Changed how Prim types are created and merged.
 *
 * Revision 1.7  1995/01/20  03:38:03  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.6  1995/01/06  16:48:39  rcm
 * added copyright message
 *
 * Revision 1.5  1994/12/23  09:18:21  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.4  1994/12/20  09:23:56  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.3  1994/11/03  07:36:47  rcm
 * Removed more Alewife-isms.
 *
 * Revision 1.2  1994/10/28  18:52:18  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Wed Jun  2 13:35:18 EDT 1993
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
#pragma ident "config.h,v 1.10 1995/04/21 05:44:11 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#ifndef _CONFIG_H_
#define _CONFIG_H_

#include <limits.h>


/* expected suffixes for input and output files */
#define INPUT_SUFFIX   ".c"
#define OUTPUT_SUFFIX  ".p.c"

/* preprocessor command lines */
#define DEFAULT_PREPROC       "gcc -E -x c"
#define ANSI_PREPROC          "gcc -E -ansi -x c"


/* maximum number of nested block scopes */
#define MAX_NESTED_SCOPES    100

/* default warning level */
#define WARNING_LEVEL 4

#if 0
/* These DEFAULT_... symbols are obsolete.  The default signedness for all
   types but char is specified by ANSI C, and the logic in FinishPrimType
   is hard-coded to follow ANSI.  For char, c-to-c treats unspecified chars 
   as distinct types from signed char and unsigned char, so no default is
   required. -- rcm */
/* basic types w/o signed or unsigned default to: */
#define DEFAULT_INT     Sint
#define DEFAULT_SHORT   Sshort
#define DEFAULT_LONG    Slong
#define DEFAULT_CHAR    Schar
#endif

/* host types used hold values of each target type;
   i.e. TARGET_INT resolves to the type of the host used to
   represent ints on the target */
typedef char            TARGET_CHAR;
typedef int             TARGET_INT;
typedef unsigned int    TARGET_UINT;
typedef long            TARGET_LONG;
typedef unsigned long   TARGET_ULONG;

/* target limits */
#define TARGET_MAX_UCHAR  256
#define TARGET_MAX_INT    INT_MAX
#define TARGET_MAX_UINT   UINT_MAX
#define TARGET_MAX_LONG   LONG_MAX
#define TARGET_MAX_ULONG  ULONG_MAX

/* Basic sizes and alignments */
#define CHAR_SIZE         sizeof(char)
#define CHAR_ALIGN        CHAR_SIZE

#define SHORT_SIZE        sizeof(short)
#define SHORT_ALIGN       SHORT_SIZE

#define INT_SIZE          sizeof(int)
#define INT_ALIGN         INT_SIZE

#define FLOAT_SIZE        sizeof(float)
#define FLOAT_ALIGN       FLOAT_SIZE

#define DOUBLE_SIZE       sizeof(double)
#define DOUBLE_ALIGN      DOUBLE_SIZE

#ifdef __GNUC__
#define LONGDOUBLE_SIZE   sizeof(long double)
#else
#define LONGDOUBLE_SIZE   sizeof(double)
#endif
#define LONGDOUBLE_ALIGN  LONGDOUBLE_SIZE

#define LONG_SIZE         sizeof(long)
#define LONG_ALIGN        LONG_SIZE

#ifdef __GNUC__
#define LONGLONG_SIZE     sizeof(long long)
#else
#define LONGLONG_SIZE     sizeof(long)
#endif
#define LONGLONG_ALIGN    LONGLONG_SIZE

#define POINTER_SIZE      sizeof(void *)
#define POINTER_ALIGN     POINTER_SIZE

#define BYTE_LENGTH   CHAR_BIT
#define WORD_LENGTH   (INT_SIZE * BYTE_LENGTH)

#endif  /* ifndef _CONFIG_H_ */
