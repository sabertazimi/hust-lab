/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  basics.h,v
 * Revision 1.15  1995/05/05  19:18:23  randall
 * Added #include reconstruction.
 *
 * Revision 1.14  1995/04/21  05:44:06  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.13  1995/04/09  21:30:41  rcm
 * Added Analysis phase to perform all analysis at one place in pipeline.
 * Also added checking for functions without return values and unreachable
 * code.  Added tests of live-variable analysis.
 *
 * Revision 1.12  1995/03/23  15:30:55  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.11  1995/02/13  02:00:02  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.10  1995/02/01  07:34:11  rcm
 * Added TransformFlag and TransformContext to transform.c
 *
 * Revision 1.9  1995/01/20  03:38:00  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.8  1995/01/06  16:48:36  rcm
 * added copyright message
 *
 * Revision 1.7  1994/12/23  09:18:19  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.6  1994/12/20  09:23:52  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.5  1994/11/22  01:54:25  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.4  1994/11/10  03:13:09  rcm
 * Fixed line numbers on AST nodes.
 *
 * Revision 1.3  1994/11/03  07:38:39  rcm
 * Added code to output C from the parse tree.
 *
 * Revision 1.2  1994/10/28  18:52:08  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Fri Apr 23 10:50:52 EDT 1993
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
#pragma ident "basics.h,v 1.15 1995/05/05 19:18:23 randall Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#ifndef _BASICS_H_
#define _BASICS_H_


#ifndef __GNUC__
#define inline
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "config.h"

#ifdef NO_PROTOTYPES
extern int      fprintf();
extern int      fputc();
extern int      fputs();
extern FILE     *fopen();
extern int      fclose();
extern int      printf();
extern int	sscanf();
extern int      _flsbuf();
extern void     bcopy();
extern int      toupper();
extern char *   memcpy();
extern int      fflush();
#endif


#define GLOBAL
#define PRIVATE static



/* NoReturn indicates that the function never returns (like "exit") */
#ifdef __GNUC__
#define NoReturn void
#else
#define NoReturn void
#endif

/* for generic prototypes (use Generic *) */
typedef void Generic;
typedef void **GenericREF;  /* address of a Generic, for pass by reference */

typedef int Bool;
#define TRUE 1
#define FALSE 0


/* assertion checking */
#undef assert
#ifdef NDEBUG
 #define assert(x) ((void) 0)
#else
 #define assert(x)  ((x) ? (void)0 : (void)Fail(__FILE__, __LINE__, #x))
#endif

#define FAIL(str) \
  Fail(__FILE__, __LINE__, str)
#define UNREACHABLE FAIL("UNREACHABLE")



#define PLURAL(i) (((i) == 1) ? "" : "s")
#define TABSTRING "    "





#define MAX_FILES       256
#define MAX_FILENAME    200
#define MAX_SCOPE_DEPTH 100
#define MAX_OPERATORS   600




/* Basic Typedefs */

typedef struct nodeStruct Node;
typedef struct tablestruct SymbolTable;
typedef int OpType;


typedef struct coord {
    int line;
    short offset;
    short file;
    Bool includedp;
} Coord;

GLOBAL Coord UnknownCoord;
#define IsUnknownCoord(coord)  ((coord).file == UnknownCoord.file)



#define PRINT_COORD(out, c) \
    { if (PrintLineOffset) \
      fprintf(out,"%s:%d:%d", FileNames[(c).file], (int)(c).line, \
              (int)(c).offset); \
    else fprintf(out, "%s:%d", FileNames[(c).file], (int) (c).line); }


#define REFERENCE(var)  ((var)->u.decl.references++)
#define VAR_NAME(var)   ((var)->u.decl.name)



/* Prototypes/definitions from other files */

#include "heap.h"
#include "list.h"
#include "symbol.h"




/* Basic Global Variables */

GLOBAL extern const float VersionNumber;     /* main.c */
GLOBAL extern const char *const VersionDate; /* main.c */
GLOBAL extern const char * Executable;       /* program name, main.c */
GLOBAL extern List *Program;                 /* main.c */
GLOBAL extern int WarningLevel;              /* main.c */
GLOBAL extern int Line, LineOffset, Errors, Warnings;    /* warning.c */
GLOBAL extern unsigned int CurrentFile;      /* c4.l: current file number */
GLOBAL extern char *Filename;                /* c4.l */
GLOBAL extern char *FileNames[MAX_FILES];    /* c4.l: file # to name mapping*/
GLOBAL extern const char *PhaseName;         /* main.c */
GLOBAL extern Bool FileIncludedp[MAX_FILES]; /* c4.l */
GLOBAL extern Bool CurrentIncludedp;         /* c4.l */

/* ANSI defines the following name spaces (K&R A11.1, pg 227): */
GLOBAL extern SymbolTable *Identifiers, *Labels, *Tags;

/* This table is used to ensure consistency across the translation unit */
GLOBAL extern SymbolTable *Externals;

/* Global Flags */
GLOBAL extern Bool DebugLex;                 /* main.c */
GLOBAL extern Bool PrintLineOffset;          /* main.c */
GLOBAL extern Bool IgnoreLineDirectives;     /* main.c */
GLOBAL extern Bool ANSIOnly;                 /* main.c */
GLOBAL extern Bool FormatReadably;           /* main.c */
GLOBAL extern Bool PrintLiveVars;            /* main.c */

/* Basic Global Procedures */

/* pretty-printing */
GLOBAL void DPN(Node *n);
GLOBAL void DPL(List *list);
GLOBAL void PrintNode(FILE *out, Node *node, int tab_depth);
GLOBAL int PrintConstant(FILE *out, Node *c, Bool with_name);
GLOBAL void PrintCRSpaces(FILE *out, int spaces);
GLOBAL void PrintSpaces(FILE *out, int spaces);
GLOBAL void PrintList(FILE *out, List *list, int tab_depth);
GLOBAL int PrintOp(FILE *out, OpType op);  /* operators.c */
GLOBAL void CharToText(char *array, unsigned char value);
GLOBAL inline int PrintChar(FILE *out, int c);    /* print.c */
GLOBAL int PrintString(FILE *out, const char *string); /* print.c */

/* warning.c */
GLOBAL NoReturn Fail(const char *file, int line, const char *msg);
GLOBAL void SyntaxError(const char *fmt, ...);
GLOBAL void Warning(int level, const char *fmt, ...);
GLOBAL void SyntaxErrorCoord(Coord c, const char *fmt, ...);
GLOBAL void WarningCoord(int level, Coord c, const char *fmt, ...);

/* parsing phase */
GLOBAL int yyparse(void);
GLOBAL int yylex(void); 

GLOBAL char *UniqueString(const char *string);   /* strings.c */
GLOBAL void SetFile(const char *filename, int line);       /* c4.l */

/* verification */
GLOBAL void VerifyParse(List *program);          /* verify-parse.c */

/* semantic check -- sem-check.c */
GLOBAL List *SemanticCheckProgram(List *program);
GLOBAL Node *SemCheckNode(Node *node);
GLOBAL List *SemCheckList(List *list);

/* transform phase -- transform.c */
GLOBAL List *TransformProgram(List *program);

/* output phase -- output.c */
GLOBAL void OutputProgram(FILE *out, List *program);


#endif  /* ifndef _BASICS_H_ */


