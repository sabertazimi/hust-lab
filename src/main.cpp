/*!
 * \file main.cpp
 * \brief program entry(for debug only)
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#include <iostream>

#define DEBUG
// #undef DEBUG

#ifdef DEBUG
#include "test/spec.h"
#endif

using namespace std;

int main(int argc, char **argv) {

#ifdef DEBUG
    postk_spec();
    cout<<"Test: postk_spec passed!\n";
    oostk_spec();
    cout<<"Test: oostk_spec passed!\n";
    stack_spec();
    cout<<"Test: stack_spec passed!\n";
    que2s_spec();
    cout<<"Test: que2s_spec passed!\n";
    queis_spec();
    cout<<"Test: queis_spec passed!\n";
#endif

    return 0;
}


