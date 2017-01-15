/*!
 * \file stack.cpp
 * \brief implementation of stack class
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#include <iostream>
#include "stack.h"  // add include/ path to g++ flags

using namespace std;

STACK::STACK(int m): elems(m > 0 ? new int[m] : new int[0]), max(m > 0 ? m : 0) {
    this->pos = 0;

    for (int i = 0; i < this->size(); i++) {
        this->elems[i] = 0;
    }
}

STACK::STACK(const STACK &s): elems(s.max > 0 ? new int[s.max] : new int[0]), max(s.max > 0 ? s.max : 0) {
    this->pos = 0;

    for (int i = 0; i < (int)s && i < this->size(); i++) {
        (*this)<<s[i];
    }
}

int STACK::size(void) const {
    return this->max;
}

STACK::operator int(void) const {
    return (int)(this->pos);
}

int STACK::operator[](int x) const {
    // out of range check
    if (x < 0 || x >= (int)(*this)) return 0;

    return this->elems[x];
}

STACK& STACK::operator<<(int e) {
    // full check
    if (this->size() <= (int)(*this)) return *this;

    this->elems[this->pos++] = e;
    return *this;
}

STACK& STACK::operator>>(int &e) {
    // empty check
    if ((int)(*this) <= 0) {
        e = 0;
        return *this;
    }

    e = this->elems[--this->pos];
    return *this;
}

STACK& STACK::operator=(const STACK &s) {
    this->~STACK();
    new (this) STACK(s);
    return *this;
}

int STACK::operator==(const STACK &s) const {
    // size or pos should equal
    if (this->size() != s.size() || (int)(*this) != (int)s) return 0;

    // every single element should equal
    for (int i = 0; i < (int)(*this); i++) {
        if ((*this)[i] != s[i]) return 0;
    }

    return 1;
}

void STACK::print(void) const {
    for (int i = 0; i < (int)(*this); i++) {
        cout<<"\t"<<(*this)[i];
    }
    cout<<"\n";
}

STACK::~STACK(void) {
    delete this->elems;
    this->pos = 0;
}

