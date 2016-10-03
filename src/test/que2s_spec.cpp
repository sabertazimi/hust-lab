/*!
 * \file que2s_spec.cpp
 * \brief test file for que2s class
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#include <iostream>
#include "spec.h"
#include "que2s.h"  // added include/ path into g++ flag

using namespace std;

int que2s_spec(void) {
    cout<<"\n\n<<< ********** QUE2S Testing ********** >>>\n";

    int elem;

    QUE2S *p = new QUE2S(-1);
    ASSERT("initQUE2S", 1, "initiate p with minus capacity return a 0 long queue");
    ASSERT("size", p->size() == 0, "size of p is 0 owing initiating p with -1 capacity");
    ASSERT("type casting", (int)(*p) == 0, "p is a empty queue");

    QUE2S q(5);
    ASSERT("initQUE2S", 1, "initiate q with 5 capacity return a 5 long queue");
    ASSERT("size", q.size() == 5, "size of q is 5");
    ASSERT("type casting", (int)q == 0, "q is a empty queue");
    q<<5<<4<<3<<2<<1;
    ASSERT("type casting", (int)q == 5, "q holds 5 elements");

    p = new QUE2S(q);
    ASSERT("initQUE2S", 1, "initiate p with s return a 5 long queue");
    ASSERT("size", p->size() == 5, "size of p is 5");
    ASSERT("type casting", (int)(*p) == 0, "p is a empty queue");

    p = new QUE2S(3);
    ASSERT("initQUE2S", 1, "initiate p with 3 capacity return a 3 long queue");
    ASSERT("size", p->size() == 3, "size of p is 3");
    ASSERT("type casting", (int)(*p) == 0, "p is a empty queue");

    ASSERT("getelem", (*p)[0] == 0, "p[0] isn't be assigned");
    ASSERT("getelem", (*p)[-1] == 0, "p[-1] is out of range");
    ASSERT("getelem", (*p)[3] == 0, "p[3] is out of range");

    ASSERT("enqueue", (*p)<<1<<2 == (*p) && (*p)[0] == 1, "enqueue 1 and 2 into p");
    ASSERT("type casting", (int)(*p) == 2, "p contains 2 elements");
    ASSERT("enqueue", (*p)<<3 == (*p) && (*p)[2] == 3, "enqueue 3 into p");
    ASSERT("type casting", (int)(*p) == 3, "p contains 3 elements");
    ASSERT("enqueue", (*p)<<4 == (*p) && (*p)[3] == 0, "enqueue 4 failed owing to p is full");

    p->print();
    ASSERT("print", p != NULL, "print p");

    QUE2S t(3);
    t<<1<<2<<3;
    ASSERT("equal", *p == t, "p has the same queue with t");

    ASSERT("dequeue", (*p)>>elem == (*p) && elem == 3, "dequeue top element 3 from p");
    ASSERT("type casting", (int)(*p) == 2, "p contains 2 elements");
    ASSERT("dequeue", (*p)>>elem>>elem == (*p) && elem == 1, "dequeue top elements 1 and 2 from p");
    ASSERT("type casting", (int)(*p) == 0, "p contains 0 element");
    ASSERT("dequeue", (*p)>>elem == (*p) && elem == 0, "dequeue top element failed owing to p is empty");

    ASSERT("assign", ((*p) = q) == (*p) && (*p)[0] == 5 && (*p)[1] == 4 && (*p)[2] == 3 && (*p)[3] == 0,
            "(p = q) makes p holds the same queue with s(a copy queue capatiable to p)");

    delete p;
    ASSERT("destroyQUE2S", 1, "destroy p");

    cout<<"<<< ********** QUE2S Testing ********** >>>\n";

    return 1;
}

