#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semant.h"

#define TODO()\
  do{\
  printf ("TODO: add your code at file: \"%s\", line: %d\n", __FILE__, __LINE__);\
}while(0)

//////////////////////////////////////
// the symbol table
List_t table = 0;

// lookup an "id" in the symbol table.
// return "type" on success; and -1 for failure
Type_t Table_lookup (char *id)
{
  List_t p = table;
  while (p){
    Dec_t d = (Dec_t)p->data;
    if (strcmp(d->id, id)==0)
      return d->type;
    p = p->next;
  }
  return -1;
}

void Table_insert (Dec_t dec)
{

  if (Table_lookup (dec->id) != -1){
    fprintf (stderr, "Error: the variable "
	     "\"%s\" has been declared!\n", dec->id);
    exit (0);
  }
  table = List_new (dec, table);
  return;
}

//////////////////////////////////////////
// dec
void check_dec(Dec_t d)
{
  Table_insert (d);
}

void check_decs(List_t decs)
{
  while (decs){
    Dec_t d = (Dec_t)decs->data;
    check_dec(d);
    decs = decs->next;
  }
  return;
}

////////////////////////////////////////
// exp

// Your job:
Type_t check_exp (Exp_t exp)
{
    switch (exp->kind) {
        case EXP_INT: {
            return TYPE_INT;
        }
        case EXP_TRUE: {
            return TYPE_BOOL;
        }
        case EXP_FALSE: {
            return TYPE_BOOL;
        }
        case EXP_ID: {
            Exp_Id e = (Exp_Id)exp;
            Type_t type = Table_lookup(e->id);

            if (type == -1){
                fprintf (stderr, "Error: the variable "
	                    "\"%s\" hasn't been declared!\n", e->id);
                exit (0);
            }

            return type;
       }
        case EXP_ADD: {
            Exp_Add e = (Exp_Add)exp;
            Type_t left = check_exp(e->left);
            Type_t right = check_exp(e->right);

            if (left != TYPE_INT || right != TYPE_INT) {
                fprintf(stderr, "Error: mismatching type in add expression!\n");
                exit(0);
            }

            return left;
        }
        case EXP_SUB: {
            Exp_Sub e = (Exp_Sub)exp;
            Type_t left = check_exp(e->left);
            Type_t right = check_exp(e->right);

            if (left != TYPE_INT || right != TYPE_INT) {
                fprintf(stderr, "Error:  mismatching type in sub expression!\n");
                exit(0);
            }

            return left;
        }
        case EXP_TIMES: {
            Exp_Times e = (Exp_Times)exp;
            Type_t left = check_exp(e->left);
            Type_t right = check_exp(e->right);

            if (left != TYPE_INT || right != TYPE_INT) {
                fprintf(stderr, "Error: mismatching type in times expression!\n");
                exit(0);
            }

            return left;
        }
        case EXP_DIVIDE: {
            Exp_Divide e = (Exp_Divide)exp;
            Type_t left = check_exp(e->left);
            Type_t right = check_exp(e->right);

            if (left != TYPE_INT || right != TYPE_INT) {
                fprintf(stderr, "Error: mismatching type in divide expression!\n");
                exit(0);
            }

            return left;
        }
        case EXP_AND: {
            Exp_And e = (Exp_And)exp;
            Type_t left = check_exp(e->left);
            Type_t right = check_exp(e->right);

            if (left != TYPE_BOOL != TYPE_BOOL) {
                fprintf(stderr, "Error: mismatching type in and expression!\n");
                exit(0);
            }

            return left;
        }
        case EXP_OR: {
            Exp_Or e = (Exp_Or)exp;
            Type_t left = check_exp(e->left);
            Type_t right = check_exp(e->right);

            if (left != TYPE_BOOL || right != TYPE_BOOL) {
                fprintf(stderr, "Error: mismatching type in or expression!\n");
                exit(0);
            }

            return left;
        }
    }

}

////////////////////////////////////////
// stm

// Your job:
void check_stm (Stm_t stm)
{
    switch (stm->kind) {
    case STM_ASSIGN: {
                         Stm_Assign s = (Stm_Assign)stm;
                         Type_t left = Table_lookup(s->id);

                         if (left == -1){
                            fprintf (stderr, "Error: the variable "
	                                "\"%s\" hasn't been declared!\n",s->id);
                            exit (0);
                         }

                         Type_t right = check_exp(s->exp);

                         if (left != right) {
                            fprintf(stderr, "Error: mismatching type in assign statement!\n");
                            exit(0);
                         }

                         break;
                     }
    case STM_PRINTI: {
                         Stm_Printi s = (Stm_Printi)stm;
                         Type_t t = check_exp(s->exp);

                         if (t != TYPE_INT) {
                             fprintf(stderr, "Error: in printi function, expect int expression, but got bool expression!\n");
                             exit(0);
                         }

                         break;
                     }
    case STM_PRINTB: {
                         Stm_Printi s = (Stm_Printi)stm;
                         Type_t t = check_exp(s->exp);

                         if (t != TYPE_BOOL) {
                             fprintf(stderr, "Error: in printb function, expect bool expression, but got int expression!\n");
                             exit(0);
                         }

                         break;
                     }
    }

    return;
}

void check_stms(List_t stms)
{
  while (stms){
    Stm_t s = (Stm_t)stms->data;
    check_stm(s);
    stms = stms->next;
  }
  return;
  TODO();
}


void Semant_check(Prog_t prog)
{
  // create table
  check_decs(prog->decs);
  // check stm
  check_stms(prog->stms);
  return;
}
