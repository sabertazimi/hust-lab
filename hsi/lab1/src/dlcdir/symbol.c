/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  symbol.c,v
 * Revision 1.7  1995/04/21  05:44:51  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.6  1995/01/31  23:28:50  rcm
 * Added functions to iterate over symbol table
 *
 * Revision 1.5  1995/01/11  17:18:44  rcm
 * Added InsertUniqueSymbol.
 *
 * Revision 1.4  1995/01/06  16:49:11  rcm
 * added copyright message
 *
 * Revision 1.3  1994/12/20  09:24:23  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.2  1994/10/28  18:53:13  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Fri Apr 30 11:27:44 EDT 1993
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
#pragma ident "symbol.c,v 1.7 1995/04/21 05:44:51 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "basics.h"

/* TABLE_SIZE must be a power of two */
#define TABLE_SIZE 16
#define TABLE_MASK (TABLE_SIZE - 1)

typedef struct {
    short level;
    short version;
} Scope;

typedef struct symbolstruct Symbol;
struct symbolstruct {
    const char *name;
    Generic *var;
    Scope scope;
    Symbol *next;
    Symbol *shadow;
    Symbol *scope_next;
};

struct tablestruct {
    Symbol *table[TABLE_SIZE];
    const char *table_name;
    TableType kind;
    Symbol *scopes[MAX_SCOPE_DEPTH];
    ShadowProc shadow;
    ExitscopeProc exitscope;
    struct tablestruct *next_table;
};

GLOBAL short Level = 0;
GLOBAL Bool TrackScopeExits = TRUE;
extern Bool TrackInsertSymbol; /* main.c */

PRIVATE short current_version[MAX_SCOPE_DEPTH];
PRIVATE SymbolTable *table_list = NULL;


/***********************************************************************\
* Symbol Table Hash Function
\***********************************************************************/

PRIVATE inline unsigned hash(const char *name)
{
    return(((unsigned long)(name) >> 2) & TABLE_MASK);
}


/***********************************************************************\
* Symbol memory management
\***********************************************************************/

PRIVATE Symbol *free_list = NULL;

PRIVATE Symbol *new_symbol()
{
    static const int blocks = 4096/(sizeof(Symbol));
    Symbol *sym;
    
    sym = free_list;
    if (sym == NULL) {
	int i;

	free_list = HeapNewArray(Symbol, blocks);
	sym = free_list;
	for (i=0; i<blocks-1; i++) {
	    sym->next = &free_list[i];
	    sym = sym->next;
	}
	sym->next = NULL;
	sym = free_list;
    }
    free_list = free_list->next;
    return(sym);
}

PRIVATE void free_symbol(Symbol *sym)
{
    assert(sym != NULL);
    /* fprintf(stderr, "FREE %s (%d,%d)\n", sym->name, sym->scope.level,
	    sym->scope.version); */
    sym->next = free_list;
    free_list = sym;
}



/***********************************************************************\
* NewSymbolTable
\***********************************************************************/

GLOBAL SymbolTable *NewSymbolTable(const char *name, TableType kind,
				   ShadowProc shadow,
				   ExitscopeProc exitscope)
{
    SymbolTable *create;

    create = HeapNew(SymbolTable);
    create->table_name = name;
    create->kind = kind;
    create->shadow = shadow;
    create->exitscope = exitscope;

    /* this table to the list of tables */
    create->next_table = table_list;
    table_list = create;

    return(create);
}

/***********************************************************************\
* ResetSymbolTable
\***********************************************************************/

GLOBAL void ResetSymbolTable(SymbolTable *table)
{
    int i;
    Symbol *chain, *next;

    for (i=0; i<TABLE_SIZE; i++) {
	for (chain = table->table[i]; chain != NULL; chain = next) {
	    if (table->exitscope != NULL)
	      (*table->exitscope)(chain->var);
	    next = chain->next;
	    free_symbol(chain);
	}
	table->table[i] = NULL;
    }
}


/***********************************************************************\
* Enter/Exit nested scope
\***********************************************************************/

GLOBAL void EnterScope()
{
    Level++;
    if (Level == MAX_SCOPE_DEPTH) {
	fprintf(stderr, "Internal Error: out of nesting levels!\n");
	abort();
    }
    current_version[Level]++;
}


