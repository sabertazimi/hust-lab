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

class STACK {
    int *const elems;   ///< store elements
    const int max;      ///< capacity of stack
    int pos;            ///< number of elements in stack: when stack is empty, pos = 0
public:
    STACK(int m);
    STACK(const STACK &s);
    virtual int size(void) const;
    virtual operator int(void) const; // type casting
    virtual int operator[](int x) const;
    virtual STACK& operator<<(int e);
    virtual STACK& operator>>(int &e);
    virtual STACK& operator=(const STACK &s);
    virtual void print(void) const;
    virtual ~STACK(void);
};

#endif /* !STACK_H */
