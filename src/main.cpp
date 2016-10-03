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
    int cnt_passed = 0;

    cout<<"Date: "<<(__DATE__)<<"\n";
    cout<<"Time: "<<(__TIME__)<<"\n";

    if (postk_spec()) {
        cout<<"[passed] - postk_spec test.\n";
        cnt_passed++;
    } else {
        cerr<<"[failed] - postk_spec test!\n";
    }

    if (oostk_spec()) {
        cout<<"[passed] - oostk_spec test.\n";
        cnt_passed++;
    } else {
        cerr<<"[failed] - oostk_spec test!\n";
    }

    if (stack_spec()) {
        cout<<"[passed] - stack_spec test.\n";
        cnt_passed++;
    } else {
        cerr<<"[failed] - stack_spec test!\n";
    }

    if (que2s_spec()) {
        cout<<"[passed] - que2s_spec test.\n";
        cnt_passed++;
    } else {
        cerr<<"[failed] - que2s_spec test!\n";
    }

    if (queis_spec()) {
        cout<<"[passed] - queis_spec test.\n";
        cnt_passed++;
    } else {
        cerr<<"[failed] - queis_spec test!\n";
    }

    cout<<"\n\n[passed] - "<<cnt_passed<<"/5\n";
    cout<<"[passed] - rate: "<<cnt_passed/5.0*100<<"\%\n";
    cerr<<"[failed] - "<<(5-cnt_passed)<<"/5\n";
    cerr<<"[failed] - rate: "<<(5-cnt_passed)/5.0*100<<"\%\n";

#endif

    return 0;
}


