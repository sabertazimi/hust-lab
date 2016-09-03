/*
 * lexer.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include "vm.h"
#include "lexer.h"

int keywords_init(void) {
    int i;
    src = "char else enum if int return sizeof while open read close printf malloc memset memcmp exit void main";

    // add keywords to symbol table
    i = Char;
    while (i <= While) {
        next();
        current_id[Token] = i++;
    }

    // add library to symbol table
    i = OPEN;
    while (i <= EXIT) {
        next();
        current_id[Scope] = Sys;
        current_id[Type] = INT;
        current_id[Value] = i++;
    }

    next();
    current_id[Token] = Char;       // handle void type
    next();
    idmain = current_id;            // keep track of main

}

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

                // scan through symbol table
                current_id = current_id + ID_SIZE;
            }

            // store new identifier
            current_id[Name] = (int)last_pos;
            current_id[Hash] = hash;
            token = current_id[Token]  = Id; // token type: identifier

            return 0;
        } else if (isdigit(token)) {
            // parse number: decimal, octal, hexidecimal
            token_val = token - '0';

            if (token_val > 0) {
                while (isdigit(*src)) {
                    token_val = token_val * 10 + (*src++ - '0');
                }
            } else {
                if (*src == 'x' || *src == 'X') {
                    token = *++src;
                    while (isxdigit(token)) {
                        token_val = token_val * 16 + ((token & 15) + (token >= 'A' ? 9 : 0));
                        token = *++src;
                    }
                } else {
                    while (*src >= '0' && *src <= '7') {
                        token_val = token_val * 8 + (*src++ - '0');
                    }
                }
            }

            token = Num;

            return 0;
        } else if (token == '"' || token == '\'') {
            // parse string
            last_pos = data;

            while (*src != 0 && *src != token) {
                token_val = *src++;

                if (token_val == '\\') {
                    token_val = *src++;

                    if (token_val == 'n') {
                        token_val = '\n';
                    }
                }

                if (token == '"') {
                    *data++ = token_val;
                }
            }

            src++;
            // if it is a single character, return Num token
            if (token == '"') {
                token_val = (int)last_pos;
            } else {
                token = Num;
            }

            return 0;
        } else if (token == '/') {
            if (*src == '/') {
                // skip comments
                while (*src != 0 && *src != '\n') {
                    ++src;
                }
            } else {
                // divide operator
                token = Div;
                return 0;
            }
        } else if (token == '=') {
            // parse '==' and '='
            if (*src == '=') {
                src ++;
                token = Eq;
            } else {
                token = Assign;
            }
            return 0;
        } else if (token == '+') {
            // parse '+' and '++'
            if (*src == '+') {
                src ++;
                token = Inc;
            } else {
                token = Add;
            }
            return 0;
        } else if (token == '-') {
            // parse '-' and '--'
            if (*src == '-') {
                src ++;
                token = Dec;
            } else {
                token = Sub;
            }
            return 0;
        } else if (token == '!') {
            // parse '!='
            if (*src == '=') {
                src++;
                token = Ne;
            }
            return 0;
        } else if (token == '<') {
            // parse '<=', '<<' or '<'
            if (*src == '=') {
                src ++;
                token = Le;
            } else if (*src == '<') {
                src ++;
                token = Shl;
            } else {
                token = Lt;
            }
            return 0;
        } else if (token == '>') {
            // parse '>=', '>>' or '>'
            if (*src == '=') {
                src ++;
                token = Ge;
            } else if (*src == '>') {
                src ++;
                token = Shr;
            } else {
                token = Gt;
            }
            return 0;
        } else if (token == '|') {
            // parse '|' or '||'
            if (*src == '|') {
                src ++;
                token = Lor;
            } else {
                token = Or;
            }
            return 0;
        } else if (token == '&') {
            // parse '&' and '&&'
            if (*src == '&') {
                src ++;
                token = Lan;
            } else {
                token = And;
            }
            return 0;
        } else if (token == '^') {
            token = Xor;
            return 0;
        } else if (token == '%') {
            token = Mod;
            return 0;
        } else if (token == '*') {
            token = Mul;
            return 0;
        } else if (token == '[') {
            token = Brak;
            return 0;
        } else if (token == '?') {
            token = Cond;
            return 0;
        } else if (token == '~' || token == ';' || token == '{' || token == '}' || token == '(' || token == ')' || token == ']' || token == ',' || token == ':') {
            // directly return the character as token;
            return 0;
        }

        /* end of parsing token */
    }

    return 0;
}

