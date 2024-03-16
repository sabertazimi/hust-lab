/*!
 * \file Scope.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "syntax/Tree.h"
#include "semantic/Symbol.h"
#include "semantic/Scope.h"

Scope::Scope(void) {
    symbols = new map<string , Symbol *>();
}

scopeKind Scope::getKind(void) {
    return SCOPE;
}

void Scope::print(AstPrinter *ap) {
    ap->print("scope");
}

bool Scope::isGlobalScope(void) {
    return false;
}

bool Scope::isClassScope(void) {
    return false;
}

bool Scope::isLocalScope(void) {
    return false;
}

bool Scope::isFormalScope(void) {
    return false;
}

Symbol *Scope::lookup(string name) {
    map<string , Symbol *>::iterator it = symbols->find(name);

    // found
    if (it != symbols->end()) {
        return it->second;
    } else {
        return 0;
    }
}

void Scope::declare(Symbol *symbol) {
    (*symbols)[symbol->name] = symbol;

    // bind symbol and scope
    symbol->definedIn = this;
}

FormalScope::FormalScope(Function *owner, Block *astNode) {
    this->owner = owner;        // function symbol
    this->astNode = astNode;    // block ast node(belong to function defination)
}

scopeKind FormalScope::getKind(void) {
    return SCOPE_FORMAL;
}

bool FormalScope::isFormalScope(void) {
    return true;
}

void FormalScope::print(AstPrinter *ap) {
    ap->print("formal scope of '%s': ", owner->name.c_str());
    ap->incIndent();

    for (map<string, Symbol *>::iterator it = symbols->begin();
            it != symbols->end(); it++) {
        ap->print(it->second->toString());
    }

    astNode->associatedScope->print(ap);

    ap->decIndent();
}

LocalScope::LocalScope(Block *node) {
    this->node = node;
}

scopeKind LocalScope::getKind(void) {
    return SCOPE_LOCAL;
}

void LocalScope::print(AstPrinter *ap) {
    ap->print("local scope: ");
    ap->incIndent();

    for (map<string, Symbol *>::iterator it = symbols->begin();
            it != symbols->end(); it++) {
        ap->print(it->second->toString());
    }

    for (int i = 0; i < node->block->size(); i++) {
        // print nested local scope
        Node *n = ((Node *)((*(node->block))[i]));
        if (n->kind == STMT_BLOCK) {
            Block *b = (Block *)n;
            b->associatedScope->print(ap);
        }
    }

    ap->decIndent();
}

bool LocalScope::isLocalScope(void) {
    return true;
}

ClassScope::ClassScope(Class *owner) {
    this->owner = owner;
}

bool ClassScope::isClassScope(void) {
    return true;
}

ClassScope *ClassScope::getParentScope(void) {
    Class *p = owner->getParent();
    return p == 0 ? 0 : p->associatedScope;
}

scopeKind ClassScope::getKind(void) {
    return SCOPE_CLASS;
}

void ClassScope::print(AstPrinter *ap) {
    ap->print("class scope of '%s': ", owner->name.c_str());
    ap->incIndent();

    for (map<string, Symbol *>::iterator it = symbols->begin();
            it != symbols->end(); it++) {
        ap->print(it->second->toString());
    }

    for (map<string, Symbol *>::iterator it = symbols->begin();
            it != symbols->end(); it++) {
        if (it->second->isFunction()) {
            ((Function *)(it->second))->associatedScope->print(ap);
        }
    }

    ap->decIndent();
}

bool ClassScope::isInherited(Symbol *symbol) {
    Scope *scope = symbol->definedIn;

    // empty scope or non-classScope can't be inherited
    if (scope == 0 || scope == this || !scope->isClassScope()) {
        return false;
    }

    for (ClassScope *p = getParentScope(); p != 0; p = p->getParentScope()) {
        if (scope == p) {
            return true;
        }
    }

    return false;
}

Symbol *ClassScope::lookupVisible(string name) {
    // search through scope list
    for (ClassScope *cs = this; cs != 0; cs = cs->getParentScope()) {
        Symbol *symbol = cs->lookup(name);

        if (symbol != 0) {
            return symbol;
        }
    }

    return 0;
}

bool GlobalScope::isGlobalScope(void) {
    return true;
}

scopeKind GlobalScope::getKind(void) {
    return SCOPE_GLOBAL;
}

void GlobalScope::print(AstPrinter *ap) {
    ap->print("global scope: ");
    ap->incIndent();

    for (map<string, Symbol *>::iterator it = symbols->begin();
            it != symbols->end(); it++) {
        ap->print(it->second->toString());
    }

    for (map<string, Symbol *>::iterator it = symbols->begin();
            it != symbols->end(); it++) {
        ap->print(it->second->toString());
        ((Class *)(it->second))->associatedScope->print(ap);
    }

    ap->decIndent();
}

ScopeStack::ScopeStack(void) {
    scopeStack = new List <Scope *>();
}

Symbol *ScopeStack::lookup(string name, bool through) {
    // search into scope stack
    if (through) {
        for (int i = scopeStack->size() - 1;
                i > -1; i--) {
            Symbol *symbol = (*scopeStack)[i]->lookup(name);
            if (symbol != 0) {
                return symbol;
            }
        }

        return 0;
    } else {
        // only search in top scope(closest scope)
        return (*scopeStack)[scopeStack->size() - 1]->lookup(name);
    }
}

Symbol *ScopeStack::lookupBeforeLocation(string name, yyltype *loc) {
    for (int i = scopeStack->size() - 1;
            i > -1; i--) {
        Scope *scope = (*scopeStack)[i];
        Symbol *symbol = scope->lookup(name);

        if (symbol != 0) {
            // skip symbol in local scope or after location
            if (scope->isLocalScope() && loccmp(symbol->location, loc) > 0) {
                continue;
            }

            return symbol;
        }
    }

    return 0;
}

void ScopeStack::declare(Symbol *symbol) {
    (*scopeStack)[scopeStack->size()-1]->declare(symbol);
}

void ScopeStack::open(Scope *scope) {
    switch (scope->getKind()) {
        // bind global scope to globalScope(member of scope stack)
        case SCOPE_GLOBAL:
            globalScope = (GlobalScope *)scope;
            break;
        case SCOPE_CLASS:
            {
                ClassScope *cs = ((ClassScope *)scope)->getParentScope();
                if (cs != 0) open(cs);
                break;
            }
        default:
            break;
    }

    // push current scope(not GlobalScope) into scope stack
    scopeStack->append(scope);
}

void ScopeStack::close(void) {
    // pop top scope
    Scope *scope = scopeStack->pop();

    // if it's class scope, clear up class scope
    if (scope->isClassScope()) {
        for (int n = (scopeStack->size() - 1); n > 0; n--) {
            scopeStack->pop();
        }
    }
}

Scope *ScopeStack::lookForScope(scopeKind kind) {
    for (int i = scopeStack->size() - 1;
            i > -1; i--) {
        Scope *scope = (*scopeStack)[i];

        if (scope->getKind() == kind) {
            return scope;
        }

    }

    return 0;
}

Scope *ScopeStack::getCurrentScope(void) {
    return (*scopeStack)[scopeStack->size()-1];
}

Class *ScopeStack::lookupClass(string name) {
    return (Class *) globalScope->lookup(name);
}
