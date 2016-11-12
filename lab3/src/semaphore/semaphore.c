/*!
 * \file semaphore.c
 * \brief simple encapsulation for semget/semop/semctl written in OO pattern
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-11-11
 * \license MIT
 */

#undef DEBUG
#define DEBUG
// #undef DBUEG

#include <stdio.h>
#include <stdlib.h>
#include "utils/utils.h"
#include "semaphore/semaphore.h"

/// \brief P function
/// \param self semaphore pointer
/// \return void
static void semP(semaphore_t self);

/// \brief V function
/// \param self semaphore pointer
/// \return void
static void semV(semaphore_t self);

/// \brief destructor for semaphore
/// \param self semaphore pointer
/// \return void
static void semdel(semaphore_t self);

semaphore_t semnew(key_t key,int semval, int init_flag) {
    // initialize a new semphore
    semaphore_t sem = (semaphore_t)malloc(sizeof(*sem));

    // create/get a semaphore IPC
    if ((sem->semid = semget(key, 1, IPC_CREAT | 0666)) == -1) {
        perror("semget error\n");
        return NULL;

    }

    sem->semval = semval;
    sem->semun.val = semval;            // initial value of semaphore for semctl function

    if (init_flag == 1) {
        semctl(sem->semid, 0, SETVAL, sem->semun);
    }

    sem->sembuf.sem_num = 0;            // set operation index to sem[0](all semaphores are with single demension)
    sem->sembuf.sem_flg = SEM_UNDO;     // automatically undone when the process terminates

    sem->P = semP;                      // set up P function pointer
    sem->V = semV;                      // set up V function pointer
    sem->del = semdel;                  // set up destructor pointer

    return sem;
}

static void semP(semaphore_t self) {
    LOG("%d: P\n", self->semid);
    self->semval--;
    self->sembuf.sem_op = -1;
    semop(self->semid, &(self->sembuf), 1);
}

static void semV(semaphore_t self) {
    LOG("%d: V\n", self->semid);
    self->semval++;
    self->sembuf.sem_op = +1;
    semop(self->semid, &(self->sembuf), 1);
}

static void semdel(semaphore_t self) {
    // check to prevent multiple-destruction
    if (self->P != NULL || self->V != NULL || self->del != NULL) {
        // delete semaphore IPC
        semctl(self->semid, 0, IPC_RMID);

        // set all pointer member to NULL
        self->P = NULL;
        self->V = NULL;
        self->del = NULL;

        // free heap
        free(self);
    }
}
