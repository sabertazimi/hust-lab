/* Header file for CS 213 Assignment H1 */

/* Identifying information for project team */
typedef struct {
  /* Full name of first team member */
  char *name1;
  /* Andrew ID of first team member */
  char *id1;
  /* Full name of second team member */
  char *name2;
  /* Andrew ID of second team member */
  char *id2;
} team_struct;

/* Prototypes for functions in bits.c */

long int bitOr(long int, long int);
long int bitXor(long int, long int);
long int isZero(long int);
long int isEqual(long int, long int);
long int anyMaskedBits(long int, long int);
long int allMaskedBits(long int, long int);

long int is32(void);
long int signBit(void);
long int highByte(long int x);

long int TMin(void);
long int minusOne(void);
long int TMax(void);
long int isNegative(long int);
long int isPositive(long int);
long int negate(long int);
long int absval(long int);
long int isGreater(long int, long int); 

long int bang(long int);
long int bitOr(long int, long int);
long int bitXor(long int, long int);

/* Prototypes for test functions.  Call only when can't solve problem */
long int test_bitOr(long int, long int);
long int test_bitXor(long int, long int);
long int test_isZero(long int);
long int test_isEqual(long int, long int);
long int test_anyMaskedBits(long int, long int);
long int test_allMaskedBits(long int, long int);

long int test_is32(void);
long int test_signBit(void);
long int test_highByte(long int x);

long int test_TMin(void);
long int test_minusOne(void);
long int test_TMax(void);
long int test_isNegative(long int);
long int test_isPositive(long int);
long int test_negate(long int);
long int test_absval(long int);
long int test_isGreater(long int, long int);
long int test_bang(long int);

