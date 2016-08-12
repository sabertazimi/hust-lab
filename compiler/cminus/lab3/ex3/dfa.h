/*
 * dfa.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 *
 * Report BUGs to <sabertazimI@gmail.com>
 */

#ifndef DFA_H
#define DFA_H

#include "nfa.h"

typedef Nfa_t *Dfa_t;

Dfa_t Dfa_new ();
Node_t Dfa_lookupOrInsert (Dfa_t dfa, int num);
void Dfa_addEdge(Dfa_t dfa, int from, int to, int c);
void Dfa_print (Dfa_t dfa);

#endif /* !DFA_H */
