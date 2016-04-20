#include <stdio.h>
#include <stdlib.h>

#include "bits.h"



/* Code for simple bit-level manipulations */
/* Set up to verify with BDD Checker */

long int bad_long_tmin() {
  return
    /* $begin bad_long_tmin */
    /* WARNING: This code is buggy */
    /* Shift 1 over by 8*sizeof(long) - 1 */
    1L  << sizeof(long)<<3 - 1
    /* $end bad_long_tmin */
    ;
}

long int long_tmin() {
  return
    /* $begin long_tmin_solve */
    /* Shift 1 over by 8*sizeof(long) - 1 */
    1L  << (sizeof(long)<<3) - 1
    /* $end long_tmin_solve */
    ;
}

long int test_long_tmin() {
  return
    /* Shift 1 over by 8*sizeof(long) - 1 */
    1L  << (8*sizeof(long) - 1);
}

/* $begin get_msb */
/* Get most significant byte from x */
int get_msb(int x) {
    /* Shift by w-8 */
    int shift_val = (sizeof(int)-1)<<3;
    /* Arithmetic shift */
    int xright = x >> shift_val;
    /* Zero all but LSB */
    return xright & 0xFF;
}
/* $end get_msb */

int test_get_msb(int x) {
    /* Shift by w-8 */
    int shift_val = 8*(sizeof(int)-1);
    int xright = (unsigned) x >> shift_val;
    return xright;
}

/* $begin leftmost_one_solve */
/*
 * Generate mask indicating leftmost 1 in x.
 * For example 0xFF00 -> 0x8000, and 0x6600 --> 0x4000
 * If x = 0, then return 0.
 */
unsigned leftmost_one(unsigned x) {
    /* First, convert to pattern of the form 0...011...1 */
    x |= (x>>1);
    x |= (x>>2);
    x |= (x>>4);
    x |= (x>>8);
    x |= (x>>16);
    /* Now knock out all but leading 1 bit */
    x ^= (x>>1);
    return x;
}
/* $end leftmost_one_solve */

/*
 * Generate mask indicating leftmost 1 in x.
 * For example 0xFF00 -> 0x8000, and 0x6600 --> 0x4000
 * If x = 0, then return 0.
 */
unsigned old_leftmost_one(unsigned x) {
    /* Set of bits being probed */
    unsigned probe_bits = x;
    /* Use divide and conquer */
    int position = x != 0;
  
    /* Is there a 1 in the upper 16/32 bits? */
    int in_upper16 = (probe_bits & 0xFFFF0000u) != 0;
    /* If so, shift */
    position <<= (in_upper16 << 4);
    /* Merge upper and lower probe bits */
    probe_bits = (probe_bits & -!in_upper16) | (probe_bits >> 16);
  
    /* Is there a 1 in the remaining upper 8/16 bits? */
    int in_upper8 = (probe_bits & 0xFF00) != 0;
    /* If so, shift */
    position <<= (in_upper8 << 3);
    /* Merge upper and lower probe bits */
    probe_bits  = (probe_bits & -!in_upper8) | (probe_bits >> 8);

    /* Is there a 1 in the remaining upper 4/8 bits? */
    int in_upper4 = (probe_bits & 0xF0) != 0;
    /* If so, shift */
    position <<= (in_upper4 << 2);
    /* Merge upper and lower probe bits */
    probe_bits  = (probe_bits & -!in_upper4) | (probe_bits >> 4);

    /* Is there a 1 in the remaining upper 2/4 bits? */
    int in_upper2 = (probe_bits & 0xC) != 0;
    /* If so, shift */
    position <<= (in_upper2 << 1);
    /* Merge upper and lower probe bits */
    probe_bits  = (probe_bits & -!in_upper2) | (probe_bits >> 2);

    /* Is there a 1 in the remaining upper 1/2 bit? */
    int in_upper1 = (probe_bits & 0x2) != 0;
    /* If so, shift */
    position <<= in_upper1;

    return position;
}


