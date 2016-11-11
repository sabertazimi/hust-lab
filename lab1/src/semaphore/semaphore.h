/*!
 * \file semaphore.h
 * \brief header file for semaphore module
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-11-11
 * \license MIT
 */

#ifndef SEMAPHORE_H
#define SEMAPHORE_H

#include <sys/sem.h>

typedef union semun *semun_t;
typedef struct sembuf *sembuf_t;
typedef struct _semaphore_ *semaphore_t;

/// \brief an OO struct for encapsulating semget/semop/semctl functions
///
/// implement semaphore with OO pattern
struct _semaphore_ {
    int semid;                     ///< id of semaphore
    int semval;                    ///< initial value of semaphore
    semun_t semun;                 ///< struct from stand sem.h for semctl function
    sembuf_t sembuf;               ///< struct from stand sem.h for semop function
    semaphore_t self;               ///< pointer pointing to self memory(for OO pattern implementation)
    void (*P)(semaphore_t self);    ///< function pointer pointing to P function
    void (*V)(semaphore_t self);    ///< function pointer pointing to V function
    void (*del)(semaphore_t self);  ///< function pointer pointing to destructor
};

/// \brief constructor for semaphore struct
/// \param semval initial value of semaphore
/// \return pointer pointing to an allocated semaphore
semaphore_t semnew(int semval);

#endif /* !SEMAPHORE_H */
