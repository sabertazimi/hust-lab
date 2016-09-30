/*!
 * \file oostk.h
 * \brief header file for object-oriented stack
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#ifndef OOSTK_H
#define OOSTK_H

/// \brief object-oriented stack
///
/// implement stack
class OOSTK {
    int *const elems;   ///< store elements
    const int max;      ///< capacity of stack
    int pos;            ///< number of elements in stack: when stack is empty, pos = 0

public:

    /// \brief stack instructor
    /// \param m stack capacity
    /// \return void
    OOSTK(int m);

    /// \brief deep copy stack instructor
    /// \param s source stack reference
    /// \return void
    OOSTK(const OOSTK &s);

    /// \brief get capacity of stack
    /// \return capacity of stack
    int size(void) const;

    /// \brief get number of elements in stack
    /// \return number of elements in stack
    int howMany(void) const;

    /// \brief get target element with index x
    /// \param x index of target element
    /// \return tartget element with index x
    int getelem(int x) const;

    /// \brief push a new element into stack
    /// \param e new element to push
    /// \return stack reference of p
    OOSTK &push(int e);

    /// \brief pop a element from stack
    /// \param e hold value of element poped
    /// \return stack reference of p
    OOSTK &pop(int &e);

    /// \brief assign stack p with stack s
    /// \param s source stack reference
    /// \return stack reference of p
    OOSTK &assign(const OOSTK &s);

    /// \brief print all elements in stack
    /// \return void
    void print(void) const;

    /// \brief destroy stack
    // \return void
    ~OOSTK(void);
};

#endif /* !OOSTK_H */
