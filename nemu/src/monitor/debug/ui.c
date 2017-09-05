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
  printf("eax\t\t0x%08x\t%d\n", cpu.eax, cpu.eax);
  printf("ecx\t\t0x%08x\t%d\n", cpu.ecx, cpu.ecx);
  printf("edx\t\t0x%08x\t%d\n", cpu.edx, cpu.edx);
  printf("ebx\t\t0x%08x\t%d\n", cpu.ebx, cpu.ebx);
  printf("esp\t\t0x%08x\t%d\n", cpu.esp, cpu.esp);
  printf("ebp\t\t0x%08x\t%d\n", cpu.ebp, cpu.ebp);
  printf("esi\t\t0x%08x\t%d\n", cpu.esi, cpu.esi);
  printf("edi\t\t0x%08x\t%d\n", cpu.edi, cpu.edi);
  printf("eip\t\t0x%08x\t%d\n", cpu.eip, cpu.eip);
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
      printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
    }
  }
  else {
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(arg, cmd_table[i].name) == 0) {
        printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
        return 0;
      }
    }
    printf("Unknown command '%s'\n", arg);
  }
  return 0;
}

static int cmd_si(char *args) {
  int steps = 0;

  if (NULL == args) {
    cpu_exec(1);
  } else {
    sscanf(args, "%d", &steps);
    steps = (steps > 1) ? steps : 1;
    cpu_exec(steps);
  }

  return 0;
}

static int cmd_info(char *args) {
  if (NULL == args) {
    printf("Missing required parameters\n");
  } else if (0 == strcmp(args, "r")) {
    print_registers();
  } else if (0 == strcmp(args, "w")) {
    /* TODO */
  } else {
    printf("Unkown command '%s'\n", args);
  }

  return 0;
}

static int cmd_p(char *args) {
  return 0;
}

static int cmd_x(char *args) {
  if (NULL == args) {
    printf("Missing required parameters\n");
    return 0;
  }

  uint32_t len = 0;
  uint32_t addr = 0;
  char *lenStr = strtok(args, " ");
  char *addrStr = strtok(NULL, " ");
  bool success = true;

  if (NULL == lenStr || NULL == addrStr) {
    printf("Missing required parameters\n");
    return 0;
  }

  sscanf(lenStr, "%d", &len);
  addr = expr(addrStr, &success);

  if (success == false) {
    printf("Bad expression\n");
    return 0;
  }

  for (int i = 0; i < len * 4; ++i) {
    if (0 == i % 4) {
      printf("%08x: ", addr + i);
    }

    uint32_t num = vaddr_read(addr + i, 1);
    printf("%08x\t", num);

    if (3 == i % 4) {
      printf("\n");
    }
  }

  return 0;
}

static int cmd_w(char *args) {
  return 0;
}

static int cmd_d(char *args) {
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

    if (i == NR_CMD) { printf("Unknown command '%s'\n", cmd); }
  }
}
