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

	line_read = readline("\033[33m(nemu) \033[0m");

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
			printf("\033[1m\033[31m%s - %s\n\033[0m", cmd_table[i].name, cmd_table[i].description);
		}
	}
	else {
		for(i = 0; i < NR_CMD; i ++) {
			if(strcmp(arg, cmd_table[i].name) == 0) {
				printf("\033[1m\033[31m%s - %s\n\033[0m", cmd_table[i].name, cmd_table[i].description);
				return 0;
			}
		}
		printf("\033[1m\033[31mUnknown command '%s'\n\033[0m", arg);
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
		printf("\033[1m\033[31mMissing required parameters\n\033[0m");
	} else if (strcmp(args, "r") == 0) {
		print_registers();
	} else if (strcmp(args, "w") == 0) {
		print_watchpoints();
	} else {
		printf("\033[1m\033[31mUnknown command '%s'\n\033[0m", args);
	}

	return 0;
}

int print_registers(void) {
	printf("\033[1m\033[35meax\t\t0x%08x\t%d\n\033[0m",cpu.eax, cpu.eax);
	printf("\033[1m\033[35mecx\t\t0x%08x\t%d\n\033[0m",cpu.ecx, cpu.ecx);
	printf("\033[1m\033[35medx\t\t0x%08x\t%d\n\033[0m",cpu.edx, cpu.edx);
	printf("\033[1m\033[35mebx\t\t0x%08x\t%d\n\033[0m",cpu.ebx, cpu.ebx);
	printf("\033[1m\033[35mesp\t\t0x%08x\t%d\n\033[0m",cpu.esp, cpu.esp);
	printf("\033[1m\033[35mebp\t\t0x%08x\t%d\n\033[0m",cpu.ebp, cpu.ebp);
	printf("\033[1m\033[35mesi\t\t0x%08x\t%d\n\033[0m",cpu.esi, cpu.esi);
	printf("\033[1m\033[35medi\t\t0x%08x\t%d\n\033[0m",cpu.edi, cpu.edi);
	printf("\033[1m\033[35meip\t\t0x%08x\t%d\n\033[0m",cpu.eip, cpu.eip);

	return 0;
}

int print_watchpoints(void) {
	return 0;
}

static int cmd_x(char *args) {
	if(!args) {
		printf("\033[1m\033[31mMissing required parameters\n\033[0m");
		return 0;
	}
	uint32_t num,
             addr,
             i;
    // j

	char *n = strtok(NULL, " ");

	if (sscanf(n, "%u", &num) < 1) {
		printf("\033[1m\033[31mInvalid ram unit numbers\n\033[0m");
		return 0;
	}

	char *expression = n + strlen(n) + 1;
	bool success = false;
	addr = expr(expression, &success);

	if(!success){
		printf("\033[1m\033[31mInvalid expression\n\033[0m");
		return 0;
	}

    for (i = 0; i < num; i++ ) {
		printf("\033[1m\033[35m0x%08x:\t\n", addr + i);
    }

    printf("\n\033[0m");

    /**
     * TODO: implement cache/memory
     *
	for(i = 0; i < num; i += 4) {
		printf("\033[1m\033[35m0x%08x:\t", addr + i * 4);

		for(j = 0; i + j< num && j < NR_RAM_UNIT_EACH_LINE; ++j) {
			printf("0x%08x\t", swaddr_read(addr + (i + j) * 4, 4));
		}

		printf("\n\033[0m");
	}
     *
     */

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

		if(i == NR_CMD) { printf("\033[1m\033[31mUnknown command '%s'\n\033[0m", cmd); }
	}
}
