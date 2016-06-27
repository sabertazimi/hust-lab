#include "nemu.h"

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <sys/types.h>
#include <regex.h>
#include <stdlib.h>
#include <elf.h>

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
		if (type == "(") {
			nr_parens += 1;
		} else if (type == ")") {
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

		}
	}
}

uint32_t expr(char *e, bool *success) {
	if(!make_token(e)) {
		*success = false;
		return 0;
	}

	/* TODO: Insert codes to evaluate the expression. */
	panic("please implement me");
	return 0;
}

