#include <stdlib.h>
#include <stdio.h>

#include "gen-hash.h"
#include "boolnet.h"
#include "ast.h"
#include "mem.h"

#define DEBUG 0

/* Arrays implemented using Efficient Memory Model, as described in Bryant, et al., CAV '97 */
/* Memory contains individual bytes, each represented as bvec */

/* Data structure for array EMM elements */
/* Memory consists of sequence of single-byte writes at word-length index.
   Most recent write is at head of list
*/
typedef struct EMM emm_ele, *emm_ptr;

struct EMM {
  op_ptr is_valid; /* Conditions under which this element was written */
  bvec_ptr index; /* Array index write */
  bvec_ptr byte; /* Byte written (type always unsigned char) */
  emm_ptr next;
};

/* Maintain buffer of all arrays */
/* Elements in array buffer */
typedef struct {
  node_ptr var;   /* Root array name */
  emm_ptr emm;    /* EMM list */
} array_buf_ele, *array_buf_ptr;

static int array_cnt = 0;
static int array_acount = 0;
static array_buf_ptr array_buf = NULL;

  /* Initialize array buffer */
void init_mem()
{
  array_cnt = 0;
  array_acount = 64;
  array_buf = calloc(array_acount, sizeof(array_buf_ele));
}

/* Find array entry  */
static int find_array(node_ptr var)
{
  int i;
  for (i = 0; i < array_cnt; i++) 
    if (var == array_buf[i].var)
      return i;
  return -1;
}


/* Add to set of local arrays */
void add_array(node_ptr var)
{
  if (array_cnt >= array_acount) {
    array_acount *= 2;
    array_buf = realloc(array_buf, array_cnt * sizeof(array_buf_ele));
  }
  array_buf[array_cnt].var = var;
  array_buf[array_cnt].emm = NULL;
  array_cnt++;
}
	 
/* Set array as if never had any associated writes */
void remove_array(node_ptr var)
{
  int i = find_array(var);
  emm_ptr m;
  if (i < 0)
    return; /* No associated storage */
  m = array_buf[i].emm;
  while (m) {
    emm_ptr nextm = m->next;
    free((void *) m);
    m = nextm;
  }
  array_buf[i].emm = NULL;
}

/************************* Implementing Memory Operations *******************************/

static void emm_write(emm_ptr *emmp, op_ptr is_valid, bvec_ptr index, bvec_ptr byte)
{
  emm_ptr ele = (emm_ptr) malloc(sizeof(emm_ele));
  ele->is_valid = is_valid;
  ele->index = index;
  ele->byte = byte;
  ele->next = *emmp;
  *emmp = ele;
}

#if DEBUG
static char abuf[WSIZE+1], dbuf[WSIZE+1];
#endif

static bvec_ptr emm_read(emm_ptr emm, bvec_ptr index, op_ptr *is_definedp)
{
  if (!emm) {
    *is_definedp = zero();
    return int_const(0);
  } else {
    op_ptr sub_defined;
    bvec_ptr sub_read = emm_read(emm->next, index, &sub_defined);
    op_ptr match = and_op(emm->is_valid, int_eq(index, emm->index));
    bvec_ptr result = int_mux(match, emm->byte, sub_read);
    *is_definedp = or_op(match, sub_defined);

#if DEBUG
    /* Debug */
    bvec_char(abuf, index, ISIZE);
    bvec_char(dbuf, result, CSIZE);
    printf("EMM Read with index %s --> %s\n", abuf, dbuf);
#endif

    return result;
  }
}

#if DEBUG
/* Debug */
char si[WSIZE+1], di[WSIZE+1];
#endif

