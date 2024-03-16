/*!
 * \file Tree.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "syntax/Type.h"
#include "semantic/Scope.h"
#include "semantic/Symbol.h"
#include "ir/Tac.h"
#include "syntax/Tree.h"

using namespace std;

Node::Node(astKind kind, yyltype *loc) {
    this->kind = kind;
    this->loc = loc;
}

void Node::accept(Visitor *v) {
    v->visitNode(this);
}

void Node::print(AstPrinter *ap) {
    ap->print("node");
}

Program::Program(List <ClassDef *> *classes, yyltype *loc): Node(PROGRAM, loc) {
    this->classes = classes;
}

void Program::accept(Visitor *v) {
    v->visitProgram(this);
}

void Program::print(AstPrinter *ap) {
    ap->print("program");
    ap->incIndent();

    for (int i = 0; i < classes->size(); i++) {
        (*classes)[i]->print(ap);
    }

    ap->decIndent();
}

ClassDef::ClassDef(char *name, char *parent, List <Node *> *fields, yyltype *loc): Node(CLASS_DEF, loc) {
    this->name = name;
    this->parent = parent;
    this->fields = fields;
}

void ClassDef::accept(Visitor *v) {
    v->visitClassDef(this);
}

void ClassDef::print(AstPrinter *ap) {
    ap->print("class-><%s, %s>", name, parent);
    ap->incIndent();

    for (int i = 0; i < fields->size(); i++) {
        (*fields)[i]->print(ap);
    }

    ap->decIndent();
}

FuncDef::FuncDef(char *name, TypeLiteral *returnType, List <VarDef *> *formals, Block *body, yyltype *loc): Node(FUNC_DEF, loc) {
    this->name = name;
    this->returnType = returnType;
    this->formals = formals;
    this->body = body;
}

void FuncDef::accept(Visitor *v) {
    v->visitFuncDef(this);
}

void FuncDef::print(AstPrinter *ap) {
    ap->print("func->%s", name);

    returnType->print(ap);
    ap->print("");

    ap->incIndent();
    ap->print("formals->");
    ap->incIndent();

    for (int i = 0; i < formals->size(); i++) {
        (*formals)[i]->print(ap);
    }

    ap->decIndent();
    body->print(ap);
    ap->decIndent();
}

VarDef::VarDef(char *name, TypeLiteral *type, yyltype *loc): Node(VAR_DEF, loc) {
    this->name = name;
    this->type = type;
}

void VarDef::accept(Visitor *v) {
    v->visitVarDef(this);
}

void VarDef::print(AstPrinter *ap) {
    ap->print("vardef->%s", name);
    type->print(ap);
    ap->print("");
}

Block::Block(List <Node *> *block, yyltype *loc): Node(STMT_BLOCK, loc) {
    this->block = block;
}

void Block::accept(Visitor *v) {
    v->visitBlock(this);
}

void Block::print(AstPrinter *ap) {
    ap->print("stmtblock->");
    ap->incIndent();

    for (int i = 0;i < block->size(); i++) {
        (*block)[i]->print(ap);
    }

    ap->decIndent();
}

WhileLoop::WhileLoop(Expr *condition, Node *loopBody, yyltype *loc): Node(STMT_WHILE, loc) {
    this->condition = condition;
    this->loopBody = loopBody;
}

void WhileLoop::accept(Visitor *v) {
    v->visitWhileLoop(this);
}

void WhileLoop::print(AstPrinter *ap) {
    ap->print("while->");
    ap->incIndent();

    condition->print(ap);

    if (loopBody != 0) {
        loopBody->print(ap);
    }

    ap->decIndent();
}

ForLoop::ForLoop(Node *init, Expr *condition, Node *update, Node *loopBody, yyltype *loc): Node(STMT_FOR, loc) {
    this->init = init;
    this->condition = condition;
    this->update = update;
    this->loopBody = loopBody;
}

void ForLoop::accept(Visitor *v) {
    v->visitForLoop(this);
}

void ForLoop::print(AstPrinter *ap) {
    ap->print("for->");
    ap->incIndent();

    if (init != 0) {
        init->print(ap);
    } else {
        ap->print("<emtpy>");
    }

    condition->print(ap);

    if (update != 0) {
        update->print(ap);
    } else {
        ap->print("<empty>");
    }

    if (loopBody != 0) {
        loopBody->print(ap);
    }

    ap->decIndent();
}

If::If(Expr *condition, Node *trueBranch, Node *falseBranch, yyltype *loc): Node(STMT_IF, loc) {
    this->condition = condition;
    this->trueBranch = trueBranch;
    this->falseBranch = falseBranch;
}

void If::accept(Visitor *v) {
    v->visitIf(this);
}

void If::print(AstPrinter *ap) {
    ap->print("if->");
    ap->incIndent();

    condition->print(ap);

    if (trueBranch != 0) {
        trueBranch->print(ap);
    }

    ap->decIndent();

    if (falseBranch != 0) {
        ap->print("else");
        ap->incIndent();
        falseBranch->print(ap);
        ap->decIndent();
    }
}

Exec::Exec(Expr *expr, yyltype *loc): Node(EXEC, loc) {
    this->expr = expr;
}

void Exec::accept(Visitor *v) {
    v->visitExec(this);
}

void Exec::print(AstPrinter *ap) {
    expr->print(ap);
}

Print::Print(List <Expr *> *exprs, yyltype *loc): Node(STMT_PRINT, loc) {
    this->exprs = exprs;
}

void Print::accept(Visitor *v) {
    v->visitPrint(this);
}

void Print::print(AstPrinter *ap) {
    ap->print("print->");
    ap->incIndent();

    for (int i = 0; i < exprs->size(); i++) {
        (*exprs)[i]->print(ap);
    }

    ap->decIndent();
}

Return::Return(Expr *expr, yyltype *loc): Node(STMT_RETURN, loc) {
    this->expr = expr;
}

void Return::accept(Visitor *v) {
    v->visitReturn(this);
}

void Return::print(AstPrinter *ap) {
    ap->print("return->");

    if (expr != 0) {
        ap->incIndent();
        expr->print(ap);
        ap->decIndent();
    }
}

Expr::Expr(astKind kind, yyltype *loc): Node(kind, loc) {
    /* empty */
}

