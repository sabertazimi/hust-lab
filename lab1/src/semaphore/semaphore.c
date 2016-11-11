/*!
 * \file semaphore.c
 * \brief simple encapsulation for semget/semop/semctl written in OO pattern
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-11-11
 * \license MIT
 */

#include <stdlib.h>
#include <time.h>
#include "semaphore.h"

/* int semid;                     ///< id of semaphore */
/* int semval;                    ///< initial value of semaphore */
/* semun_t semun;                 ///< struct from stand sem.h for semctl function */
/* sembuf_t sembuf;               ///< struct from stand sem.h for semop function */
/* semaphore_t self;               ///< pointer pointing to self memory(for OO pattern implementation) */
/* void (*P)(semaphore_t self);    ///< function pointer pointing to P function */
/* void (*V)(semaphore_t self);    ///< function pointer pointing to V function */
/* void (*del)(semaphore_t self);  ///< function pointer pointing to destructor */

semaphore_t semnew(int semval) {
    // initialize rand number generator
    srand((unsigned)time(NULL));

    semaphore_t t sem = (semaphore_t)malloc(sizeof(*sem));

    return NULL;
}

void semP(semaphore_t self) {

}

void semV(semaphore_t self) {

}

void semdel(semaphore_t self) {

}




