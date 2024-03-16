/*!
 * \file Tac.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "syntax/Type.h"
#include "semantic/Symbol.h"
#include "ir/Tac.h"

using namespace std;

int Label::labelCount = 0;
int Temp::tempCount = 0;
map<int, Temp*> *Temp::constTempPool = new map<int , Temp*>();

Label::Label(void) {
}

Label::Label(int id, string name, bool target) {
    this->id = id;
    this->name = name;
    this->target = target;
}

Label *Label::createLabel(void) {
    return createLabel(false);
}

Label *Label::createLabel(bool target) {
    int id = (Label::labelCount)++;
    return new Label(id, string("_L") + id, target);
}

Label *Label::createLabel(string name, bool target) {
    int id = (Label::labelCount)++;
    return new Label(id, name, target);
}

string Label::toString(void) {
    return name;
}

Temp::Temp(void) {
    offset = INT_MAX;
}

Temp::Temp(int id, string name, int size, int offset) {
    this->id = id;
    this->name = name;
    this->size = size;
    this->offset = offset;
}

Temp *Temp::createTempI4(void) {
    int id = (Temp::tempCount)++;
    return new Temp(id, string("_T") + id, 4, INT_MAX);
}

Temp *Temp::createConstTemp(int value) {
    map<int, Temp*>::iterator it = (Temp::constTempPool)->find(value);

    if (it == (Temp::constTempPool)->end()) {
        Temp *temp = new Temp();
        temp->isConst = true;
        temp->value = value;
        temp->name = itoa(value);
        (*(Temp::constTempPool))[value] = temp;
        return temp;
    } else {
        return it->second;
    }
}

/// \brief @Override
bool Temp::equals(Temp *temp) {
    return temp ? id == temp->id : 0;
}

/// \brief @Override
string Temp::toString(void) {
    return name;
}

Functy::Functy(void) {
    this->label = 0;
    this->head = 0;
    this->tail = 0;
    this->paramRegs = 0;
    this->actualRegs = 0;
    this->sym = 0;
}

Tac *Functy::search(Temp *src, Tac *tail) {
    Tac *trav = tail;

    while (trav != 0) {

        // found closest tac take src temp as op0
        if (trav->op0 && trav->op0->equals(src)) {
            switch (trav->opc) {
                case TAC_LOAD_IMM4:
                    // find constant
                    return trav;
                case TAC_ASSIGN:
                    // recursion to find constant
                    trav = search(trav->op1, trav);
                    return trav;
                default:
                    return 0;
            }
        }

        trav = trav->prev;
    }

    return 0;
}

VTable::VTable(void) {
    this->name = "";
    this->parent = 0;
    this->className = "";
    this->entries = 0;
}

Tac::Tac(tacKind opc, Temp *op0) {
    this->opc = opc;
    this->op0 = op0;
    this->op1 = 0;
    this->op2 = 0;
}

/// \brief create Tac: a := op b
Tac::Tac(tacKind opc, Temp *op0, Temp *op1) {
    this->opc = opc;
    this->op0 = op0;
    this->op1 = op1;
    this->op2 = 0;
}

/// \brief create Tac: a := b op c
Tac::Tac(tacKind opc, Temp *op0, Temp *op1, Temp *op2) {
    this->opc = opc;
    this->op0 = op0;
    this->op1 = op1;
    this->op2 = op2;
}

/// \brief create Tac: stringConst
Tac::Tac(tacKind opc, string str) {
    this->opc = opc;
    this->op0 = 0;
    this->op1 = 0;
    this->op2 = 0;
    this->str = str;
}

/// \brief create Tac:
Tac::Tac(tacKind opc, Temp *op0, string str) {
    this->opc = opc;
    this->op0 = op0;
    this->op1 = 0;
    this->op2 = 0;
    this->str = str;
}

/// \brief create Tac: LOAD_VTBL
Tac::Tac(tacKind opc, Temp *op0, VTable *vt) {
    this->opc = opc;
    this->op0 = op0;
    this->op1 = 0;
    this->op2 = 0;
    this->vt = vt;
}

/// \brief create Tac: jmp/mark
Tac::Tac(tacKind opc, Label *label) {
    this->opc = opc;
    this->op0 = 0;
    this->op1 = 0;
    this->op2 = 0;
    this->label = label;
}

/// \brief create Tac: beqz/bnez
Tac::Tac(tacKind opc, Temp *op0, Label *label) {
    this->opc = opc;
    this->op0 = op0;
    this->op1 = 0;
    this->op2 = 0;
    this->label = label;
}

Tac *Tac::emitAdd(Temp *dst, Temp *src1, Temp *src2) {
    return new Tac(TAC_ADD, dst, src1, src2);
}

Tac *Tac::emitSub(Temp *dst, Temp *src1, Temp *src2) {
    return new Tac(TAC_SUB, dst, src1, src2);
}

Tac *Tac::emitMul(Temp *dst, Temp *src1, Temp *src2) {
    return new Tac(TAC_MUL, dst, src1, src2);
}

Tac *Tac::emitDiv(Temp *dst, Temp *src1, Temp *src2) {
    return new Tac(TAC_DIV, dst, src1, src2);
}

Tac *Tac::emitMod(Temp *dst, Temp *src1, Temp *src2) {
    return new Tac(TAC_MOD, dst, src1, src2);
}

Tac *Tac::emitNeg(Temp *dst, Temp *src) {
    return new Tac(TAC_NEG, dst, src);
}

Tac *Tac::emitLAnd(Temp *dst, Temp *src1, Temp *src2) {
    return new Tac(TAC_AND, dst, src1, src2);
}

Tac *Tac::emitLOr(Temp *dst, Temp *src1, Temp *src2) {
    return new Tac(TAC_OR, dst, src1, src2);
}

Tac *Tac::emitLNot(Temp *dst, Temp *src) {
    return new Tac(TAC_NOT, dst, src);
}

Tac *Tac::emitGtr(Temp *dst, Temp *src1, Temp *src2) {
    return new Tac(TAC_GT, dst, src1, src2);
}

Tac *Tac::emitGeq(Temp *dst, Temp *src1, Temp *src2) {
    return new Tac(TAC_GE, dst, src1, src2);
}

Tac *Tac::emitEqu(Temp *dst, Temp *src1, Temp *src2) {
    return new Tac(TAC_EQ, dst, src1, src2);
}

Tac *Tac::emitNeq(Temp *dst, Temp *src1, Temp *src2) {
    return new Tac(TAC_NE, dst, src1, src2);
}

Tac *Tac::emitLeq(Temp *dst, Temp *src1, Temp *src2) {
    return new Tac(TAC_LE, dst, src1, src2);
}

Tac *Tac::emitLes(Temp *dst, Temp *src1, Temp *src2) {
    return new Tac(TAC_LT, dst, src1, src2);
}

Tac *Tac::emitAssign(Temp *dst, Temp *src) {
    return new Tac(TAC_ASSIGN, dst, src);
}

Tac *Tac::emitLoadVtbl(Temp *dst, VTable *vt) {
    return new Tac(TAC_LOAD_VTBL, dst, vt);
}

Tac *Tac::emitIndirectCall(Temp *dst, Temp *func) {
    return new Tac(TAC_INDIRECT_CALL, dst, func);
}

Tac *Tac::emitDirectCall(Temp *dst, Label *func) {
    return new Tac(TAC_DIRECT_CALL, dst, func);
}

Tac *Tac::emitReturn(Temp *src) {
    return new Tac(TAC_RETURN, src);
}

Tac *Tac::emitJmp(Label *label) {
    label->target = true;
    return new Tac(TAC_JMP, label);
}

Tac *Tac::emitBeqz(Temp *cond, Label *label) {
    label->target = true;
    return new Tac(TAC_BEQZ, cond, label);
}

Tac *Tac::emitBnez(Temp *cond, Label *label) {
    label->target = true;
    return new Tac(TAC_BNEZ, cond, label);
}

Tac *Tac::emitLoad(Temp *dst, Temp *base, Temp *offset) {
    if (!offset->isConst) {
        cout << "offset must be constant" << endl;
        exit(-1);
    }

    return new Tac(TAC_LOAD, dst, base, offset);
}

Tac *Tac::emitStore(Temp *src, Temp *base, Temp *offset) {
    if (!offset->isConst) {
        cout << "offset must be constant" << endl;
        exit(-1);
    }

    return new Tac(TAC_STORE, src, base, offset);
}

Tac *Tac::emitLoadImm4(Temp *dst, Temp *val) {
    if (!val->isConst) {
        cout << "value must be constant" << endl;
        exit(-1);
    }

    return new Tac(TAC_LOAD_IMM4, dst, val);
}

Tac *Tac::emitLoadStrConst(Temp *dst, string str) {
    return new Tac(TAC_LOAD_STR_CONST, dst, str);
}

Tac *Tac::emitMark(Label *label) {
    Tac *mark = new Tac(TAC_MARK, label);
    label->where = mark;
    return mark;
}

Tac *Tac::emitParm(Temp *src) {
    return new Tac(TAC_PARM, src);
}

string Tac::binanyOpToString(string op) {
    return op0->name + string(" := ") + op1->name + string(" ") + op + string(" ") + op2->name;
}

string Tac::unaryOpToString(string op) {
    return op0->name + string(" := ") + op + string(" ") + op1->name;
}

string Tac::toString(void) {
    switch (opc) {
        case TAC_ADD:
            return binanyOpToString("+");
        case TAC_SUB:
            return binanyOpToString("-");
        case TAC_MUL:
            return binanyOpToString("*");
        case TAC_DIV:
            return binanyOpToString("/");
        case TAC_MOD:
            return binanyOpToString("%");
        case TAC_NEG:
            return unaryOpToString("-");
        case TAC_AND:
            return binanyOpToString("&&");
        case TAC_OR:
            return binanyOpToString("||");
        case TAC_NOT:
            return unaryOpToString("!");
        case TAC_GT:
            return binanyOpToString(">");
        case TAC_GE:
            return binanyOpToString(">=");
        case TAC_EQ:
            return binanyOpToString("==");
        case TAC_NE:
            return binanyOpToString("!=");
        case TAC_LE:
            return binanyOpToString("<=");
        case TAC_LT:
            return binanyOpToString("<");
        case TAC_ASSIGN:
            return op0->name + string(" := ") + op1->name;
        case TAC_LOAD_VTBL:
            return op0->name + string(" := VTBL <") + vt->name + string(">");
        case TAC_INDIRECT_CALL:
            if (op0 != 0) {
                return op0->name + string(" := ") + string(" call ") + op1->name;
            } else {
                return string("call ") + op1->name;
            }
        case TAC_DIRECT_CALL:
            if (op0 != 0) {
                return op0->name + string(" := ") + string(" call ") + label->name;
            } else {
                return string("call ") + label->name;
            }
        case TAC_RETURN:
            if (op0 != 0) {
                return string("return ") + op0->name;
            } else {
                return string("return <empty>");
            }
        case TAC_JMP:
            return string("jmp ") + label->name;
        case TAC_BEQZ:
            return string("if (") + op0->name + string(" == 0) jmp ") + label->name;
        case TAC_BNEZ:
            return string("if (") + op0->name + string(" != 0) jmp ") + label->name;
        case TAC_LOAD:
            if (op2->value >= 0) {
                return op0->name + string(" := *(") + op1->name + string(" + ") + op2->value + string(")");
            } else {
                return op0->name + string(" := *(") + op1->name + string(" - ") + (-op2->value) + string(")");
            }
        case TAC_STORE:
            if (op2->value >= 0) {
                return string("*(") + op1->name + string(" + ") + op2->value + string(") := ") + op0->name;
            } else {
                return string("*(") + op1->name + string(" - ") + (-op2->value) + string(") := ") + op0->name;
            }
        case TAC_LOAD_IMM4:
            return op0->name + string(" := ") + op1->value;
        case TAC_LOAD_STR_CONST:
            return op0->name + string(" := ") + string("LOAD ") + str;
        case TAC_MARK:
            return label->name + string(":");
        case TAC_PARM:
            return string("parm ") + op0->name;
        default:
            return "";
            break;
    }
}
