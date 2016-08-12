#ifndef RE_H
#define RE_H

#include "nfa.h"

/////////////////////////////////
// data structures
typedef enum Re_Kind_t {
  RE_KIND_EPS,
  RE_KIND_CHAR,
  RE_KIND_CONCAT,
  RE_KIND_ALT,
  RE_KIND_CLOSURE
} Re_Kind_t;


/* e -> \epsilon
      | c
      | e e
      | e | e
      | e*
*/
typedef struct Re_t *Re_t;
struct Re_t
{
  Re_Kind_t kind;
};

typedef struct Re_Eps_t *Re_Eps_t;
struct Re_Eps_t
{
  Re_Kind_t kind;
};

typedef struct Re_Char_t *Re_Char_t;
struct Re_Char_t 
{
  Re_Kind_t kind;
  int c;
};

typedef struct Re_Concat_t *Re_Concat_t;
struct Re_Concat_t
{
  Re_Kind_t kind;
  Re_t left;
  Re_t right;
};

typedef struct Re_Alt_t *Re_Alt_t;
struct Re_Alt_t
{
  Re_Kind_t kind;
  Re_t left;
  Re_t right;
};

typedef struct Re_Closure_t *Re_Closure_t;
struct Re_Closure_t
{
  Re_Kind_t kind;
  Re_t exp;
};

//////////////////////////////////
// operations
Re_t Re_Eps_new ();
Re_t Re_Char_new (int c);
Re_t Re_Concat_new (Re_t left, Re_t right);
Re_t Re_Alt_new (Re_t left, Re_t right);
Re_t Re_Closure_new (Re_t exp);

void Re_print (Re_t e);
Nfa_t Re_thompson (Re_t e);

#endif
