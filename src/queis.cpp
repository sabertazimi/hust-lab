/*!
 * \file queis.cpp
 * \brief implementation of queis class
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#include "queis.h"  // add include/ path to g++ flags

QUEIS::QUEIS(int m): STACK(m), s(m) {
}

QUEIS::QUEIS(const QUEIS &q): STACK(q), s(q.s) {
}

    /// \brief get capacity of queue
    /// \return capacity of queue
int QUEIS::size(void) const {
    return STACK::size();
}

    /// \brief [type casting] get number of elements in queue
    /// \return number of elements in queue
QUEIS::operator int(void) const {
    return 0;
}

    /// \brief [operator overload] get target element with index x
    /// \param x index of target element
    /// \return tartget element with index x
int QUEIS::operator[](int x) const {
    return 0;
}

    /// \brief [operator overload] enqueue method
    /// \param e new element to enqueue
    /// \return queue reference of p
QUEIS& QUEIS::operator<<(int e) {
    return *this;
}

    /// \brief [operator overload] dequeue method
    /// \param e hold value of element dequeued
    /// \return queue reference of p
QUEIS& QUEIS::operator>>(int &e) {
    return *this;
}

    /// \brief [operator overload] assign queue p with queue q
    /// \param q source queue reference
    /// \return queue reference of p
QUEIS& QUEIS::operator=(const QUEIS &q) {
    return *this;
}

    /// \brief [operator overload] equal function
    /// \param q source queue reference
    /// \return ture or false
int QUEIS::operator==(const QUEIS &q) const {
    return 1;
}

    /// \brief print all elements in queue
    /// \return void
void QUEIS::print(void) const {

}

    /// \brief destroy queue
    /// \return void
QUEIS::~QUEIS(void) {

}

