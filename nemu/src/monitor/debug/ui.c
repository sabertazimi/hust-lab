#include "monitor/monitor.h"
#include "monitor/expr.h"
#include "monitor/watchpoint.h"
#include "nemu.h"

#include <stdlib.h>
#include <readline/readline.h>
#include <readline/history.h>

void cpu_exec(uint64_t);

/* We use the `readline' library to provide more flexibility to read from stdin. */
char* rl_gets() {
  static char *line_read = NULL;

  if (line_read) {
    free(line_read);
    line_read = NULL;
  }

  line_read = readline("(nemu) ");

  if (line_read && *line_read) {
    add_history(line_read);
  }

  return line_read;
}

static int cmd_c(char *args) {
  cpu_exec(-1);
  return 0;
}

static int cmd_q(char *args) {
  return -1;
}

static int cmd_help(char *args);
static int cmd_si(char *args);
static int cmd_info(char *args);
static int cmd_p(char *args);
static int cmd_x(char *args);
static int cmd_w(char *args);
static int cmd_d(char *args);

static void print_registers(void) {
  Info("eax\t\t0x%08x\t%d", cpu.eax, cpu.eax);
  Info("ecx\t\t0x%08x\t%d", cpu.ecx, cpu.ecx);
  Info("edx\t\t0x%08x\t%d", cpu.edx, cpu.edx);
  Info("ebx\t\t0x%08x\t%d", cpu.ebx, cpu.ebx);
  Info("esp\t\t0x%08x\t%d", cpu.esp, cpu.esp);
  Info("ebp\t\t0x%08x\t%d", cpu.ebp, cpu.ebp);
  Info("esi\t\t0x%08x\t%d", cpu.esi, cpu.esi);
  Info("edi\t\t0x%08x\t%d", cpu.edi, cpu.edi);
  Info("eip\t\t0x%08x\t%d", cpu.eip, cpu.eip);
}

static struct {
  char *name;
  char *description;
  int (*handler) (char *);
} cmd_table [] = {
  { "help", "Display informations about all supported commands", cmd_help },
  { "c", "Continue the execution of the program", cmd_c },
  { "q", "Exit NEMU", cmd_q },

  /* TODO: Add more commands */
  { "si", "Step N instructions exactly", cmd_si },
  { "info", "List of regsiters or watchpoints", cmd_info },
  { "p", "Print value of expression EXPR", cmd_p },
  { "x", "Examine memory: x/FMT ADDRESS(EXPR)", cmd_x },
  { "w", "Set a watchpoint for an expression", cmd_w },
  { "d", "Delete some breakpoints or auto-display expressions", cmd_d }
};

#define NR_CMD (sizeof(cmd_table) / sizeof(cmd_table[0]))

static int cmd_help(char *args) {
  /* extract the first argument */
  char *arg = strtok(NULL, " ");
  int i;

  if (arg == NULL) {
    /* no argument given */
    for (i = 0; i < NR_CMD; i ++) {
      Info("%s - %s", cmd_table[i].name, cmd_table[i].description);
    }
  }
  else {
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(arg, cmd_table[i].name) == 0) {
        Info("%s - %s", cmd_table[i].name, cmd_table[i].description);
        return 0;
      }
    }
    Warn("Unknown command '%s'", arg);
  }
  return 0;
}

static int cmd_si(char *args) {
  int steps = 0;

  if (args == NULL) {
    cpu_exec(1);
  } else {
    sscanf(args, "%d", &steps);
    steps = (steps > 1) ? steps : 1;
    cpu_exec(steps);
  }

  return 0;
}

static int cmd_info(char *args) {
  if (args == NULL) {
    Warn("Missing required parameters");
  } else if (strcmp(args, "r") == 0) {
    print_registers();
  } else if (strcmp(args, "w") == 0) {
    print_watchpoints();
  } else {
    Warn("Unkown command '%s'", args);
  }

  return 0;
}

static int cmd_p(char *args) {
  if (args == NULL) {
    Warn("Missing required parameters");
    return 0;
  }

  bool success = true;
  int val = expr(args, &success);

  if (success == false) {
    Warn("Bad Expression");
  } else {
    Info("%d", val);
  }

  return 0;
}

static int cmd_x(char *args) {
  if (args == NULL) {
    Warn("Missing required parameters");
    return 0;
  }

  char *lenStr = strtok(args, " ");
  char *addrStr = strtok(NULL, " ");
  bool success = true;
  uint32_t len = 0;
  uint32_t addr = 0;

  if (lenStr == NULL || addrStr == NULL) {
    Warn("Missing required parameters");
    return 0;
  }

  sscanf(lenStr, "%d", &len);
  addr = expr(addrStr, &success);

  if (success == false) {
    Warn("Bad expression");
    return 0;
  }


  printf("\33[1;33m");

  for (int i = 0; i < len * 4; ++i) {
    if (i % 4 == 0) {
      printf("0x%08x: ", addr + i);
    }

    uint32_t num = vaddr_read(addr + i, 1);
    printf("0x%08x\t", num);

    if (i % 4 == 3) {
      printf("\n");
    }
  }

  printf("\33[0m");

  return 0;
}

static int cmd_w(char *args) {
  if (args == NULL) {
    Warn("Missing required parameters");
    return 0;
  }

  WP *wp = new_wp(args);

  if (wp == NULL) {
    Warn("No more space for a new watchpoint");
  } else {
    Info("Watchpoint No.%d: %s", wp->NO, wp->exprStr);
  }

  return 0;
}

static int cmd_d(char *args) {
  if (args == NULL) {
    Warn("Missing required parameters");
    return 0;
  }

  int NO = strtol(args, NULL, 10);
  bool deleted = free_wp(NO);

  if (deleted == true) {
    Info("Deleted watchpoint No.%d", NO);
  } else {
    Warn("Delete watchpoint No.%d fail", NO);
  }

  return 0;
}

void ui_mainloop(int is_batch_mode) {
  if (is_batch_mode) {
    cmd_c(NULL);
    return;
  }

  while (1) {
    char *str = rl_gets();
    char *str_end = str + strlen(str);

    /* extract the first token as the command */
    char *cmd = strtok(str, " ");
    if (cmd == NULL) { continue; }

    /* treat the remaining string as the arguments,
     * which may need further parsing
     */
    char *args = cmd + strlen(cmd) + 1;
    if (args >= str_end) {
      args = NULL;
    }

#ifdef HAS_IOE
    extern void sdl_clear_event_queue(void);
    sdl_clear_event_queue();
#endif

    int i;
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(cmd, cmd_table[i].name) == 0) {
        if (cmd_table[i].handler(args) < 0) { return; }
        break;
      }
    }

    if (i == NR_CMD) { Warn("Unknown command '%s'", cmd); }
  }
}
