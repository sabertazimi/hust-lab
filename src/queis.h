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

class QUEIS: public STACK {
    STACK s;
public:
    QUEIS(int m);
    QUEIS(const QUEIS &q);
    virtual operator int(void) const;
    virtual QUEIS& operator<<(int e);
    virtual QUEIS& operator>>(int &e);
    virtual QUEIS& operator=(const QUEIS &q);
    virtual void print(void) const;
    virtual ~QUEIS(void);
};

#endif /* !QUEIS_H */
