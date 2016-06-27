#include "monitor/monitor.h"
#include "monitor/expr.h"
#include "monitor/watchpoint.h"
#include "nemu.h"

#include <stdlib.h>
#include <readline/readline.h>
#include <readline/history.h>

void cpu_exec(uint32_t);

/* We use the ``readline'' library to provide more flexibility to read from stdin. */
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

/**
 * two simple helper functions for cmd_info
 */
int print_registers(void);
int print_watchpoints(void);

static int cmd_x(char *args);

static struct {
	char *name;
	char *description;
	int (*handler) (char *);
} cmd_table [] = {
	{ "help", "Display informations about all supported commands", cmd_help },
	{ "c", "Continue the execution of the program", cmd_c },
	{ "q", "Exit NEMU", cmd_q },

	/* TODO: Add more commands */
	{ "si", "Step one instruction exactly", cmd_si},
	{"info", "List of integer registers contents and specified watchpoints", cmd_info},
	{"x", "Print value of expression EXP each time the program stops", cmd_x}

};

#define NR_CMD (sizeof(cmd_table) / sizeof(cmd_table[0]))

static int cmd_help(char *args) {
	/* extract the first argument */
	char *arg = strtok(NULL, " ");
	int i;

	if(arg == NULL) {
		/* no argument given */
		for(i = 0; i < NR_CMD; i ++) {
			printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
		}
	}
	else {
		for(i = 0; i < NR_CMD; i ++) {
			if(strcmp(arg, cmd_table[i].name) == 0) {
				printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
				return 0;
			}
		}
		printf("Unknown command '%s'\n", arg);
	}
	return 0;
}

static int cmd_si(char *args) {
	int steps;

	// whether has specific steps or not
	if (NULL == args) {
		cpu_exec(1);
	} else {
		sscanf(args, "%d", &steps);
		cpu_exec(steps);
	}

	return 0;
}

static int cmd_info(char *args) {
	args = strtok(args, " ");

	if (NULL == args) {
		printf("Missing required parameters\n");
	} else if (strcmp(args, "r") == 0) {
		print_registers();
	} else if (strcmp(args, "w") == 0) {
		print_watchpoints();
	} else {
		printf("Unknown command '%s'\n", args);
	}

	return 0;
}

int print_registers(void) {
	printf("eax\t\t0x%08x\t%d\n",cpu.eax, cpu.eax);
	printf("ecx\t\t0x%08x\t%d\n",cpu.ecx, cpu.ecx);
	printf("edx\t\t0x%08x\t%d\n",cpu.edx, cpu.edx);
	printf("ebx\t\t0x%08x\t%d\n",cpu.ebx, cpu.ebx);
	printf("esp\t\t0x%08x\t%d\n",cpu.esp, cpu.esp);
	printf("ebp\t\t0x%08x\t%d\n",cpu.ebp, cpu.ebp);
	printf("esi\t\t0x%08x\t%d\n",cpu.esi, cpu.esi);
	printf("edi\t\t0x%08x\t%d\n",cpu.edi, cpu.edi);
	printf("eip\t\t0x%08x\t%d\n",cpu.eip, cpu.eip);

	return 0;
}

int print_watchpoints(void) {
	return 0;
}

static int cmd_x(char *args) {
	return 0;
}

void ui_mainloop() {

	// offset for history list
	int offset = 0;

	HIST_ENTRY * cmd_prev = NULL;

	while(1) {
		offset = where_history();

		while(cmd_prev == NULL) {
			cmd_prev = history_get(offset--);

			if (offset < 0) {
				break;
			}
		}

		char *str = rl_gets();
		char *str_end = str + strlen(str);

		/* extract the first token as the command */
		char *cmd = strtok(str, " ");
		if(cmd == NULL) {
			if (cmd_prev->line) {
				cmd = strtok((char *)(cmd_prev->line), " ");
				str_end = (char *)(cmd_prev->line + strlen(cmd_prev->line));
			} else {
				continue;
			}
		}

		cmd_prev = current_history();

		/* treat the remaining string as the arguments,
		 * which may need further parsing
		 */
		char *args = cmd + strlen(cmd) + 1;
		if(args >= str_end) {
			args = NULL;
		}

#ifdef HAS_DEVICE
		extern void sdl_clear_event_queue(void);
		sdl_clear_event_queue();
#endif

		int i;
		for(i = 0; i < NR_CMD; i ++) {
			if(strcmp(cmd, cmd_table[i].name) == 0) {
				if(cmd_table[i].handler(args) < 0) { return; }
				break;
			}
		}

		if(i == NR_CMD) { printf("Unknown command '%s'\n", cmd); }
	}
}
