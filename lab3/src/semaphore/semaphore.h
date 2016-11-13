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

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>

typedef struct _semaphore_ *semaphore_t;

union semun {
    int              val;    ///< value for SETVAL
    struct semid_ds *buf;    ///< buffer for IPC_STAT, IPC_SET
    unsigned short  *array;  ///< array for GETALL, SETALL
    struct seminfo  *__buf;  ///< buffer for IPC_INFO (Linux-specific)
};

/// \brief an OO struct for encapsulating semget/semop/semctl functions
///
/// implement semaphore with OO pattern
struct _semaphore_ {
    int semid;                      ///< id of semaphore
    union semun semun;              ///< struct for semctl function
    struct sembuf sembuf;           ///< struct from stand sem.h for semop function
    void (*P)(semaphore_t self);    ///< function pointer pointing to P function
    void (*V)(semaphore_t self);    ///< function pointer pointing to V function
    void (*del)(semaphore_t self);  ///< function pointer pointing to destructor
};

/// \brief constructor for semaphore struct
/// \param semval initial value of semaphore
/// \return pointer pointing to an allocated semaphore
semaphore_t semnew(key_t key, int semval);

#endif /* !SEMAPHORE_H */
