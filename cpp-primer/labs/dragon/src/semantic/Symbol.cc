/*!
 * \file Symbol.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "syntax/Type.h"
#include "syntax/Tree.h"
#include "semantic/Scope.h"
#include "ir/Tac.h"
#include "semantic/Symbol.h"

using namespace std;

extern ScopeStack *gtable;      ///< global scope stack

Symbol::Symbol(string name, Type *type, yyltype *location) {
    this->name = name;
    this->type = type;
    this->location = location;
    tostr = 0;
    definedIn = 0;
}

bool Symbol::isVariable(void) {
    return false;
}

bool Symbol::isClass(void) {
    return false;
}

bool Symbol::isFunction(void) {
    return false;
}

char *Symbol::toString(void) {
    return tostr;
}

Variable::Variable(string name, Type *type, yyltype *location): Symbol(name, type, location) {
    offset = 0;
    temp = 0;
}

bool Variable::isParam(void) {
    return definedIn->isFormalScope();
}

bool Variable::isLocalVar(void) {
    return definedIn->isLocalScope();
}

bool Variable::isMemberVar(void) {
    return definedIn->isClassScope();
}

bool Variable::isVariable(void) {
    return true;
}

char *Variable::toString(void) {
    if (tostr == 0) {
        tostr = new char[80];
        sprintf(tostr, "variable:\t%c%s: %s", isParam() ? '@' : ' ', name.c_str(), type->toString());
    }

    return tostr;
}

Function::Function(string name, Type *returnType, Block *node, yyltype *location): Symbol(name, 0, location) {
    type = new FuncType(returnType);
    associatedScope = new FormalScope(this, node);

    // declare 'this' as parameters
    ClassScope *cs = (ClassScope *) gtable->lookForScope(SCOPE_CLASS);
    Variable *_this = new Variable("this", cs->owner->type, location);
    associatedScope->declare(_this);
    appendParam(_this);
}

Type *Function::getReturnType(void) {
    return ((FuncType *)type)->returnType;
}

void Function::appendParam(Variable *arg) {
    FuncType *ft = (FuncType *)type;
    arg->order = ft->numOfParams();
    ft->appendParam(arg->type);
}

bool Function::isFunction(void) {
    return true;
}

char *Function::toString(void) {
    if (tostr == 0) {
        tostr = new char[80];
        sprintf(tostr, "function:\t%s: %s", name.c_str(), type->toString());
    }

    return tostr;
}

Class::Class(string name, string parentName, yyltype *location): Symbol(name, 0, location) {
    this->parentName = parentName;
    this->order = -1;
    this->check = false;
    this->numFunc = -1;
    this->numVar = -1;
    this->associatedScope = new ClassScope(this);
}

void Class::createType(void) {
    Class *p = getParent();

    if (p == 0) {
        type = new ClassType(this, 0);
    } else {
        // create type for parent class
        if (p->getType() == 0) {
            p->createType();
        }

        type = new ClassType(this, (ClassType *)(p->getType()));
    }
}

ClassType *Class::getType(void) {
    if (type == 0) {
        createType();
    }
    return (ClassType *) type;
}

char *Class::toString(void) {
    if (tostr == 0) {
        tostr = new char[300];
        sprintf(tostr, "class %s", name.c_str());

        if (!parentName.empty()) {
            strcat(tostr, ": ");
            strcat(tostr, parentName.c_str());
        }
    }

    return tostr;
}

Class *Class::getParent(void) {
    return gtable->lookupClass(parentName);
}

bool Class::isClass(void) {
    return true;
}

void Class::dettachParent(void) {
    parentName = "";
}

void Class::resolveFieldOrder(void) {
    // numFunc/numVar == -1: represent the correct order hasn't been set up
    if (numFunc >= 0 && numVar >= 0) {
        return;
    }

    // resolve inheritance
    if (!parentName.empty()) {
        // resolve fields in parent class
        Class *parent = getParent();
        parent->resolveFieldOrder();

        // inheritance
        numFunc = parent->numFunc;
        numVar = parent->numVar;
        size = parent->size;
    } else {
        numFunc = 0;
        numVar = 0;
        size = POINTER_SIZE;
    }

    ClassScope *ps = associatedScope->getParentScope();

    for (map<string, Symbol *>::iterator it = associatedScope->symbols->begin();
            it != associatedScope->symbols->end(); it++) {
        Symbol *sym = it->second;

        // variable field
        if (sym->isVariable()) {
            sym->order = numVar++;
            size += WORD_SIZE;
        } else {
            // function field
            if (ps == 0) {
                // no parent class
                sym->order = numFunc++;
            } else {
                // resolve inheritance
                Symbol *s = ps->lookupVisible(sym->name);

                if (s == 0) {
                    // no parent method
                    sym->order = numFunc++;
                } else {
                    // resolve method overwrite
                    // inherites(overwrite) from parent class
                    sym->order = s->order;
                }
            }
        }
    }
}
