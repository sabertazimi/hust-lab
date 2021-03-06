#if 0

/*
 * 班级: 计科1409班
 * 学号: U201414800
 * 姓名: 刘一龙
 */

/*
 * Makefile 增加 test rule:
 * test:
 *      ./dlc bits.c
 *      ./btest
 */

#endif

/*
 *   lsbZero - set 0 to the least significant bit of x
 *   Example: lsbZero(0x87654321) = 0x87654320
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 1
 */
int lsbZero(int x) {
    return x >> 1 << 1;
}

/*
 * byteNot - bit-inversion to byte n from word x
 *   Bytes numbered from 0 (LSB) to 3 (MSB)
 *   Examples: getByteNot(0x12345678,1) = 0x1234A978
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 2
 */
int byteNot(int x, int n) {
    // mask = 0xff << (n * 8)
    // 用于取得目标字节
    int mask = 0xff << (n << 3);

    return x ^ mask;
}

/*
 *   byteXor - compare the nth byte of x and y, if it is same, return 0, if not, return 1

 *   example: byteXor(0x12345678, 0x87654321, 1) = 1

 *			  byteXor(0x12345678, 0x87344321, 2) = 0
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 2
 */
int byteXor(int x, int y, int n) {
    // mask 用于取得目标字节
    int mask = 0xff << (n << 3);

    // 对两个操作数相应的字节进行异或操作
    // !! 取得逻辑值
    return !!((x & mask) ^ (y & mask));
}

/*
 *   logicalAnd - x && y
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 */
int logicalAnd(int x, int y) {
    // !! 用于取得操作数的逻辑值
    return !!x & !!y;
}

/*
 *   logicalOr - x || y
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 */
int logicalOr(int x, int y) {
    // !! 用于取得操作数的逻辑值
    return !!x | !!y;
}

/*
 * rotateLeft - Rotate x to the left by n
 *   Can assume that 0 <= n <= 31
 *   Examples: rotateLeft(0x87654321,4) = 0x76543218
 *   Legal ops: ~ & ^ | + << >> !
 *   Max ops: 25
 *   Rating: 3
 */
int rotateLeft(int x, int n) {
    // 此掩码用来分割操作数的两个部分: 高位移出部分与低位移入部分
    // e.g 若 n = 4, 则 mask = 0xfffffff0
    int mask = ~0 << n;

    // 32_minus_n = 32 - n
    int _32_minus_n = 32 + (~n + 1);

    // 第一部分: 将 x 正常左移,将低 n 位置0
    // 第二部分: 将 x 的高 n 位右移 32-n 位,达到循环移位的效果
    return (x << n & mask) | (x >> _32_minus_n & ~mask);
}

/*
 * parityCheck - returns 1 if x contains an odd number of 1's
 *   Examples: parityCheck(5) = 0, parityCheck(7) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 4
 */
int parityCheck(int x) {
    // 根据数字逻辑的知识, 奇偶检测电路为: result = bit31 ^ bit30 ^ ... ^ bit0
    // 结合 异或 运算的结合性, 可利用二分异或的方法快速得到奇偶检测结果

    // 得到16位掩码 0xffff
    int mask16 = 0xff << 8 | 0xff;
    // 下面利用异或的结合性,打乱异或运算的顺序
    // 高16位与低16位异或
    int result16 = (x >> 16 ^ x) & mask16;
    // 将 result16 的高8位与低8位异或
    int result8 = (result16 >> 8 ^ result16) & 0xff;
    // 将 result8 的高4位与低4位异或
    int result4 = (result8 >> 4 ^ result8) & 0xf;
    // 将 result4 的高2位与低2位异或
    int result2 = (result4 >> 2 ^ result4) & 0x3;

    return (result2 >> 1 ^ result2) & 0x1;
}

/*
 * mul2OK - Determine if can compute 2*x without overflow
 *   Examples: mul2OK(0x30000000) = 1
 *             mul2OK(0x40000000) = 0
 *
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 2
 */
int mul2OK(int x) {
    // 可将 * 2 视为 << 1
    // 对于有符号整数: 若移出位不等于新符号位,则左移溢出
    int bit31 = x >> 31 & 0x1;
    int bit30 = x >> 30 & 0x1;

    // 即第 31 位 与 第 30 位必须同符号
    return ~(bit31 ^ bit30) & 0x1;
}

