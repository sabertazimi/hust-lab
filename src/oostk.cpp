/*!
 * \file oostk.cpp
 * \brief implementation of oostk class
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#include <iostream>
#include "oostk.h"  // add include/ path to g++ flags

using namespace std;

OOSTK::OOSTK(int m): elems(m > 0 ? new int[m] : new int[0]), max(m > 0 ? m : 0) {
    this->pos = 0;

    for (int i = 0; i < this->size(); i++) {
            this->elems[i] = 0;
    }
}

OOSTK::OOSTK(const OOSTK &s): elems(s.max > 0 ? new int[s.max] : new int[0]), max(s.max > 0 ? s.max : 0) {
    this->pos = 0;

    for (int i = 0; i < s.howMany() && i < this->size(); i++) {
        this->push(s.getelem(i));
    }
}

int OOSTK::size(void) const {
    return this->max;
}

int OOSTK::howMany(void) const {
    return this->pos;
}

int OOSTK::getelem(int x) const {
    // out of range check
    if (x < 0 || x >= this->howMany()) return 0;

    return this->elems[x];
}

OOSTK &OOSTK::push(int e) {
    // full check
    if (this->howMany() >= this->size()) return *this;

    this->elems[this->pos++] = e;
    return *this;
}

OOSTK &OOSTK::pop(int &e) {
    // empty check
    if (this->howMany() <= 0) {
        e = 0;
        return *this;
    }

    e = this->elems[--this->pos];
    return *this;
}

OOSTK &OOSTK::assign(const OOSTK &s) {
    this->~OOSTK();
    new (this) OOSTK(s);
    return *this;
}

int OOSTK::operator==(const OOSTK &s) const {
    // size or number of elements should equal
    if (this->size() != s.size() || this->howMany() != s.howMany()) return 0;

    // every single element should equal
    for (int i = 0; i < this->howMany(); i++) {
        if (this->getelem(i) != s.getelem(i)) return 0;
    }

    return 1;
}

void OOSTK::print(void) const {
    for (int i = 0; i < this->howMany(); i++) {
        cout<<"\t"<<this->getelem(i);
    }
    cout<<"\n";
}

OOSTK::~OOSTK(void) {
    // destruction flag avoiding destruct repeatly
    delete this->elems;
    this->pos = 0;
}

