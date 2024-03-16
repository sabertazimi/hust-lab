/*!
 * \file Symbol.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#ifndef SEMA_SYMBOL_H
#define SEMA_SYMBOL_H

#include <cstdio>
#include <string>
#include <map>
#include "location.h"
#include "ir/OffsetCounter.h"

using namespace std;

// forward defination owing to circular reference
class Block;

// forward defination owing to circular reference
class Type;
class FuncType;
class ClassType;

// forward defination owing to circular reference
class Scope;
class FormalScope;
class ClassScope;
class ScopeStack;

// forward defination owing to circular reference
class Label;
class Temp;
class Functy;
class VTable;

extern ScopeStack *gtable;      ///< global scope stack

class Symbol{
    public:
        string name;
        yyltype *location;
        Type *type;
        Scope *definedIn;
        int order;
        char *tostr;        ///< intilize it to 0

        /// \brief
        Symbol(string name, Type *type, yyltype *location);

        virtual bool isVariable(void);

        virtual bool isClass(void);

        virtual bool isFunction(void);

        /// \brief print assistant function
        virtual char *toString(void);

};

class Variable: public Symbol{
    public:
        int offset;
        Temp *temp;

        Variable(string name, Type *type, yyltype *location);

        /// \brief parameters or not
        virtual bool isParam(void);

        /// \brief local variables or not
        virtual bool isLocalVar(void);

        /// \brief member field or not
        virtual bool isMemberVar(void);

        /// \brief @Override
        virtual bool isVariable(void);

        /// \brief @Override
        virtual char *toString(void);
};

class Function: public Symbol{
    public:
        FormalScope *associatedScope;
        bool isMain;
        int offset;
        Functy *functy;

        /// \brief constructor
        /// add this parameter
        Function(string name, Type *returnType, Block *node, yyltype *location);

        virtual Type *getReturnType(void);

        virtual void appendParam(Variable *arg);

        /// \brief @Override
        virtual bool isFunction(void);

        /// \brief @Override
        virtual char *toString(void);
};

class Class: public Symbol{
    public:
        string parentName;
        ClassScope *associatedScope;
        bool check;
        int numFunc;
        int numVar;
        int order;
        int size;
        VTable *vtable;
        Label *newFuncLabel;    ///< label for static constructor

        Class(string name, string parentName, yyltype *location);

        virtual void createType(void);

        ClassType *getType(void);

        /// \brief get symbol of parent class
        virtual Class *getParent(void);

        /// \brief remove parent class
        virtual void dettachParent(void);

        /// \brief @Override
        virtual char *toString(void);

        /// \brief @Override
        virtual bool isClass(void);

        /// \brief set up correct order for fields in class
        virtual void resolveFieldOrder(void);
};

/// \brief compare two symbols with location
int symloccmp(Symbol *o1, Symbol *o2);

/// \brief compare two symbols with order
int symordcmp(Symbol *o1, Symbol *o2);

#endif /* !SEMA_SYMBOL_H */