/*
 * Generate mask indicating leftmost 1 in x.
 * For example 0xFF00 -> 0x8000, and 0x6600 --> 0x4000
 * If x = 0, then return 0.
 */
unsigned test_leftmost_one(unsigned x) {
    unsigned mask;
    for (mask = 1u<<31; mask; mask >>= 1)
	if (x & mask)
	    return mask;
    /* x is all Zeros */
    return 0;
}


/* $begin rightmost_one_solve */
/*
 * Generate mask indicating rightmost 1 in x.
 * For example 0xFF00 -> 0x0100, and 0x6600 --> 0x200.
 * If x = 0, then return 0.
 */
unsigned rightmost_one(unsigned x) {
    /*
     * Rightmost portions of x and -x
     * are identical up to first 1
     */
    return (x & -x);
}
/* $end rightmost_one_solve */

/*
 * Generate mask indicating rightmost 1 in x
 * For example 0xFF00 -> 0x0100, and 0x6600 --> 0x200
 */
int test_rightmost_one(unsigned x) {
    int mask;
    for (mask = 1; mask; mask <<= 1)
	if (x & mask)
	    return mask;
    /* x is all Zeros */
    return 0;
}

/* $begin any_one_solve */
/* Return 1 when any bit of x equals 1; 0 otherwise */
int any_one(unsigned x) {
    /* !x detects whether x == 0 */
    return !!x;
}
/* $end any_one_solve */

/* Any bit of x equals 1 */
int test_any_one(unsigned x)
{
    return (x != 0);
}

/* $begin any_zero_solve */
/* Return 1 when any bit of x equals 0; 0 otherwise */
int any_zero(unsigned x) {
    /* Look for a 1 in ~x */
    return !!~x;
}
/* $end any_zero_solve */

/* Any bit of x equals 0 */
int test_any_zero(unsigned x)
{
    return (x != ~0);
}

/* $begin any_LSB_one_solve */
/* Return 1 when any bit of LSB of x equals 1; 0 otherwise */
int any_LSB_one(unsigned x) {
    /* Use 0xFF to mask all but LSB */
    return !!(x&0xFF);
}
/* $end any_LSB_one_solve */

/* Any bit of LSB of x equals 1 */
int test_any_LSB_one(unsigned x)
{
    unsigned char LSB = (unsigned char) x;
    return (LSB != 0);
}

/* $begin any_LSB_zero_solve */
/* Return 1 when any bit of LSB of x equals 0; 0 otherwise */
int any_LSB_zero(unsigned x) {
    /* Use 0xFF to mask all but LSB */
    return !!(~x&0xFF);
}
/* $end any_LSB_zero_solve */

/* Any bit of LSB of x equals 0 */
int test_any_LSB_zero(unsigned x)
{
    unsigned char LSB = (unsigned char) x;
    unsigned char allones = (unsigned char) ~0;
    return (LSB != allones);
}

/* $begin any_MSB_one_solve */
/* Return 1 when any bit of MSB of x equals 1; 0 otherwise */
int any_MSB_one(unsigned x) {
    /* Use shifted 0xFF to mask all but MSB */
    int msb_mask = 0xFF << (sizeof(int)-1<<3);
    return !!(x&msb_mask);
}
/* $end any_MSB_one_solve */

/* Any bit of MSB of x equals 1 */
int test_any_MSB_one(unsigned x)
{
    int i;
    for (i = (sizeof(int)<<3)-8; i < (sizeof(int)<<3); i++)
        if (x & (1<<i))
            return 1;
    return 0;
}

/* $begin any_MSB_zero_solve */
/* Return 1 when any bit of MSB of x equals 0; 0 otherwise */
int any_MSB_zero(unsigned x) {
    /* Use shifted 0xFF to mask all but MSB */
    int msb_mask = 0xFF << (sizeof(int)-1<<3);
    return !!(~x&msb_mask);
}
/* $end any_MSB_zero_solve */

