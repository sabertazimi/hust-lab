#include "nemu.h"
#include "monitor/expr.h"
#include "monitor/watchpoint.h"
#include "monitor/monitor.h"

/* The assembly code of instructions executed is only output to the screen
 * when the number of instructions executed is less than this value.
 * This is useful when you use the `si' command.
 * You can modify this value as you want.
 */
#define MAX_INSTR_TO_PRINT 10

int nemu_state = NEMU_STOP;

void exec_wrapper(bool);

/* Simulate how the CPU works. */
void cpu_exec(uint64_t n) {
  if (nemu_state == NEMU_END) {
    printf("Program execution has ended. To restart the program, exit NEMU and run again.\n");
    return;
  }
  nemu_state = NEMU_RUNNING;

  bool print_flag = n < MAX_INSTR_TO_PRINT;

  for (; n > 0; n --) {
    /* Execute one instruction, including instruction fetch,
     * instruction decode, and the actual execution. */
    exec_wrapper(print_flag);

#ifdef DEBUG
    /* TODO: check watchpoints here. */

    for (WP *trav = get_watchpoints(); trav != NULL; trav = trav->next) {
      bool success = true;
      int newval = expr(trav->exprStr, &success);

      if (newval != trav->oldval) {
        Info("Watchpoint No.%d: %s", trav->NO, trav->exprStr);
        Info("Old value = %d", trav->oldval);
        Info("New value = %d", newval);
        Info("%s () at %s:%d", __func__, __FILE__, __LINE__);
        trav->oldval = newval;
      }
    }
#endif

#ifdef HAS_IOE
    extern void device_update();
    device_update();
#endif

    if (nemu_state != NEMU_RUNNING) { return; }
  }

  if (nemu_state == NEMU_RUNNING) { nemu_state = NEMU_STOP; }
}
