/*!
 * \file stack_spec.cpp
 * \brief test file for stack class
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#include <iostream>
#include "spec.h"
#include "stack.h"  // added include/ path into g++ flag

using namespace std;

int stack_spec(void) {
    cout<<"\n\n<<< ********** STACK Testing ********** >>>\n";

    int elem;

    STACK *p = new STACK(-1);
    ASSERT("initSTACK", 1, "initiate p with minus capacity return a 0 long stack");
    ASSERT("size", p->size() == 0, "size of p is 0 owing initiating p with -1 capacity");
    ASSERT("type casting", (int)(*p) == 0, "p is a empty stack");

    STACK s(5);
    ASSERT("initSTACK", 1, "initiate s with 5 capacity return a 5 long stack");
    ASSERT("size", s.size() == 5, "size of s is 5");
    ASSERT("type casting", (int)s == 0, "s is a empty stack");
    s<<5<<4<<3<<2<<1;
    ASSERT("type casting", (int)s == 5, "s holds 5 elements");

    p = new STACK(s);
    ASSERT("initSTACK", 1, "initiate p with s return a 5 long stack");
    ASSERT("size", p->size() == 5, "size of p is 5");
    ASSERT("type casting", (int)(*p) == 0, "p is a empty stack");

    p = new STACK(3);
    ASSERT("initSTACK", 1, "initiate p with 3 capacity return a 3 long stack");
    ASSERT("size", p->size() == 3, "size of p is 3");
    ASSERT("type casting", (int)(*p) == 0, "p is a empty stack");

    ASSERT("getelem", (*p)[0] == 0, "p[0] isn't be assigned");
    ASSERT("getelem", (*p)[-1] == 0, "p[-1] is out of range");
    ASSERT("getelem", (*p)[3] == 0, "p[3] is out of range");

    ASSERT("push", (*p)<<1<<2 == (*p) && (*p)[0] == 1, "push 1 and 2 into p");
    ASSERT("type casting", (int)(*p) == 2, "p contains 2 elements");
    ASSERT("push", (*p)<<3 == (*p) && (*p)[2] == 3, "push 3 into p");
    ASSERT("type casting", (int)(*p) == 3, "p contains 3 elements");
    ASSERT("push", (*p)<<4 == (*p) && (*p)[3] == 0, "push 4 failed owing to p is full");

    p->print();
    ASSERT("print", p != NULL, "print p");

    STACK t(3);
    t<<1<<2<<3;
    ASSERT("equal", *p == t, "p has the same stack with t");

    ASSERT("pop", (*p)>>elem == (*p) && elem == 3, "pop top element 3 from p");
    ASSERT("type casting", (int)(*p) == 2, "p contains 2 elements");
    ASSERT("pop", (*p)>>elem>>elem == (*p) && elem == 1, "pop top elements 1 and 2 from p");
    ASSERT("type casting", (int)(*p) == 0, "p contains 0 element");
    ASSERT("pop", (*p)>>elem == (*p) && elem == 0, "pop top element failed owing to p is empty");

    ASSERT("assign", ((*p) = s) == (*p) && (*p)[0] == 5 && (*p)[1] == 4 && (*p)[2] == 3 && (*p)[3] == 0,
            "assign(p, s) makes p holds the same stack with s(a copy stack capatiable to p)");

    delete p;
    ASSERT("destroySTACK", 1, "destroy p");

    cout<<"<<< ********** STACK Testing ********** >>>\n";

    return 1;
}