/* Any bit of MSB of x equals 0 */
int test_any_MSB_zero(unsigned x)
{
    int i;
    for (i = (sizeof(int)<<3)-8; i < (sizeof(int)<<3); i++)
        if (!(x & (1<<i)))
            return 1;
    return 0;
}

/* $begin any_odd_one_solve */
/* Return 1 when any odd bit of x equals 1; 0 otherwise.  Assume w=32 */
int any_odd_one(unsigned x) {
    /* Use mask to select odd bits */
    return (x&0xAAAAAAAA) != 0;
}
/* $end any_odd_one_solve */

/* Any odd bit of x equals 1.  Assume w=32 */
int test_any_odd_one(unsigned x)
{
    int mask = 1<<1; /* First odd bit */
    while (mask) {
	if (x & mask)
	    return 1;
	mask <<= 2;
    }
    return 0;
}

/* $begin any_even_one_solve */
/* Return 1 when any even bit of x equals 1; 0 otherwise.  Assume w=32 */
int any_even_one(unsigned x) {
    /* Use mask to select even bits */
    return (x&0x55555555) != 0;
}
/* $end any_even_one_solve */

/* Any even bit of x equals 1.  Assume w=32 */
int test_any_even_one(unsigned x)
{
    int mask = 1<<0; /* First odd bit */
    while (mask) {
	if (x & mask)
	    return 1;
	mask <<= 2;
    }
    return 0;
}

/* $begin odd_ones_solve */
/* Return 1 when x contains an odd number of 1s; 0 otherwise.  Assume w=32 */
int odd_ones(unsigned x) {
    /* Use bit-wise ^ to compute multiple bits in parallel */
    /* Xor bits i and i+16 for 0 <= i < 16 */
    unsigned p16 = (x  >> 16) ^ x;
    /* Xor bits i and i+8 for 0 <= i < 8 */
    unsigned p8 =  (p16>>  8) ^ p16;
    /* Xor bits i and i+4 for 0 <= i < 4 */
    unsigned p4 =  (p8 >>  4) ^ p8;
    /* Xor bits i and i+2 for 0 <= i < 2 */
    unsigned p2 =  (p4 >>  2) ^ p4;
    /* Xor bits 0 and 1 */
    unsigned p1 =  (p2 >>  1) ^ p2;
    /* Answer is in least significant bit */
    return p1 & 1;
}
/* $end odd_ones_solve */

/* Is there an odd number of ones in x?  Assume w=32 */
int test_odd_ones(unsigned x)
{
    int i;
    int result = 0;
    for (i = 0; i < 8 * sizeof(int); i++)
	if (x & (1<<i))
	    result = !result;
    return result;
}

/* $begin even_ones_solve */
/* Return 1 when x contains an even number of 1s; 0 otherwise.  Assume w=32 */
int even_ones(unsigned x) {
    /* Use bit-wise ^ to compute multiple bits in parallel */
    /* Xor bits i and i+16 for 0 <= i < 16 */
    unsigned p16 = (x  >> 16) ^ x;
    /* Xor bits i and i+8 for 0 <= i < 8 */
    unsigned p8 =  (p16>>  8) ^ p16;
    /* Xor bits i and i+4 for 0 <= i < 4 */
    unsigned p4 =  (p8 >>  4) ^ p8;
    /* Xor bits i and i+2 for 0 <= i < 2 */
    unsigned p2 =  (p4 >>  2) ^ p4;
    /* Xor bits 0 and 1 */
    unsigned p1 =  (p2 >>  1) ^ p2;
    /* Least significant bit is 1 if odd number of ones */
    return !(p1 & 1);
}
/* $end even_ones_solve */

/* Is there an even number of ones in x?  Assume w=32 */
int test_even_ones(unsigned x)
{
    int i;
    int result = 1;
    for (i = 0; i < 8 * sizeof(int); i++)
	if (x & (1<<i))
	    result = !result;
    return result;
}


