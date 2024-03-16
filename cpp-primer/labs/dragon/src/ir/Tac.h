/*!
 * \file Tac.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#ifndef IR_TAC_H
#define IR_TAC_H

#include <climits>
#include <cstdlib>
#include <string>
#include <iostream>
#include <vector>
#include <map>
#include <set>
#include <algorithm>
#include "libs/List.h"
#include "libs/StringUtils.h"

using namespace std;

// forward defination
class Variable;
class Function;
class FuncType;
class Tac;

typedef enum __tacKind__ {
    TAC_ADD,
    TAC_SUB,
    TAC_MUL,
    TAC_DIV,
    TAC_MOD,
    TAC_NEG,
    TAC_AND,
    TAC_OR,
    TAC_NOT,
    TAC_GT,
    TAC_GE,
    TAC_EQ,
    TAC_NE,
    TAC_LE,
    TAC_LT,
    TAC_ASSIGN,
    TAC_LOAD_VTBL,
    TAC_INDIRECT_CALL,
    TAC_DIRECT_CALL,
    TAC_RETURN,
    TAC_JMP,
    TAC_BEQZ,
    TAC_BNEZ,
    TAC_LOAD,
    TAC_STORE,
    TAC_LOAD_IMM4,
    TAC_LOAD_STR_CONST,
    TAC_MARK,
    TAC_PARM
} tacKind;

class Label {
    public:
        int id;         ///< label id
        string name;    ///< label name information
        bool target;    ///< whether is the target of jmp instruction
        Tac *where;     ///< label position information
        static int labelCount;  ///< for id

        Label(void);

        Label(int id, string name, bool target);

        static Label *createLabel(void);

        static Label *createLabel(bool target);

        static Label *createLabel(string name, bool target);

        /// \brief print out Label information
        virtual string toString(void);
};

class Temp {
    public:
        int id;
        string name;
        int offset;
        int size;
        Variable *sym;
        int value;          ///< for const temp
        bool isConst;       ///< whether is constant or not
        bool isParam;       ///< whether is parameter of function or not, offset = (%ebp+4, 8...)
        static int tempCount;   ///< for id
        static map<int, Temp*> *constTempPool;

        Temp(void);

        Temp(int id, string name, int size, int offset);

        static Temp *createTempI4(void);

        static Temp *createConstTemp(int value);

        /// \brief @Override
        virtual bool equals(Temp *temp);

        /// \brief @Override
        virtual string toString(void);
};

class Functy {
    public:
        Label *label;
        Tac *head;
        Tac *tail;
        Temp *currentThis;
        vector <int> *paramRegs;
        vector <int> *actualRegs;
        Function *sym;

        Functy(void);

        /// \brief search the closest constant assign tac take target temp as left hand(op0) before tail
        /// \param src target temp
        /// \param tail search region
        /// \return constant assign tac related to target temp
        virtual Tac *search(Temp *src, Tac *tail);
};

class VTable {
    public:
        string name;
        VTable *parent;
        string className;
        vector <Label *> *entries;
        VTable(void);
};

class Tac {
    public:
        tacKind opc;
        Tac *prev;
        Tac *next;
        Temp *op0;
        Temp *op1;
        Temp *op2;
        Label *label;   ///< for jmp/mark
        VTable *vt;     ///< for LOAD VTBL
        string str;     ///< for emitStringConst

        /// \brief create Tac:
        Tac(tacKind opc, Temp *op0);

        /// \brief create Tac: a := op b
        Tac(tacKind opc, Temp *op0, Temp *op1);

        /// \brief create Tac: a := b op c
        Tac(tacKind opc, Temp *op0, Temp *op1, Temp *op2);

        /// \brief create Tac:
        Tac(tacKind opc, string str);

        /// \brief create Tac:
        Tac(tacKind opc, Temp *op0, string str);

        /// \brief create Tac:
        Tac(tacKind opc, Temp *op0, VTable *vt);

        /// \brief create Tac:
        Tac(tacKind opc, Label *label);

        /// \brief create Tac:
        Tac(tacKind opc, Temp *op0, Label *label);

        static Tac *emitAdd(Temp *dst, Temp *src1, Temp *src2);

        static Tac *emitSub(Temp *dst, Temp *src1, Temp *src2);

        static Tac *emitMul(Temp *dst, Temp *src1, Temp *src2);

        static Tac *emitDiv(Temp *dst, Temp *src1, Temp *src2);

        static Tac *emitMod(Temp *dst, Temp *src1, Temp *src2);

        static Tac *emitNeg(Temp *dst, Temp *src);

        static Tac *emitLAnd(Temp *dst, Temp *src1, Temp *src2);

        static Tac *emitLOr(Temp *dst, Temp *src1, Temp *src2);

        static Tac *emitLNot(Temp *dst, Temp *src);

        static Tac *emitGtr(Temp *dst, Temp *src1, Temp *src2);

        static Tac *emitGeq(Temp *dst, Temp *src1, Temp *src2);

        static Tac *emitEqu(Temp *dst, Temp *src1, Temp *src2);

        static Tac *emitNeq(Temp *dst, Temp *src1, Temp *src2);

        static Tac *emitLeq(Temp *dst, Temp *src1, Temp *src2);

        static Tac *emitLes(Temp *dst, Temp *src1, Temp *src2);

        static Tac *emitAssign(Temp *dst, Temp *src);

        static Tac *emitLoadVtbl(Temp *dst, VTable *vt);

        static Tac *emitIndirectCall(Temp *dst, Temp *func);

        static Tac *emitDirectCall(Temp *dst, Label *func);

        static Tac *emitReturn(Temp *src);

        static Tac *emitJmp(Label *label);

        static Tac *emitBeqz(Temp *cond, Label *label);

        static Tac *emitBnez(Temp *cond, Label *label);

        static Tac *emitLoad(Temp *dst, Temp *base, Temp *offset);

        static Tac *emitStore(Temp *src, Temp *base, Temp *offset);

        static Tac *emitLoadImm4(Temp *dst, Temp *val);

        static Tac *emitLoadStrConst(Temp *dst, string str);

        static Tac *emitMark(Label *label);

        static Tac *emitParm(Temp *src);

        virtual string binanyOpToString(string op);

        virtual string unaryOpToString(string op);

        virtual string toString(void);
};

#endif /* !IR_TAC_H */
