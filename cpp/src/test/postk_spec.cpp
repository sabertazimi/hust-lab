/*!
 * \file postk_spec.cpp
 * \brief test file for postk struct
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#include <iostream>
#include <cstdlib>
#include "spec.h"
#include "postk.h"  // added include/ path into g++ flag

using namespace std;

/* functions to test */

extern void initPOSTK(POSTK *const p, int m);
extern void initPOSTK(POSTK *const p, const POSTK &s);
extern int size(const POSTK *const p);
extern int howMany(const POSTK *const p);
extern int getelem(const POSTK *const p, int x);
extern POSTK *const push(POSTK *const p, int e);
extern POSTK *const pop(POSTK *const p, int &e);
extern POSTK *const assign(POSTK *const p, const POSTK &s);
extern void print(const POSTK *const p);
extern void destroyPOSTK(POSTK *const p);

/* functions to test */

int postk_spec(void) {
    cout<<"\n\n<<< ********** POSTK Testing ********** >>>\n";

    POSTK *p = NULL;

    int *elems = (int *)malloc(sizeof(int) * 5);
    elems[0] = 0;
    elems[1] = 1;
    elems[2] = 2;
    POSTK s = {
        elems,
        5,
        3
    };

    int elem = 0;

    /* NULL pointer test */

    initPOSTK(p, 0);
    ASSERT("initPOSTK", p == NULL, "when p is null, initPOSTK(p, 0) should keep p NULL");
    initPOSTK(p, s);
    ASSERT("initPOSTK", p == NULL, "when p is null, initPOSTK(p, s) should keep p NULL");

    ASSERT("size", size(p) == 0, "when p is null, size(p) should return 0");
    ASSERT("howMany", howMany(p) == 0, "when p is null, howMany(p) should return 0");

    ASSERT("getelem", getelem(p, 1) == 0, "when p is null, getelem(p, 1) should return 0");
    ASSERT("push", push(p, 3) == NULL && p == NULL, "when p is null, push(p, 3) should keep p NULL and return NULL");
    ASSERT("pop", pop(p, elem) == NULL && p == NULL && elem == 0, "when p is null, pop(p, elem) should keep p NULL, keep elem 0 and return NULL");

    ASSERT("assign", assign(p, s) == NULL && p == NULL, "when p is null, assign(p, s) should keep p NULL and return NULL");

    print(p);
    ASSERT("print", p == NULL, "when p is null, print(p) should do nothing but keep p NULL");

    destroyPOSTK(p);
    ASSERT("destroyPOSTK", p == NULL, "when p is null, destroyPOSTK(p) should do nothing but keep p NULL");

    /* NULL pointer test */

    p = (POSTK *)malloc(sizeof(POSTK));

    initPOSTK(p, s);
    ASSERT("initPOSTK", p->elems != NULL && size(p) == 5 && howMany(p) == 3, "initPOSTK(p, s) set up a 5 long stack");

    initPOSTK(p, 3);
    ASSERT("initPOSTK", p->elems != NULL && size(p) == 3 && howMany(p) == 0, "initPOSTK(p, 3) set up a 3 long stack");

    ASSERT("size", size(p) == 3, "size of p is 3");
    ASSERT("howMany", howMany(p) == 0, "p is a empty stack");

    ASSERT("getelem", getelem(p, 0) == 0, "p[0] isn't be assigned");
    ASSERT("getelem", getelem(p, -1) == 0, "p[-1] is out of range");
    ASSERT("getelem", getelem(p, 1) == 0, "p[1] is out of range");

    ASSERT("push", push(p, 1) == p && getelem(p, 0) == 1, "push 1 into p");
    ASSERT("howMany", howMany(p) == 1, "p contains 1 element");
    ASSERT("push", push(p, 2) == p && getelem(p, 1) == 2, "push 2 into p");
    ASSERT("howMany", howMany(p) == 2, "p contains 2 elements");
    ASSERT("push", push(p, 3) == p && getelem(p, 2) == 3, "push 3 into p");
    ASSERT("howMany", howMany(p) == 3, "p contains 3 elements");
    ASSERT("push", push(p, 4) == p && getelem(p, 3) == 0, "push 4 failed owing to p is full");

    ASSERT("pop", pop(p, elem) == p && elem == 3, "pop top element 3 from p");
    ASSERT("howMany", howMany(p) == 2, "p contains 2 elements");
    ASSERT("pop", pop(p, elem) == p && elem == 2, "pop top element 2 from p");
    ASSERT("howMany", howMany(p) == 1, "p contains 1 element");
    ASSERT("pop", pop(p, elem) == p && elem == 1, "pop top element 1 from p");
    ASSERT("howMany", howMany(p) == 0, "p contains 0 element");
    ASSERT("pop", pop(p, elem) == p && elem == 0, "pop top element failed owing to p is empty");

    ASSERT("assign", assign(p, s) == p && getelem(p, 0) == 0 && getelem(p, 1) == 1 && getelem(p, 2) == 2 && getelem(p, 3) == 0, "assign(p, s) makes p holds the same stack with s(a copy stack)");

    print(p);
    ASSERT("print", p != NULL, "print p");

    destroyPOSTK(p);
    ASSERT("destroyPOSTK", 1, "destroy p");

    cout<<"<<< ********** POSTK Testing ********** >>>\n";

    return 1;
}
