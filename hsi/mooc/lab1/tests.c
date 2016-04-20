/* Testing Code */

#include <limits.h>
#include <math.h>

/* Routines used by floation point test code */

/* Convert from bit level representation to floating point number */
float u2f(unsigned u) {
  union {
    unsigned u;
    float f;
  } a;
  a.u = u;
  return a.f;
}

/* Convert from floating point number to bit-level representation */
unsigned f2u(float f) {
  union {
    unsigned u;
    float f;
  } a;
  a.f = f;
  return a.u;
}

// Rating: 1
int test_bitAnd(int x, int y)
{
  return x&y;
}
int test_bitXor(int x, int y)
{
  return x^y;
}
int test_thirdBits(void) {
  int result = 0;
  int i;
  for (i = 0; i < 32; i+=3)
    result |= 1<<i;
  return result;
}
// Rating: 2
int test_fitsBits(int x, int n)
{
  int TMin_n = -(1 << (n-1));
  int TMax_n = (1 << (n-1)) - 1;
  return x >= TMin_n && x <= TMax_n;
}
int test_sign(int x) {
    if ( !x ) return 0;
    return (x < 0) ? -1 : 1;
}
int test_getByte(int x, int n)
{
    unsigned char byte;
    switch(n) {
    case 0:
      byte = x;
      break;
    case 1:
      byte = x >> 8;
      break;
    case 2:
      byte = x >> 16;
      break;
    default:
      byte = x >> 24;
      break;
    }
    return (int) (unsigned) byte;
}
// Rating: 3
int test_logicalShift(int x, int n) {
  unsigned u = (unsigned) x;
  unsigned shifted = u >> n;
  return (int) shifted;
}
int test_addOK(int x, int y)
{
    long long lsum = (long long) x + y;
    return lsum == (int) lsum;
}
// Rating: 4
int test_bang(int x)
{
  return !x;
}
// Extra Credit: Rating: 3
int test_conditional(int x, int y, int z)
{
  return x?y:z;
}
// Extra Credit: Rating: 4
int test_isPower2(int x) {
  int i;
  for (i = 0; i < 31; i++) {
    if (x == 1<<i)
      return 1;
  }
  return 0;
}
