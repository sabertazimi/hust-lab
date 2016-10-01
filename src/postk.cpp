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

/// \brief initiate stack
/// \param p stack pointer
/// \param m stack capacity
/// \return void
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

/// \brief initiate stack (with copy)
/// \param p destination stack pointer
/// \param s source stack pointer
/// \return void
void initPOSTK(POSTK *const p, const POSTK &s) {
    // empty check
    if (p == NULL) return;

    p->elems = s.elems;
    p->max   = s.max;
    p->pos   = s.pos;
}

/// \brief get capacity of stack
/// \param p stack pointer
/// \return capacity of stack
int size(const POSTK *const p) {
    // empty check
    if (p == NULL) return 0;

    return p->max;
}

/// \brief get number of elements in stack
/// \param p stack pointer
/// \return number of elements in stack
int howMany(const POSTK *const p) {
    // empty check
    if (p == NULL) return 0;

    return p->pos;
}

/// \brief get target element with index x
/// \param p stack pointer
/// \param x index of target element
/// \return tartget element with index x
int getelem(const POSTK *const p, int x) {
    // empty/out of range check
    if (p == NULL || p->elems == NULL || p->pos <= 0 || x >= p->pos) return 0;

    return p->elems[x];
}

/// \brief push a new element into stack
/// \param p stack pointer
/// \param e new element to push
/// \return stack pointer point to p
POSTK *const push(POSTK *const p, int e) {
    // empty pointer check, full stack check
    if (p == NULL || p->elems == NULL || p->pos >= p->max) return p;

    p->elems[(p->pos)++] = e;

    return p;
}

/// \brief pop a element from stack
/// \param p stack pointer
/// \param e hold value of element poped
/// \return stack pointer point to p
POSTK *const pop(POSTK *const p, int &e) {
    // empty check
    if (p == NULL || p->elems == NULL || p->pos <= 0) {
        e = 0;
        return p;
    }

    e = p->elems[--(p->pos)];
    return p;
}

/// \brief assign stack p with stack s
/// \param p destination stack pointer
/// \param s source stack pointer
/// \return stack pointer point to p
POSTK *const assign(POSTK *const p, const POSTK &s) {
    // empty check
    if (p == NULL) return NULL;

    p->elems = s.elems;
    p->max   = s.max;
    p->pos   = s.pos;

    return p;
}

/// \brief print all elements in stack
/// \param p stack pointer
/// \return void
void print(const POSTK *const p) {
    // empty check
    if (p == NULL || p->elems == NULL) return;

    for (int i = 0; i < p->pos; i++) {
        cout<<"\t"<<p->elems[i];
    }
    cout<<"\n";
}

/// \brief destroy stack
/// \param p stack pointer
/// \return void
void destroyPOSTK(POSTK *const p) {
    // empty check
    if (p == NULL) return;

    if (p->elems != NULL) {
        free(p->elems);
        p->elems = NULL;
    }

    free(p);
}

