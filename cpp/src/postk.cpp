/*!
 * \file postk.cpp
 * \brief implementation of postk struct
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#include <iostream>
#include <cstdlib>
#include "postk.h"  // add include/ path to g++ flags

using namespace std;

void initPOSTK(POSTK *const p, int m) {
    // empty check
    if (p == NULL) return;

    p->elems = (int *)malloc(sizeof(int) * (m > 0 ? m : 0));
    p->max   = m > 0 ? m : 0;
    p->pos   = 0;
}

void initPOSTK(POSTK *const p, const POSTK &s) {
    // empty check
    if (p == NULL) return;

    p->elems = (int *)malloc(sizeof(int) * (s.max > 0 ? s.max : 0));
    p->max   = s.max > 0 ? s.max : 0;
    p->pos   = 0;

    for (int i = 0; i < howMany(&s) && i < size(p); i++) {
        push(p, getelem(&s, i));
    }
}

int size(const POSTK *const p) {
    // empty check
    if (p == NULL) return 0;

    return p->max;
}

int howMany(const POSTK *const p) {
    // empty check
    if (p == NULL) return 0;

    return p->pos;
}

int getelem(const POSTK *const p, int x) {
    // empty/out of range check
    if (p == NULL || p->elems == NULL || howMany(p) <= 0 || howMany(p) <= x) return 0;

    return p->elems[x];
}

POSTK *const push(POSTK *const p, int e) {
    // empty pointer check, full stack check
    if (p == NULL || p->elems == NULL || howMany(p) >= size(p)) return p;

    p->elems[(p->pos)++] = e;

    return p;
}

POSTK *const pop(POSTK *const p, int &e) {
    // empty check
    if (p == NULL || p->elems == NULL || howMany(p) <= 0) {
        e = 0;
        return p;
    }

    e = p->elems[--(p->pos)];
    return p;
}

POSTK *const assign(POSTK *const p, const POSTK &s) {
    // empty check
    if (p == NULL) return NULL;

    if (p->elems != NULL) {
        free(p->elems);
        p->elems = NULL;
    }

    initPOSTK(p, s);

    return p;
}

void print(const POSTK *const p) {
    // empty check
    if (p == NULL || p->elems == NULL) return;

    for (int i = 0; i < howMany(p); i++) {
        cout<<"\t"<<getelem(p, i);
    }
    cout<<"\n";
}

void destroyPOSTK(POSTK *const p) {
    // empty check
    if (p == NULL) return;

    if (p->elems != NULL) {
        free(p->elems);
        p->elems = NULL;
    }

    p->max = 0;
    p->pos = 0;
    free(p);
}

