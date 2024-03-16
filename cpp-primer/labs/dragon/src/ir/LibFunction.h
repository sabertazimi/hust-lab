/*!
 * \file LibFunction.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#ifndef LIBFUNCTION_H
#define LIBFUNCTION_H

#include <string>

using namespace std;

class BaseType;
class Label;

class LibFunction {
public:
	static LibFunction *MALLOC;
	static LibFunction *READ_INT;
	static LibFunction *READ_LINE;
	static LibFunction *PRINT_INT;
	static LibFunction *PRINT_STRING;
	static LibFunction *PRINT_BOOL;

	Label *label;
	int numArgs;
	BaseType *type;

	LibFunction(string  name, int numArgs, BaseType *type);
};

#endif /* !LIBFUNCTION_H */
