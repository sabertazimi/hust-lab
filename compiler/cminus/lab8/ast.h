#ifndef AST_H
#define AST_H

#include "list.h"

typedef char *string;

/////////////////////////////
// type
typedef enum Type_Kind_t{
  TYPE_INT,
  TYPE_BOOL
} Type_t;
void Type_print (Type_t);

//////////////////////////////
// dec
typedef struct Dec_t *Dec_t;
struct Dec_t
{
  Type_t type;
  char *id;
};
Dec_t Dec_new (Type_t, char *);
void Dec_print (Dec_t);

///////////////////////////////
// exp
enum Exp_Kind_t{
  EXP_INT,
  EXP_TRUE,
  EXP_FALSE,
  EXP_ID,
  EXP_ADD,
  EXP_SUB,
  EXP_TIMES,
  EXP_DIVIDE,
  EXP_AND,
  EXP_OR
};

typedef struct Exp_t *Exp_t;
struct Exp_t{
  enum Exp_Kind_t kind;
};
// all operations on "Exp"
void Exp_print (Exp_t exp);
int Exp_numNodes (Exp_t exp);

// n
typedef struct Exp_Int *Exp_Int;
struct Exp_Int
{
  enum Exp_Kind_t kind;
  int n;
};
Exp_t Exp_Int_new (int n);

// id
typedef struct Exp_Id *Exp_Id;
struct Exp_Id
{
  enum Exp_Kind_t kind;
  char *id;
};
Exp_t Exp_Id_new (char *id);

// true
typedef struct Exp_True *Exp_True;
struct Exp_True
{
  enum Exp_Kind_t kind;
};
Exp_t Exp_True_new ();

// false
typedef struct Exp_False *Exp_False;
struct Exp_False
{
  enum Exp_Kind_t kind;
};
Exp_t Exp_False_new ();

// +
typedef struct Exp_Add *Exp_Add;
struct Exp_Add
{
  enum Exp_Kind_t kind;
  Exp_t left;
  Exp_t right;
};
Exp_t Exp_Add_new ();

// -
typedef struct Exp_Sub *Exp_Sub;
struct Exp_Sub
{
  enum Exp_Kind_t kind;
  Exp_t left;
  Exp_t right;
};
Exp_t Exp_Sub_new ();

// *
typedef struct Exp_Times *Exp_Times;
struct Exp_Times
{
  enum Exp_Kind_t kind;
  Exp_t left;
  Exp_t right;
};
Exp_t Exp_Times_new ();

// /
typedef struct Exp_Divide *Exp_Divide;
struct Exp_Divide
{
  enum Exp_Kind_t kind;
  Exp_t left;
  Exp_t right;
};
Exp_t Exp_Divide_new ();

// &&
typedef struct Exp_And *Exp_And;
struct Exp_And
{
  enum Exp_Kind_t kind;
  Exp_t left;
  Exp_t right;
};
Exp_t Exp_And_new ();

// ||
typedef struct Exp_Or *Exp_Or;
struct Exp_Or
{
  enum Exp_Kind_t kind;
  Exp_t left;
  Exp_t right;
};
Exp_t Exp_Or_new ();

/////////////////////////////////////
// stm

enum Stm_Kind_t{
  STM_ASSIGN,
  STM_PRINTI,
  STM_PRINTB
};

typedef struct Stm_t *Stm_t;
struct Stm_t
{
  enum Stm_Kind_t kind;
};
void Stm_print (Stm_t);

// x = e;
typedef struct Stm_Assign *Stm_Assign;
struct Stm_Assign
{
  enum Stm_Kind_t kind;
  char *id;
  Exp_t exp;
};
Stm_t Stm_Assign_new (char *, Exp_t);

// printi (exp)
typedef struct Stm_Printi *Stm_Printi;
struct Stm_Printi
{
  enum Stm_Kind_t kind;
  Exp_t exp;
};
Stm_t Stm_Printi_new (Exp_t);

// printb (exp)
typedef struct Stm_Printb *Stm_Printb;
struct Stm_Printb
{
  enum Stm_Kind_t kind;
  Exp_t exp;
};
Stm_t Stm_Printb_new (Exp_t);

/////////////////////////////////////
// prog
typedef struct Prog_t *Prog_t;
struct Prog_t{
  List_t decs;  // List_t<Dec_t>
  List_t stms;   // List_t<Stm_t>
};
Prog_t Prog_new (List_t, List_t);
void Prog_print (Prog_t);

#endif
