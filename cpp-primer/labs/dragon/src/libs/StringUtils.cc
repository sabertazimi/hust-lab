/*!
 * \file StringUtils.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "StringUtils.h"

using namespace std;

string itoa(int i) {
    stringstream ss;
    string str;
    ss << i;
    ss >> str;
    return string(str);
}

string operator+(string s, int i) {
    return string(s + itoa(i));
}

string operator+(int i, string s) {
    return string(itoa(i) + s);
}

string operator+(string s, char *c) {
    return string(s + string(c));
}

string operator+(char *c, string s) {
    return string(string(c) + s);
}
