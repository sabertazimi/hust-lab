/*!
 * \file stack.h
 * \brief header file for operator overload object-oriented stack
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#ifndef STACK_H
#define STACK_H

/// \brief object-oriented stack with overloaded operator and virtual function members
///
/// implement stack with awesome feature: overloaded operator and virtual function
class STACK {
    int *const elems;   ///< store elements
    const int max;      ///< capacity of stack
    int pos;            ///< number of elements in stack: when stack is empty, pos = 0

public:

    /// \brief stack instructor
    /// \param m stack capacity
    /// \return void
    STACK(int m);

    /// \brief deep copy stack instructor
    /// \param s source stack reference
    /// \return void
    STACK(const STACK &s);

    /// \brief get capacity of stack
    /// \return capacity of stack
    virtual int size(void) const;

    /// \brief [type casting] get number of elements in stack
    /// \return number of elements in stack
    virtual operator int(void) const;

    /// \brief [operator overload] get target element with index x
    /// \param x index of target element
    /// \return tartget element with index x
    virtual int operator[](int x) const;

    /// \brief [operator overload] push a new element into stack
    /// \param e new element to push
    /// \return stack reference of p
    virtual STACK& operator<<(int e);

    /// \brief [operator overload] pop a element from stack
    /// \param e hold value of element poped
    /// \return stack reference of p
    virtual STACK& operator>>(int &e);

    /// \brief [operator overload] assign stack p with stack s
    /// \param s source stack reference
    /// \return stack reference of p
    virtual STACK& operator=(const STACK &s);

    /// \brief print all elements in stack
    /// \return void
    virtual void print(void) const;

    /// \brief destroy stack
    /// \return void
    virtual ~STACK(void);
};

#endif /* !STACK_H */