/* $begin lower_one_mask_solve */
/*
 * Mask with least signficant n bits set to 1
 * Examples: n = 6 --> 0x2F, n = 17 --> 0x1FFFF 
 * Assume 1 <= n <= w
 */
int lower_one_mask(int n) {
    /*
     * 2^n-1 has bit pattern 0...01..1 (n 1's)
     * But, we must avoid a shift by 32
     */
    return (2<<(n-1)) - 1;
}
/* $end lower_one_mask_solve */

/*
 * Mask of n 1's in lower bits
 * Assumes 1 <= n <= w
 */
int test_lower_one_mask(int n)
{
    int result = 0;
    int i;
    for (i = 0; i < n; i++)
	result = result | (1<<i);
    return result;
}

/* $begin lower_bits_solve */
/*
 * Clear all but least signficant n bits of x
 * Examples: x = 0x78ABCDEF, n = 8 --> 0xEF, n = 16 --> 0xCDEF
 * Assume 1 <= n <= w
 */
int lower_bits(int x, int n) {
    /* 
     * Create mask with lower n bits set
     * 2^n-1 has bit pattern 0...01..1 (n 1's)
     * But, we must avoid a shift by 32
     */
    int mask = (2<<(n-1)) - 1;
    return x & mask;
}
/* $end lower_bits_solve */

/*
 * Clear all but least signficant n bits of x
 * Examples: x = 0x78ABCDEF, n = 8 --> 0xEF, n = 16 --> 0xCDEF
 * Assumes 1 <= n <= w
 */
int test_lower_bits(int x, int n)
{
    int result = 0;
    int i;
    for (i = 0; i < n; i++)
      result = result | (x & (1<<i));
    return result;
}


/* $begin fits_bits_solve */
/*
 * Return 1 when x can be represented as an n-bit, 2's complement number;
 * 0 otherwise
 * Assume 1 <= n <= w
 */
int fits_bits(int x, int n) {
    /*
     * Use left shift then right shift
     * to sign extend from n bits to full int
     */
    int count = (sizeof(int)<<3)-n;
    int leftright = (x << count) >> count;
    /* See if still have same value */
    return x == leftright;
}
/* $end fits_bits_solve */

/* Can x be represented as an n-bit, 2's complement number? */
/* Assume 1 <= n <= w */
int test_fits_bits(int x, int n)
{
    int tmax_n = (1<<(n-1)) -1;
    int tmin_n = -tmax_n - 1;
    return x >= tmin_n && x <= tmax_n;
}

/* $begin rotate_right_solve */
/*
 * Do rotating right shift.  Assume 0 <= n < w
 * Examples when x = 0x12345678:
 *    n=4 -> 0x81234567, n=20 -> 0x45678123
 */   
unsigned rotate_right(unsigned x, int n) {
    /* Mask all 1's when n = 0 and all 0's otherwise */
    int z_mask = -!n;
    /* Right w-n bits */
    unsigned right = x >> n;
    /* Left n bits */
    unsigned left  = x << ((sizeof(unsigned)<<3)-n);
    return (z_mask & x) | (~z_mask & (left|right));
}
/* $end rotate_right_solve */

/* Do rotating right shift.  Assume 0 <= n < w */
unsigned test_rotate_right(unsigned x, int n)
{
    unsigned result = x;
    int i;
    for (i = 0; i < n; i++) {
	unsigned lsb = result & 0x1;
	unsigned rest = result >> 1;
	result = (lsb << ((sizeof(unsigned)<<3)-1)) | rest;
    }
    return result;
}

/* $begin rotate_left_solve */
/*
 * Do rotating left shift.  Assume 0 <= n < w
 * Examples when x = 0x12345678:
 *    n=4 -> 0x23456781, n=20 -> 0x67812345
 */   
