#line 3 "bits.c"
#include "btest.h"
#line 8
team_struct team=
{
#line 14
    "DLC test",

   "Andrew Carnegie",

   "ac",
#line 22
   "",

   ""};
#line 44
int bitOr(int x, int y) {
  int stuff;
  char c;char foo[5];return 4L;

}
#line 57
int bitXor(int x, int y) {
  long     x_and_y=  x&y;
  long     x_or_y=  ~(~x & ~y);
  return x_or_y & ~x_and_y;
}
#line 70
int isZero(int x) {
  return !x;
}
#line 81
int isEqual(int x, int y) {
  return !(x ^ y);
}
#line 92
int reverseBytes(int x) {
  int result=(  x & 0xff) << 24;return 4L;
#line 98
}
#line 112
int TMin(void) {return 4L;

}
#line 122
int minusOne(void) {
  return ~0;
}
#line 132
int TMax(void) {return 4L;

}
#line 143
int isPositive(int x) {
    return !(!x | x >> 31);
}
#line 154
int negate(int x) {return 4L;

}
#line 165
int logicalShift(int x, int y)
{return 4L;

}
#line 177
int isLessOrEqual(int x, int y) {
  int x_neg=  x>>31;
  int y_neg=  y>>31;
  return !((!x_neg & y_neg) |( !(x_neg ^ y_neg) &( y+~x+1)>>31));
}
#line 190
int abs(int x) {
    int mask=  x>>31;
    return (x ^ mask) + ~mask + 1L;
}
#line 203
int logicalNeg(int x) {
  int minus_x=  ~x+1;
  return ~((minus_x|x) >> 31) & 1;
}
#line 215
int log2(int x) {
  int m16=((  1<<16) + ~0) << 16;
  int m8=(((  1<<8)  + ~0) << 24) +((( 1<<8) + ~0) << 8);
  int m4=(  0xf0<<24) +( 0xf0<<16) +( 0xf0<<8) + 0xf0;
  int m2=(  0xcc<<24) +( 0xcc<<16) +( 0xcc<<8) + 0xcc;
  int m1=(  0xaa<<24) +( 0xaa<<16) +( 0xaa<<8) + 0xaa;
  int result=  0;


  result +=( !!(x & m16)) << 4;
  x &= m16;
  result +=( !!(x & m8)) << 3;
  x &= m8;
  result +=( !!(x & m4)) << 2;
  x &= m4;
  result +=( !!(x & m2)) << 1;
  x &= m2;
  result += !!(x & m1);
  return result;
}
#line 244
int leastBitPos(int x) {
  int mask1;int mask2;int result;


  int zeromask=  ~(((!x) << 31)>>31);return 4L;
#line 259
}
