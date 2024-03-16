/*!
 * \file Translater.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "Translater.h"

using namespace std;

Translater::Translater(void) {
    vtables = new List<VTable *>();
    funcs = new List<Functy *>();
}

Translater *Translater::translate(Program *tree) {
    Translater *tr = new Translater();
    TransPass1 *tp1 = new TransPass1(tr);
    tp1->visitProgram(tree);
    TransPass2 *tp2 = new TransPass2(tr);
    tp2->visitProgram(tree);
    return tr;
}

void Translater::print(AstPrinter *ap) {
    for (int i = 0; i < vtables->size(); i++) {
        VTable *vt = (*vtables)[i];
        ap->print("vtable (" + vt->name + ") { " + vt->className + ":" + (vt->parent ? vt->parent->name : ""));

        for (int i = 0; i < (int)vt->entries->size(); i++) {
            Label *l = (*(vt->entries))[i];
            ap->print("    " + l->name + ";");
        }

        ap->print("}");
        ap->print("");
    }

    for (int i = 0; i < funcs->size(); i++) {
        Functy *ft = (*funcs)[i];
        ap->print("function (" + ft->label->name + ") {");
        Tac *tac = ft->head;

        while (tac != 0) {
            if (tac->opc == TAC_MARK) {
                ap->print(tac->toString());
            } else {
                ap->print("    " + tac->toString());
            }
            tac = tac->next;
        }

        ap->print("}");
        ap->print("");
    }
}

Functy *Translater::createFuncty(Function *func) {
    Functy *functy = new Functy();

    if (func->isMain) {
        functy->label = Label::createLabel("main", true);
    } else {
        functy->label = Label::createLabel("_"+ ((ClassScope *)func->definedIn)->owner->name + "." + func->name, true);
    }

    // bind tac to symbol
    functy->sym = func;
    func->functy = functy;

    return functy;
}

void Translater::beginFunc(Function *func) {
    currentFuncty = func->functy;

    // M-> epsilon
    emitMark(func->functy->label);
}

void Translater::endFunc(void) {
    funcs->append(currentFuncty);

    // set up true complete tac list
    currentFuncty->head->prev = 0;
    currentFuncty->tail->next = 0;

    // reset currentFuncty
    currentFuncty = 0;
}

void Translater::createVTable(Class *c) {
    if (c->vtable != 0) {
        return;
    }

    VTable *vtable = new VTable();
    vtable->className = c->name;
    vtable->name = "_" + c->name;
    vtable->entries = new vector<Label *>(c->numFunc);

    fillVTableEntries(vtable, c->associatedScope);

    // bind vtable to symbol
    c->vtable = vtable;

    vtables->append(vtable);
}

void Translater::fillVTableEntries(VTable *vt, ClassScope *cs) {
    // add field in parent to vatale
    // in lower address
    if (cs->getParentScope() != 0) {
        fillVTableEntries(vt, cs->getParentScope());
    }

    for (map<string, Symbol *>::iterator it = cs->symbols->begin();
            it != cs->symbols->end(); it++) {
        Symbol *sym = it->second;

        // add method to vtable
        // in higher address
        if (sym->isFunction()) {
            Function *func = (Function *) sym;
            (*vt->entries)[func->order] = func->functy->label;
        }
    }
}

void Translater::append(Tac *tac) {
    if (currentFuncty->head == 0) {
        currentFuncty->head = currentFuncty->tail = tac;
    } else {
        // insert tac at tail
        tac->prev = currentFuncty->tail;
        currentFuncty->tail->next = tac;
        currentFuncty->tail = tac;
    }
}

Temp *Translater::emitAdd(Temp *src1, Temp *src2) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitAdd(dst, src1, src2));
    return dst;
}

Temp *Translater::emitSub(Temp *src1, Temp *src2) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitSub(dst, src1, src2));
    return dst;
}

Temp *Translater::emitMul(Temp *src1, Temp *src2) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitMul(dst, src1, src2));
    return dst;
}

Temp *Translater::emitDiv(Temp *src1, Temp *src2) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitDiv(dst, src1, src2));
    return dst;
}

Temp *Translater::emitMod(Temp *src1, Temp *src2) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitMod(dst, src1, src2));
    return dst;
}

Temp *Translater::emitNeg(Temp *src) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitNeg(dst, src));
    return dst;
}

Temp *Translater::emitLAnd(Temp *src1, Temp *src2) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitLAnd(dst, src1, src2));
    return dst;
}

Temp *Translater::emitLOr(Temp *src1, Temp *src2) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitLOr(dst, src1, src2));
    return dst;
}

Temp *Translater::emitLNot(Temp *src) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitLNot(dst, src));
    return dst;
}

Temp *Translater::emitGtr(Temp *src1, Temp *src2) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitGtr(dst, src1, src2));
    return dst;
}

Temp *Translater::emitGeq(Temp *src1, Temp *src2) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitGeq(dst, src1, src2));
    return dst;
}

Temp *Translater::emitEqu(Temp *src1, Temp *src2) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitEqu(dst, src1, src2));
    return dst;
}

Temp *Translater::emitNeq(Temp *src1, Temp *src2) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitNeq(dst, src1, src2));
    return dst;
}

Temp *Translater::emitLeq(Temp *src1, Temp *src2) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitLeq(dst, src1, src2));
    return dst;
}

Temp *Translater::emitLes(Temp *src1, Temp *src2) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitLes(dst, src1, src2));
    return dst;
}

void Translater::emitAssign(Temp *dst, Temp *src) {
    append(Tac::emitAssign(dst, src));
}

Temp *Translater::emitLoadVTable(VTable *vtbl) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitLoadVtbl(dst, vtbl));
    return dst;
}

Temp *Translater::emitIndirectCall(Temp *func, Type *retType) {
    Temp *dst;

    if (retType->equals(BaseType::VOID)) {
        dst = 0;
    } else {
        dst = Temp::createTempI4();
    }

    append(Tac::emitIndirectCall(dst, func));
    return dst;
}

Temp *Translater::emitDirectCall(Label *func, Type *retType) {
    Temp *dst;

    if (retType->equals(BaseType::VOID)) {
        dst = 0;
    } else {
        dst = Temp::createTempI4();
    }

    append(Tac::emitDirectCall(dst, func));
    return dst;
}

void Translater::emitReturn(Temp *src) {
    append(Tac::emitReturn(src));
}

void Translater::emitJmp(Label *dst) {
    append(Tac::emitJmp(dst));
}

void Translater::emitBeqz(Temp *cond, Label *dst) {
    append(Tac::emitBeqz(cond, dst));
}

void Translater::emitBnez(Temp *cond, Label *dst) {
    append(Tac::emitBnez(cond, dst));
}

Temp *Translater::emitLoad(Temp *base, int offset) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitLoad(dst, base, Temp::createConstTemp(offset)));
    return dst;
}

void Translater::emitStore(Temp *src, Temp *base, int offset) {
    append(Tac::emitStore(src, base, Temp::createConstTemp(offset)));
}

Temp *Translater::emitLoadImm4(int imm) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitLoadImm4(dst, Temp::createConstTemp(imm)));
    return dst;
}

Temp *Translater::emitLoadStrConst(string value) {
    Temp *dst = Temp::createTempI4();
    append(Tac::emitLoadStrConst(dst, value));
    return dst;
}

void Translater::emitMark(Label *label) {
    append(Tac::emitMark(label));
}

void Translater::emitParm(Temp *parm) {
    append(Tac::emitParm(parm));
}

Temp *Translater::emitNewArray(Temp *length) {
    Temp *unit = emitLoadImm4(WORD_SIZE);
    Temp *size = emitAdd(unit, emitMul(unit, length));

    // push size into call stack
    emitParm(size);

    // call allocation
    Temp *obj = emitDirectCall(LibFunction::MALLOC->label, BaseType::INT);

    // store return pointer
    emitStore(length, obj, 0);

    // initialize array elements to zero
    Label *loop = Label::createLabel();
    Label *exit = Label::createLabel();

    // zero
    Temp *zero = emitLoadImm4(0);

    // obj = obj + size
    // limit address
    append(Tac::emitAdd(obj, obj, size));

    emitMark(loop);
    // size--
    append(Tac::emitSub(size, size, unit));
    // condition
    emitBeqz(size, exit);
    // obj--
    append(Tac::emitSub(obj, obj, unit));
    // set to zero
    emitStore(zero, obj, 0);
    emitJmp(loop);
    emitMark(exit);

    return obj;
}

/// \brief treat constructor of class('new') as functions
void Translater::emitNewForClass(Class *c) {
        if (c->name != "Main") {

        currentFuncty = new Functy();
        currentFuncty->label = Label::createLabel("_" + c->name + "_" + "New", true);

        // bind functy to symbol
        c->newFuncLabel = currentFuncty->label;

        emitMark(currentFuncty->label);

        // call allocation
        Temp *size = emitLoadImm4(c->size);
        emitParm(size);
        Temp *newObj = emitDirectCall(LibFunction::MALLOC->label, BaseType::INT);

        int time = c->size / WORD_SIZE - 1;

        if (time != 0) {
            Temp *zero = emitLoadImm4(0);

            for (int i = 0; i < time; i++) {
                // initialize fields to zero
                emitStore(zero, newObj, WORD_SIZE * (i + 1));
            }
        }

        // store vtable reference at offset[0]
        emitStore(emitLoadVTable(c->vtable), newObj, 0);
        // return 'this' pointer
        emitReturn(newObj);

        endFunc();
    }
}

TransPass1::TransPass1(Translater *tr) {
    this->tr = tr;
    vars = new vector<Variable *>();
}

/// \breif @Override
///
/// create vtable and static constructor
///
void TransPass1::visitProgram(Program *program) {
    for (int i = 0; i < program->classes->size(); i++) {
        ClassDef *cd = (*(program->classes))[i];
        cd->accept(this);
    }

    for (int i = 0; i < program->classes->size(); i++) {
        ClassDef *cd = (*(program->classes))[i];
        // create vtable
        tr->createVTable(cd->symbol);
        // create static constructor
        tr->emitNewForClass(cd->symbol);
    }

    // bind vtable of father class to child class
    for (int i = 0; i < program->classes->size(); i++) {
        ClassDef *cd = (*(program->classes))[i];
        // has parent
        if (strcmp(cd->parent, "")) {
            cd->symbol->vtable->parent = cd->symbol->getParent()->vtable;
        }
    }
}

/// \breif @Override
///
/// calculate offset of fields
///
void TransPass1::visitClassDef(ClassDef *classDef) {
    // calculate order of vars and funcs
    classDef->symbol->resolveFieldOrder();

    objectSize = 0;
    vars->clear();

    for (int i = 0; i < classDef->fields->size(); i++) {
        Node *f = (*(classDef->fields))[i];
        f->accept(this);
    }

    sort(vars->begin(), vars->end(), ordercmp);

    // member offset
    OffsetCounter *oc = OffsetCounter::MEMBER_COUNTER;

    // field inheriting from father
    Class *c = classDef->symbol->getParent();
    if (c != 0) {
        oc->set(c->size);
    } else {
        oc->reset();
    }

    for (int i = 0; i < (int)vars->size(); i++) {
        (*vars)[i]->offset = oc->next(WORD_SIZE);
    }

    //initialize the class counter
    oc->reset();
}

/// \breif @Override
void TransPass1::visitFuncDef(FuncDef *funcDef) {
    Function *func = funcDef->symbol;

    // offset in vtable
    func->offset = 2 * POINTER_SIZE + func->order * POINTER_SIZE;

    // create functy
    Functy *ft = tr->createFuncty(func);
    ft->paramRegs = new vector<int>();

    // start calculate offset of parameters
    OffsetCounter *oc = OffsetCounter::PARAM_COUNTER;
    oc->reset();

    // 'this' parameter
    Variable *v = (Variable *) func->associatedScope->lookup("this");

    // set order
    v->order = 0;

    // bind 'this' to reg
    Temp* t = Temp::createTempI4();
    t->sym = v;
    t->isParam = true;
    v->temp = t;

    // bind 'this' temp to functy
    ft->currentThis = t;
    ft->paramRegs->push_back(t->id);

    // set 'this' offset
    v->offset = oc->next(POINTER_SIZE);
    t->offset = v->offset;

    int order = 1;
    for (int i = 0; i < funcDef->formals->size(); i++) {
        VarDef *vd = (*(funcDef->formals))[i];

        // set order
        vd->symbol->order = order++;

        // bind param to reg
        Temp *t = Temp::createTempI4();
        t->sym = vd->symbol;
        t->isParam = true;
        vd->symbol->temp = t;

        // bind param to functy
        ft->paramRegs->push_back(t->id);

        // set offset
        vd->symbol->offset = oc->next(vd->symbol->temp->size);
        t->offset = vd->symbol->offset;
    }
}

/// \breif @Override
void TransPass1::visitVarDef(VarDef *varDef) {
    vars->push_back(varDef->symbol);

    // increase object size(a var field occupy 4 bytes)
    objectSize += WORD_SIZE;
}

TransPass2::TransPass2(Translater *tr) {
    this->tr = tr;
    loopExits = new stack<Label *>();
}

/// \breif @Override
void TransPass2::visitProgram(Program *program) {
    for (int i = 0; i < program->classes->size(); i++) {
        ClassDef *cd = (*(program->classes))[i];
        cd->accept(this);
    }
}

/// \breif @Override
void TransPass2::visitClassDef(ClassDef *classDef) {
    for (int i = 0; i < classDef->fields->size(); i++) {
        Node *f = (*(classDef->fields))[i];
        f->accept(this);
    }
}

/// \breif @Override
void TransPass2::visitFuncDef(FuncDef *funcDef) {
    currentThis = ((Variable *)funcDef->symbol->associatedScope->lookup("this"))->temp;

    // translate function
    tr->beginFunc(funcDef->symbol);
    funcDef->body->accept(this);
    tr->endFunc();

    currentThis = 0;
}

/// \breif @Override
void TransPass2::visitVarDef(VarDef *varDef) {
    // bind reg to local variable(in stack)
    if (varDef->symbol->isLocalVar()) {
        Temp *t = Temp::createTempI4();
        t->sym = varDef->symbol;
        varDef->symbol->temp = t;
    }
}

/// \breif @Override
void TransPass2::visitBinary(Binary *expr) {
    // recursion
    expr->left->accept(this);
    expr->right->accept(this);

    // get closest assign tac take left/right expr as op0
    // Tac *left = tr->currentFuncty->search(expr->left->val, tr->currentFuncty->tail);
    // Tac *right = tr->currentFuncty->search(expr->right->val, tr->currentFuncty->tail);

    // bind reg to expr
    switch (expr->kind) {
        case EXPR_ADD:
            // constant folding
            if (expr->left->kind == CONSTANT && expr->right->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(((Constant *)(expr->left))->num_val + ((Constant *)(expr->right))->num_val);
            } else {
                expr->val = tr->emitAdd(expr->left->val, expr->right->val);
            }
            break;
        case EXPR_SUB:
            if (expr->left->kind == CONSTANT && expr->right->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(((Constant *)(expr->left))->num_val - ((Constant *)(expr->right))->num_val);
            } else {
                expr->val = tr->emitSub(expr->left->val, expr->right->val);
            }
            break;
        case EXPR_MUL:
            if (expr->left->kind == CONSTANT && expr->right->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(((Constant *)(expr->left))->num_val * ((Constant *)(expr->right))->num_val);
            } else {
                expr->val = tr->emitMul(expr->left->val, expr->right->val);
            }
            break;
        case EXPR_DIV:
            if (expr->left->kind == CONSTANT && expr->right->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(((Constant *)(expr->left))->num_val / ((Constant *)(expr->right))->num_val);
            } else {
                expr->val = tr->emitDiv(expr->left->val, expr->right->val);
            }
            break;
        case EXPR_MOD:
            if (expr->left->kind == CONSTANT && expr->right->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(((Constant *)(expr->left))->num_val % ((Constant *)(expr->right))->num_val);
            } else {
                expr->val = tr->emitMod(expr->left->val, expr->right->val);
            }
            break;
        case EXPR_AND:
            if (expr->left->kind == CONSTANT && expr->right->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(((Constant *)(expr->left))->num_val && ((Constant *)(expr->right))->num_val);
            } else {
                expr->val = tr->emitLAnd(expr->left->val, expr->right->val);
            }
            break;
        case EXPR_OR:
            if (expr->left->kind == CONSTANT && expr->right->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(((Constant *)(expr->left))->num_val || ((Constant *)(expr->right))->num_val);
            } else {
                expr->val = tr->emitLOr(expr->left->val, expr->right->val);
            }
            break;
        case EXPR_LT:
            if (expr->left->kind == CONSTANT && expr->right->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(((Constant *)(expr->left))->num_val < ((Constant *)(expr->right))->num_val);
            } else {
                expr->val = tr->emitLes(expr->left->val, expr->right->val);
            }
            break;
        case EXPR_LE:
            if (expr->left->kind == CONSTANT && expr->right->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(((Constant *)(expr->left))->num_val <= ((Constant *)(expr->right))->num_val);
            } else {
                expr->val = tr->emitLeq(expr->left->val, expr->right->val);
            }
            break;
        case EXPR_GT:
            if (expr->left->kind == CONSTANT && expr->right->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(((Constant *)(expr->left))->num_val > ((Constant *)(expr->right))->num_val);
            } else {
                expr->val = tr->emitGtr(expr->left->val, expr->right->val);
            }
            break;
        case EXPR_GE:
            if (expr->left->kind == CONSTANT && expr->right->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(((Constant *)(expr->left))->num_val >= ((Constant *)(expr->right))->num_val);
            } else {
                expr->val = tr->emitGeq(expr->left->val, expr->right->val);
            }
            break;
        case EXPR_EQ:
            if (expr->left->kind == CONSTANT && expr->right->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(((Constant *)(expr->left))->num_val == ((Constant *)(expr->right))->num_val);
            } else {
                expr->val = tr->emitEqu(expr->left->val, expr->right->val);
            }
        case EXPR_NE:
            if (expr->left->kind == CONSTANT && expr->right->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(((Constant *)(expr->left))->num_val != ((Constant *)(expr->right))->num_val);
            } else {
                expr->val = tr->emitNeq(expr->left->val, expr->right->val);
            }
            break;
        default:
            break;
    }
}

/// \breif @Override
void TransPass2::visitAssign(Assign *assign) {
    // recursion
    assign->left->accept(this);
    assign->expr->accept(this);

    switch (assign->left->kind) {
        case ARRAY_ELEMENT:
            {
                Indexed *arrayRef = (Indexed *) assign->left;

                // calculate offset address of array element
                Temp *esz = tr->emitLoadImm4(WORD_SIZE);
                Temp *t = tr->emitMul(arrayRef->index->val, esz);
                Temp *base = tr->emitAdd(arrayRef->array->val, t);

                tr->emitStore(assign->expr->val, base, 0);
            }
            break;
        case MEMBER_VAR:
            {
                Ident *varRef = (Ident *)assign->left;

                // class[offset]
                tr->emitStore(assign->expr->val, varRef->owner->val, varRef->symbol->offset);
            }
            break;
        case PARAM_VAR:
        case LOCAL_VAR:
            {
                // param & local variable already bind to reg, in TransPass1 and TransPass2
                tr->emitAssign(((Ident *)assign->left)->symbol->temp, assign->expr->val);
            }
            break;
        default:
            break;
    }
}

/// \breif @Override
void TransPass2::visitConstant(Constant *constant) {
    switch (constant->typekind) {
        case TYPE_INT:
            constant->val = tr->emitLoadImm4(constant->num_val);
            break;
        case TYPE_BOOL:
            constant->val = tr->emitLoadImm4(constant->num_val ? 1 : 0);
            break;
        default:
            constant->val = tr->emitLoadStrConst(string(constant->str_val));
            break;
    }
}

/// \breif @Override
void TransPass2::visitExec(Exec *exec) {
    exec->expr->accept(this);
}

/// \breif @Override
void TransPass2::visitUnary(Unary *expr) {
    expr->expr->accept(this);

    // Tac *t = tr->currentFuncty->search(expr->expr->val, tr->currentFuncty->tail);

    switch (expr->kind){
        case EXPR_NEG:
            if (expr->expr->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(-(((Constant *)(expr->expr))->num_val));
            } else {
                expr->val = tr->emitNeg(expr->expr->val);
            }
            break;
        default:
            if (expr->expr->kind == CONSTANT) {
                expr->val = tr->emitLoadImm4(!(((Constant *)(expr->expr))->num_val));
            } else {
                expr->val = tr->emitLNot(expr->expr->val);
            }
            break;
    }
}

/// \breif @Override
void TransPass2::visitNull(Null *nullExpr) {
    nullExpr->val = tr->emitLoadImm4(0);
}

/// \breif @Override
void TransPass2::visitBlock(Block *block) {
    for (int i = 0;i < block->block->size(); i++) {
        Node *s = (*(block->block))[i];
        s->accept(this);
    }
}

/// \breif @Override
void TransPass2::visitThisExpr(ThisExpr *thisExpr) {
    thisExpr->val = currentThis;
}

/// \breif @Override
void TransPass2::visitReadIntExpr(ReadIntExpr *readIntExpr) {
    readIntExpr->val = tr->emitDirectCall(LibFunction::READ_INT->label, BaseType::INT);
}

/// \breif @Override
void TransPass2::visitReadLineExpr(ReadLineExpr *readStringExpr) {
    readStringExpr->val = tr->emitDirectCall(LibFunction::READ_LINE->label, BaseType::STRING);
}

/// \breif @Override
void TransPass2::visitReturn(Return *returnStmt) {
    if (returnStmt->expr != 0) {
        returnStmt->expr->accept(this);
        tr->emitReturn(returnStmt->expr->val);
    } else {
        tr->emitReturn(0);
    }

}

/// \breif @Override
void TransPass2::visitPrint(Print *printStmt) {
    for (int i  = 0; i < printStmt->exprs->size(); i++) {
        Expr *r = (*(printStmt->exprs))[i];

        // emit parameter
        r->accept(this);
        tr->emitParm(r->val);
        if (r->type->equals(BaseType::BOOL)) {
            tr->emitDirectCall(LibFunction::PRINT_BOOL->label, BaseType::VOID);
        } else if (r->type->equals(BaseType::INT)) {
            tr->emitDirectCall(LibFunction::PRINT_INT->label, BaseType::VOID);
        } else if (r->type->equals(BaseType::STRING)) {
            tr->emitDirectCall(LibFunction::PRINT_STRING->label, BaseType::VOID);
        }
    }
}

/// \breif @Override
void TransPass2::visitIndexed(Indexed *indexed) {
    indexed->array->accept(this);
    indexed->index->accept(this);

    // calculate offset of element
    Temp *esz = tr->emitLoadImm4(WORD_SIZE);
    Temp *t = tr->emitMul(indexed->index->val, esz);
    Temp *base = tr->emitAdd(indexed->array->val, t);
    indexed->val = tr->emitLoad(base, 0);
}

/// \breif @Override
void TransPass2::visitIdent(Ident *ident) {
    if (ident->kind == MEMBER_VAR){
        ident->owner->accept(this);
    }

    switch (ident->kind ) {
        case MEMBER_VAR:
            // class[field offset]
            ident->val = tr->emitLoad(ident->owner->val, ident->symbol->offset);
            break;
        default:
            ident->val = ident->symbol->temp;
            break;
    }
}

/// \breif @Override
void TransPass2::visitCallExpr(CallExpr *callExpr) {
    if (callExpr->receiver != 0) {
        callExpr->receiver->accept(this);
    }

    for (int i = 0; i < callExpr->actuals->size(); i++) {
        Expr *expr = (*(callExpr->actuals))[i];
        expr->accept(this);
    }

    // push param from right to left
    for (int i = callExpr->actuals->size() - 1; i > -1; i--) {
        Expr *expr = (*(callExpr->actuals))[i];
        tr->emitParm(expr->val);
    }

    // push 'this' into call stack
    if (callExpr->receiver != 0) {
        tr->emitParm(callExpr->receiver->val);
    }

    // in semantic analysis, all methods invoking already bind to this(including implicit this)/class variable
    if (callExpr->receiver == 0) {
        callExpr->val = tr->emitDirectCall(callExpr->symbol->functy->label, callExpr->symbol->getReturnType());
    } else {
        // search vtable, get method reference
        Temp *vt = tr->emitLoad(callExpr->receiver->val, 0);        // get vtable address
        Temp *func = tr->emitLoad(vt, callExpr->symbol->offset);    // search method in vtable

        // invoke method
        callExpr->val = tr->emitIndirectCall(func, callExpr->symbol->getReturnType());
    }
}

/// \breif @Override
void TransPass2::visitForLoop(ForLoop *forLoop) {
    // initial expression
    if (forLoop->init != 0) {
        forLoop->init->accept(this);
    }

    // create label
    Label *cond = Label::createLabel();
    Label *loop = Label::createLabel();

    // emit condition branch
    tr->emitJmp(cond);

    // next mark( M -> epsilon )
    // when condition is true, jump here
    tr->emitMark(loop);

    // update expression
    if (forLoop->update != 0) {
        forLoop->update->accept(this);
    }

    // condition mark( M -> epsilon)
    // when loop body finish 1 time, jump here
    tr->emitMark(cond);
    forLoop->condition->accept(this);

    // exit loop
    Label *exit = Label::createLabel();
    tr->emitBeqz(forLoop->condition->val, exit);
    loopExits->push(exit);

    if (forLoop->loopBody != 0) {
        forLoop->loopBody->accept(this);
    }

    tr->emitJmp(loop);
    loopExits->pop();
    tr->emitMark(exit);
}

/// \breif @Override
void TransPass2::visitIf(If *ifStmt) {
    ifStmt->condition->accept(this);

    if (ifStmt->falseBranch != 0) {
        Label *falseLabel = Label::createLabel();
        tr->emitBeqz(ifStmt->condition->val, falseLabel);

        // fall through to true branch when condition is true
        ifStmt->trueBranch->accept(this);
        Label *exit = Label::createLabel();
        tr->emitJmp(exit);

        // M -> epsilon
        // when condition is false, jump here
        tr->emitMark(falseLabel);
        ifStmt->falseBranch->accept(this);

        // M -> epsilon
        // when true branch finish, jump here
        tr->emitMark(exit);
    } else if (ifStmt->trueBranch != 0) {
        Label *exit = Label::createLabel();
        tr->emitBeqz(ifStmt->condition->val, exit);

        if (ifStmt->trueBranch != 0) {
            ifStmt->trueBranch->accept(this);
        }

        // M -> epsilon
        // when true branch finish, jump here
        tr->emitMark(exit);
    }
}

/// \breif @Override
void TransPass2::visitWhileLoop(WhileLoop *whileLoop) {
    Label *loop = Label::createLabel();

    // M -> epsilon
    // when loop finish 1 time, jump here
    tr->emitMark(loop);

    whileLoop->condition->accept(this);

    Label *exit = Label::createLabel();
    tr->emitBeqz(whileLoop->condition->val, exit);
    loopExits->push(exit);

    if (whileLoop->loopBody != 0) {
        whileLoop->loopBody->accept(this);
    }

    tr->emitJmp(loop);
    loopExits->pop();

    // M -> epsilon
    // when condition is false, jump here
    tr->emitMark(exit);
}

/// \breif @Override
void TransPass2::visitNewArray(NewArray *newArray) {
    newArray->length->accept(this);
    newArray->val = tr->emitNewArray(newArray->length->val);
}

/// \breif @Override
void TransPass2::visitNewClass(NewClass *newClass) {
    newClass->val = tr->emitDirectCall(newClass->symbol->newFuncLabel,BaseType::INT);
}
