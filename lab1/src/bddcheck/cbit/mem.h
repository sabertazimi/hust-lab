/* Implementation of memory for arrays */

void init_mem();

/* Add entry for array */
void add_array(node_ptr var);

/* Remove entry for array */
void remove_array(node_ptr var);

/* Read array element.  */
context_ptr read_array(node_ptr var, context_ptr con, node_ptr index_list, int big_endian, bvec_ptr *valp);

/* Write array element */
context_ptr write_array(node_ptr var, context_ptr con, node_ptr index_list, bvec_ptr val, int big_endian);
