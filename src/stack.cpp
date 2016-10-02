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

    /// \brief stack instructor
    /// \param m stack capacity
    /// \return void
STACK::STACK(int m): elems(m > 0 ? new int[m] : new int[0]), max(m > 0 ? m : 0) {
    this->pos = 0;
}

    /// \brief deep copy stack instructor
    /// \param s source stack reference
    /// \return void
STACK::STACK(const STACK &s): elems(s.elems), max(s.max) {
    this->pos = 0;
}

    /// \brief get capacity of stack
    /// \return capacity of stack
int STACK::size(void) const {
    return this->max;
}

    /// \brief [type casting] get number of elements in stack
    /// \return number of elements in stack
STACK::operator int(void) const {
    return (int)(this->pos);
}

    /// \brief [operator overload] get target element with index x
    /// \param x index of target element
    /// \return tartget element with index x
int STACK::operator[](int x) const {
    // out of range check
    if (x < 0 || x >= (int)(*this)) return 0;

    return this->elems[x];
}

    /// \brief [operator overload] push a new element into stack
    /// \param e new element to push
    /// \return stack reference of p
STACK& STACK::operator<<(int e) {
    // full check
    if (this->size() <= (int)(*this)) return *this;

    this->elems[this->pos++] = e;
    return *this;
}

    /// \brief [operator overload] pop a element from stack
    /// \param e hold value of element poped
    /// \return stack reference of p
STACK& STACK::operator>>(int &e) {
    // empty check
    if ((int)(*this) <= 0) {
        e = 0;
        return *this;
    }

    e = this->elems[--this->pos];
    return *this;
}

    /// \brief [operator overload] assign stack p with stack s
    /// \param s source stack reference
    /// \return stack reference of p
STACK& STACK::operator=(const STACK &s) {
    this->pos = 0;

    for (int i = 0; i < (int)s && i < this->size(); i++) {
        (*this)<<(s[i]);
    }

    return *this;
}

    /// \brief [operator overload] equal function
    /// \param s source stack reference
    /// \return ture or false
int STACK::operator==(const STACK &s) const {
    // size or pos should equal
    if (this->size() != s.size() || (int)(*this) != (int)s) return 0;

    // every single element should equal
    for (int i = 0; i < (int)(*this); i++) {
        if ((*this)[i] != s[i]) return 0;
    }

    return 1;
}

    /// \brief print all elements in stack
    /// \return void
void STACK::print(void) const {
    for (int i = 0; i < (int)(*this); i++) {
        cout<<"\t"<<(*this)[i];
    }
    cout<<"\n";
}

    /// \brief destroy stack
    /// \return void
STACK::~STACK(void) {
    delete this->elems;
    this->pos = 0;
        }
