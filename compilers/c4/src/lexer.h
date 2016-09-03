/*
 * lexer.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef LEXER_H
#define LEXER_H

#include "c4lib.h"

// token type
enum {
    Num = 128,
    Fun,
    Sys,
    Glo,
    Loc,
    Id,
    Char,
    Else,
    Enum,
    If,
    Int,
    eturn,
    Sizeof,
    While,
    Assign,
    Cond,
    Lor,
    Lan,
    Or,
    Xor,
    And,
    Eq,
    Ne,
    Lt,
    Gt,
    Le,
    Ge,
    Shl,
    Shr,
    Add,
    Sub,
    Mul,
    Div,
    Mod,
    Inc,
    Dec,
    Brak
};

char *src,
     *old_src;
int line;

int token,      // current token
    token_val,  // value of current token
    *current_id;// ID of current token

/* defination of symbol
 *
 * struct id_t {
 *   int token;
 *   int hash;
 *   char *name;
 *   int scope;
 *   int type;
 *   int value;
 *   int global_scope;
 *   int global_type;
 *   int global_value;
 * }
 *
 */

int *symbols;

// fields of identifier (index): symbols[index]
enum {
    Token,
    Hash,
    Name,
    Scope,
    Type,
    Value,
    Global_Scope,
    Global_Type,
    Global_Value,
    ID_Size         // total count of fields for a single identifier
};

// keywords type
enum {
    CHAR,
    INT,
    PTR
};

int *idmain

int keywords_init(void);
int next(void);

#endif /* !LEXER_H */
