#include "proc.h"

#define MAX_NR_PROC 4
#define PRIORITY 255

static uint32_t priority_counter = 0;
static uint32_t schedule_flag = 0;
static uint32_t change_game_flag = 0;

static PCB pcb[MAX_NR_PROC];
static int nr_proc = 0;
PCB *current = NULL;
static PCB *current_game = NULL;

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

  if (current_game == NULL) {
    current_game = &pcb[0];
    current = current_game;
  }

  if (schedule_flag || change_game_flag) {
    current = current_game;
    schedule_flag = 0;
    change_game_flag = 0;
  } else if (!schedule_flag && priority_counter > PRIORITY) {
    current = &pcb[1];
    schedule_flag = 1;
    priority_counter = 0;
  }

  ++priority_counter;

  _switch(&current->as);

  return current->tf;
}

void change_current_game(void) {
  current_game = (current_game == &pcb[0]) ? &pcb[2] : &pcb[0];
  change_game_flag = 1;
}
