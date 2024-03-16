/*!
 * \file Type.cc
 * \brief Type System(independence of grammar/ast tree)
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "semantic/Scope.h"
#include "semantic/Symbol.h"
#include "semantic/semantic.h"
#include "syntax/Type.h"

using namespace std;

Type::Type(void) {
    typeName = 0;
}

bool Type::isBaseType(void) {
    return false;
}

bool Type::isArrayType(void) {
    return false;
}

bool Type::isFuncType(void) {
    return false;
}

bool Type::isClassType(void) {
    return false;
}

bool Type::compatible(Type *type) {
    return type->typeName == 0;
}

bool Type::equals(Type *type) {
    return type->typeName == 0;
}

char *Type::toString(void) {
    return typeName;
}

BaseType *BaseType::INT = new BaseType("int");
BaseType *BaseType::BOOL = new BaseType("bool");
BaseType *BaseType::STRING = new BaseType("string");
BaseType *BaseType::VOID = new BaseType("void");
BaseType *BaseType::NIL = new BaseType("null");
BaseType *BaseType::ERROR = new BaseType("error");

BaseType::BaseType(const char *typeName) {
    this->typeName = strdup(typeName);
}

bool BaseType::isBaseType(void) {
    return true;
}

bool BaseType::compatible(Type *type) {
    if (equals(ERROR) || type->equals(ERROR)) {
        return true;
    }

    if (equals(NIL) && type->isClassType()) {
        return true;
    }

    return equals(type);
}

bool BaseType::equals(Type *type) {
    return this == type;
}

char *BaseType::toString(void) {
    return typeName;
}

ArrayType::ArrayType(Type *elementType) {
    this->elementType = elementType;
    typeName = 0;
}

bool ArrayType::compatible(Type *type) {
    if (type->equals(BaseType::ERROR)) {
        return true;
    }

    return equals(type);
}

bool ArrayType::equals(Type *type) {
    if (!type->isArrayType()) {
        return false;
    } else {
        // equality to type of element
        return elementType->equals(((ArrayType *) type)->elementType);
    }
}

char *ArrayType::toString(void) {
    if (0 == typeName) {
        typeName = new char[strlen(elementType->toString())+3];
        strcpy(typeName, elementType->toString());
        strcat(typeName, "[]");
    }

    return typeName;
}

bool ArrayType::isArrayType(void) {
    return true;
}


FuncType::FuncType(Type *returnType) {
    this->returnType = returnType;
    argList = new List <Type *>();
    typeName = 0;
}

bool FuncType::compatible(Type *type) {
    if (type->equals(BaseType::ERROR)) {
        return true;
    }

    if (!type->isFuncType()) {
        return false;
    } else {
        FuncType *ft = (FuncType *) type;

        // different type or arguments
        if (!returnType->compatible(ft->returnType)
                || argList->size() != ft->argList->size()) {
            return false;
        } else {
            for (int i = 0; i < argList->size(); i++) {
                if (!(((*(ft->argList))[i])->compatible((*argList)[i]))) {
                    return false;
                }
            }

            return true;
        }
    }
}

bool FuncType::equals(Type *type) {
    return compatible(type);
}

char *FuncType::toString(void) {
    if (0 == typeName) {
        typeName = new char[80];

        // arguments type
        strcpy(typeName, (*argList)[0]->toString());
        strcat(typeName, "->");

        for (int i = 1; i < argList->size(); i++) {
            strcat(typeName, (*argList)[i]->toString());
            strcat(typeName, "->");
        }

        // return value type
        strcat(typeName, returnType->toString());
    }

    return typeName;
}

bool FuncType::isFuncType(void) {
    return true;
}

int FuncType::numOfParams(void) {
    return argList->size();
}

void FuncType::appendParam(Type *type) {
    argList->append(type);
}

ClassType::ClassType(Class *symbol, ClassType *parent) {
    this->symbol = symbol;
    this->parent = parent;
    typeName = 0;
}

bool ClassType::compatible(Type *type) {
    if (type->equals(BaseType::ERROR)) {
        return true;
    }

    if (!type->isClassType()) {
        return false;
    }

    // compatiable with inheritance
    for (ClassType *ct = this; ct != 0; ct = ct->parent) {
        if (ct->equals(type)) {
            return true;
        }
    }

    return false;
}

bool ClassType::equals(Type *type) {
    return type->isClassType() && symbol == (((ClassType *)type)->symbol);
}

bool ClassType::isClassType(void) {
    return true;
}

char *ClassType::toString(void) {
    if (0 == typeName) {
        typeName = new char[strlen(symbol->name.c_str())+10];
        strcpy(typeName, "class: ");
        strcat(typeName, symbol->name.c_str());
    }

    return typeName;
}

ClassScope *ClassType::getClassScope(void) {
    return symbol->associatedScope;
}
