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
    int max;    ///< capacity temporary variable

    // empty check
    if (p == NULL) return;

    // minus capacity check
    if (m < 0) {
        max = 0;
    } else {
        max = m;
    }

    p->elems = (int *)malloc(sizeof(int) * max);
    p->max   = max;
    p->pos   = 0;
}

void initPOSTK(POSTK *const p, const POSTK &s) {
    // empty check
    if (p == NULL) return;

    p->max   = s.max;
    p->pos   = s.pos;
    p->elems = (int *)malloc(sizeof(int) * s.max);

    for (int i = 0; i < s.pos; i++) {
        p->elems[i] = getelem(&s, i);
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
    if (p == NULL || p->elems == NULL || p->pos <= 0 || x >= p->pos) return 0;

    return p->elems[x];
}

POSTK *const push(POSTK *const p, int e) {
    // empty pointer check, full stack check
    if (p == NULL || p->elems == NULL || p->pos >= p->max) return p;

    p->elems[(p->pos)++] = e;

    return p;
}

POSTK *const pop(POSTK *const p, int &e) {
    // empty check
    if (p == NULL || p->elems == NULL || p->pos <= 0) {
        e = 0;
        return p;
    }

    e = p->elems[--(p->pos)];
    return p;
}

POSTK *const assign(POSTK *const p, const POSTK &s) {
    // empty check
    if (p == NULL) return NULL;

    // free old elems
    if (p->elems) free(p->elems);

    // keep max old value
    p->pos   = 0;
    p->elems = (int *)malloc(sizeof(int) * s.max);

    for (int i = 0; i < s.pos && i < p->max; i++) {
        push(p,getelem(&s, i));
    }

    return p;
}

void print(const POSTK *const p) {
    // empty check
    if (p == NULL || p->elems == NULL) return;

    for (int i = 0; i < p->pos; i++) {
        cout<<"\t"<<p->elems[i];
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

    free(p);
}

