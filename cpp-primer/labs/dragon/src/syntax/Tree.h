/*!
 * \file Tree.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#ifndef SYNTAX_TREE_H
#define SYNTAX_TREE_H

#include <iostream>
#include "location.h"
#include "libs/List.h"
#include "syntax/AstPrinter.h"

/// \brief enum variable for kind of ast node
typedef enum __astKind__ {
    PROGRAM,        ///< for program node(top node)
    CLASS_DEF,      ///< for class defination node
    FUNC_DEF,       ///< for function defination node
    VAR_DEF,        ///< for variable defination node
    STMT_BLOCK,     ///< for block node '{ block }'
    STMT_IF,        ///< for if statement node
    STMT_WHILE,     ///< for while loop statement node
    STMT_FOR,       ///< for for loop statement node
    STMT_RETURN,    ///< for return statement node
    STMT_PRINT,     ///< for print statement node
    EXEC,           ///< for exec(function call) node(wrapper for call node)
    NEWCLASS,       ///< for 'new' class(create a new class instance) node
    NEWARRAY,       ///< for 'new' array(create a new array(malloc)) node
    INDEXED,        ///< for array[index](array element reference) node
    IDENT,          ///< for identifier(variable reference) node 
    TYPE_BASIC,     ///< for type literal(int/bool/string) node
    TYPE_CLASS,     ///< for type literal(class) node
    TYPE_ARRAY,     ///< for type literal(array) node
    EXPR_ASSIGN,    ///< for assign expression node
    EXPR_NEG,       ///< for negative expression node
    EXPR_NOT,       ///< for not expression node
    EXPR_OR,        ///< for or expression node
    EXPR_AND,       ///< for and expression node
    EXPR_EQ,        ///< for equal expression node
    EXPR_NE,        ///< for not equal expression node
    EXPR_LT,        ///< for less than expression node
    EXPR_GT,        ///< for greater than expression node
    EXPR_LE,        ///< for less equal expression node
    EXPR_GE,        ///< for greater equal expression node
    EXPR_ADD,       ///< for add expression node
    EXPR_SUB,       ///< for substract expression node
    EXPR_MUL,       ///< for multiple expression node
    EXPR_DIV,       ///< for divide expression node
    EXPR_MOD,       ///< for modular expression node
    CONSTANT,       ///< for constant node
    CALLEXPR,       ///< for call expression node
    THISEXPR,       ///< for this reference expression node
    READINTEXPR,    ///< for readint() function call expression node
    READLINEEXPR,   ///< for readline() function call expression node
    TYPE_NIL,       ///< for null node
    TYPE_VOID,      ///< for type system
    TYPE_INT,       ///< for type system
    TYPE_BOOL,      ///< for type system
    TYPE_STRING     ///< for type system
} astKind ;

/// \brief enum variable for kind of left variable
typedef enum __lvKind__ {
    LOCAL_VAR,      ///< for local variable
    PARAM_VAR,      ///< for parameter variable
    MEMBER_VAR,     ///< for member variable
    ARRAY_ELEMENT   ///< for array element variable(array[index] reference)
} lvKind;

// forword defination
class Node;
class ClassDef;
class VarDef;
class Block;
class Expr;
class TypeLiteral;

// forword defination
class Visitor;

// forword defination(extern)
class Type;

// forword defination owing to circular reference
class Variable;
class Function;
class Class;

// forword defination owing to circular reference
class LocalScope;
class GlobalScope;

class Temp;

/// \brief basic node defination
///
/// base for ast node system
/// with simplest members set: kind(node kind),
///                             loc(location),
///                             type(node type)
/// with simplest functions set: constructor,
///                             accept(visit interface),
///                             print(print interface)
///
/// pattern: visit, composite, decorate
///
class Node {
    public:
        astKind kind;       ///< kind of node
        yyltype* loc;       ///< location information
        Type* type;         ///< type information

        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a node instance
        Node(astKind kind, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief program node
class Program:public Node {
    public:
        List <ClassDef *> *classes;     ///< class defination list
        Class *main;                    ///< symbol for main class
        GlobalScope *globalScope;       ///< global scope

        /// \brief constructor
        /// \param classes class defination list
        /// \param loc location
        /// \return a program instance
        Program(List <ClassDef *> *classes, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief class node
class ClassDef:public Node {
    public:
        char *name;             ///< class name
        char *parent;           ///< parent name
        List <Node *> *fields;  ///< member list
        Class *symbol;          ///< symbol binding

        /// \brief constructor
        /// \param name class name
        /// \param parent parent name
        /// \param fields member list
        /// \param loc location
        /// \return a class defination instance
        ClassDef(char *name, char *parent, List <Node *> *fields, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief function node
class FuncDef:public Node {
    public:
        char *name;                 ///< function name
        TypeLiteral *returnType;    ///< return type
        List <VarDef *> *formals;   ///< parameter list
        Block *body;                ///< function body
        Function *symbol;           ///< symbol binding

        /// \brief constructor
        /// \param name functino name
        /// \param returnType return type
        /// \param formals parameter list
        /// \param body function body
        /// \param loc location
        /// \return a function instance
        FuncDef(char *name, TypeLiteral *returnType, List <VarDef *> *formals, Block *body, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief variable node
class VarDef:public Node {
    public:
        char *name;         ///< variable name
        TypeLiteral *type;  ///< variable type
        Variable *symbol;   ///< symbol binding

        /// \brief constructor
        /// \param type variable type
        /// \param loc location
        /// \return a variable defination instance
        VarDef(char *name, TypeLiteral *type, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief block node
class Block:public Node {
    public:
        List <Node *> *block;           ///< statement list
        LocalScope *associatedScope;    ///< scope binding

        /// \brief constructor
        /// \param block statement list
        /// \param loc location
        /// \return a block instance
        Block(List <Node *> *block, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief while loop node
class WhileLoop:public Node {
    public:
        Expr *condition;    ///< condition expression
        Node *loopBody;     ///< loop body

        /// \brief constructor
        /// \param condition condition expression
        /// \param loopBody loop body
        /// \param loc location
        /// \return a while loop instance
        WhileLoop(Expr *condition, Node *loopBody, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief for loop node
class ForLoop:public Node {
    public:
        Node *init;     ///< initial expression
        Expr *condition;///< condition expression
        Node *update;   ///< update expression
        Node *loopBody; ///< loop body

        /// \brief constructor
        /// \param init initial expression
        /// \param condition condition expression
        /// \param update update expression
        /// \param loopBody loop body
        /// \param loc location
        /// \return a for loop instance
        ForLoop(Node *init, Expr *condition, Node *update, Node *loopBody, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief if statement node
class If:public Node {
    public:
        Expr *condition;    ///< condition expression
        Node *trueBranch;   ///< true branch
        Node *falseBranch;  ///< false branch

        /// \brief constructor
        /// \param condition condition expression
        /// \param trueBranch true branch
        /// \param falseBranch false branch 
        /// \param loc location
        /// \return a if instance
        If(Expr *condition, Node *trueBranch, Node *falseBranch, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief exec(function call) node
class Exec:public Node {
    public:
        Expr *expr; ///< call expression

        /// \brief constructor
        /// \param expr call expression
        /// \param loc location
        /// \return a exec instance
        Exec(Expr *expr, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief print function call node
class Print:public Node {
    public:
        List <Expr *> *exprs;   ///< parameter list(to print)

        /// \brief constructor
        /// \param exprs paramter list(to print)
        /// \param loc location
        /// \return a print instance
        Print(List <Expr *> *exprs, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief return statement node
class Return:public Node {
    public:
        Expr *expr; ///< return expression

        /// \brief constructor
        /// \param expr return expression
        /// \param loc location
        /// \return a return instance
        Return(Expr *expr, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief expression node(interface)
class Expr:public Node {
    public:
        Type *type;         ///< expression type
        Temp *val;          ///< temp binding(simply ir generation)
        bool isClass;       ///< mark whether it is a Class Name Type
        bool usedForRef;    ///< mark whether it is left value or not

        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a expression instance
        Expr(astKind kind, yyltype *loc);
};

/// \brief new class node
class NewClass:public Expr {
    public:
        char *className;    ///< class name
        Class *symbol;      ///< symbol bind

        /// \brief constructor
        /// \param className class name 
        /// \param loc location
        /// \return a new class instance
        NewClass(char *className, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief new array node
class NewArray:public Expr {
    public:
        TypeLiteral *elementType;   ///< array element type
        Expr *length;               ///< array max length

        /// \brief constructor
        /// \param elementType array element type 
        /// \param length array max length 
        /// \return a new array instance
        NewArray(TypeLiteral *elementType, Expr *length, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief left value node(interface)
class LValue:public Expr {
    public:
        lvKind kind;    ///< left value kind

        /// \brief constructor
        /// \param kind lvalue kind
        /// \param loc location
        /// \return a LValue instance
        LValue(astKind kind, yyltype *loc);
};

/// \brief assign node
class Assign:public Node {
    public:
        LValue *left;   ///< left value to assign
        Expr *expr;     ///< expression to evaluate

        /// \brief constructor
        /// \param left left value to assign 
        /// \param expr expression to evaluate 
        /// \param loc location information
        /// \return a assign instance
        Assign(LValue *left, Expr *expr, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief unary node
class Unary:public Expr {
    public:
        Expr *expr;

        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a node instance
        Unary(astKind kind, Expr *expr, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief binary node
class Binary:public Expr {
    public:
        Expr *left;
        Expr *right;

        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a node instance
        Binary(astKind kind, Expr *left, Expr *right, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief functino call node
class CallExpr:public Expr {
    public:
        Expr *receiver;
        char *method;
        List <Expr *> *actuals;
        Function *symbol;

        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a node instance
        CallExpr(Expr *receiver, char *method, List <Expr *> *actuals, yyltype *loc);
        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);
        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief readint function call node
class ReadIntExpr:public Expr {
    public:
        /// \brief constructor
        /// \param loc location
        /// \return a node instance
        ReadIntExpr(yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief readline function call node
class ReadLineExpr:public Expr {
    public:
        /// \brief constructor
        /// \param loc location
        /// \return a node instance
        ReadLineExpr(yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief this reference node
class ThisExpr:public Expr {
    public:
        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a node instance
        ThisExpr(yyltype *loc);
        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);
        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief array element reference node
class Indexed:public LValue {
    public:
        Expr *array;
        Expr *index;

        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a node instance
        Indexed(Expr *array, Expr *index, yyltype *loc);
        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);
        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief indentifier reference node
class Ident:public LValue {
    public:
        Expr *owner;
        char *name;
        Variable *symbol;
        bool isDefined;

        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a node instance
        Ident(Expr *owner, char *name, yyltype *loc);
        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);
        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief constant node
class Constant:public Expr {
    public:
        astKind typekind;
        int num_val;
        char *str_val;

        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a node instance
        Constant(astKind typekind, int num_val, yyltype *loc);
        Constant(astKind typekind, char *str_val, yyltype *loc);
        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);
        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief null node
class Null:public Expr {
    public:
        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a node instance
        Null(yyltype *loc);
        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);
        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief type literal node(distinguish from Type variable(type system))
class TypeLiteral:public Node {
    public:
        Type *type;

        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a node instance
        TypeLiteral(astKind kind, yyltype *loc);
};

/// \brief basic type node
class TypeBasic:public TypeLiteral {
    public:
        astKind typekind;

        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a node instance
        TypeBasic(astKind typekind, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief class type node
class TypeClass:public TypeLiteral {
    public:
        char *name;

        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a node instance
        TypeClass(char *name, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief array type node
class TypeArray:public TypeLiteral {
    public:
        TypeLiteral *elementType;

        /// \brief constructor
        /// \param kind node kind
        /// \param loc location
        /// \return a node instance
        TypeArray(TypeLiteral *elementType, yyltype *loc);

        /// \brief setup visitor
        /// \param v visitor where actual tree visit operating defination
        /// \return void
        virtual void accept(Visitor *v);

        /// \brief generate information of node
        /// \param ap AstPrinter to enable node to have capbility to print information
        /// \return void
        virtual void print(AstPrinter *ap);
};

/// \brief visitor 
///
/// in this class, define interface for every node visiting
/// with a visitor instance, overwrite specific interface function to change visit behavior
/// by visit pattern, it's conveninet to visit ast tree for multiple times in different behavior(such as build symbol or semantic analysis)
///
class Visitor {
    public:
        /// \brief this function won't get invoked ever
        void visitNode(Node *that);

        // below functions will get invoked

        virtual void visitProgram(Program *that);
        virtual void visitClassDef(ClassDef *that);
        virtual void visitFuncDef(FuncDef *that);
        virtual void visitVarDef(VarDef *that);
        virtual void visitBlock(Block *that);
        virtual void visitWhileLoop(WhileLoop *that);
        virtual void visitForLoop(ForLoop *that);
        virtual void visitIf(If *that);
        virtual void visitExec(Exec *that);
        virtual void visitReturn(Return *that);
        virtual void visitNewClass(NewClass *that);
        virtual void visitNewArray(NewArray *that);
        virtual void visitAssign(Assign *that);
        virtual void visitUnary(Unary *that);
        virtual void visitBinary(Binary *that);
        virtual void visitCallExpr(CallExpr *that);
        virtual void visitReadIntExpr(ReadIntExpr *that);
        virtual void visitReadLineExpr(ReadLineExpr *that);
        virtual void visitPrint(Print *that);
        virtual void visitThisExpr(ThisExpr *that);
        virtual void visitLValue(LValue *that);
        virtual void visitIndexed(Indexed *that);
        virtual void visitIdent(Ident *that);
        virtual void visitConstant(Constant *that);
        virtual void visitNull(Null *that);
        virtual void visitTypeBasic(TypeBasic*that);
        virtual void visitTypeClass(TypeClass *that);
        virtual void visitTypeArray(TypeArray *that);
};

#endif
