/*!
 * \file LibFunction.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "syntax/Type.h"
#include "ir/Tac.h"
#include "LibFunction.h"

using namespace std;

LibFunction *LibFunction::MALLOC = new LibFunction("malloc", 1, BaseType::INT);
LibFunction *LibFunction::READ_INT = new LibFunction("_ReadInteger", 0, BaseType::INT);
LibFunction *LibFunction::READ_LINE = new LibFunction("_ReadLine", 0, BaseType::STRING);
LibFunction *LibFunction::PRINT_INT = new LibFunction("_PrintInt", 1, BaseType::VOID);
LibFunction *LibFunction::PRINT_STRING = new LibFunction("_PrintString", 1, BaseType::VOID);
LibFunction *LibFunction::PRINT_BOOL = new LibFunction("_PrintBool", 1, BaseType::VOID);

LibFunction::LibFunction(string name, int numArgs, BaseType *type) {
    this->label = Label::createLabel(name, false);
    this->numArgs = numArgs;
    this->type = type;
}
