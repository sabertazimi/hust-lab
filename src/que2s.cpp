/*!
 * \file que2s.cpp
 * \brief implementation of que2s class
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#include "que2s.h"  // add include/ path to g++ flags

QUE2S::QUE2S(int m): s1(m), s2(m) {
}

QUE2S::QUE2S(const QUE2S &q): s1(q.s1), s2(q.s2) {
}

    /// \brief get capacity of queue
    /// \return capacity of queue
int QUE2S::size(void) const {
    return s1.size();
}

    /// \brief [type casting] get number of elements in queue
    /// \return number of elements in queue
QUE2S::operator int(void) const {
    return (int)s1 + (int)s2;
}

    /// \brief [operator overload] get target element with index x
    /// \param x index of target element
    /// \return tartget element with index x
int QUE2S::operator[](int x) const {
    if (x < (int)s2) {
        return s2[int(s2)-x-1];
    } else {
        return s1[x-(int)s2];
    }
}

    /// \brief [operator overload] enqueue method
    /// \param e new element to enqueue
    /// \return queue reference of p
QUE2S& QUE2S::operator<<(int e) {
    s1<<e;
    return *this;
}

    /// \brief [operator overload] dequeue method
    /// \param e hold value of element dequeued
    /// \return queue reference of p
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

    /// \brief [operator overload] assign queue p with queue q
    /// \param q source queue reference
    /// \return queue reference of p
QUE2S& QUE2S::operator=(const QUE2S &q) {
    return *this;
}

    /// \brief [operator overload] equal function
    /// \param q source queue reference
    /// \return ture or false
int QUE2S::operator==(const QUE2S &q) const {
    return 1;
}

    /// \brief print all elements in queue
    /// \return void
void QUE2S::print(void) const {

}

    /// \brief destroy queue
    /// \return void
    QUE2S::~QUE2S(void) {

    }
