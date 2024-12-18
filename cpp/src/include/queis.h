/*!
 * \file queis.h
 * \brief header file for queue inheriting from stack
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#ifndef QUEIS_H
#define QUEIS_H

#include "stack.h"  // add include/ path to g++ flags

/// \brief queue inherits from stack
///
/// implement queue by inheriting
class QUEIS: public STACK {
    STACK s;   ///< stack member: store elements in reverse order, and pop elements from this stack

public:

    /// \brief queue instructor
    /// \param m queue capacity
    /// \return void
    QUEIS(int m);

    /// \brief deep copy queue instructor
    /// \param q source queue reference
    /// \return void
    QUEIS(const QUEIS &q);

    /// \brief get capacity of queue
    /// \return capacity of queue
    virtual int size(void) const;

    /// \brief [type casting] get number of elements in queue
    /// \return number of elements in queue
    virtual operator int(void) const;

    /// \brief [operator overload] get target element with index x
    /// \param x index of target element
    /// \return tartget element with index x
    virtual int operator[](int x) const;

    /// \brief [operator overload] enqueue method
    /// \param e new element to enqueue
    /// \return queue reference of p
    virtual QUEIS& operator<<(int e);

    /// \brief [operator overload] dequeue method
    /// \param e hold value of element dequeued
    /// \return queue reference of p
    virtual QUEIS& operator>>(int &e);

    /// \brief [operator overload] assign queue p with queue q
    /// \param q source queue reference
    /// \return queue reference of p
    virtual QUEIS& operator=(const QUEIS &q);

    /// \brief [operator overload] equal function
    /// \param q source queue reference
    /// \return ture or false
    virtual int operator==(const QUEIS &q) const;

    /// \brief print all elements in queue
    /// \return void
    virtual void print(void) const;

    /// \brief destroy queue
    /// \return void
    virtual ~QUEIS(void);
};

#endif /* !QUEIS_H */
