/*
 * CSE 351 HW1 (Data Lab )
 *
 * <Please put your name and userid here>
 *
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 *
 * WARNING: Do not include the <stdio.h> header; it confuses the dlc
 * compiler. You can still use printf for debugging without including
 * <stdio.h>, although you might get a compiler warning. In general,
 * it's not good practice to ignore compiler warnings, but in this
 * case it's OK.
 */

#if 0
/*
 * Instructions to Students:
 *
 * STEP 1: Read the following instructions carefully.
 */

You will provide your solution to this homework by
editing the collection of functions in this source file.

INTEGER CODING RULES:

  Replace the "return" statement in each function with one
  or more lines of C code that implements the function. Your code
  must conform to the following style:

  int Funct(arg1, arg2, ...) {
      /* brief description of how your implementation works */
      int var1 = Expr1;
      ...
      int varM = ExprM;

      varJ = ExprJ;
      ...
      varN = ExprN;
      return ExprR;
  }

  Each "Expr" is an expression using ONLY the following:
  1. Integer constants 0 through 255 (0xFF), inclusive. You are
      not allowed to use big constants such as 0xffffffff.
  2. Function arguments and local variables (no global variables).
  3. Unary integer operations ! ~
  4. Binary integer operations & ^ | + << >>

  Some of the problems restrict the set of allowed operators even further.
  Each "Expr" may consist of multiple operators. You are not restricted to
  one operator per line.

  You are expressly forbidden to:
  1. Use any control constructs such as if, do, while, for, switch, etc.
  2. Define or use any macros.
  3. Define any additional functions in this file.
  4. Call any functions.
  5. Use any other operations, such as &&, ||, -, or ?:
  6. Use any form of casting.
  7. Use any data type other than int.  This implies that you
     cannot use arrays, structs, or unions.


  You may assume that your machine:
  1. Uses 2s complement, 32-bit representations of integers.
  2. Performs right shifts arithmetically.
  3. Has unpredictable behavior when shifting an integer by more
     than the word size.

EXAMPLES OF ACCEPTABLE CODING STYLE:
  /*
   * pow2plus1 - returns 2^x + 1, where 0 <= x <= 31
   */
  int pow2plus1(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     return (1 << x) + 1;
  }

  /*
   * pow2plus4 - returns 2^x + 4, where 0 <= x <= 31
   */
  int pow2plus4(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     int result = (1 << x);
     result += 4;
     return result;
  }

NOTES:
  1. Use the dlc (data lab checker) compiler (described in the handout) to
     check the legality of your solutions.
  2. Each function has a maximum number of operators (! ~ & ^ | + << >>)
     that you are allowed to use for your implementation of the function.
     The max operator count is checked by dlc. Note that '=' is not
     counted; you may use as many of these as you want without penalty.
  3. Use the btest test harness to check your functions for correctness.
  4. The maximum number of ops for each function is given in the
     header comment for each function. If there are any inconsistencies
     between the maximum ops in the writeup and in this file, consider
     this file the authoritative source.

/*
 * STEP 2: Modify the following functions according the coding rules.
 *
 *   IMPORTANT. TO AVOID GRADING SURPRISES:
 *   Use the dlc compiler to check that your solutions conform
 *   to the coding rules.
 */


#endif
// Rating: 1
/*
 * bitAnd - x&y using only ~ and |
 *   Example: bitAnd(6, 5) = 4
 *   Legal ops: ~ |
 *   Max ops: 8
 *   Rating: 1
 */
int bitAnd(int x, int y) {
    // 根据数字逻辑和离散数学所学知识:
    // x & y = ~(~(x&y) = ~( ~x | ~y);
    return ~(~x | ~y);

}
/*
 * bitXor - x^y using only ~ and &
 *   Example: bitXor(4, 5) = 1
 *   Legal ops: ~ &
 *   Max ops: 14
 *   Rating: 1
 */
int bitXor(int x, int y) {
    // 根据数字逻辑和离散数学所学知识:
    // x^y = x & ~y | ~x & y;
    // x | y = ~(~(x | y) = ~(~x & ~y);
    // 结合以上两式可得出结果
    return ~(~(x & ~y) & ~(~x & y));
}
/*
 * thirdBits - return word with every third bit (starting from the LSB) set to 1
 * and the rest set to 0
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 8
 *   Rating: 1
 */
int thirdBits(void) {
    // 根据题意得出:
    // 01001001 00100100 10010010 01001001
    // 即 0x49249249
    int highest = 0x49 << 24;
    int higher = 0x24 << 16;
    int lower = 0x92 << 8;
    int lowest = 0x49;
    return highest + higher + lower + lowest;
}
// Rating: 2
/*
 * fitsBits - return 1 if x can be represented as an
 *  n-bit, two's complement integer.
 *   1 <= n <= 32
 *   Examples: fitsBits(5,3) = 0, fitsBits(-4,3) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 2
 */
int fitsBits(int x, int n) {
    // 对于 n 位补码,可表示数范围为 -(2^(n-1)) ~ (2^(n-1) - 1)
    // 故:
    // 对于正数: 右移n-1位后,若结果为0(最高符号位应为0,且高位全为0),则说明位于范围内
    // 即 result = x >> (n + ~0)
    // 对于负数: 还需额外剔除最高符号位(1)的干扰
    // return result ^ x >> 31
    return !(x >> (n + ~0) ^ (x >> 31));
}
/*
 * sign - return 1 if positive, 0 if zero, and -1 if negative
 *  Examples: sign(130) = 1
 *            sign(-23) = -1
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 10
 *  Rating: 2
 */
