/*
 * semantic.h
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef SEMANTIC_H
#define SEMANTIC_H

#include <cstring>
#include <string>
#include <map>
#include "syntax/Tree.h"
#include "syntax/Type.h"
#include "semantic/Scope.h"
#include "semantic/Symbol.h"
#include "errors/errors.h"

using namespace std;

extern ScopeStack *gtable;

class BuildSymbol: public Visitor {
    public:
        bool failed;
        ScopeStack *table;

        /// \brief constructor
        BuildSymbol(ScopeStack *table);

        /// \brief  check Main class whether valid or not
        ///
        /// Main class must have a main function
        /// with void formal and void return type
        ///
        /// Main class can't define fields, except main function
        ///
        virtual void mainClassCheck(Class *c);

        /// \brief calculate depth in inheriting tree
        virtual int calcOrder(Class *c);

        /// \brief override check
        ///
        /// error cases:
        /// 1.var cannnot be override
        /// 2.var override func
        /// 3.func override var
        /// 4.return type not compatible
        ///
        virtual void checkOverride(Class *c);

        virtual void visitProgram(Program *program);

        virtual void visitClassDef(ClassDef *classDef);

        virtual void visitVarDef(VarDef *varDef);

        virtual void visitFuncDef(FuncDef *funcDef);

        /// \brief check variable defination in block(local scope)
        virtual void visitBlock(Block *block);

        /// \brief check variable defination in block(local scope)
        virtual void visitForLoop(ForLoop *forLoop);

        /// \brief check variable defination in block(local scope)
        virtual void visitIf(If *ifStmt);

        /// \brief check variable defination in block(local scope)
        virtual void visitWhileLoop(WhileLoop *whileLoop);

        virtual void visitTypeBasic(TypeBasic *type);

        virtual void visitTypeClass(TypeClass *typeClass);

        virtual void visitTypeArray(TypeArray *typeArray);
};

class TypeCheck: Visitor {
    public:
        ScopeStack *table;
        Function *currentFunction;
        bool failed;

        /// \brief constructor
        TypeCheck(ScopeStack *table);

        virtual void visitProgram(Program *program);

        virtual void visitClassDef(ClassDef *classDef);

        virtual void visitFuncDef(FuncDef *func);

        virtual void visitBlock(Block *block);

        /// \brief condition expression check
        virtual void checkTestExpr(Expr *expr);

        virtual void visitWhileLoop(WhileLoop *whileLoop);

        virtual void visitForLoop(ForLoop *forLoop);

        virtual void visitIf(If *ifStmt);

        virtual void visitPrint(Print *printStmt);

        virtual void visitReturn(Return *returnStmt);

        virtual void visitAssign(Assign *assign);

        virtual void visitNull(Null *nullExpr);

        virtual void visitReadIntExpr(ReadIntExpr *readIntExpr);

        virtual void visitReadLineExpr(ReadLineExpr *readStringExpr);

        virtual void visitIndexed(Indexed *indexed);

        virtual void checkCallExpr(CallExpr *callExpr, Symbol *f);

        virtual void visitCallExpr(CallExpr *callExpr);

        virtual void visitExec(Exec *exec);

        virtual void visitNewArray(NewArray *newArrayExpr);

        virtual void visitNewClass(NewClass *newClass);

        virtual void visitThisExpr(ThisExpr *thisExpr);

        virtual void visitIdent(Ident *ident);

        virtual void visitTypeBasic(TypeBasic *type);

        virtual void visitTypeClass(TypeClass *typeClass);

        virtual void visitTypeArray(TypeArray *typeArray);

        virtual Type *checkBinaryOp(Expr *left, Expr *right, astKind op, yyltype *loc);

        virtual void visitBinary(Binary *expr);

        virtual void visitUnary(Unary *expr);

        virtual void visitConstant(Constant *constant);
};

#endif /* !SEMANTIC_H */
