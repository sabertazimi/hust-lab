/* Implementation of a very general hash table package.
   Hashes a structure consisting of a block of bytes, where the initial entry
   is a next pointer for use by the hash table.
*/

/* Entries in hash table are blocks of bytes, where the first part of
   the structure contains a next pointer for use by the table.  Remaining
   bytes carried along implicily */

typedef struct HELE hash_ele, *hash_ele_ptr;

struct HELE {
    hash_ele_ptr next_hash;
};


/* User must supply hash function that will take a
   hash element and return an integer */
typedef int (*hash_fun)(hash_ele_ptr);

/* User must supply function that tests two elements for equality */
typedef int (*hash_eq_fun)(hash_ele_ptr, hash_ele_ptr);

/* Functions that can be used to operate on hash elements */
typedef void (*hash_operate_fun)(hash_ele_ptr);

/* Actual representation of the hash table */
typedef struct {
    hash_ele_ptr *buckets;
    int nbuckets;
    int nelements;
    hash_fun h;
    hash_eq_fun eq;
} hash_table_ele, *hash_table_ptr;

hash_table_ptr new_hash(hash_fun h, hash_eq_fun eq);

/* Apply function to every element in hash table.
   OK for operation to be destructive, e.g., by freeing element,
   as long as don't try to access hash table afterward.
*/
void apply_hash(hash_table_ptr ht, hash_operate_fun op_fun);

/* Dismantle hash table, freeing all of its storage.  
   Elements are not freed by this function
*/
void free_hash(hash_table_ptr ht);

/* Insert element into hash table.  Does not check for duplicates */
void insert_hash(hash_table_ptr ht, hash_ele_ptr ele);

/* Look for element in hash table.  Must pass complete hash element.
 Returns one with matching key, or NULL
*/
hash_ele_ptr find_hash(hash_table_ptr ht, hash_ele_ptr key_ele);

/* Remove an element from hash table.  Does not free storage for element */
void unlink_hash(hash_table_ptr ht, hash_ele_ptr ele);

/* Some useful hash functions */
/* Map strings to integers */
int hash_string(char *s);

/* Hash array of integers */
int hash_int_array(int *a, int cnt);

/* Hash array of pointers */
int hash_pointer_array(void **a, int cnt);