int sign(int x) {
    // 根据 x的符号位 与 x的逻辑真值即可得到 x的正确符号
    return x >> 31 | !!x;
}
/*
 * getByte - Extract byte n from word x
 *   Bytes numbered from 0 (LSB) to 3 (MSB)
 *   Examples: getByte(0x12345678,1) = 0x56
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 2
 */
int getByte(int x, int n) {
    // 将高24位置0: mask = 0xff;
    // result = x >> (n * 8) & mask;
    return x >> (n << 3) & 0xff;
}
// Rating: 3
/*
 * logicalShift - shift x to the right by n, using a logical shift
 *   Can assume that 0 <= n <= 31
 *   Examples: logicalShift(0x87654321,4) = 0x08765432
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 */
int logicalShift(int x, int n) {
    // 使用 mask 将高 n 位置0
    // 0x1 << 31 = 0x8000000
    // 0x80000000 >> (n-1) = 高n位为1的数
    // 最后取反,得到高n位位0的数
    int mask = ~((0x1 << 31) >> n << 1);
    return x >> n & mask;
}
/*
 * addOK - Determine if can compute x+y without overflow
 *   Example: addOK(0x80000000,0x80000000) = 0,
 *            addOK(0x80000000,0x70000000) = 1,
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 */
int addOK(int x, int y) {
    int a = x >> 31 & 0x1;      // x 的符号
    int b = y >> 31 & 0x1;      // y 的符号
    int c = (x+y) >> 31 & 0x1;  // sum 的符号
    // 有符号数加法溢出有以下两种情况:
    // 正 + 正 = 负;
    // 负 + 负 = 正;
    // 将溢出设为0,不溢出设为1, 根据数字逻辑的知识,根据a,b,c的最小项表达式:
    // a b c result
    // 0 0 0    1
    // 0 0 1    0
    // 0 1 0    1
    // 0 1 1    1
    // 1 0 0    1
    // 1 0 1    1
    // 1 1 0    0
    // 1 1 1    1
    // 画卡诺图可得:
    // result = (a & !b) | (!a & !c) | (b & c)
    return (a & !b) | (!a & !c) | (b & c);
}

// Rating: 4
/*
 * bang - Compute !x without using !
 *   Examples: bang(3) = 0, bang(0) = 1
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 4
 */
int bang(int x) {
    // 除0 与 0x80000000, 正数与负数的符号位相同外
    // 其余整数的正数与负数的符号位不同
    int sign = x >> 31 & 0x1;
    int neg_sign = (~x + 1) >> 31 & 0x1;
    // result = !(sign ^ neg_sign)
    // 由于不能使用!, 只能使用 ~ 与 & 代替: !bitOne = ~bitOne & 0x1
    // 其中 ` | x >> 31 `,是为了区分 0 与 0x80000000
    return ~((sign ^ neg_sign) | x >> 31) & 0x1;
}

// Extra Credit: Rating: 3
/*
 * conditional - same as x ? y : z
 *   Example: conditional(2,4,5) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
int conditional(int x, int y, int z) {
    // 当!!x = 1时,要求输出y
    // 此时需要将z置为0
    // 即 y & 0xffffffff, z & 0x00000000
    // 当!!x = 0时,要求输出z
    // 此时需要将y置为0
    // 即 y & 0x00000000, z & 0xffffffff
    int flag = !!x;
    int ymask = ~flag + 1;  // -1 = 0xffffffff, -0 = 0x00000000
    int zmask = ~ymask;
    return (y & ymask) | (z & zmask);
}

// Extra Credit: Rating: 4
/*
 * isPower2 - returns 1 if x is a power of 2, and 0 otherwise
 *   Examples: isPower2(5) = 0, isPower2(8) = 1, isPower2(0) = 0
 *   Note that no negative number is a power of 2.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 4
 */
int isPower2(int x) {
    // 2的幂次方的二进制数必须有且仅有1个bit位上为1,其余所有bit位必须为0
    // x & (x-1) == 0
    // 0 与 负数 不可能是 2的幂次方
    return !(x & (x + ~0)) & !(x >> 31 & 0x1) & !!x;
}

unsigned float_neg(unsigned uf) {
    unsigned result;
    unsigned tmp;
    tmp=uf&(0x7fffffff);
    result=uf^0x80000000;

    if(tmp>0x7f800000)
        result=uf;
    return result;
}

unsigned float_i2f(int x) {
    unsigned shiftLeft = 0;
    unsigned afterShift, tmp, flag;
    unsigned absX = x;
    unsigned sign = 0;

    if (x == 0) return 0;

    if (x < 0) {
        sign = 1;
        absX = x;
    }

    afterShift = absX;

    // 对二进制数进行左规
    while (1) {
        tmp = afterShift;
        afterShift <<= 1;
        shiftLeft++;
        // 当最高位为1时，规格化结束
        if (tmp & 0x80000000) break;
    }

    if ((afterShift & 0x01ff) > 0x0100) flag = 1;
    else if ((afterShift & 0x03ff) == 0x0300) flag = 1;
    else flag = 0;

    return (sign << 31) + ((159 - shiftLeft) << 23) + flag + (afterShift >> 9);
}

unsigned float_twice(unsigned uf) {
    unsigned f = uf;

    // f & 0x7f80000 为 f 的阶码
    // 阶码为0表示为非规格化浮点数
    // 阶码不为0表示为规格化浮点数
    // 阶码为255表示为无穷大数/非数
    if ((f & 0x7f800000) == 0) {
        f = ((f & 0x007fffff) << 1) | (0x80000000 & f);
    } else if ((f & 0x7f800000) != 0x7f800000) {
        f += 0x00800000;
    }

    return f;
}