/* Process index expression to generate byte offset into array.  Do bounds checking along way */
static context_ptr find_offset(node_ptr var, context_ptr con, node_ptr index_list, bvec_ptr *offsetp)
{
  bvec_ptr scale = int_const(var->wsize/CSIZE);
  bvec_ptr index = index_list->val;
  node_ptr dim = var->children[0]; /* Dimension structure for array */
  op_ptr ok = and_op(int_le(int_const(0), index), int_lt(index, dim->val));
  context_ptr result = clone_context(con);

#if DEBUG
  /* Debug */
  printf("Indexing %s", var->name);
    /* Debug */
    bvec_char(si, index, CSIZE);
    bvec_char(di, dim->val, CSIZE);
    printf("[%s/%s]", si, di);
#endif

  while (dim->children[1]) {
    if (!index_list->children[1]) {
      fprintf(ERRFILE, "Error: Index list shorter than dimensions in reference to array %s", var->name);
      exit(1);
    }
    dim = dim->children[1];
    index_list = index_list->children[1];
    ok = and_op(ok,
		  and_op(int_le(int_const(0), index_list->val), int_lt(index_list->val, dim->val)));
    index = int_add(int_mult(index, dim->val), index_list->val);

#if DEBUG
    /* Debug */
    bvec_char(si, index_list->val, CSIZE);
    bvec_char(di, dim->val, CSIZE);
    printf("[%s/%s]", si, di);
#endif
  }
  if (index_list->children[1]) {
    fprintf(ERRFILE, "Error: Index list longer than dimensions in reference to array %s\n", var->name);
    exit(1);
  }

  *offsetp = int_mult(scale, index);
  result->normal = and_op(con->normal, ok);
  result->mem_error = or_op(con-> mem_error, not_op(ok));

#if DEBUG
  /* Debug */
  bvec_char(si, *offsetp, ISIZE);
  printf(" --> %s\n", si);
#endif

  return result;
}

/* Read array element.  */
context_ptr read_array(node_ptr varnode, context_ptr con, node_ptr index_list, int big_endian, bvec_ptr *valp)
{
  bvec_ptr index;
  context_ptr result = find_offset(varnode, con, index_list, &index);
  bvec_ptr data = int_const(0);
  emm_ptr emm;
  op_ptr ok = one();

  int bcnt, i, idx;
  if (varnode->ntype != E_LAVAR) {
    fprintf(ERRFILE, "Error: Unexpected node type.  Expecting E_VAR, got %d\n", varnode->ntype);
    exit(1);
  }
  idx = find_array(varnode);
  if (idx < 0) {
    fprintf(ERRFILE, "Error: Couldn't find array %s", varnode->name);
    exit(1);
  }
  emm = array_buf[idx].emm;
  bcnt = varnode->wsize/CSIZE;

  for (i = 0; i < bcnt; i++) {
    op_ptr is_defined;
    int offset = big_endian ? bcnt-i : i;
    bvec_ptr bindex = i ? int_add(index, int_const(i)) : index;
    bvec_ptr byte = emm_read(emm, bindex, &is_defined);
    data = replace_byte(data, byte, offset);
    ok = and_op(ok, is_defined);
  }
  result->normal = and_op(result->normal, ok);
  result->mem_error = or_op(result->mem_error, not_op(ok));
  *valp = data;
  return result;
}


/* Write array element */
context_ptr write_array(node_ptr varnode, context_ptr con, node_ptr index_list, bvec_ptr val, int big_endian)
{
  bvec_ptr index;
  context_ptr result = find_offset(varnode, con, index_list, &index);
  emm_ptr *emmp;

  int bcnt, i, idx;
  if (varnode->ntype != E_LAVAR) {
    fprintf(ERRFILE, "Error: Unexpected node type.  Expecting E_VAR, got %d\n", varnode->ntype);
    exit(1);
  }
  idx = find_array(varnode);
  if (idx < 0) {
    fprintf(ERRFILE, "Error: Couldn't find array %s", varnode->name);
    exit(1);
  }
  emmp = &(array_buf[idx].emm);
  bcnt = varnode->wsize/CSIZE;

  for (i = 0; i < bcnt; i++) {
    int offset = big_endian ? bcnt-i : i;
    bvec_ptr bindex = i ? int_add(index, int_const(i)) : index;
    bvec_ptr byte = extract_byte(val, offset);

#if DEBUG
    bvec_char(abuf, bindex, ISIZE);
    bvec_char(dbuf, byte, CSIZE);
    printf("EMM write %s --> %s\n", dbuf, abuf);
#endif
    
    emm_write(emmp, result->normal, bindex, byte);
  }
  return result;
}
