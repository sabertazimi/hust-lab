#include "nemu.h"

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <sys/types.h>
#include <regex.h>
#include <stdlib.h>
#include <elf.h>

uint32_t expr(char *, bool *);

extern char *strtab;
extern Elf32_Sym *symtab;
extern int nr_symtab_entry;

enum {
	NOTYPE = 256,
	DECIMAL_NUM,
    HEX_NUM,
    REGS,
    VAR,
	EQ,
    NEQ,
    AND,
    OR,
    NOT,
    DEREF
};

static struct rule {
	char *regex;
	int token_type;
} rules[] = {
	{" +",	NOTYPE},				// spaces
    {"0|[1-9][0-9]*", DECIMAL_NUM}, // decimal number
    {"0x[0-9a-fA-F]+", HEX_NUM},    // hexadecimal number
    {"\\$[a-z]+", REGS},            // registers
    {"[a-zA-Z_]\\w*", VAR},         // variable
    {"\\(", '('},                   // left parenthese
    {"\\)", ')'},                   // right parenthese
	{"\\+", '+'},					// plus
	{"-", '-'},					    // minus or de-refference
	{"\\*", '*'},					// multiple
	{"/", '/'},					    // divide
	{"==", EQ},						// equal
	{"!=", NEQ},				    // not equal
	{"&&", AND},				    // logical and
	{"\\|\\|", OR},				    // logical or
	{"!", NOT}						// logical not
};

#define NR_REGEX (sizeof(rules) / sizeof(rules[0]) )

static regex_t re[NR_REGEX];
static uint8_t token_priority[300];

/* Rules are used for many times.
 * Therefore we compile them only once before any usage.
 */
void init_regex() {
	int i;
	char error_msg[128];
	int ret;

	for(i = 0; i < NR_REGEX; i ++) {
		ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
		if(ret != 0) {
			regerror(ret, &re[i], error_msg, 128);
			Assert(ret == 0, "regex compilation failed: %s\n%s", error_msg, rules[i].regex);
		}
	}

	// establish token priority table
	token_priority['!'] = token_priority[DEREF] = 5;
	token_priority['*'] = token_priority['/'] = 4;
	token_priority['+'] = token_priority['-'] = 3;
	token_priority[EQ] = token_priority[NEQ] = 2;
	token_priority[AND] = 1;
	token_priority[OR] = 0;
}

typedef struct token {
	int type;
	char str[32];
} Token;

Token tokens[32];
int nr_token;

// step one: generate tokens
static bool make_token(char *e) {
	int position = 0;
	int i;
	regmatch_t pmatch;

	nr_token = 0;

	while(e[position] != '\0') {
		/* Try all rules one by one. */
		for(i = 0; i < NR_REGEX; i ++) {
			if(regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
				char *substr_start = e + position;
				int substr_len = pmatch.rm_eo;

				Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s", i, rules[i].regex, position, substr_len, substr_len, substr_start);
				position += substr_len;

				/* TODO: Now a new token is recognized with rules[i]. Add codes
				 * to record the token in the array ``tokens''. For certain
				 * types of tokens, some extra actions should be performed.
				 */

				switch(rules[i].token_type) {
					case DECIMAL_NUM:
					case HEX_NUM:
					case REGS:
					case VAR:
						strncpy(tokens[nr_token].str, substr_start, substr_len);
						tokens[nr_token].str[substr_len] = '\0';
						tokens[nr_token++].type = rules[i].token_type;
						break;
					case NOTYPE:
						break;
					default:
						tokens[nr_token++].type = rules[i].token_type;
						break;
				}

				break;
			}
		}

		if(i == NR_REGEX) {
			printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
			return false;
		}
	}

	return true;
}

// step two: generate token tree by priority
// priority table will be initialized in function init_regex
int get_dominant_op(Token *tokens, int p, int q, bool *success) {
	int nr_parens = 0,
		op = -1,
		priority = -1,
		type,
		i;

	*success = false;

	for (i = p; i <= q; i++) {
		type = tokens[i].type;

		// dominant operator can't be in parensthese expression
		if (type == '(') {
			nr_parens += 1;
		} else if (type == ')') {
			nr_parens -= 1;
		}

		if (0 == nr_parens) {

			// dominant operator can't be parensthese or number/variable/registers
			switch (type) {
				case DECIMAL_NUM:
				case HEX_NUM:
				case REGS:
				case VAR:
				case '(':
				case ')':
					continue;
				// unkown token
				default:
					break;
			}

			// first loop
			if (op == -1) {
				*success = true;
				op = i;
				priority = token_priority[type];
			} else {
				// dominant operator must have lower priority
				if (token_priority[type] <= priority) {
					op = i;
					priority = token_priority[type];
				}
			}
		}
	}

	return op;
}

// step three: recursive evaluation

/**
 * helper function: check_parentheses
 */
