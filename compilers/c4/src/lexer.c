/*
 * lexer.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include "lexer.h"

int next(void) {
    char *last_pos;
    int hash;

    while (token = *src) {
        ++src;

        /* start of parsing token */

        // skip white space
        if (token == '\n') {
            ++line;
        } else if (isalpha(token) || token == '_') {
            // parse identifier
            last_pos = src-1;
            hash = token;

            while (isalnum(*src) || *src == '_') {
                hash = hash * 147 + *src;
                src++;
            }

            // search symbol table
            current_id = symbols;
            while (current_id[Token]) {
                if (current_id[Hash] == hash && !memcmp((char *)current_id[Name], last_pos, src - last_pos)) {
                    token = current_id[Token];
                    return 0;
                }

                current_id = current_id + ID_SIZE;
            }
        }

        /* end of parsing token */
    }

    return 0;
}

