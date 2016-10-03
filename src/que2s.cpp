/*!
 * \file que2s.cpp
 * \brief implementation of que2s class
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#include <iostream>
#include "que2s.h"  // add include/ path to g++ flags

using namespace std;

QUE2S::QUE2S(int m): s1(m), s2(m) {
}

QUE2S::QUE2S(const QUE2S &q): s1(q.s1), s2(q.s2) {
}

int QUE2S::size(void) const {
    return s1.size();
}

QUE2S::operator int(void) const {
    return (int)s1 + (int)s2;
}

int QUE2S::operator[](int x) const {
    if (x < (int)s2) {
        return s2[int(s2)-x-1];
    } else {
        return s1[x-(int)s2];
    }
}

QUE2S& QUE2S::operator<<(int e) {
    // full check
    if (this->size() <= (int)(*this)) return *this;

    s1<<e;
    return *this;
}

QUE2S& QUE2S::operator>>(int &e) {
    if ((int)s2 <= 0) {
        int elem;

        // push all elements of s1 into s2
        while ((int)s1) {
            s1>>elem;
            s2<<elem;
        }
    }

    s2>>e;
    return *this;
}

QUE2S& QUE2S::operator=(const QUE2S &q) {
    this->s1 = q.s1;
    this->s2 = q.s2;
    return *this;
}

int QUE2S::operator==(const QUE2S &q) const {
    // size or pos should equal
    if (this->size() != q.size() || (int)(*this) != (int)q) return 0;

    // every single element should equal
    for (int i = 0; i < (int)(*this); i++) {
        if ((*this)[i] != q[i]) return 0;
    }

    return 1;
}

void QUE2S::print(void) const {
    for (int i = 0; i < (int)(*this); i++) {
        cout<<"\t"<<(*this)[i];
    }
    cout<<"\n";
}

QUE2S::~QUE2S(void) {
}
