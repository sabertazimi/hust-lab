/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  symbol.h,v
 * Revision 1.7  1995/04/21  05:44:53  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.6  1995/01/31  23:28:53  rcm
 * Added functions to iterate over symbol table
 *
 * Revision 1.5  1995/01/11  17:18:46  rcm
 * Added InsertUniqueSymbol.
 *
 * Revision 1.4  1995/01/06  16:49:12  rcm
 * added copyright message
 *
 * Revision 1.3  1994/12/20  09:24:24  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.2  1994/10/28  18:53:16  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Fri Apr 30 11:27:40 EDT 1993
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
#pragma ident "symbol.h,v 1.7 1995/04/21 05:44:53 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#ifndef _SYMBOL_H_
#define _SYMBOL_H_


/* two kinds of symbol tables: nested scope or one large flat scope */
typedef enum { Nested, Flat } TableType;

GLOBAL extern short Level;  /* scope depth, initially zero */

typedef void (*ConflictProc)(Generic *orig, Generic *create);
typedef void (*ShadowProc)(Generic *create, Generic *shadowed);
typedef void (*ExitscopeProc)(Generic *dead);


/* create a create symbol table:
   `shadow' is called when one symbol shadows another,
      if `shadow' is NULL then no action is taken;
   `exitscope' is called when an entry becomes dead,
      if it is NULL then no action is taken */
GLOBAL SymbolTable *NewSymbolTable(const char *name, TableType kind,
				   ShadowProc, ExitscopeProc);

GLOBAL void ResetSymbolTable(SymbolTable *table);

GLOBAL void PrintSymbolTable(FILE *out, SymbolTable *table);

GLOBAL void EnterScope(void);
GLOBAL void ExitScope(void);

GLOBAL Bool LookupSymbol(SymbolTable *, const char *name, Generic **var);

GLOBAL Generic *InsertSymbol(SymbolTable *, const char *name, Generic *var,
			     ConflictProc);

GLOBAL void MoveToOuterScope(SymbolTable *, const char *name);

GLOBAL const char *InsertUniqueSymbol(SymbolTable *table, Generic *var, const char *root);


typedef struct {
  SymbolTable *table;
  int i;
  void *chain;
} SymbolTableMarker;

GLOBAL void IterateSymbolTable(SymbolTableMarker *, SymbolTable *);
GLOBAL Bool NextInSymbolTable(SymbolTableMarker *, const char **name, GenericREF itemref);

#endif  /* ifndef _SYMBOL_H_ */

