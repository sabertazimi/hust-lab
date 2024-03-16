/*!
 * \file StringUtils.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#ifndef STRINGUTILS_H
#define STRINGUTILS_H

#include <string>
#include <sstream>

using namespace std;

/// \brief simple helper function for tranfering integer to string
/// \param i integer to tranfer
/// \return integer string
string itoa(int i);

/// \brief @Override enable string can add with integer
/// \param s string
/// \param i integer
/// \return string
string operator+(string s, int i);

/// \brief @Override enable integer can add with string
/// \param s string
/// \param i integer
/// \return string
string operator+(int i, string s);

/// \brief @Override enable string can add with char *
/// \param s string
/// \param c char *
/// \return string
string operator+(string s, char *c);

/// \brief @Override enable char *can add with string
/// \param s string
/// \param c char *
/// \return string
string operator+(char *c, string s);

#endif /* !STRINGUTILS_H */
