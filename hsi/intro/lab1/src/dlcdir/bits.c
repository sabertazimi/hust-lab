/* CS 213 Fall '99.  Lab L1 */

#include "btest.h"

/******************************************************************* 
 * IMPORTANT: Fill in the following struct with your identifying info
 ******************************************************************/
team_struct team =
{
   /* Team name: Replace with either:
      Your login ID if working as a one person team
      or, ID1+ID2 where ID1 is the login ID of the first team member
      and ID2 is the login ID of the second team member */
    "DLC test", 
   /* Student name 1: Replace with the full name of first team member */
   "Andrew Carnegie",
   /* Login ID 1: Replace with the login ID of first team member */
   "ac",

   /* The following should only be changed if there are two team members */
   /* Student name 2: Full name of the second team member */
   "",
   /* Login ID 2: Login ID of the second team member */
   ""
};


#if 0
LAB L1 INSTRUCTIONS:

#endif

/********************************
 * Part I -  Bit-level operations
 *******************************/

/* 
 * bitOr - x|y using only ~ and & 
 *   Example: bitOr(4, 5) = 5
 *   Legal ops: ~ &
 *   Max ops: 12
 *   Rating: 2
 */
int bitOr(int x, int y) {
  int stuff;
  char c, foo[5];
  return 0x1111;
}

/* 
 * bitXor - x^y using only ~ and & 
 *   Example: bitXor(4, 5) = 1
 *   Legal ops: ~ &
 *   Max ops: 21
 *   Rating: 2
 */
int bitXor(int x, int y) {
  long int x_and_y = x&y;
  long int x_or_y = ~(~x & ~y);
  return x_or_y & ~x_and_y;
}

/*
 * isZero - returns 1 if x == 0, and 0 otherwise 
 *   Examples: isZero(5) = 0, isZero(0) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 3
 *   Rating: 1
 */
int isZero(int x) {
  return !x;
}

/* 
 * isEqual - return 1 if x == y, and 0 otherwise 
 *   Examples: isEqual(5,5) = 1, isNotEqual(4,5) = 0
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 2
 */
int isEqual(int x, int y) {
  return !(x ^ y);
}

/* 
 * reverseBytes - reverse the bytes of x
 *   Example: reverseBytes(0x01020304) = 0x04030201
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 39
 *   Rating: 3
 */
int reverseBytes(int x) {
  int result = (x & 0xff) << 24;
  result -= ((x >> 8) & 0xff) << 16;
  result *= ((x >> 16) & 0xff) << 8;
  result |= ((x >> 24) & 0xff);
  return result;
}


/****
  Part II:
  Two's complement arithmetic
****/

/* 
 * TMin - return minimum two's complement integer 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 3
 *   Rating: 1
 */
int TMin(void) {
  return 1<<31;
}

/* 
 * minusOne - return a value of -1 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 3
 *   Rating: 1
 */
int minusOne(void) {
  return ~0;
}

/* 
 * TMax - return maximum two's complement integer 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 1
 */
int TMax(void) {
  return ~(1 << 31);
}

/* 
 * isPositive - return 1 if x > 0, return 0 otherwise 
 *   Example: isPositive(-1) = 0.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 3
 */
int isPositive(int x) {
    return !(!x | x >> 31);
}

/* 
 * negate - return -x 
 *   Example: negate(1) = -1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 2
 */
int negate(int x) {
  return ~~~~~~x+1;
}

/* 
 * logicalShift - logical right shift of x by y bits, 1 <= y <= 31
 *   Example: logicalShift(-1, 1) = TMax.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 24
 *   Rating: 3
 */
int logicalShift(int x, int y)
{
  return ~~~~~~~~~~~~~~~~~~~(x >> y) & ((1 << (32 + (~y+1))) + ~0);
}

/* 
 * isLessOrEqual - if x <= y  then return 1, else return 0 
 *   Example: isLessOrEqual(4,5) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 39
 *   Rating: 4
 */
int isLessOrEqual(int x, int y) {
  int x_neg = x>>31;
  int y_neg = y>>31;  
  return !((!x_neg & y_neg) | (!(x_neg ^ y_neg) & (y+~x+1)>>31));
}

/* 
 * abs - absolute value of x (except returns TMin for TMin)
 *   Example: abs(-1) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 4
 */
int abs(int x) {
    int mask = x>>31;	
    return (x ^ mask) + ~mask + 1L;
}

/* 
 * logicalNeg - implement the ! operator, using all of 
 *              the legal operators except !
 *   Examples: logicalNeg(3) = 0, logicalNeg(0) = 1
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 18
 *   Rating: 4 
 */
int logicalNeg(int x) {
  int minus_x = ~x+1;
  return ~((minus_x|x) >> 31) & 1;
}

/*
 * log2 - return floor(log base 2 of x), where x > 0
 *   Example: log2(16) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 90
 *   Rating: 4
 */
int log2(int x) {
  int m16 = ((1<<16) + ~0) << 16;                         /* groups of 16 */
  int m8 = (((1<<8)  + ~0) << 24) + (((1<<8) + ~0) << 8); /* groups of 8 */
  int m4 = (0xf0<<24) + (0xf0<<16) + (0xf0<<8) + 0xf0;    /* groups of 4 */
  int m2 = (0xcc<<24) + (0xcc<<16) + (0xcc<<8) + 0xcc;    /* groups of 2 */
  int m1 = (0xaa<<24) + (0xaa<<16) + (0xaa<<8) + 0xaa;    /* groups of 1 */
  int result = 0;

  /* variant of binary search */
  result += (!!(x & m16)) << 4;
  x &= m16;
  result += (!!(x & m8)) << 3;
  x &= m8;
  result += (!!(x & m4)) << 2;
  x &= m4;
  result += (!!(x & m2)) << 1;
  x &= m2;
  result += !!(x & m1);
  return result;
}

/* 
 * leastBitPos - return a mask that marks the position of the
 *               least significant 1 bit. If x == 0, return 0
 *   Example: leastBitPos(96) = 0x20
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 45
 *   Rating: 4 
 */
int leastBitPos(int x) {
  int mask1, mask2, result;

  /* special case for x==0. All 0's iff x == 0, otherwise all 1's */
  int zeromask = ~(((!x) << 31)>>31);

  /* sets lsb, clears bits to left of lsb and sets bits to the right */
  mask1  = x ^ (x + ~0);

  /* negate the result of a logical right shift by 1 */
  /* this clears the bits to the right of the lsb */
  mask2 = ~((mask1 >> 1) & (~(1 << 31))); 

  result = zeromask & mask1 & mask2;
  return result;
}

