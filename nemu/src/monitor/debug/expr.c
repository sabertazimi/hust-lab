#include "nemu.h"

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <sys/types.h>
#include <regex.h>
#include <stdlib.h>

// 16 type token
enum {
  TK_NOTYPE = 256, TK_EQ = 1,

  /* TODO: Add more token types */

  // binary
  TK_NEQ,
  TK_AND,
  TK_OR,
  TK_HEX,
  TK_DEC,
  TK_REG,

  // unary
  TK_MINUS,
  TK_DEREF
};

static struct rule {
  char *regex;
  int token_type;
} rules[] = {

  /* TODO: Add more rules.
   * Pay attention to the precedence level of different rules.
   */

  {" +", TK_NOTYPE},    // spaces
  {"\\+", '+'},         // plus
  {"-", '-'},           // substract or TK_MINUS
  {"\\*", '*'},         // mutiple or TK_DEREF
  {"/", '/'},           // divide
  {"==", TK_EQ},        // equal
  {"!=", TK_NEQ},       // not equal
  {"&&", TK_AND},       // logical and
  {"\\|\\|", TK_OR},    // logical or
  {"!", '!'},           // logical not
  {"\\(", '('},         // left parenthesis
  {"\\)", ')'},         // right parenthesis
  {"(0x|0X)[0-9a-fA-F]+", TK_HEX},   // hexdecimal integer
  {"[0-9]+", TK_DEC},   // decimal integer
  {"\\$[a-z]+", TK_REG} // register
};

#define NR_REGEX (sizeof(rules) / sizeof(rules[0]) )

static regex_t re[NR_REGEX];

static int tokens_priority[256];

static void set_priority(void);
static bool is_parenthesis_match(int p, int q);
static bool check_parenthesis(int p, int q, bool *success);
static int get_dominant_pos(int p, int q);
static int get_regval(char *reg_name, bool *success);
static int eval(int p, int q, bool *success);
static void do_operator_check(void);

static void set_priority(void) {
  tokens_priority[TK_OR] = 1;
  tokens_priority[TK_AND] = 2;
  tokens_priority[TK_EQ] = tokens_priority[TK_NEQ] = 3;
  tokens_priority['+'] = tokens_priority['-'] = 4;
  tokens_priority['*'] = tokens_priority['/'] = 5;
  tokens_priority[TK_MINUS] = tokens_priority[TK_DEREF] = tokens_priority['!'] = 6;

  // set priority of non-operator to 0
  tokens_priority['('] = tokens_priority[')'] = 0;
  tokens_priority[TK_HEX] = tokens_priority[TK_DEC] = tokens_priority[TK_REG] = 0;
}

/* Rules are used for many times.
 * Therefore we compile them only once before any usage.
 */
void init_regex() {
  int i;
  char error_msg[128];
  int ret;

  for (i = 0; i < NR_REGEX; i ++) {
    ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
    if (ret != 0) {
      regerror(ret, &re[i], error_msg, 128);
      panic("regex compilation failed: %s\n%s", error_msg, rules[i].regex);
    }
  }

  set_priority();
}

typedef struct token {
  int type;
  char str[32];
} Token;

Token tokens[32];
int nr_token;

static bool make_token(char *e) {
  int position = 0;
  int i;
  regmatch_t pmatch;

  nr_token = 0;

  while (e[position] != '\0') {
    /* Try all rules one by one. */
    for (i = 0; i < NR_REGEX; i ++) {
      if (regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
        char *substr_start = e + position;
        int substr_len = pmatch.rm_eo;

        Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s",
            i, rules[i].regex, position, substr_len, substr_len, substr_start);
        position += substr_len;

        /* TODO: Now a new token is recognized with rules[i]. Add codes
         * to record the token in the array `tokens'. For certain types
         * of tokens, some extra actions should be performed.
         */

        switch (rules[i].token_type) {
          case '+':
          case '-':
          case '*':
          case '/':
          case TK_EQ:
          case TK_NEQ:
          case TK_AND:
          case TK_OR:
          case '!':
          case '(':
          case ')':
            tokens[nr_token].type = rules[i].token_type;
            ++nr_token;
            break;
          case TK_HEX:
          case TK_DEC:
          case TK_REG:
            tokens[nr_token].type = rules[i].token_type;
            strncpy(tokens[nr_token].str, substr_start, substr_len);
            ++nr_token;
            break;
          default:
            break;
        }

        break;
      }
    }

    if (i == NR_REGEX) {
      printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
      return false;
    }
  }

  return true;
}

static bool is_parenthesis_match(int p, int q) {
  int stk[nr_token + 2];
  int stk_top = 0;

  for (int i = p; i <= q; ++i) {
    if (tokens[i].type == ')' && stk_top && stk[stk_top - 1] == '(') {
      --stk_top;
      stk[stk_top] = 0;
    } else if (tokens[i].type == '(' || tokens[i].type == ')') {
      stk[stk_top] = tokens[i].type;
      ++stk_top;
    }
  }

  return stk_top == 0;
}

