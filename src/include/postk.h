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

/// \brief process-oriented stack
///
/// implement process-oriented stack
struct POSTK {
    int *elems;     ///< store elements
    int max;        ///< capacity of stack
    int pos;        ///< number of elements in stack: when stack is empty, pos = 0
};

/// \brief initiate stack
/// \param p stack pointer
/// \param m stack capacity
/// \return void
void initPOSTK(POSTK *const p, int m);

/// \brief initiate stack (with copy)
/// \param p destination stack pointer
/// \param s source stack pointer
/// \return void
void initPOSTK(POSTK *const p, const POSTK &s);

/// \brief get capacity of stack
/// \param p stack pointer
/// \return capacity of stack
int size(const POSTK *const p);

/// \brief get number of elements in stack
/// \param p stack pointer
/// \return number of elements in stack
int howMany(const POSTK *const p);

/// \brief get target element with index x
/// \param p stack pointer
/// \param x index of target element
/// \return tartget element with index x
int getelem(const POSTK *const p, int x);

/// \brief push a new element into stack
/// \param p stack pointer
/// \param e new element to push
/// \return stack pointer point to p
POSTK *const push(POSTK *const p, int e);

/// \brief pop a element from stack
/// \param p stack pointer
/// \param e hold value of element poped
/// \return stack pointer point to p
POSTK *const pop(POSTK *const p, int &e);

/// \brief assign stack p with stack s
/// \param p destination stack pointer
/// \param s source stack pointer
/// \return stack pointer point to p
POSTK *const assign(POSTK *const p, const POSTK &s);

/// \brief print all elements in stack
/// \param p stack pointer
/// \return void
void print(const POSTK *const p);

/// \brief destroy stack
/// \param p stack pointer
/// \return void
void destroyPOSTK(POSTK *const p);

#endif /* !POSTK_H */
