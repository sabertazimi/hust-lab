#include <assert.h>
#include <stdio.h>
#include "dfa.h"
#include "new.h"

Dfa_t Dfa_new () {
    return (Dfa_t)Nfa_new();
}

// lookup a node "num" in the dfa and return
// it; if that
// node does not exist, create a fresh one
// and return it.
Node_t Dfa_lookupOrInsert (Dfa_t dfa, int num) {
    return Nfa_lookupOrInsert((Nfa_t)dfa, num);
}

void Dfa_addEdge(Dfa_t dfa, int from, int to, int c) {
    Nfa_addEdge((Nfa_t)dfa, from, to, c);
}

void Dfa_print (Dfa_t dfa) {
    Nfa_print((Nfa_t)dfa);
}