bool check_parentheses(Token *tokens, int p, int q, bool *success) {
	int nr_left = 0,
		nr_right = 0,
		i;

	for (i = p; i <= q; i++) {
		if (tokens[i].type == '(') {
			nr_left += 1;
		} else if (tokens[i].type == ')') {
			nr_right += 1;

			// no matching parentheses
			if (nr_right > nr_left) {
				*success = false;
				return false;
			}
		}
	}

	// no matching parentheses
	if (nr_right != nr_left) {
		*success = false;
		return false;
	}

	*success = true;

	if (tokens[p].type == '(' && tokens[q].type == ')') {
		nr_left = nr_right = 0;

		for (i = p + 1; i <= q - 1; ++i) {
			if (tokens[i].type == '(') {
				nr_left += 1;
			} else if (tokens[i].type == ')') {
				nr_right += 1;

				if(nr_right > nr_left) {
					return false;
				}
			}
		}

		return true;
	}

	return false;
}

char regs_name[][5] = {
	"eax", "ecx", "edx", "ebx", "esp", "ebp", "esi", "edi", "eip"
};

uint32_t regs_num = 9;

/**
 * recursive evaluation
 */
uint32_t eval(Token *tokens, int p, int q, bool *success) {
	int i;

	// recursive termination condition
	if (p > q) {
		*success = false;
		return 0;
	} else if (p == q) {
		if (tokens[p].type == DECIMAL_NUM) {
			*success = true;
			return strtoul(tokens[p].str, NULL, 10);
		} else if (tokens[p].type == HEX_NUM) {
			*success = true;
			return strtoul(tokens[p].str, NULL, 16);
		} else if (tokens[p].type == REGS) {
			for (i = 0; i < regs_num; i++) {
				if (strcmp(tokens[p].str + 1, regs_name[i]) == 0) {
					break;
				}
			}

			*success = true;

			switch (i) {
				case 0:
					return cpu.eax;
				case 1:
					return cpu.ecx;
				case 2:
					return cpu.edx;
				case 3:
					return cpu.ebx;
				case 4:
					return cpu.esp;
				case 5:
					return cpu.ebp;
				case 6:
					return cpu.esi;
				case 7:
					return cpu.edi;
				case 8:
					return cpu.eip;
				default:
					*success = false;
					return 0;
			}
		} else if (tokens[p].type == VAR) {
			*success = true;

			for (i = 0; i < nr_symtab_entry; i++) {
				Elf32_Sym * syb = symtab + i;

				if (ELF32_ST_TYPE(syb->st_info) == STT_OBJECT) {
					if (0 == strcmp(tokens[p].str, strtab+syb->st_name)) {
						return syb->st_value;
					}
				}
			}

			*success = false;
			return 0;
		} else {
			*success = false;
			return 0;
		}
	} else {
		if (check_parentheses(tokens, p, q, success) == true) {
			return eval(tokens, p + 1, q - 1, success);
		}

		if (*success == false) {
			return 0;
		}

		int op = get_dominant_op(tokens, p, q, success);

		if (*success == false) {
			return 0;
		}

		uint32_t val1 = 0;

		if (tokens[op].type != NOT && tokens[op].type != DEREF) {
			val1 = eval(tokens, p, op -1, success);
			if (*success == false) {
				return 0;
			}
		}

		uint32_t val2 = eval(tokens, op + 1, q, success);

		if (*success == false) {
			return 0;
		}

		*success = true;

		switch (tokens[op].type) {
			case '+':
				return val1 + val2;
			case '-':
				return val1 - val2;
			case '*':
				return val1 * val2;
			case '/':
				return val1 / val2;
			case EQ :
				return val1 == val2;
			case NEQ:
				return val1 != val2;
			case AND:
				return val1 && val2;
			case OR:
				return val1 || val2;
			case NOT:
				return !val2;
			case DEREF:
				// TODO: implement cache/memory
                // return swaddr_read(val2, 4, DS);
                return val2;
			default:
				assert(0);
				break;
		}
	}

	return 0;
}

uint32_t expr(char *e, bool *success) {
	int i;

	if (!make_token(e)) {
		*success = false;
		return 0;
	}

	for (i = 0; i < nr_token; ++i) {
		if (tokens[i].type == '*') {
			if (i == 0) {
				tokens[i].type = DEREF;
				continue;
			}

			switch (tokens[i - 1].type) {
				case DEREF:
				case '(':
				case '+':
				case '-':
				case '*':
				case '/':
				case EQ:
				case NEQ:
				case AND:
				case OR:
				case NOT:
					tokens[i].type = DEREF;
					break;
				case DECIMAL_NUM:
				case HEX_NUM:
				case ')':
				case VAR:
				case REGS:
					break;
				default:
					assert(0);
					break;
			}
		}
	}

	return eval(tokens, 0, nr_token - 1, success);
}