GLOBAL void ExitScope()
{
    if (Level == 0) {
	SyntaxError("missing '{' detected");
    } else {
	/* notify dead Generics */
	SymbolTable *table;
	for (table = table_list; table != NULL; table = table->next_table) {
	    if (table->exitscope != NULL) {
		Symbol *var;
		for (var = table->scopes[Level];
		     var != NULL; var = var->scope_next)
		  (*table->exitscope)(var->var);
		table->scopes[Level] = NULL; /* reset Generic list */
	    }
	}
	Level--;
    }
    /* PrintSymbolTable(stderr, Identifiers); */
}


PRIVATE inline Bool stale(Scope scope)
{
    return((scope.level > Level) ||
	   (current_version[scope.level] > scope.version));
}



/***********************************************************************\
* Symbol creation
\***********************************************************************/

PRIVATE Symbol *make_symbol(const char *name, Generic *var,
			    short level, short version)
{
    Symbol *sym = new_symbol();
    sym->name = name;
    sym->var = var;
    sym->scope.level = level;
    sym->scope.version = version;
    sym->shadow = sym->next = NULL;
    return(sym);
}


/***********************************************************************\
* InsertSymbol
\***********************************************************************/

/* returns the final version of the inserted Generic.  It differs from
   the input `var' only when there is a redeclaration, in which case
   the value is determined by the `conflict' procedure.

   The `conflict' procedure is called when the create Generic conflicts
   with an existing (current scope) symbol.  It is expected to modify
   the `orig' Generic to represent the merger of the two versions.
   For example, it may just declares a syntax error and leave the original
   alone. */

GLOBAL Generic *InsertSymbol(SymbolTable *table, const char *name,
			     Generic *var,
			     ConflictProc conflict)
{
    unsigned int bucket;
    Symbol *chain, *sym;
    Symbol **handle;
    short level;

    if (TrackInsertSymbol)
      fprintf(stderr, "InsertSymbol(%s, %s) %s scope=(%d,%d)\n",
	      table->table_name, name,
	      table->kind == Nested ? "Nested" : "Flat",
	      Level, current_version[Level]);

    if (table->kind == Nested) {
	sym = make_symbol(name, var, Level, current_version[Level]);
	level = Level;
    } else {
	/* all symbols in a flat table have scope (0,0) and thus
	   can never be stale */
	sym = make_symbol(name, var, 0, 0);
	level = 0;
    }

    if (table->exitscope != NULL) {
	/* add to list of Generics at this level */
	sym->scope_next = table->scopes[level];
	table->scopes[level] = sym;
    }

    bucket = hash(name);
    chain = table->table[bucket];
    handle = &(table->table[bucket]);  /* *handle == chain */

    while (chain != NULL) {
	if (chain->name == name) {
	    Symbol *next = chain->next;
	    while (chain != NULL  &&  stale(chain->scope)) {
		Symbol *tmp = chain->shadow;
		free_symbol(chain);
		chain = tmp;
	    }
	    if (chain == NULL) {
		*handle = sym;
		sym->next = next;
		assert(sym->shadow == NULL);
		return(var);
	    } else {
		assert(!stale(chain->scope));
		if (chain->scope.level == level) {
		    /* patch table in case we removed stale symbols */
		    *handle = chain;
		    chain->next = next;
		    /* resolve conflict */
		    if (conflict == NULL) {
		      FAIL("InsertSymbol(%s) conflicts -- NULL conflict function\n" /* FIX to include name of function */);
		    }
		    (*conflict)(chain->var, var);
		    return(chain->var); /* return resolved Generic */
		} else {
		    assert(chain->scope.level < level);
		    *handle = sym;
		    sym->shadow = chain;
		    sym->next = next;
		    if (table->shadow)
		      (*table->shadow)(sym->var, chain->var);
		    return(var);
		}
	    }
	    /* unreachable */
	}
	handle = &(chain->next);
	chain = chain->next; /* == *handle */
    }
	
    /* insert at front */
    sym->next = table->table[bucket];
    assert(sym->shadow == NULL);
    table->table[bucket] = sym;
    return(var);
}



/***********************************************************************\
* MoveToOuterScope
\***********************************************************************/

GLOBAL void MoveToOuterScope(SymbolTable *table, const char *name)
{
    unsigned int bucket;
    Symbol *chain;

    if (TrackInsertSymbol)
      fprintf(stderr, "Moving to outer scope %s\n", name);

    assert(Level > 0);
    bucket = hash(name);
    chain = table->table[bucket];

    while (chain != NULL) {
	if (chain->name == name) {
	    assert(chain->scope.level == Level);
	    assert(chain->scope.version == current_version[Level]);
	    chain->scope.level--;
	    chain->scope.version = current_version[Level-1];
	    return;
	}
	chain = chain->next;
    }
    /* the symbol was not found! */
    assert(FALSE);
}



