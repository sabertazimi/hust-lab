/*!
 * \file que2s.h
 * \brief header file for queue consisting of 2 stack
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#ifndef QUE2S_H
#define QUE2S_H

/// \brief queue consist of 2 stack
///
/// implement queue with 2 stack composite
class QUE2S {
    STACK s1;
    STACK s2;
public:
    QUE2S(int m);
    QUE2S(const QUE2S &q);
    operator int(void) const;   ///< type casting
    QUE2S& operator<<(int e);
    QUE2S& operator>>(int &e);
    QUE2S& operator=(const QUE2S &q);
    void print(void) const;
    ~QUE2S(void);
};

#endif /* !QUE2S_H */