unsigned rotate_left(unsigned x, int n) {
    /* Mask all 1's when n = 0 and all 0's otherwise */
    int z_mask = -!n;
    /* Left w-n bits */
    unsigned left  = x << n;
    /* Right n bits */
    unsigned right = x >> ((sizeof(unsigned)<<3)-n);
    return (z_mask&x) | (~z_mask &(left|right));
}
/* $end rotate_left_solve */

/* Do rotating left shift.  Assume 0 <= n < w */
unsigned test_rotate_left(unsigned x, int n)
{
    int w = (sizeof(unsigned)<<3);
    n %= w;  /* No need to have multiple rotations */
    unsigned result = x;
    int i;
    for (i = 0; i < n; i++) {
	unsigned msb = result >> ((sizeof(unsigned)<<3)-1);
	unsigned rest = result << 1;
	result = rest | msb;
    }
    return result;
}

/* $begin saturating_add_solve */
/* Addition that saturates to TMin or TMax */
int saturating_add(int x, int y) {
    int sum = x + y;
    int wm1 = (sizeof(int)<<3)-1;
    /* In the following we create "masks" consisting of all 1's
       when a condition is true, and all 0's when it is false */
    int xneg_mask = (x >> wm1);
    int yneg_mask = (y >> wm1);
    int sneg_mask = (sum >> wm1);
    int pos_over_mask = ~xneg_mask & ~yneg_mask & sneg_mask;
    int neg_over_mask = xneg_mask & yneg_mask & ~sneg_mask;
    int over_mask = pos_over_mask | neg_over_mask;
    /* $end saturating_add_solve */
    int INT_MAX = ~(1<<((sizeof(int)<<3)-1));
    int INT_MIN = INT_MAX+1;
    /* $begin saturating_add_solve */
    /* Choose between sum, INT_MAX, and INT_MIN */
    int result =
	(~over_mask & sum)|
        (pos_over_mask & INT_MAX)|(neg_over_mask & INT_MIN);
    return result;
}
/* $end saturating_add_solve */

/* Addition that saturates to TMin or TMax */
int test_saturating_add(int x, int y)
{
    long long llx = (long long) x;
    long long lly = (long long) y;
    long long llsum = llx + lly;
    int INT_MAX = ~(1<<((sizeof(int)<<3)-1));
    int INT_MIN = INT_MAX+1;
    int sum = (int) llsum;
    if (sum == llsum)
	return sum;
    if (llsum < 0)
	return INT_MIN;
    return INT_MAX;
}
  
/* $begin sub_ok_solve */
/* Return 1 when computing x-y does not overflow; 0 otherwise. */
int sub_ok(int x, int y) {
    int diff = x-y;
    int wm1 = (sizeof(int)<<3)-1;
    int xneg = (x >> wm1) & 1;
    int yneg = (y >> wm1) & 1;
    int dneg = (diff >> wm1) & 1;
    /* Compute overflow rules, but modified for subtraction */
    int pos_over = !xneg && yneg && dneg;
    int neg_over = xneg && !yneg && !dneg;
    return !pos_over && !neg_over;
}
/* $end sub_ok_solve */

/* Can we compute x-y without overflow? */
int test_sub_ok(int x, int y)
{
    long long llx = (long long) x;
    long long lly = (long long) y;
    long long lldiff = llx - lly;
    int diff = (int) lldiff;
    return (lldiff == diff);
}

/* $begin sub_ovf_solve */  
/* Return 1 when computing x-y causes overflow; 0 otherwise. */
int sub_ovf(int x, int y) {
    int diff = x-y;
    int wm1 = (sizeof(int)<<3)-1;
    int xneg = (x >> wm1) & 1;
    int yneg = (y >> wm1) & 1;
    int dneg = (diff >> wm1) & 1;
    /* Compute overflow rules, but modified for subtraction */
    int pos_over = !xneg && yneg && dneg;
    int neg_over = xneg && !yneg && !dneg;
    return pos_over || neg_over;
}
/* $end sub_ovf_solve */  

