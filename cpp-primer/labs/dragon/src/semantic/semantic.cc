/*!
 * \file semantic.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "semantic/semantic.h"

BuildSymbol::BuildSymbol(ScopeStack *table) {
    this->table = table;
    failed = 0;
}

void BuildSymbol::mainClassCheck(Class *c) {
    // push class scope into stack
    table->open(c->associatedScope);
    // lookup main function in Main class scope
    Symbol *main = table->lookup("main", false);

    if (main == 0 || !main->isFunction()) {
        failed = 1;
        dragon_report(c->location, "missing 'main' function as program entry in 'Main' class\n");
    }

    // set main
    ((Function *)main)->isMain = true;

    // main function: return type must be VOID, parameters must be VOID
    FuncType *type = (FuncType *) main->type;
    if (!type->returnType->equals(BaseType::VOID) || !(type->numOfParams() == 1)) {
        failed = 1;
        dragon_report(main->location, "error type for 'main' function in 'Main' class: 'main' function must be with 0 parameter and return void\n");
    }

    table->close();
}

int BuildSymbol::calcOrder(Class *c) {
    if (c == 0) {
        return -1;
    }
    if (c->order < 0) {
        c->order = 0;
        c->order = calcOrder(c->getParent()) + 1;
    }
    return c->order;
}

void BuildSymbol::checkOverride(Class *c) {
    if (c->check) {
        return;
    }

    Class *parent = c->getParent();

    // no parent class
    if (parent == 0) {
        return;
    }

    // recursion
    checkOverride(parent);

    ClassScope *parentScope = parent->associatedScope;
    ClassScope *subScope = c->associatedScope;

    table->open(parentScope);

    for (map<string, Symbol *>::iterator it = subScope->symbols->begin();
            it != subScope->symbols->end(); it++) {
        Symbol *suspect = it->second;

        // parent symbol
        Symbol *sym = table->lookup(suspect->name, true);

        if (sym != 0 && !sym->isClass()) {
            if ((suspect->isVariable() && sym->isFunction())
                    || (suspect->isFunction() && sym->isVariable())) {
                failed = 1;
                dragon_report(suspect->location, "incompatible override: variable/function can't override each other\n");
            } else if (suspect->isFunction() && !suspect->type->compatible(sym->type)) {
                failed = 1;
                dragon_report(suspect->location, "incompatible override: different return type\n");
            } else if (suspect->isVariable()) {
                failed = 1;
                dragon_report(suspect->location, "variable can't be override\n");
            }
        }
    }

    table->close();
    c->check = true;
}

void BuildSymbol::visitProgram(Program *program) {
    // initialize the program global scope
    program->globalScope = new GlobalScope();

    // push global scope into stack
    table->open(program->globalScope);

    // declare classes in global scope
    for (int i = 0; i < program->classes->size(); i++) {
        ClassDef *cd = (*(program->classes))[i];
        Class *c = new Class(cd->name, cd->parent, cd->loc);
        Class *earlier = table->lookupClass(cd->name);

        if (earlier != 0) {
            failed = 1;
            dragon_report(cd->loc, "redefined class '%s'\n", cd->name);
        } else {
            table->declare(c);
        }

        // bind symbol to ast node
        cd->symbol = c;
    }

    // inheritance check
    for (int i = 0; i < program->classes->size(); i++) {
        ClassDef *cd = (*(program->classes))[i];
        Class *c = cd->symbol;

        if (strcmp(cd->parent, "") && c->getParent() == 0) {
            failed = 1;
            dragon_report(cd->loc, "undefined parent class '%s' of '%s'\n", cd->parent, cd->name);
            c->dettachParent();
        }

        // ban on inheriting from Main class
        if (!strcmp(cd->parent, "Main")) {
            failed = 1;
            dragon_report(cd->loc, "invalid inheritance from 'Main' class\n");
            c->dettachParent();
        }

        // wrong inheritance in the inheriting tree
        // parent extends children(circular inheritance)
        if (calcOrder(c) <= calcOrder(c->getParent())) {
            failed = 1;
            dragon_report(cd->loc, "bad inheritance between '%s' and '%s'\n", cd->parent, cd->name);
            c->dettachParent();
        }
    }

    // before recursion
    // create class description
    for (int i = 0; i < program->classes->size(); i++) {
        ClassDef *cd = (*(program->classes))[i];
        cd->symbol->createType();
    }

    // recursion
    for (int i = 0; i < program->classes->size(); i++) {
        ClassDef *cd = (*(program->classes))[i];
        cd->accept(this);

        if (!strcmp("Main", cd->name)) {
            program->main = cd->symbol;
        }
    }

    // after recursion
    // override check
    for (int i = 0; i < program->classes->size(); i++) {
        ClassDef *cd = (*(program->classes))[i];
        checkOverride(cd->symbol);
    }

    // main class check
    if (program->main == 0) {
        failed = 1;
        dragon_report(program->loc, "missing main class\n");
    } else {
        mainClassCheck(program->main);
    }

    table->close();
}

void BuildSymbol::visitClassDef(ClassDef *classDef) {
    table->open(classDef->symbol->associatedScope);

    // recursion
    for (int i = 0; i < classDef->fields->size(); i++) {
        Node *f = (*(classDef->fields))[i];
        f->accept(this);
    }

    table->close();
}

void BuildSymbol::visitVarDef(VarDef *varDef) {
    varDef->type->accept(this);

    if (varDef->type->type->equals(BaseType::VOID)) {
        failed = 1;
        dragon_report(varDef->loc, "variable '%s' can't be 'void\n", varDef->name);
        varDef->symbol = new Variable("error", BaseType::ERROR, varDef->loc);
        return ;
    }

    // create variable symbol
    Variable *v = new Variable(varDef->name, varDef->type->type, varDef->loc);

    Symbol *sym = table->lookup(varDef->name, true);
    if (sym != 0) {
        // sym only can be member, or report redefined error
        if (table->getCurrentScope() == sym->definedIn) {
            failed = 1;
            dragon_report(v->location, "redefined variable '%s'\n", v->name.c_str());
        } else if ((sym->definedIn->isFormalScope() || sym->definedIn->isLocalScope())) {
            // behavior same as gcc
            // local/formal can't own same name
            failed = 1;
            dragon_report(v->location, "redefined variable '%s'\n", v->name.c_str());
        } else {
            table->declare(v);
        }
    } else {
        table->declare(v);
    }

    // bind symbol and node
    varDef->symbol = v;
}

void BuildSymbol::visitFuncDef(FuncDef *funcDef) {
    // check return type
    funcDef->returnType->accept(this);

    // create function symbol
    Function *f = new Function(funcDef->name, funcDef->returnType->type, funcDef->body, funcDef->loc);
    // bind symbol and node
    funcDef->symbol = f;

    Symbol *sym = table->lookup(funcDef->name, false);
    if (sym != 0) {
        failed = 1;
        dragon_report(f->location, "redefined function '%s'\n", f->name.c_str());
    } else {
        table->declare(f);
    }

    table->open(f->associatedScope);

    // recursion
    for (int i = 0; i < funcDef->formals->size(); i++) {
        VarDef *d = (*(funcDef->formals))[i];
        d->accept(this);
        f->appendParam(d->symbol);
    }
    funcDef->body->accept(this);

    table->close();
}

void BuildSymbol::visitBlock(Block *block) {
    block->associatedScope = new LocalScope(block);
    table->open(block->associatedScope);

    for (int i = 0;i < block->block->size(); i++) {
        Node *s = (*(block->block))[i];
        s->accept(this);
    }

    table->close();
}

void BuildSymbol::visitForLoop(ForLoop *forLoop) {
    if (forLoop->loopBody != 0) {
        forLoop->loopBody->accept(this);
    }
}

void BuildSymbol::visitIf(If *ifStmt) {
    if (ifStmt->trueBranch != 0) {
        ifStmt->trueBranch->accept(this);
    }
    if (ifStmt->falseBranch != 0) {
        ifStmt->falseBranch->accept(this);
    }
}

void BuildSymbol::visitWhileLoop(WhileLoop *whileLoop) {
    if (whileLoop->loopBody != 0) {
        whileLoop->loopBody->accept(this);
    }
}

void BuildSymbol::visitTypeBasic(TypeBasic *type) {
    switch (type->typekind) {
        case TYPE_VOID:
            type->type = BaseType::VOID;
            break;
        case TYPE_INT:
            type->type = BaseType::INT;
            break;
        case TYPE_BOOL:
            type->type = BaseType::BOOL;
            break;
        default:
            type->type = BaseType::STRING;
            break;
    }
}

void BuildSymbol::visitTypeClass(TypeClass *typeClass) {
    Class *c = table->lookupClass(typeClass->name);

    if (c == 0) {
        failed = 1;
        dragon_report(typeClass->loc, "undefined class '%s'\n", typeClass->name);
        typeClass->type = BaseType::ERROR;
    } else {
        // @FIXME getType() in need?
        typeClass->type = c->getType();
    }
}

void BuildSymbol::visitTypeArray(TypeArray *typeArray) {
    // recursion
    typeArray->elementType->accept(this);

    if (typeArray->elementType->type->equals(BaseType::ERROR)) {
        typeArray->type = BaseType::ERROR;
    } else if (typeArray->elementType->type->equals(BaseType::VOID)) {
        failed = 1;
        dragon_report(typeArray->loc, "type of array elements can't be 'void'\n");
        typeArray->type = BaseType::ERROR;
    } else {
        typeArray->type = new ArrayType(typeArray->elementType->type);
    }
}

TypeCheck::TypeCheck(ScopeStack *table) {
    this->table = table;
    failed = 0;
}

void TypeCheck::visitProgram(Program *program) {
    table->open(program->globalScope);
    for (int i = 0; i < program->classes->size(); i++) {
        ClassDef *cd = (*(program->classes))[i];
        cd->accept(this);
    }
    table->close();
}

void TypeCheck::visitClassDef(ClassDef *classDef) {
    table->open(classDef->symbol->associatedScope);

    for (int i = 0; i < classDef->fields->size(); i++) {
        Node *f = (*(classDef->fields))[i];
        f->accept(this);
    }

    table->close();
}

void TypeCheck::visitFuncDef(FuncDef *func) {
    this->currentFunction = func->symbol;
    table->open(func->symbol->associatedScope);
    func->body->accept(this);
    table->close();
}

void TypeCheck::visitBlock(Block *block) {
    table->open(block->associatedScope);

    for (int i = 0;i < block->block->size(); i++) {
        Node *s = (*(block->block))[i];
        s->accept(this);
    }

    table->close();
}

void TypeCheck::checkTestExpr(Expr *expr) {
    expr->accept(this);

    if (!expr->type->equals(BaseType::ERROR) && !expr->type->equals(BaseType::BOOL)) {
        failed = 1;
        dragon_report(expr->loc, "condition expression must be 'bool' type\n");
    }
}

void TypeCheck::visitWhileLoop(WhileLoop *whileLoop) {
    checkTestExpr(whileLoop->condition);

    if (whileLoop->loopBody != 0) {
        whileLoop->loopBody->accept(this);
    }
}

void TypeCheck::visitForLoop(ForLoop *forLoop) {
    if (forLoop->init != 0) {
        forLoop->init->accept(this);
    }

    checkTestExpr(forLoop->condition);

    if (forLoop->update != 0) {
        forLoop->update->accept(this);
    }

    if (forLoop->loopBody != 0) {
        forLoop->loopBody->accept(this);
    }
}

void TypeCheck::visitIf(If *ifStmt) {
    checkTestExpr(ifStmt->condition);

    if (ifStmt->trueBranch != 0) {
        ifStmt->trueBranch->accept(this);
    }

    if (ifStmt->falseBranch != 0) {
        ifStmt->falseBranch->accept(this);
    }
}

void TypeCheck::visitPrint(Print *printStmt) {
    for (int i = 0; i < printStmt->exprs->size(); i++) {
        Expr *e = (*(printStmt->exprs))[i];
        // recursion
        e->accept(this);

        if (!e->type->equals(BaseType::ERROR)
                && !e->type->equals(BaseType::BOOL)
                && !e->type->equals(BaseType::INT)
                && !e->type->equals(BaseType::STRING)) {
            failed = 1;
            dragon_report(e->loc, "incompatible argument %d type '%s'\n", i+1, e->type->toString());
        }
    }
}

void TypeCheck::visitReturn(Return *returnStmt) {
    // get return type in function scope
    Type *returnType = ((FormalScope *)table->lookForScope(SCOPE_FORMAL))->owner->getReturnType();

    if (returnStmt->expr != 0) {
        returnStmt->expr->accept(this);
    }

    if (returnType->equals(BaseType::VOID)) {
        if (returnStmt->expr != 0) {
            failed = 1;
            dragon_report(returnStmt->loc, "incompatible return type between '%s' and '%s'\n",
                    returnType->toString(), returnStmt->expr->type->toString());
        }
    } else if (returnStmt->expr == 0) {
        failed = 1;
        dragon_report(returnStmt->loc, "missing return statement, need '%s'\n", returnType->toString());
    } else if (!returnStmt->expr->type->equals(BaseType::ERROR)
            && !returnStmt->expr->type->compatible(returnType)) {
        failed = 1;
        dragon_report(returnStmt->loc, "incompatible return type between '%s' and '%s'\n",
                returnType->toString(), returnStmt->expr->type->toString());
    }
}

void TypeCheck::visitAssign(Assign *assign) {
    // recursion
    assign->left->accept(this);
    assign->expr->accept(this);

    if (!assign->left->type->equals(BaseType::ERROR) &&
            (assign->left->type->isFuncType() || !assign->expr->type->compatible(assign->left->type))) {
        failed = 1;
        dragon_report(assign->loc, "incompatible assignment from '%s' to '%s'\n",
                assign->expr->type->toString(), assign->left->type->toString());
    }
}

void TypeCheck::visitNull(Null *nullExpr) {
    nullExpr->type = BaseType::NIL;
}

void TypeCheck::visitReadIntExpr(ReadIntExpr *readIntExpr) {
    readIntExpr->type = BaseType::INT;
}

void TypeCheck::visitReadLineExpr(ReadLineExpr *readStringExpr) {
    readStringExpr->type = BaseType::STRING;
}

void TypeCheck::visitIndexed(Indexed *indexed) {
    indexed->kind = ARRAY_ELEMENT;

    // recursion
    indexed->array->accept(this);
    if (!indexed->array->type->isArrayType()) {
        failed = 1;
        dragon_report(indexed->array->loc, "subscripted value is neither array nor vector\n");
        indexed->type = BaseType::ERROR;
    } else {
        indexed->type = ((ArrayType *) indexed->array->type)->elementType;
    }

    // recursion
    indexed->index->accept(this);
    if (!indexed->index->type->equals(BaseType::INT)) {
        failed = 1;
        dragon_report(indexed->index->loc, "array subscript is not an integer\n");
    }
}

void TypeCheck::checkCallExpr(CallExpr *callExpr, Symbol *f) {
    if (f == 0) {
        failed = 1;
        dragon_report(callExpr->loc, "undefined method '%s'\n", callExpr->method);
        callExpr->type = BaseType::ERROR;
    } else if (!f->isFunction()) {
        failed = 1;
        dragon_report(callExpr->loc, "field '%s' is not a method\n", callExpr->method);
        callExpr->type = BaseType::ERROR;
    } else {
        Function *func = (Function *) f;

        // bind symbol and node
        callExpr->symbol = func;
        callExpr->type = func->getReturnType();

        if (callExpr->receiver != 0 && callExpr->receiver->isClass) {
            // can't access Class Name Type
            failed = 1;
            dragon_report(callExpr->loc, "invalid access to field '%s' in '%s'\n",
                    callExpr->method, callExpr->receiver->type->toString());
        }

        // bind receiver to 'this'
        if (callExpr->receiver == 0) {
            callExpr->receiver = new ThisExpr(callExpr->loc);
            callExpr->receiver->accept(this);
        }

        // recursion
        for (int i = 0; i < callExpr->actuals->size(); i++) {
            Expr *e = (*(callExpr->actuals))[i];
            e->accept(this);
        }

        List <Type *> *argList = ((FuncType *)(func->type))->argList;

        if ((argList->size() - 1) != callExpr->actuals->size()) {
            failed = 1;
            dragon_report(callExpr->loc, "incompatible number of arguments, expected %d, get %d\n", argList->size() - 1, callExpr->actuals->size());
        } else {
            for (int i = 1, j = 0; i < argList->size() && j < callExpr->actuals->size(); i++, j++) {
                Type *t1 = (*argList)[i];

                Expr *e = (*(callExpr->actuals))[j];
                Type *t2 = e->type;

                if (!t2->equals(BaseType::ERROR) && !t2->compatible(t1)) {
                    failed = 1;
                    dragon_report(e->loc, "incompatible type between '%s' and '%s'\n", t2->toString(), t1->toString());
                }
            }
        }
    }
}

void TypeCheck::visitCallExpr(CallExpr *callExpr) {
    if (callExpr->receiver == 0) {
        // search method in class scope
        ClassScope *cs = (ClassScope *) table->lookForScope(SCOPE_CLASS);
        checkCallExpr(callExpr, cs->lookupVisible(callExpr->method));
    } else {
        // recursion
        callExpr->receiver->usedForRef = true;
        callExpr->receiver->accept(this);

        if (callExpr->receiver->type->equals(BaseType::ERROR)) {
            callExpr->type = BaseType::ERROR;
            return;
        }

        // receiver check
        if (!callExpr->receiver->type->isClassType()) {
            failed = 1;
            dragon_report(callExpr->loc, "invalid access to '%s' in '%s'\n",
                    callExpr->method, callExpr->receiver->type->toString());
            callExpr->type = BaseType::ERROR;
            return;
        }

        // search method in class scope
        ClassScope *cs = ((ClassType *)callExpr->receiver->type)->getClassScope();
        checkCallExpr(callExpr, cs->lookupVisible(callExpr->method));
    }
}

void TypeCheck::visitExec(Exec *exec){
    exec->expr->accept(this);
}

void TypeCheck::visitNewArray(NewArray *newArrayExpr) {
    // recursion
    newArrayExpr->elementType->accept(this);

    if (newArrayExpr->elementType->type->equals(BaseType::ERROR)) {
        newArrayExpr->type = BaseType::ERROR;
    } else if (newArrayExpr->elementType->type->equals(BaseType::VOID)) {
        failed = 1;
        dragon_report(newArrayExpr->elementType->loc, "type of array elements can't be 'void'\n");
        newArrayExpr->type = BaseType::ERROR;
    } else {
        newArrayExpr->type = new ArrayType(newArrayExpr->elementType->type);
    }

    // recursion
    newArrayExpr->length->accept(this);

    if (!newArrayExpr->length->type->equals(BaseType::ERROR)
            && !newArrayExpr->length->type->equals(BaseType::INT)) {
        failed = 1;
        dragon_report(newArrayExpr->length->loc, "array length is not an integer\n");
    }
}

void TypeCheck::visitNewClass(NewClass *newClass) {
    Class *c = table->lookupClass(newClass->className);
    newClass->symbol = c;

    if (c == 0) {
        failed = 1;
        dragon_report(newClass->loc, "undefined class '%s'\n", newClass->className);
        newClass->type = BaseType::ERROR;
    } else {
        newClass->type = c->getType();
    }
}

void TypeCheck::visitThisExpr(ThisExpr *thisExpr) {
    thisExpr->type = ((ClassScope *)table->lookForScope(SCOPE_CLASS))->owner->getType();
}

void TypeCheck::visitIdent(Ident *ident) {
    if (ident->owner == 0) {
        Symbol *v = table->lookupBeforeLocation(ident->name, ident->loc);

        if (v == 0) {
            failed = 1;
            dragon_report(ident->loc, "undefine variable '%s'\n", ident->name);
            ident->type = BaseType::ERROR;
        } else if (v->isVariable()) {
            Variable *var = (Variable *) v;

            // bind symbol and node
            ident->type = var->type;
            ident->symbol = var;

            if (var->isLocalVar()) {
                ident->kind = LOCAL_VAR;
            } else if (var->isParam()) {
                ident->kind = PARAM_VAR;
            } else {
                // field
                ident->owner = new ThisExpr(ident->loc);
                ident->owner->accept(this);
                ident->kind = MEMBER_VAR;
            }
        } else {
            // bind symbol and node
            ident->type = v->type;

            if (v->isClass()) {
                if (ident->usedForRef) {
                    ident->isClass = true;
                } else {
                    failed = 1;
                    // reference to method
                    dragon_report(ident->loc, "invalid reference to '%s'\n", ident->name);
                    ident->type = BaseType::ERROR;
                }
            }
        }
    } else {
        // recursion: receiver
        ident->owner->usedForRef = true;
        ident->owner->accept(this);

        if (!ident->owner->type->equals(BaseType::ERROR)) {
            // can't access on Class Name Type or non-class variable
            if (ident->owner->isClass || !ident->owner->type->isClassType()) {
                failed = 1;
                dragon_report(ident->loc, "invalid access to field '%s' in '%s'\n", ident->name, ident->owner->type->toString());
                ident->type = BaseType::ERROR;
            } else {
                ClassScope *cs = ((ClassType *)ident->owner->type)->getClassScope();
                Symbol *v = cs->lookupVisible(ident->name);

                if (v == 0) {
                    failed = 1;
                    dragon_report(ident->loc, "invalid access to undefined field '%s' in '%s'\n", ident->name, ident->owner->type->toString());
                    ident->type = BaseType::ERROR;
                } else if (v->isVariable()) {
                    ClassType *thisType = ((ClassScope *)table->lookForScope(SCOPE_CLASS))->owner->getType();

                    ident->type = v->type;

                    if (!thisType->compatible(ident->owner->type)) {
                        failed = 1;
                        dragon_report(ident->loc, "invalid access to field '%s' in '%s'\n", ident->name, ident->owner->type->toString());
                    } else {
                        ident->symbol = (Variable *)v;
                        ident->kind = MEMBER_VAR;
                    }
                } else {
                    ident->type = v->type;
                }
            }
        } else {
            ident->type = BaseType::ERROR;
        }
    }
}

void TypeCheck::visitTypeBasic(TypeBasic *type) {
    switch (type->typekind) {
        case TYPE_VOID:
            type->type = BaseType::VOID;
            break;
        case TYPE_INT:
            type->type = BaseType::INT;
            break;
        case TYPE_BOOL:
            type->type = BaseType::BOOL;
            break;
        default:
            type->type = BaseType::STRING;
            break;
    }
}

void TypeCheck::visitTypeClass(TypeClass *typeClass) {
    Class *c = table->lookupClass(typeClass->name);

    if (c == 0) {
        failed = 1;
        dragon_report(typeClass->loc, "undefined class '%s'\n", typeClass->name);
        typeClass->type = BaseType::ERROR;
    } else {
        typeClass->type = c->getType();
    }
}

void TypeCheck::visitTypeArray(TypeArray *typeArray) {
    // recursion
    typeArray->elementType->accept(this);

    if (typeArray->elementType->type->equals(BaseType::ERROR)) {
        typeArray->type = BaseType::ERROR;
    } else if (typeArray->elementType->type->equals(BaseType::VOID)) {
        failed = 1;
        dragon_report(typeArray->loc, "type of array elements can't be 'void'\n");
        typeArray->type = BaseType::ERROR;
    } else {
        typeArray->type = new ArrayType(typeArray->elementType->type);
    }
}

Type *TypeCheck::checkBinaryOp(Expr *left, Expr *right, astKind op, yyltype *loc) {
    // recursion
    left->accept(this);
    right->accept(this);

    if (left->type->equals(BaseType::ERROR) || right->type->equals(BaseType::ERROR)) {
        switch (op) {
            case EXPR_ADD:
            case EXPR_SUB:
            case EXPR_MUL:
            case EXPR_DIV:
                return left->type;
            case EXPR_MOD:
                return BaseType::INT;
            default:
                return BaseType::BOOL;
        }
    }

    bool compatible = false;
    Type *returnType = BaseType::ERROR;

    switch (op) {
        case EXPR_ADD:
        case EXPR_SUB:
        case EXPR_MUL:
        case EXPR_DIV:
            compatible = left->type->equals(BaseType::INT)
                && left->type->equals(right->type);
            returnType = left->type;
            break;
        case EXPR_GT:
        case EXPR_GE:
        case EXPR_LT:
        case EXPR_LE:
            compatible = left->type->equals(BaseType::INT)
                && left->type->equals(right->type);
            returnType = BaseType::BOOL;
            break;
        case EXPR_MOD:
            compatible = left->type->equals(BaseType::INT)
                && right->type->equals(BaseType::INT);
            returnType = BaseType::INT;
            break;
        case EXPR_EQ:
        case EXPR_NE:
            compatible = left->type->compatible(right->type)
                || right->type->compatible(left->type);
            returnType = BaseType::BOOL;
            break;
        case EXPR_AND:
        case EXPR_OR:
            compatible = left->type->equals(BaseType::BOOL)
                && right->type->equals(BaseType::BOOL);
            returnType = BaseType::BOOL;
            break;
        default:
            break;
    }

    if (!compatible) {
        failed = 1;
        dragon_report(loc, "incompatible binary operation between '%s' and '%s'\n",
                left->type->toString(), right->type->toString());
    }

    return returnType;
}

void TypeCheck::visitBinary(Binary *expr) {
    expr->type = checkBinaryOp(expr->left, expr->right, expr->kind, expr->loc);
}

void TypeCheck::visitUnary(Unary *expr) {
    expr->expr->accept(this);

    if(expr->kind == EXPR_NEG){
        if (expr->expr->type->equals(BaseType::ERROR)
                || expr->expr->type->equals(BaseType::INT)) {
            expr->type = expr->expr->type;
        } else {
            failed =1;
            dragon_report(expr->loc, "incompatible '-' operation on '%s'\n", expr->expr->type->toString());
            expr->type = BaseType::ERROR;
        }
    } else{
        if (!(expr->expr->type->equals(BaseType::BOOL) || expr->expr->type->equals(BaseType::ERROR))) {
            failed =1;
            dragon_report(expr->loc, "incompatible '!' operation on '%s'\n", expr->expr->type->toString());
        }

        expr->type = BaseType::BOOL;
    }
}

void TypeCheck::visitConstant(Constant *constant) {
    switch (constant->typekind) {
        case TYPE_INT:
            constant->type = BaseType::INT;
            break;
        case TYPE_BOOL:
            constant->type = BaseType::BOOL;
            break;
        case TYPE_STRING:
            constant->type = BaseType::STRING;
            break;
        default:
            break;
    }
}