NewClass::NewClass(char *className, yyltype *loc): Expr(NEWCLASS, loc) {
    this->className = className;
}

void NewClass::accept(Visitor *v) {
    v->visitNewClass(this);
}

void NewClass::print(AstPrinter *ap) {
    ap->print("newclass->%s", className);
}

NewArray::NewArray(TypeLiteral *elementType, Expr *length, yyltype *loc): Expr(NEWARRAY, loc) {
    this->elementType = elementType;
    this->length = length;
}

void NewArray::accept(Visitor *v) {
    v->visitNewArray(this);
}

void NewArray::print(AstPrinter *ap) {
    ap->print("newarray->");
    elementType->print(ap);
    ap->print("");
    ap->incIndent();

    length->print(ap);

    ap->decIndent();
}

LValue::LValue(astKind kind, yyltype *loc): Expr(kind, loc) {
    /* empty */
}

Assign::Assign(LValue *left, Expr *expr, yyltype *loc): Node(EXPR_ASSIGN, loc) {
    this->left = left;
    this->expr = expr;
}

void Assign::accept(Visitor *v) {
    v->visitAssign(this);
}

void Assign::print(AstPrinter *ap) {
    ap->print("assign->");
    ap->incIndent();

    left->print(ap);
    expr->print(ap);

    ap->decIndent();
}

Unary::Unary(astKind kind, Expr *expr, yyltype *loc): Expr(kind, loc) {
    this->expr = expr;
}

void Unary::accept(Visitor *v) {
    v->visitUnary(this);
}

void Unary::print(AstPrinter *ap) {
    switch (kind) {
        case EXPR_NEG:
            ap->print("neg->");
            break;
        case EXPR_NOT:
            ap->print("not->");
            break;
        default:
            break;
    }

    ap->incIndent();

    expr->print(ap);

    ap->decIndent();
}

Binary::Binary(astKind kind, Expr *left, Expr *right, yyltype *loc): Expr(kind, loc) {
    this->left = left;
    this->right = right;
}

void Binary::accept(Visitor *v) {
    v->visitBinary(this);
}

