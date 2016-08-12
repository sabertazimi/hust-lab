#include <stdio.h>
#include <stdlib.h>
#include "gen-stack.h"
#include "todo.h"
#include "list.h"

static List_t instrs = 0;
static void emit (Stack_Instr_t instr)
{
  instrs = List_new (instr, instrs);
  return;
}

////////////////////////////////
// decs
List_t gen_decs (List_t decs)
{
  List_t ids = 0;
  while (decs){
    Dec_t d = (Dec_t)decs->data;
    ids = List_new (d->id, ids);
    decs = decs->next;
  }
  return ids;
}

////////////////////////////////////////
// exp
void gen_exp (Exp_t exp)
{
  switch (exp->kind){
  case EXP_INT:{
    Exp_Int p = (Exp_Int)exp;
    emit (Stack_Instr_Push_new(p->n));
    return;
  }
  case EXP_TRUE:{
    emit (Stack_Instr_Push_new (1));
    return;
  }
  case EXP_FALSE:{
    emit (Stack_Instr_Push_new (0));
    return;
  }
  case EXP_ID:{
    Exp_Id p = (Exp_Id)exp;
    emit (Stack_Instr_Load_new(p->id));
    return;
  }
  case EXP_ADD:{
    Exp_Add p = (Exp_Add)exp;
    gen_exp (p->left);
    gen_exp (p->right);
    emit (Stack_Instr_Add_new());
    return;
  }
  case EXP_SUB:{
    TODO();
    return;
  }
  case EXP_TIMES:{
    TODO();
    return;
  }
  case EXP_DIVIDE:{
    TODO();
    return;
  }
  case EXP_AND:{
    TODO();
    return;
  }
  case EXP_OR:{
    TODO();
    return;
  }
  default:
    return;
  }
}

////////////////////////////////////////
// stms
void gen_stm (Stm_t s)
{
  switch (s->kind){
  case STM_ASSIGN:{
    Stm_Assign p = (Stm_Assign)s;
    gen_exp (p->exp);
    emit (Stack_Instr_Store_new (p->id));
    break;
  }
  case STM_PRINTI:{
    Stm_Printi p = (Stm_Printi)s;
    gen_exp(p->exp);
    emit (Stack_Instr_Printi_new ());
    break;
  }
  case STM_PRINTB:{
    Stm_Printb p = (Stm_Printb)s;
    gen_exp(p->exp);
    emit (Stack_Instr_Printb_new ());
    break;
  }
  default:
    break;
  }
}

void gen_stms(List_t stms)
{
  while (stms){
    gen_stm((Stm_t)stms->data);
    stms = stms->next;
  }
  return;
}

/////////////////////////////////////////
// prog
Stack_Prog_t Gen_stack(Prog_t prog)
{
  List_t ids = gen_decs (prog->decs);
  instrs = 0;
  gen_stms (prog->stms);
  return Stack_Prog_new (List_rev(ids)
			 , List_rev(instrs));
}
