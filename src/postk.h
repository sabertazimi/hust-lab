/*!
 * \file postk.h
 * \brief header file for process-oriented stack
 *
 * \author sabertazimi,<sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-29
 */

#ifndef POSTK_H
#define POSTK_H

struct POSTK {
    int *elems;     // store elements
    int max;        // capacity of stack
    int pos;        // number of elements in stack: when stack is empty, pos = 0
};

/// \brief initiate stack
/// \param p stack pointer
/// \param m stack capacity
/// \return void
void initPOSTK(POSTK *const p, int m);

/// \brief initiate stack (with copy)
/// \param p dest stack pointer
/// \param s src stack pointer
/// \return void
void initPOSTK(POSTK *const p, const POSTK&s);

#endif /* !POSTK_H */
