/*!
 * \file queis.cpp
 * \brief implementation of queis class
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#include <iostream>
#include "queis.h"  // add include/ path to g++ flags

using namespace std;

QUEIS::QUEIS(int m): STACK(m), s(m) {
}

QUEIS::QUEIS(const QUEIS &q): STACK(q), s(q.s) {
}

int QUEIS::size(void) const {
    return STACK::size();
}

QUEIS::operator int(void) const {
    return STACK::operator int() + (int)s;
}

int QUEIS::operator[](int x) const {
    if (x < (int)s) {
        return s[int(s)-x-1];
    } else {
        return STACK::operator[](x-(int)s);
    }
}

QUEIS& QUEIS::operator<<(int e) {
    // full check
    if (this->size() <= (int)(*this)) return *this;

    STACK::operator<<(e);
    return *this;
}

QUEIS& QUEIS::operator>>(int &e) {
    if ((int)s <= 0) {
        int elem;

        // push all elements of super stack into s
        while (STACK::operator int()) {
            STACK::operator>>(elem);
            s<<elem;
        }
    }

    s>>e;
    return *this;
}

QUEIS& QUEIS::operator=(const QUEIS &q) {
    STACK::operator=(q);
    this->s = q.s;

    return *this;
}

int QUEIS::operator==(const QUEIS &q) const {
    return STACK::operator==(q);
}

void QUEIS::print(void) const {
    STACK::print();
}

QUEIS::~QUEIS(void) {
}