/***********************************************************************\
* LookupSymbol
\***********************************************************************/

/* returns TRUE if symbol found, *var set to the found var
   (*var valid only if return value is TRUE */
GLOBAL Bool LookupSymbol(SymbolTable *table,
			 const char *name,
			 GenericREF var)
{
    unsigned int bucket;
    Symbol *chain;
    Symbol **handle;

    bucket = hash(name);
    handle = &(table->table[bucket]);
    chain = *handle; /* loop invariant */

    while (chain != NULL) {
	if (chain->name == name) {
	    Symbol *next = chain->next;
	    while (chain != NULL  &&  stale(chain->scope)) {
		Symbol *tmp = chain->shadow;
		free_symbol(chain);
		chain = tmp;
	    }
	    if (chain == NULL) {
		*handle = next;
		return(FALSE);
	    } else {
		assert(!stale(chain->scope));
		*handle = chain;
		chain->next = next;
		*var = chain->var;
		return(TRUE);
	    }
	    /* unreachable */
	}
	handle = &(chain->next);
	chain = chain->next; /* == *handle */
	
    }
    return(FALSE);
}


/***********************************************************************\
* PrintSymbolTable
\***********************************************************************/

GLOBAL void PrintSymbolTable(FILE *out, SymbolTable *table)
{
    Symbol *chain, *shadow;
    int i, entries=0, length, worst = 0, depth=0;

    assert(table != NULL);
    fprintf(out, "\nSymbolTable: %s\n", table->table_name);

    for (i=0; i<TABLE_SIZE; i++) {
	length = 0;
	for (chain = table->table[i]; chain != NULL; chain = chain->next) {
	    length++;
	    fprintf(out, "\t%s:", chain->name);
	    for (shadow = chain; shadow != NULL; shadow = shadow->shadow) {
		fprintf(out, " (%d,%d)",
			(int) shadow->scope.level,
			(int) shadow->scope.version);
	    }
	    fputc('\n', out);
	}
	entries += length;
	depth += (length + 1)*length/2;  /* sum of 1 to length */
	if (length > worst) worst = length;
    }
    fprintf(out, "End of symbol table %s\n", table->table_name);
    fprintf(out, "\t%d entries\n", entries);
    fprintf(out, "\tAverage depth for a successful search: %.2g\n",
	    depth/(entries+1e-6));
    fprintf(out, "\tAverage depth for a failed search: %.2g\n",
	    entries/(float)TABLE_SIZE);
    fprintf(out, "\tLongest chain: %d\n", worst);
}


/***********************************************************************\
* InsertUniqueSymbol
\***********************************************************************/

/* Creates unique valid C identifier for Generic and inserts
   it into symbol table.  At most 16 characters from root are used for
   prefix of identifier.  Returns identifier chosen. */

GLOBAL const char *InsertUniqueSymbol(SymbolTable *table, Generic *var, const char *root)
{
  char buf[33];
  const char *name;
  static unsigned counter = 0;
  Generic *existing;

  do {
    sprintf(buf, "%.16s%d", root, ++counter);
    name = UniqueString(buf);
  }
  while (LookupSymbol(table, name, &existing));

  InsertSymbol(table, name, var, NULL);  /* NULL conflict procedure should
					    never be called */
  return name;
}

/***********************************************************************\
* Iteration over symbol table
\***********************************************************************/

GLOBAL void IterateSymbolTable(SymbolTableMarker *marker, SymbolTable *table)
{
  marker->table = table;
  marker->i = -1;
  marker->chain = NULL;
}


GLOBAL Bool NextInSymbolTable(SymbolTableMarker *marker, const char **name, 
                            GenericREF var)
{
#define CHAIN ((Symbol *)marker->chain)

  if (marker->i == TABLE_SIZE)
    return FALSE;
  if (marker->chain != NULL)
    marker->chain = CHAIN->next;
  while (marker->chain == NULL)
    if (++marker->i == TABLE_SIZE)
      return FALSE;
    else marker->chain = marker->table->table[marker->i];

  *name = CHAIN->name;
  *var = CHAIN->var;
  return TRUE;
}