/*
 * mult3div2 - multiplies by 3/2 rounding toward 0,
 *   Should exactly duplicate effect of C expression (x*3/2),
 *   including overflow behavior.
 *   Examples: mult3div2(11) = 16
 *             mult3div2(-9) = -13
 *             mult3div2(1073741824) = -536870912(overflow)
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int mult3div2(int x) {
    int sign, least;

    // 根据分析可得, 只需处理(负奇数 / 2)的取余情况 int sign = x >> 31 & 0x1;
    // 其余情况下, 运用移位运算可自动实现取余操作

    // x * 3
    x = (x << 1) + x;

    // 结合符号位和最低位, 判断 * 3 结果是否为负奇数
    sign = x >> 31 & 0x1;
    least = x & 0x1;

    // 若是负奇数, 则在 x / 2 的基础上 + 1
    return (x >> 1) + (sign & least);
}

/*
 * subOK - Determine if can compute x-y without overflow
 *   Example: subOK(0x80000000,0x80000000) = 1,
 *            subOK(0x80000000,0x70000000) = 0,
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 */
int subOK(int x, int y) {
    // 先取得 被减数/减数/差 的符号位
    int a = x >> 31 & 0x1;
    int b = y >> 31 & 0x1;
    int c = (x + ~y + 1) >> 31 & 0x1;

    // 溢出有两种情况: 负-正=正, 正-负=负
    // 被减数 减数 差 的正负值情况总共有8种情况

    // 设 result = m( xsign, ysign, subsign), 正为1,负为0
    // 根据其最小项表达式, 作出卡诺图, 可得 result 的最简逻辑表达式
    // 其中m(0, 1, 1) = 0, m(1, 0, 0) = 0, 其余情况下 m = 1

    // result = ~a & ~b + a & c + b & ~c
    return (!a & !b) | (a & c) | (b & !c);
}

/*
 * absVal - absolute value of x
 *   Example: absVal(-1) = 1.
 *   You may assume -TMax <= x <= TMax
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 10
 *   Rating: 4
 */
int absVal(int x) {
    // sign 取得 x 的符号位
    int sign = x >> 31 & 0x1;

    // 利用 mask 实现条件表达式
    // 若sign = 1, mask = 0xffffffff, ~mask = 0x00000000
    // 若sign = 0, mask = 0x00000000, ~mask = 0xffffffff
    int mask = ~sign + 1;

    // 若sign = 1, 说明 x 为负数, 它的绝对值为其相反数
    // 若sign = 0, 说明 x 为正数, 它的绝对值为其本身
    // return sign ? (~x + 1) : x;
    return ((~x + 1) & mask) | (x & ~mask);
}

/*
 * float_abs - Return bit-level equivalent of absolute value of f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representations of
 *   single-precision floating point values.
 *   When argument is NaN, return argument..
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 10
 *   Rating: 2
 */
unsigned float_abs(unsigned uf) {
    // & 0x80000000: 将符号位置0
    int zf = uf & 0x7fffffff;
    // 若参数为NaN, 则返回其本身
    if(zf > 0x7f800000) {
        return uf;
    } else {
        return zf;
    }
}

/*
 * float_f2i - Return bit-level equivalent of expression (int) f
 *   for floating point argument f.
 *   Argument is passed as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point value.
 *   Anything out of range (including NaN and infinity) should return
 *   0x80000000u.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
int float_f2i(unsigned uf) {
    // 符号位
    int sign = uf >> 31 & 0x1;
    // 指数部分
    int exp = uf >> 23 & 0xff;
    // 尾数部分
    int frac = uf & 0x7fffff;

    // uf 为零, 转化后的整数值为0
    if (exp == 0 && frac == 0) {
        return 0;
    }
    // 处理下溢出情况
    else if (exp < 126) {
        return 0;
    }
    // 处理上溢出情况: 左规格化位数超过31位
    else if (exp > 157) {
        return 0x80000000;
    }
    // uf 为规格化浮点数
    else {
        // 计算规格化位数
        exp -= 127;
        // 补齐规格化省略的1
        frac |= 0x800000;

        // 模拟 规格化移位的还原
        // 假设x为有效位,y为空位
        if (exp > 23) {
            // 1.xxx -> 1xxxyyy
            exp -= 23;
            frac <<= exp;
        } else {
            // 1.xxxyyy -> 1xxx
            exp = 23 - exp;
            frac >>= exp;
        }

        // sign 为 1, 表示返回整型为负数, frac 取补码
        if (sign) {
            return ~frac + 1;
        } else {
            return frac;
        }
    }
}
