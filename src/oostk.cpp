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

    /// \brief stack instructor
    /// \param m stack capacity
    /// \return void
OOSTK::OOSTK(int m): elems(new int[m]), max(m) {

}

    /// \brief deep copy stack instructor
    /// \param s source stack reference
    /// \return void
OOSTK::OOSTK(const OOSTK &s): elems(s.elems), max(s.max) {

}

    /// \brief get capacity of stack
    /// \return capacity of stack
int OOSTK::size(void) const {
    return this->max;
}

    /// \brief get number of elements in stack
    /// \return number of elements in stack
int OOSTK::howMany(void) const {
    return this->pos;
}

    /// \brief get target element with index x
    /// \param x index of target element
    /// \return tartget element with index x
int OOSTK::getelem(int x) const {
    return this->elems[x];
}

    /// \brief push a new element into stack
    /// \param e new element to push
    /// \return stack reference of p
OOSTK &OOSTK::push(int e) {
    return *this;
}

    /// \brief pop a element from stack
    /// \param e hold value of element poped
    /// \return stack reference of p
OOSTK &OOSTK::pop(int &e) {
    return *this;
}

    /// \brief assign stack p with stack s
    /// \param s source stack reference
    /// \return stack reference of p
OOSTK &OOSTK::assign(const OOSTK &s) {
    return *this;
}

    /// \brief print all elements in stack
    /// \return void
void OOSTK::print(void) const {

}

    /// \brief destroy stack
    // \return void
OOSTK::~OOSTK(void) {

}

