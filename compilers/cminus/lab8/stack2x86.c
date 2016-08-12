#include <stdio.h>
#include <stdlib.h>
#include "stack2x86.h"

FILE *fp = 0;

//////////////////////////////////////////
// decs
static void genx86_ids (List_t ids)
{
  fprintf (fp, "\t.data\n"
	   "int_format:\n"
	   "\t.string \"%%d\\n\"\n"
	   "trues:\n"
	   "\t.string \"true\\n\"\n"
	   "falses:\n"
	   "\t.string \"false\\n\"\n");
  while (ids){
    char *id = (char *)ids->data;
    fprintf (fp, "%s:\n\t.int 0\n", id);
    ids = ids->next;
  }
  return;
}

///////////////////////////////////////////
// instrs
static void genx86_instr (Stack_Instr_t s)
{
  switch(s->kind){
  case STACK_INSTR_PUSH:{
    Stack_Instr_Push p = (Stack_Instr_Push)s;
    fprintf (fp, "\tpushl\t$%d", p->n);
    break;
  }
  case STACK_INSTR_LOAD:{
    Stack_Instr_Load p = (Stack_Instr_Load)s;
    fprintf (fp, "\tmovl\t%s, %%eax", p->x);
    break;
  }
  case STACK_INSTR_STORE:{
    Stack_Instr_Store p = (Stack_Instr_Store)s;
    fprintf (fp, "store %s", p->x);
    break;
  }
  case STACK_INSTR_ADD:{
    fprintf (fp, "add");
    break;
  }
  case STACK_INSTR_SUB:{
    fprintf (fp, "sub");
    break;
  }
  case STACK_INSTR_TIMES:{
    fprintf (fp, "times");
    break;
  }
  case STACK_INSTR_DIV:{
    fprintf (fp, "div");
    break;
  }
  case STACK_INSTR_PRINTI:{
    fprintf (fp, "\tcall\tprinti\n"
	     "\taddl\t$4, %%esp");
    break;
  }
  case STACK_INSTR_PRINTB:{
    fprintf (fp, "\tcall\tprintb\n"
	     "\taddl\t$4, %%esp");
    break;
  }
  default:
    break;
  }
}

void genx86_instrs(List_t l)
{
  fprintf (fp, "\n\n\t.text\n"
	   "\t.globl main\n"
	   "main:\n"
	   "\tpushl\t%%ebp\n"
	   "\tmovl\t%%esp, %%ebp\n");

  while (l){
    genx86_instr(l->data);
    fprintf (fp, "\n");
    l = l->next;
  }
  fprintf (fp, "\tleave\n"
	   "\tret\n");
  fprintf (fp, "\t.globl printi\n"
	   "printi:\n"
	   "\tpush\t%%ebp\n"
	   "\tmovl\t%%esp, %%ebp\n"
	   "\tpushl\t8(%%ebp)\n"
	   "\tpushl\t$int_format\n"
	   "\tcall\tprintf\n"
	   "\tleave\n"
	   "\tret\n"
	    "\t.globl printb\n"
	   "printb:\n"
	   "\tpush\t%%ebp\n"
	   "\tmovl\t%%esp, %%ebp\n"
	   "\txorl\t%%eax, %%eax\n"
	   "\tcmpl\t8(%%ebp), %%eax\n"
	   "\tje\t.L_f\n"
	   "\tpushl\t$trues\n"
	   "\tjmp\t.L_e\n"
	   ".L_f:\n"
	   "\tpushl\t$falses\n"
	   ".L_e:\n"
	   "\tcall\tputs\n"
	   "\tleave\n"
	   "\tret\n");
  return;
}

///////////////////////////////////////////
// prog
void Stack2x86_print (Stack_Prog_t p)
{
  fp = fopen ("temp.s", "w+");
  if (fp==0){
    printf ("error in open file\n");
    exit (0);
  }

  genx86_ids (p->ids);
  genx86_instrs (p->instrs);

  fclose (fp);
  fp = 0;
  return;
}
