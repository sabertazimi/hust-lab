/*!
 * \file Scope.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#ifndef SEMA_SCOPE_H
#define SEMA_SCOPE_H

#include <string>
#include <map>
#include "libs/List.h"
#include "location.h"
#include "syntax/AstPrinter.h"

using namespace std;

// forward defination
class Block;
class Symbol;
class Function;
class Class;

/// \brief kind of scope(common kind: SCOPE)
typedef enum __scopeKind__ {
    SCOPE = 100,
    SCOPE_GLOBAL,
    SCOPE_CLASS,
    SCOPE_FORMAL,
    SCOPE_LOCAL
} scopeKind;

/// \brief scope interface
class Scope {
    public:
        map<string , Symbol *> *symbols;    ///< symbol map(symbol table)

        /// \brief constructor
        Scope(void);

        /// \brief get kind information
        /// \return kind of scope
        virtual scopeKind getKind(void);

        /// \brief print information of scope to ap
        /// \param ap print helper class
        /// \return void
        void print(AstPrinter *ap);

        /// \brief judge kind of scope
        /// \return bool value
        virtual bool isGlobalScope(void);

        /// \brief judge kind of scope
        /// \return bool value
        virtual bool isClassScope(void);

        /// \brief judge kind of scope
        /// \return bool value
        virtual bool isLocalScope(void);

        /// \brief judge kind of scope
        /// \return bool value
        virtual bool isFormalScope(void);

        /// \brief look up symbol
        /// \param name symbol name
        /// return target symbol
        virtual Symbol *lookup(string name);

        /// \brief insert symbol from this scope
        /// \param symbol symbol to insert
        /// \return void
        virtual void declare(Symbol *symbol);

};

class FormalScope: public Scope{
    public:
        Function *owner;
        Block *astNode;

        FormalScope(Function *owner, Block *astNode);

        /// \brief @Override get kind information
        /// \return kind of scope
        virtual scopeKind getKind(void);

        /// \brief @Override
        virtual bool isFormalScope(void);

        /// \brief @Override print information of scope to ap
        /// \param ap print helper class
        /// \return void
        virtual void print(AstPrinter *ap);
};

class LocalScope: public Scope {
    public:
        Block *node;

        LocalScope(Block *node);

        /// \brief @Override get kind information
        /// \return kind of scope
        virtual scopeKind getKind(void);

        /// \brief @Override print information of scope to ap
        /// \param ap print helper class
        /// \return void
        virtual void print(AstPrinter *ap);

        /// \brief @Override
        virtual bool isLocalScope(void);
};

class ClassScope: public Scope{
    public:
        Class *owner;

        ClassScope(Class *owner);

        /// \brief @Override
        virtual bool isClassScope(void);

        virtual ClassScope *getParentScope(void);

        /// \brief @Override get kind information
        /// \return kind of scope
        virtual scopeKind getKind(void);

        /// \brief @Override print information of scope to ap
        /// \param ap print helper class
        /// \return void
        virtual void print(AstPrinter *ap);

        /// \brief judge inheritance relationship
        ///
        /// judge current scope whether is child of scope defining symbol or not
        ///
        /// \param symbol belong to parent symbol
        virtual bool isInherited(Symbol *symbol);

        /// \brief lookup symbol in scope list(bottom-to-up)
        virtual Symbol *lookupVisible(string name);
};

class GlobalScope: public Scope {
    public:
        /// \brief @Override
        virtual bool isGlobalScope(void);

        /// \brief @Override get kind information
        /// \return kind of scope
        virtual scopeKind getKind(void);

        /// \brief @Override print information of scope to ap
        /// \param ap print helper class
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief scope stack
///
/// there only exists one class scope in this stack at one time(open/close)
class ScopeStack {
    public:
        List <Scope *> *scopeStack;     ///< top: scopeStack[scoep->size()-1]
        GlobalScope *globalScope;       ///< global scope reference

        /// \brief constructor
        ScopeStack(void);

        /// \brief look up symbol in scope stack
        /// \param name symbol name
        /// \param through whether search into stack or not
        /// \return target symbol
        virtual Symbol *lookup(string name, bool through);

        /// \brief look up symbol in scope stack
        /// \param location location limits
        virtual Symbol *lookupBeforeLocation(string name, yyltype *loc);

        virtual void declare(Symbol *symbol);

        /// \brief bind global scope and push all new scopes
        virtual void open(Scope *scope);

        /// \brief clear scope stack
        virtual void close(void);

        /// \brief get closest specific kind scope
        /// \param kind kind of scope
        virtual Scope *lookForScope(scopeKind kind);

        virtual Scope *getCurrentScope(void);

        virtual Class *lookupClass(string name);
};

#endif /* !SEMA_SCOPE_H */
