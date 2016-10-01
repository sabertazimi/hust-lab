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

    cout<<"Date: "<<(__DATE__)<<"\n";
    cout<<"Time: "<<(__TIME__)<<"\n";

    if (postk_spec()) {
        cout<<"[passed] - postk_spec test.\n";
    } else {
        cerr<<"[failed] - postk_spec test!\n";
    }

    if (oostk_spec()) {
        cout<<"[passed] - oostk_spec test.\n";
    } else {
        cerr<<"[failed] - oostk_spec test!\n";
    }

    if (stack_spec()) {
        cout<<"[passed] - stack_spec test.\n";
    } else {
        cerr<<"[failed] - stack_spec test!\n";
    }

    if (que2s_spec()) {
        cout<<"[passed] - que2s_spec test.\n";
    } else {
        cerr<<"[failed] - que2s_spec test!\n";
    }

    if (queis_spec()) {
        cout<<"[passed] - queis_spec test.\n";
    } else {
        cerr<<"[failed] - queis_spec test!\n";
    }

#endif

    return 0;
}


