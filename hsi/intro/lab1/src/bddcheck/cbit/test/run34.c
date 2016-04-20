#include <stdio.h>
#include <stdlib.h>

int test_trueThreeFourths(int x)
{
    long long int x3 = (long long int) x * 3LL;
    return (int) (x3/4LL);
}

int trueThreeFourths(int x) {
  int xs1 = x >> 1;
  int xs2 = x >> 2;
  /* Compute value from low-order 2 bits */
  int bias = (x >> 31) & 0x3;
  int xl2 = x & 0x3;
  int xl1 = (x & 0x1) << 1;
  int incr = (xl2 + xl1 + bias) >> 2;
  return xs1 + xs2 + incr;
}

int main(int argc, char *argv[])
{
    int i;
    for (i = 1; i < argc; i++) {
	int x = atoi(argv[i]);
	int v1 = trueThreeFourths(x);
	int v2 = test_trueThreeFourths(x);
	printf("x = %d (0x%x)\n", x, x);
	printf("\tref: %d (0x%x)\n", v2, v2);
	printf("\tGot: %d (0x%x)\n", v1, v1);
    }
    return 0;
}