static bool check_parenthesis(int p, int q, bool *success) {
  bool ret = true;

  if (is_parenthesis_match(p, q) == false) {
    // bad parenthesis matching
    *success = false;
    ret = false;
  } else if (tokens[p].type != '(' || tokens[q].type != ')') {
    // not start && end with parenthesis
    ret = false;
  } else if (is_parenthesis_match(p + 1, q - 1) == false) {
    // **futher checking**
    ret = false;
  }

  return ret;
}

static int get_dominant_pos(int p, int q) {
  int parens = 0;
  int op = -1;
  int priority = 255;

  for (int i = p; i <=q; ++i) {
    if (tokens[i].type == '(') {
      ++parens;
    } else if (tokens[i].type == ')') {
      --parens;
    }

    if (parens == 0  // not in parenthesis
        && tokens_priority[tokens[i].type] != 0 // not non-operator
        && tokens_priority[tokens[i].type] < priority) {
      op = i;
      priority = tokens_priority[tokens[i].type];
    }
  }

  return op;
}

static int get_regval(char *reg_name, bool *success) {
  int regval = 0;

  if (strcmp(reg_name, "$eax") == 0) {
    regval = cpu.eax;
  } else if (strcmp(reg_name, "$ecx") == 0) {
    regval = cpu.ecx;
  } else if (strcmp(reg_name, "$edx") == 0) {
    regval = cpu.edx;
  } else if (strcmp(reg_name, "$ebx") == 0) {
    regval = cpu.ebx;
  } else if (strcmp(reg_name, "$esp") == 0) {
    regval = cpu.esp;
  } else if (strcmp(reg_name, "$ebp") == 0) {
    regval = cpu.ebp;
  } else if (strcmp(reg_name, "$esi") == 0) {
    regval = cpu.esi;
  } else if (strcmp(reg_name, "$edi") == 0) {
    regval = cpu.edi;
  } else if (strcmp(reg_name, "$eip") == 0) {
    regval = cpu.eip;
  } else {
    *success = false;
    printf("Unknown register\n");
  }

  return regval;
}

static int eval(int p, int q, bool *success) {
  if (*success == false) {
    return 0;
  }

  if (p > q) {
    *success = false;
    Log("p > q false");
    return 0;
  } else if (p == q) {
    switch (tokens[p].type) {
      case TK_HEX:
        return strtol(tokens[p].str, NULL, 16);
      case TK_DEC:
        return strtol(tokens[p].str, NULL, 10);
      case TK_REG:
        return get_regval(tokens[p].str, success);
      default:
        // non-number
        *success = false;
        return 0;
    }
  } else if (check_parenthesis(p, q, success) == true) {
    return eval(p + 1, q - 1, success);
  } else {
    // bad parenthesis
    if (*success == false) {
      printf("Bad expression\n");
      return 0;
    }

    int op = get_dominant_pos(p, q);

    // bad dominant position
    if (op == -1) {
      *success = false;
      printf("Bad expression\n");
      return 0;
    }

    int val1 = 0;
    int val2 = 0;

    // only eval val1 for binary operator
    if (tokens[op].type != TK_MINUS
        || tokens[op].type != TK_DEREF
        || tokens[op].type != '!') {
      val1 = eval(p, op - 1, success);
    }

    val2 = eval(op + 1, q, success);

    switch (tokens[op].type) {
      case '+':
        return val1 + val2;
      case '-':
        return val1 - val2;
      case '*':
        return val1 * val2;
      case '/':
        if (val2 == 0) {
          *success = false;
          printf("Divisor can't be 0");
        } else {
          return val1 / val2;
        }
      case TK_EQ:
        return val1 == val2;
      case TK_NEQ:
        return val1 != val2;
      case TK_AND:
        return val1 && val2;
      case TK_OR:
        return val1 || val2;
      case '!':
        return !val2;
      case TK_MINUS:
        return -val2;
      case TK_DEREF:
        return vaddr_read(val2, 4);
      default:
        return 0;
    }

    return 0;
  }
}

static void do_operator_check(void) {
  // judge '-' and '*'
  for (int i = 0; i < nr_token; ++i) {
    if (i == 0 || tokens[i - 1].type == '+'
          || tokens[i - 1].type == '-'
          || tokens[i - 1].type == '*'
          || tokens[i - 1].type == '/'
          || tokens[i - 1].type == TK_EQ
          || tokens[i - 1].type == TK_NEQ
          || tokens[i - 1].type == TK_AND
          || tokens[i - 1].type == TK_OR
          || tokens[i - 1].type == '!'
          || tokens[i - 1].type == '('
          || tokens[i - 1].type == TK_MINUS
          || tokens[i - 1].type == TK_DEREF) {
      // not binary operator
      if (tokens[i].type == '-') {
        tokens[i].type = TK_MINUS;
      } else if (tokens[i].type == '*') {
        tokens[i].type = TK_DEREF;
      }
    }
  }
}

uint32_t expr(char *e, bool *success) {
  if (!make_token(e)) {
    *success = false;
    Log("make token false");
    return 0;
  }

  /* TODO: Insert codes to evaluate the expression. */

  do_operator_check();

  return eval(0, nr_token - 1, success);
}