void Binary::print(AstPrinter *ap) {
    switch (kind) {
        case EXPR_ADD:
            ap->print("+ ->");
            break;
        case EXPR_SUB:
            ap->print("- ->");
            break;
        case EXPR_MUL:
            ap->print("* ->");
            break;
        case EXPR_DIV:
            ap->print("/ ->");
            break;
        case EXPR_MOD:
            ap->print("% ->");
            break;
        case EXPR_AND:
            ap->print("&&->");
            break;
        case EXPR_OR:
            ap->print("||->");
            break;
        case EXPR_EQ:
            ap->print("==->");
            break;
        case EXPR_NE:
            ap->print("!=->");
            break;
        case EXPR_LT:
            ap->print("< ->");
            break;
        case EXPR_LE:
            ap->print("<=->");
            break;
        case EXPR_GT:
            ap->print("> ->");
            break;
        case EXPR_GE:
            ap->print(">=->");
            break;
        default:
            break;
    }

    ap->incIndent();

    left->print(ap);
    right->print(ap);

    ap->decIndent();
}

CallExpr::CallExpr(Expr *receiver, char *method, List <Expr *> *actuals, yyltype *loc): Expr(CALLEXPR, loc) {
    this->receiver = receiver;
    this->method = method;
    this->actuals = actuals;
}

void CallExpr::accept(Visitor *v) {
    v->visitCallExpr(this);
}

void CallExpr::print(AstPrinter *ap) {
    ap->print("call->%s", method);
    ap->incIndent();

    if (receiver != 0) {
        receiver->print(ap);
    } else {
        ap->print("<empty>");
    }

    for (int i = 0; i < actuals->size(); i++) {
        (*actuals)[i]->print(ap);
    }

    ap->decIndent();
}

ReadIntExpr::ReadIntExpr(yyltype *loc): Expr(READINTEXPR, loc) {
    /* empty */
}

void ReadIntExpr::accept(Visitor *v) {
    v->visitReadIntExpr(this);
}

void ReadIntExpr::print(AstPrinter *ap) {
    ap->print("readint");
}

ReadLineExpr::ReadLineExpr(yyltype *loc): Expr(READLINEEXPR, loc) {
    /* empty */
}

void ReadLineExpr::accept(Visitor *v) {
    v->visitReadLineExpr(this);
}

void ReadLineExpr::print(AstPrinter *ap) {
    ap->print("readline");
}

ThisExpr::ThisExpr(yyltype *loc): Expr(THISEXPR, loc) {
    /* empty */
}

void ThisExpr::accept(Visitor *v) {
    v->visitThisExpr(this);
}

void ThisExpr::print(AstPrinter *ap) {
    ap->print("this");
}

Indexed::Indexed(Expr *array, Expr *index, yyltype *loc): LValue(INDEXED, loc) {
    this->array = array;
    this->index = index;
}

void Indexed::accept(Visitor *v) {
    v->visitIndexed(this);
}

void Indexed::print(AstPrinter *ap) {
    ap->print("lvalue_index->");
    ap->incIndent();

    array->print(ap);
    index->print(ap);

    ap->decIndent();
}

Ident::Ident(Expr *owner, char *name, yyltype *loc): LValue(IDENT, loc) {
    this->owner = owner;
    this->name = name;
}

void Ident::accept(Visitor *v) {
    v->visitIdent(this);
}

void Ident::print(AstPrinter *ap) {
    ap->print("lvalue_ident->%s", name);

    if (owner != 0) {
        ap->incIndent();
        owner->print(ap);
        ap->decIndent();
    }
}

Constant::Constant(astKind typekind, int num_val, yyltype *loc): Expr(CONSTANT, loc) {
    this->typekind = typekind ;
    this->num_val = num_val;
}

Constant::Constant(astKind typekind, char *str_val, yyltype *loc): Expr(CONSTANT, loc) {
    this->typekind = typekind ;
    this->str_val = str_val;
}

void Constant::accept(Visitor *v) {
    v->visitConstant(this);
}

void Constant::print(AstPrinter *ap) {
    switch (typekind) {
        case TYPE_INT:
            ap->print("intconst->%d", num_val);
            break;
        case TYPE_BOOL:
            ap->print("boolconst->%d", num_val);
            break;
        default:
            ap->print("stringconst->%s", str_val);
            break;
    }
}

