/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  warning.c,v
 * Revision 1.7  1995/04/21  05:45:05  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.6  1995/03/23  15:31:45  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.5  1995/01/06  16:49:21  rcm
 * added copyright message
 *
 * Revision 1.4  1994/12/20  09:24:32  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.3  1994/11/22  01:54:59  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.2  1994/10/28  18:53:29  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Fri Apr 23 10:46:48 EDT 1993
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
#pragma ident "warning.c,v 1.7 1995/04/21 05:45:05 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "basics.h"


#ifndef NO_STDARG
   #include <stdarg.h>
   #define VA_START(ap,fmt)   va_start(ap,fmt)
#else
   /* for many older Unix platforms: use varargs */
   #include <varargs.h>
   extern int	vfprintf(FILE *, const char *, void *);
   #define VA_START(ap,fmt)   va_start(ap)
#endif


GLOBAL int Line = 1, Errors = 0, Warnings = 0;
GLOBAL int LineOffset = 0;

GLOBAL NoReturn Fail(const char *file, int line, const char *msg)
{
    fprintf(stderr, "Assertion failed in %s, line %d\n", file, line);
    fprintf(stderr, "\t%s\n", msg);

    if (strcmp(PhaseName, "Parsing")==0) {
	fprintf(stderr, "Input: %s, line %d\n", Filename, Line);
    }
#if 0
    exit(10);
#endif
    abort();
}


GLOBAL void SyntaxError(const char *fmt, ...)
{
    va_list ap;
    VA_START(ap, fmt);
    
    Errors++;
    fprintf(stderr, "%s:%d: ", Filename, Line);
    vfprintf(stderr, fmt, ap);
    fputc('\n', stderr);
    va_end(ap);
}

GLOBAL void Warning(int level, const char *fmt, ...)
{
    va_list ap;
    VA_START(ap, fmt);

    if (level > WarningLevel) return;
    Warnings++;
    fprintf(stderr, "%s:%d: Warning: ", Filename, Line);
    vfprintf(stderr, fmt, ap);
    fputc('\n', stderr);
    va_end(ap);
}


GLOBAL void SyntaxErrorCoord(Coord c, const char *fmt, ...)
{
    va_list ap;
    VA_START(ap, fmt);

    Errors++;
    PRINT_COORD(stderr, c);
    fprintf(stderr, ": ");
    vfprintf(stderr, fmt, ap);
    fputc('\n', stderr);
    va_end(ap);
}


GLOBAL void WarningCoord(int level, Coord c, const char *fmt, ...)
{
    va_list ap;
    VA_START(ap, fmt);

    if (level > WarningLevel) return;
    Warnings++;
    PRINT_COORD(stderr, c);
    fprintf(stderr, ": Warning: ");
    vfprintf(stderr, fmt, ap);
    fputc('\n', stderr);
    va_end(ap);
}

