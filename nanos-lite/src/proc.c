#include "proc.h"

#define MAX_NR_PROC 4
#define PRIORITY 6666

static uint32_t priority_counter = 0;

static PCB pcb[MAX_NR_PROC];
static int nr_proc = 0;
PCB *current = NULL;

uintptr_t loader(_Protect *as, const char *filename);

void load_prog(const char *filename) {
  int i = nr_proc ++;
  _protect(&pcb[i].as);

  uintptr_t entry = loader(&pcb[i].as, filename);

  _Area stack;
  stack.start = pcb[i].stack;
  stack.end = stack.start + sizeof(pcb[i].stack);

  pcb[i].tf = _umake(&pcb[i].as, stack, stack, (void *)entry, NULL, NULL);
}

_RegSet* schedule(_RegSet *prev) {
  current->tf = prev;

  if (current == &pcb[1]) {
    current = &pcb[0];
  } else if (current == &pcb[0] && priority_counter > PRIORITY) {
    current = &pcb[1];
    priority_counter = 0;
  } else {
    current = &pcb[0];
  }

  ++priority_counter;

  // current = (current == &pcb[0] ? &pcb[1] : &pcb[0]);
  _switch(&current->as);

  return current->tf;
}
