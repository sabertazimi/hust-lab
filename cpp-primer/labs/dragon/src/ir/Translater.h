/*!
 * \file Translater.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#ifndef TRANSLATER_H
#define TRANSLATER_H

#include <string>
#include <vector>
#include <stack>
#include <map>
#include <algorithm>
#include "libs/List.h"
#include "syntax/Tree.h"
#include "syntax/Type.h"
#include "semantic/Scope.h"
#include "semantic/Symbol.h"
#include "ir/Tac.h"
#include "ir/OffsetCounter.h"
#include "ir/LibFunction.h"

using namespace std;

// forward defination
class TransPass1;
class TransPass2;

class Translater {
    public:
        List<VTable *> *vtables;
        List<Functy *> *funcs;
        Functy *currentFuncty;

        Translater(void);

        static Translater *translate(Program *tree);

        virtual void print(AstPrinter *ap);

        virtual Functy *createFuncty(Function *func);

        virtual void beginFunc(Function *func);

        virtual void endFunc(void);

        virtual void createVTable(Class *c);

        virtual void fillVTableEntries(VTable *vt, ClassScope *cs);

        virtual void append(Tac *tac);

        virtual Temp *emitAdd(Temp *src1, Temp *src2);

        virtual Temp *emitSub(Temp *src1, Temp *src2);

        virtual Temp *emitMul(Temp *src1, Temp *src2);

        virtual Temp *emitDiv(Temp *src1, Temp *src2);

        virtual Temp *emitMod(Temp *src1, Temp *src2);

        virtual Temp *emitNeg(Temp *src);

        virtual Temp *emitLAnd(Temp *src1, Temp *src2);

        virtual Temp *emitLOr(Temp *src1, Temp *src2);

        virtual Temp *emitLNot(Temp *src);

        virtual Temp *emitGtr(Temp *src1, Temp *src2);

        virtual Temp *emitGeq(Temp *src1, Temp *src2);

        virtual Temp *emitEqu(Temp *src1, Temp *src2);

        virtual Temp *emitNeq(Temp *src1, Temp *src2);

        virtual Temp *emitLeq(Temp *src1, Temp *src2);

        virtual Temp *emitLes(Temp *src1, Temp *src2);

        virtual void emitAssign(Temp *dst, Temp *src);

        virtual Temp *emitLoadVTable(VTable *vtbl);

        virtual Temp *emitIndirectCall(Temp *func, Type *retType);

        virtual Temp *emitDirectCall(Label *func, Type *retType);

        virtual void emitReturn(Temp *src);

        virtual void emitJmp(Label *dst);

        virtual void emitBeqz(Temp *cond, Label *dst);

        virtual void emitBnez(Temp *cond, Label *dst);

        virtual Temp *emitLoad(Temp *base, int offset);

        virtual void emitStore(Temp *src, Temp *base, int offset);

        virtual Temp *emitLoadImm4(int imm);

        virtual Temp *emitLoadStrConst(string value);

        virtual void emitMark(Label *label);

        virtual void emitParm(Temp *parm);

        virtual Temp *emitNewArray(Temp *length);

        /// \brief treat constructor of class('new') as functions
        virtual void emitNewForClass(Class *c);
};

class TransPass1: public Visitor {
    public:
        Translater *tr;
        int objectSize;
        vector <Variable *> *vars;

        static bool ordercmp(Variable *o1, Variable *o2) {
            return o1->order < o2->order ? true : false;
        }

        TransPass1(Translater *tr);

        /// \breif @Override
        ///
        /// create vtable and static constructor
        ///
        virtual void visitProgram(Program *program);

        /// \breif @Override
        ///
        /// calculate offset of fields
        ///
        virtual void visitClassDef(ClassDef *classDef);

        /// \breif @Override
        virtual void visitFuncDef(FuncDef *funcDef);

        /// \breif @Override
        virtual void visitVarDef(VarDef *varDef);
};

class TransPass2: public Visitor {
    public:
        Translater *tr;
        Temp *currentThis;      ///< current class 'this' reference
        stack <Label *> *loopExits;

        TransPass2(Translater *tr);

        /// \breif @Override
        virtual void visitProgram(Program *program);

        /// \breif @Override
        virtual void visitClassDef(ClassDef *classDef);

        /// \breif @Override
        virtual void visitFuncDef(FuncDef *funcDef);

        /// \breif @Override
        virtual void visitVarDef(VarDef *varDef);

        /// \breif @Override
        virtual void visitBinary(Binary *expr);

        /// \breif @Override
        virtual void visitAssign(Assign *assign);

        /// \breif @Override
        virtual void visitConstant(Constant *constant);

        /// \breif @Override
        virtual void visitExec(Exec *exec);

        /// \breif @Override
        virtual void visitUnary(Unary *expr);

        /// \breif @Override
        virtual void visitNull(Null *nullExpr);

        /// \breif @Override
        virtual void visitBlock(Block *block);

        /// \breif @Override
        virtual void visitThisExpr(ThisExpr *thisExpr);

        /// \breif @Override
        virtual void visitReadIntExpr(ReadIntExpr *readIntExpr);

        /// \breif @Override
        virtual void visitReadLineExpr(ReadLineExpr *readStringExpr);

        /// \breif @Override
        virtual void visitReturn(Return *returnStmt);

        /// \breif @Override
        virtual void visitPrint(Print *printStmt);

        /// \breif @Override
        virtual void visitIndexed(Indexed *indexed);

        /// \breif @Override
        virtual void visitIdent(Ident *ident);

        /// \breif @Override
        virtual void visitCallExpr(CallExpr *callExpr);

        /// \breif @Override
        virtual void visitForLoop(ForLoop *forLoop);

        /// \breif @Override
        virtual void visitIf(If *ifStmt);

        /// \breif @Override
        virtual void visitWhileLoop(WhileLoop *whileLoop);

        /// \breif @Override
        virtual void visitNewArray(NewArray *newArray);

        /// \breif @Override
        virtual void visitNewClass(NewClass *newClass);
};

#endif /* !TRANSLATER_H */
