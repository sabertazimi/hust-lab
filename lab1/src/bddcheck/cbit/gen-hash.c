/* Implementation of a very general hash table package.
   Hashes a structure consisting of a block of bytes, where the initial entry
   is a next pointer for use by the hash table.
*/
#include <stdlib.h>
#include "gen-hash.h"

/* Some useful parameters */
/* Targe load factors used to control resizing of bucket array */
#define MAX_LOAD 5.0
#define MIN_LOAD 1.5


/* Where should we start indexing into the prime array */
/* #define INIT_PI 5 */
#define INIT_PI 0
/* Good integer hash table sizes.  Primes just under a power of 2 */
static int  primes[] = {
			    2,
			    3,
			    7,
			    13,
			    23,
			    59,
			    113,
			    241,
			    503,
			    1019,
			    2039,
			    4091,
			    8179,
			    16369,
			    32749,
			    65521,
			    131063,
			    262139,
			    524269,
			    1048571,
			    2097143,
			    4194287,
			    8388593,
			    16777199,
			    33554393,
			    67108859,
			    134217689,
			    268435399,
			    536870879,
			    1073741789,
			    2147483629,
			    0
};

hash_table_ptr new_hash(hash_fun h, hash_eq_fun eq)
{
    hash_table_ptr result = malloc(sizeof(hash_table_ele));
    result->buckets = calloc(sizeof(hash_ele_ptr), primes[INIT_PI]);
    result->nbuckets = primes[INIT_PI];
    result->nelements = 0;
    result->h = h;
    result->eq = eq;
    return result;
}

/* Apply function to every element in hash table.  OK for operation to
   be destructive
*/
void apply_hash(hash_table_ptr ht, hash_operate_fun op_fun)
{
    int i;
    int n = ht->nbuckets;
    for (i = 0; i < n; i++) {
	hash_ele_ptr ele = ht->buckets[i];
	while (ele) {
	    hash_ele_ptr nele = ele->next_hash;
	    op_fun(ele);
	    ele = nele;
	}
    }
}


/* Dismantle hash table, freeing all of its storage.
   Elements are not freed by this function.
*/
void free_hash(hash_table_ptr ht)
{
    free (ht->buckets);
    free(ht);
}

/* Check whether need to resize table due to growing or shrinking */
static void check_for_resize(hash_table_ptr ht, int growing)
{
    int new_size = ht->nbuckets;
    hash_ele_ptr *new_buckets;
    float load = (float) ht->nelements/ht->nbuckets;
    int i;
    if (growing && load >= MAX_LOAD) {
	int pi;
	for (pi = INIT_PI; primes[pi] && primes[pi] <= new_size; pi++)
	    ;
	if (primes[pi])
	    new_size = primes[pi];
    } else if (!growing && new_size > primes[INIT_PI]
		 && load < MIN_LOAD) {
	int pi;
	for (pi = INIT_PI; primes[pi+1] < new_size; pi++)
	    ;
	new_size = primes[pi];
    } else
	return;
    /* Generate new table of size new_size */
    new_buckets = calloc(sizeof(hash_ele_ptr), new_size);
    /* Rehash all of the entries into the new set of buckets */
    for (i = 0; i < ht->nbuckets; i++) {
	hash_ele_ptr ele = ht->buckets[i];
	while (ele) {
	    hash_ele_ptr nele = ele->next_hash;
	    unsigned pos = (unsigned) ht->h(ele) % new_size;
	    ele->next_hash = new_buckets[pos];
	    new_buckets[pos] = ele;
	    ele = nele;
	}
    }
    free(ht->buckets);
    ht->buckets= new_buckets;
    ht->nbuckets = new_size;
}


/* Insert element into hash table.  Does not check for duplicates */
void insert_hash(hash_table_ptr ht, hash_ele_ptr ele)
{
    unsigned pos;
    check_for_resize(ht, 1);
    pos = (unsigned) ht->h(ele) % ht->nbuckets;
    ele->next_hash = ht->buckets[pos];
    ht->buckets[pos] = ele;
    ht->nelements++;
}

/* Look for element in hash table.  Must pass complete hash element.
 Returns one with matching key, or NULL
*/
hash_ele_ptr find_hash(hash_table_ptr ht, hash_ele_ptr key_ele)
{
    unsigned pos = (unsigned) ht->h(key_ele) % ht->nbuckets;
    hash_ele_ptr ele = ht->buckets[pos];
    while (ele) {
	if (ht->eq(key_ele, ele))
	    return ele;
	ele = ele->next_hash;
    }
    /* Didn't find matching element */
    return NULL;
}

/* Remove an element from hash table.  Does not free storage for element */
void unlink_hash(hash_table_ptr ht, hash_ele_ptr ele)
{
    unsigned pos;
    hash_ele_ptr *elep = NULL;
    hash_ele_ptr tele;
    check_for_resize(ht, 0);
    pos = (unsigned) ht->h(ele) % ht->nbuckets;
    elep = &(ht->buckets[pos]);
    tele = *elep;
    while (tele && tele != ele) {
	elep = &(tele->next_hash);
	tele = *elep;
    }
    if (tele) {
	/* Found the element.  Unlink it. */
	*elep = ele->next_hash;
	ht->nelements--;
    }
}

/* Hash functions */
int hash_string(char *s)
{
    int val = 0;
    int c;
    while ((c = *s++) != 0)
	val = ((val << 1) | ((val >> 31) & 0x1)) ^ c;
    return val;    
}

int hash_int_array(int *a, int cnt)
{
    int i;
    int val = 0;
    for (i = 0; i < cnt; i++)
	val = ((val << 3) | ((val >> 29) & 0x7)) ^ a[i];
    return val;    
}

int hash_pointer_array(void **a, int cnt)
{
    int i;
    int val = 0;
    for (i = 0; i < cnt; i++)
	val = ((val << 3) | ((val >> 29) & 0x7)) ^ (int)(long int) a[i];
    return val;    
}

