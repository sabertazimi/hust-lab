#include "nemu.h"

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <sys/types.h>
#include <regex.h>
#include <stdlib.h>

enum {
  TK_NOTYPE = 256, TK_EQ,

  /* TODO: Add more token types */

  TK_NEQ,
  TK_HEX,
  TK_DEC
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
  {"-", '-'},           // substract
  {"\\*", '*'},         // mutiple/reference
  {"/", '/'},           // divide
  {"==", TK_EQ},        // equal
  {"!=", TK_NEQ},       // not equal
  {"\\(", '('},         // left parenthesis
  {"\\)", ')'},         // right parenthesis
  {",", ','},           // comma
  {"(0x|0X)[0-9a-fA-F]+", TK_HEX},   // hexdecimal integer
  {"[0-9]+", TK_DEC}    // decimal integer
};

#define NR_REGEX (sizeof(rules) / sizeof(rules[0]) )

static regex_t re[NR_REGEX];

static bool check_parenthesis(int p, int q, bool *success);
static int eval(int p, int q, bool *success);

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
          case '(':
          case ')':
          case ',':
            tokens[nr_token].type = rules[i].token_type;
            ++nr_token;
            break;
          case TK_HEX:
          case TK_DEC:
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

uint32_t expr(char *e, bool *success) {
  if (!make_token(e)) {
    *success = false;
    return 0;
  }

  /* TODO: Insert codes to evaluate the expression. */

  return eval(0, nr_token - 1, success);
}

static bool check_parenthesis(int p, int q, bool *success) {
  bool ret = true;

  if (tokens[p].type != '(' || tokens[q].type != ')') {
    ret = false;
  }

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

  if (stk_top != 0) {
    *success = false;
    ret = false;
  }

  return ret;
}

static int eval(int p, int q, bool *success) {
  if (*success == false) {
    return 0;
  }

  if (p > q) {
    *success = false;
    return 0;
  } else if (p == q) {
    switch (tokens[p].type) {
      case TK_HEX:
        return strtol(tokens[p].str, NULL, 16);
      case TK_DEC:
        return strtol(tokens[p].str, NULL, 10);
      default:
        *success = false;
        return 0;
    }
  } else if (check_parenthesis(p, q, success) == true) {
    return eval(p + 1, q - 1, success);
  } else {
    // bad parenthesis
    if (*success == false) {
      return 0;
    }

    return 0;
  }
}
