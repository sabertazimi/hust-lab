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

class OOSTK {
    int *const elems;   ///< store elements
    const int max;      ///< capacity of stack
    int pos;            ///< number of elements in stack: when stack is empty, pos = 0
public:
    OOSTK(int m);
    OOSTK(const OOSTK &s);
    int size(void) const;
    int howMany(void) const;
    int getelem(int x) const;
    OOSTK &push(int e);
    OOSTK &pop(int &e);
    OOSTK &assign(const OOSTK &s);
    void print(void) const;
    ~OOSTK(void);
};

#endif /* !OOSTK_H */