/* Will computing x-y cause overflow? */
int test_sub_ovf(int x, int y)
{
    long long llx = (long long) x;
    long long lly = (long long) y;
    long long lldiff = llx - lly;
    int diff = (int) lldiff;
    return (lldiff != diff);
}

/* $begin divide_power2_solve */  
/* Divide by power of two.  Assume 0 <= k < w-1 */
int divide_power2(int x, int k) {
    /* All 1's if x < 0 */
    int mask = x>>((sizeof(int)<<3)-1);
    int bias = mask & ((1<<k)-1);
    return (x+bias)>>k;
}
/* $end divide_power2_solve */  

/* Divide by power of two.  Assume 0 <= k <= w-1 */
int test_divide_power2(int x, int k)
{
    int p2k = 1<<k;
    return x/p2k;
}

/* $begin mul3div4_solve */  
/* Compute 3*x/4 */
int mul3div4(int x) {
    int mul3 = x + (x<<1);
    int mul3_mask = mul3 >> ((sizeof(int)<<3)-1);
    int bias = mul3_mask & 3;
    return (mul3+bias)>>2;
}
/* $end mul3div4_solve */  

/* Compute 3*x/4 */
int test_mul3div4(int x)
{
    return 3*x/4;
}

/* $begin threefourths_solve */  
/* Compute 3/4*x with no overflow */
int threefourths(int x) {
    int xl2 = x & 0x3;
    int xl1 = (x&1) << 1;
    int x_mask = x >> ((sizeof(int)<<3)-1);
    int bias = x_mask & 3;
    int incr = (xl2+xl1+bias) >> 2;
    int s2 = x >> 2;
    int s1 = x >> 1;
    return s1 + s2 + incr;
}
/* $end threefourths_solve */  

/* Compute 3/4*x with no overflow */
int test_threefourths(int x)
{
    long long llx = (long long) x;
    long long val = 3*llx/4;
    return (int) val;
}

/* $begin mul5div8_solve */  
/* Compute 5*x/8 */
int mul5div8(int x) {
    int mul5 = x + (x<<2);
    int mul5_mask = mul5 >> ((sizeof(int)<<3)-1);
    int bias = mul5_mask & 7;
    return (mul5+bias)>>3;
}
/* $end mul5div8_solve */  

/* Compute 5*x/8 */
int test_mul5div8(int x)
{
    return 5*x/8;
}

/* $begin fiveeighths_solve */  
/* Compute 5/8*x with no overflow */
int fiveeighths(int x) {
    int xl3 = x & 0x7;
    int xl1 = (x&1) << 2;
    int x_mask = x >> ((sizeof(int)<<3)-1);
    int bias = x_mask & 7;
    int incr = (xl3+xl1+bias) >> 3;
    int s3 = x >> 3;
    int s1 = x >> 1;
    return s1 + s3 + incr;
}
/* $end fiveeighths_solve */  

/* Compute 5/8*x with no overflow */
int test_fiveeighths(int x)
{
    long long llx = (long long) x;
    long long val = 5*llx/8;
    return (int) val;
}

/* Check if multiplication OK.  Use char's to make feasible for BDDs */
int tmult_ok1(char x, char y) {
  char prod = x*y;
  int iprod = (int) x * y;
  return iprod == prod;
}

/* Check if multiplication OK.  Use char's to make feasible for BDDs */
int test_tmult_ok1(char x, char y) {
  int iprod = (int) x*y;
  return iprod >= -128 && iprod <= 127;
}

int main(int argc, char *argv[]) {
  int i;
  for (i = 1; i < argc; i++) {
    int x = strtoul(argv[i], NULL, 0);
    int v = leftmost_one(x);
    int t = test_leftmost_one(x);
    printf("x = 0x%.8x, val = 0x%.8x, test = 0x%.8x\n",
	   x, v, t);
  }
  return 0;
}
