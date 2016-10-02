/*!
 * \file oostk_spec.cpp
 * \brief test file for oostk class
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#include <iostream>
#include "spec.h"
#include "oostk.h"  // added include/ path into g++ flag

using namespace std;

int oostk_spec(void) {
    cout<<"\n\n<<< ********** OOSTK Testing ********** >>>\n";

    int elem;

    OOSTK *p = new OOSTK(-1);
    ASSERT("initOOSTK", 1, "initiate p with minus capacity return a 0 long stack");
    ASSERT("size", p->size() == 0, "size of p is 0 owing initiating p with -1 capacity");
    ASSERT("howMany", p->howMany() == 0, "p is a empty stack");

    OOSTK s(5);
    ASSERT("initOOSTK", 1, "initiate s with 5 capacity return a 5 long stack");
    ASSERT("size", s.size() == 5, "size of s is 5");
    ASSERT("howMany", s.howMany() == 0, "s is a empty stack");
    s.push(5).push(4).push(3).push(2).push(1);
    ASSERT("howMany", s.howMany() == 5, "s holds 5 elements");

    p = new OOSTK(s);
    ASSERT("initOOSTK", 1, "initiate p with s return a 5 long stack");
    ASSERT("size", p->size() == 5, "size of p is 5");
    ASSERT("howMany", p->howMany() == 0, "p is a empty stack");

    p = new OOSTK(3);
    ASSERT("initOOSTK", 1, "initiate p with 3 capacity return a 3 long stack");
    ASSERT("size", p->size() == 3, "size of p is 3");
    ASSERT("howMany", p->howMany() == 0, "p is a empty stack");

    ASSERT("getelem", p->getelem(0) == 0, "p[0] isn't be assigned");
    ASSERT("getelem", p->getelem(-1) == 0, "p[-1] is out of range");
    ASSERT("getelem", p->getelem(3) == 0, "p[3] is out of range");

    ASSERT("push", p->push(1).push(2) == (*p) && p->getelem(0) == 1, "push 1 and 2 into p");
    ASSERT("howMany", p->howMany() == 2, "p contains 2 elements");
    ASSERT("push", p->push(3) == (*p) && p->getelem(2) == 3, "push 3 into p");
    ASSERT("howMany", p->howMany() == 3, "p contains 3 elements");
    ASSERT("push", p->push(4) == (*p) && p->getelem(3) == 0, "push 4 failed owing to p is full");

    p->print();
    ASSERT("print", p != NULL, "print p");

    OOSTK t(3);
    t.push(1).push(2).push(3);
    ASSERT("equal", *p == t, "p has the same stack with t");

    ASSERT("pop", p->pop(elem) == (*p) && elem == 3, "pop top element 3 from p");
    ASSERT("howMany", p->howMany() == 2, "p contains 2 elements");
    ASSERT("pop", p->pop(elem).pop(elem) == (*p) && elem == 1, "pop top elements 1 and 2 from p");
    ASSERT("howMany", p->howMany() == 0, "p contains 0 element");
    ASSERT("pop", p->pop(elem) == (*p) && elem == 0, "pop top element failed owing to p is empty");

    ASSERT("assign", p->assign(s) == (*p) && p->getelem(0) == 5 && p->getelem(1) == 4 && p->getelem(2) == 3 && p->getelem(3) == 0,
            "assign(p, s) makes p holds the same stack with s(a copy stack capatiable to p)");

    delete p;
    ASSERT("destroyOOSTK", 1, "destroy p");

    cout<<"<<< ********** OOSTK Testing ********** >>>\n";

    return 1;
}

