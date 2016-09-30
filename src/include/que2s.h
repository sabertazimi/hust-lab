/*!
 * \file que2s.h
 * \brief header file for queue consisting of 2 queue
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#ifndef QUE2S_H
#define QUE2S_H

#include "stack.h"  // add include/ path to g++ flags

/// \brief queue consist of 2 queue
///
/// implement queue with 2 queue composite
class QUE2S {
    // TODO: add more details on s1, s2
    STACK s1;   ///< stack one
    STACK s2;   ///< stack two

public:

    /// \brief queue instructor
    /// \param m queue capacity
    /// \return void
    QUE2S(int m);

    /// \brief deep copy queue instructor
   /// \param q source queue reference
    /// \return void
    QUE2S(const QUE2S &q);

    /// \brief get capacity of queue
    /// \return capacity of queue
    int size(void) const;

    /// \brief [type casting] get number of elements in queue
    /// \return number of elements in queue
    operator int(void) const;

    /// \brief [operator overload] get target element with index x
    /// \param x index of target element
    /// \return tartget element with index x
    int operator[](int x) const;

    /// \brief [operator overload] enqueue method
    /// \param e new element to enqueue
    /// \return queue reference of p
    QUE2S& operator<<(int e);

    /// \brief [operator overload] dequeue method
    /// \param e hold value of element dequeued
    /// \return queue reference of p
    QUE2S& operator>>(int &e);

    /// \brief [operator overload] assign queue p with queue q
    /// \param q source queue reference
    /// \return queue reference of p
    QUE2S& operator=(const QUE2S &q);

    /// \brief print all elements in queue
    /// \return void
    void print(void) const;

    /// \brief destroy queue
    /// \return void
    ~QUE2S(void);
};

#endif /* !QUE2S_H */