Null::Null(yyltype *loc): Expr(TYPE_NIL, loc) {
    /* empty */
}

void Null::accept(Visitor *v) {
    v->visitNull(this);
}

void Null::print(AstPrinter *ap) {
    ap->print("null");
}

TypeLiteral::TypeLiteral(astKind kind, yyltype *loc): Node(kind, loc) {
    /* empty */
}

TypeBasic::TypeBasic(astKind typekind, yyltype *loc): TypeLiteral(TYPE_BASIC, loc) {
    this->typekind = typekind;
}

void TypeBasic::accept(Visitor *v) {
    v->visitTypeBasic(this);
}

void TypeBasic::print(AstPrinter *ap) {
    switch (typekind){
        case TYPE_INT:
            ap->print("inttype");
            break;
        case TYPE_BOOL:
            ap->print("booltype");
            break;
        case TYPE_VOID:
            ap->print("voidtype");
            break;
        default:
            ap->print("stringtype");
            break;
    }
}

TypeClass::TypeClass(char *name, yyltype *loc): TypeLiteral(TYPE_CLASS, loc) {
    this->name = name;
}

void TypeClass::accept(Visitor *v) {
    v->visitTypeClass(this);
}

void TypeClass::print(AstPrinter *ap) {
    ap->print("classtype->%s", name);
}

TypeArray::TypeArray(TypeLiteral *elementType, yyltype *loc): TypeLiteral(TYPE_ARRAY, loc) {
    this->elementType = elementType;
}

void TypeArray::accept(Visitor *v) {
    v->visitTypeArray(this);
}

void TypeArray::print(AstPrinter *ap) {
    ap->print("arrtype->");
    elementType->print(ap);
}

void Visitor::visitNode(Node *that) {
    cout << that->kind;
}

void Visitor::visitProgram(Program *that) {
    cout << that->kind;
}

void Visitor::visitClassDef(ClassDef *that) {
    cout << that->kind;
}

void Visitor::visitFuncDef(FuncDef *that) {
    cout << that->kind;
}

void Visitor::visitVarDef(VarDef *that) {
    cout << that->kind;
}

void Visitor::visitBlock(Block *that) {
    cout << that->kind;
}

void Visitor::visitWhileLoop(WhileLoop *that) {
    cout << that->kind;
}

void Visitor::visitForLoop(ForLoop *that) {
    cout << that->kind;
}

void Visitor::visitIf(If *that) {
    cout << that->kind;
}

void Visitor::visitExec(Exec *that) {
    cout << that->kind;
}

void Visitor::visitReturn(Return *that) {
    cout << that->kind;
}

void Visitor::visitNewClass(NewClass *that) {
    cout << that->kind;
}

void Visitor::visitNewArray(NewArray *that) {
    cout << that->kind;
}

void Visitor::visitAssign(Assign *that) {
    cout << that->kind;
}

void Visitor::visitUnary(Unary *that) {
    cout << that->kind;
}

void Visitor::visitBinary(Binary *that) {
    cout << that->kind;
}

void Visitor::visitCallExpr(CallExpr *that) {
    cout << that->kind;
}

void Visitor::visitReadIntExpr(ReadIntExpr *that) {
    cout << that->kind;
}

void Visitor::visitReadLineExpr(ReadLineExpr *that) {
    cout << that->kind;
}

void Visitor::visitPrint(Print *that) {
    cout << that->kind;
}

void Visitor::visitThisExpr(ThisExpr *that) {
    cout << that->kind;
}

void Visitor::visitLValue(LValue *that) {
    cout << that->kind;
}

void Visitor::visitIndexed(Indexed *that) {
    cout << that->kind;
}

void Visitor::visitIdent(Ident *that) {
    cout << that->kind;
}

void Visitor::visitConstant(Constant *that) {
    cout << that->kind;
}

void Visitor::visitNull(Null *that) {
    cout << that->kind;
}

void Visitor::visitTypeBasic(TypeBasic*that) {
    cout << that->kind;
}

void Visitor::visitTypeClass(TypeClass *that) {
    cout << that->kind;
}

void Visitor::visitTypeArray(TypeArray *that) {
    cout << that->kind;
}
