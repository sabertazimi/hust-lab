int bitAnd(int x, int y) {
    // 根据数字逻辑和离散数学所学知识:
    // x & y = ~(~(x&y) = ~( ~x | ~y);
    return ~(~x | ~y);

}

int bitXor(int x, int y) {
    // 根据数字逻辑和离散数学所学知识:
    // x^y = x & ~y | ~x & y;
    // x | y = ~(~(x | y) = ~(~x & ~y);
    // 结合以上两式可得出结果
    return ~(~(x & ~y) & ~(~x & y));
}

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

int fitsBits(int x, int n) {
    // 对于 n 位补码,可表示数范围为 -(2^(n-1)) ~ (2^(n-1) - 1)
    // 故:
    // 对于正数: 右移n-1位后,若结果为0(最高符号位应为0,且高位全为0),则说明位于范围内
    // 即 result = x >> (n + ~0)
    // 对于负数: 还需额外剔除最高符号位(1)的干扰
    // return result ^ x >> 31
    return !(x >> (n + ~0) ^ (x >> 31));
}

int sign(int x) {
    // 根据 x的符号位 与 x的逻辑真值即可得到 x的正确符号
    return x >> 31 | !!x;
}

int getByte(int x, int n) {
    // 将高24位置0: mask = 0xff;
    // result = x >> (n * 8) & mask;
    return x >> (n << 3) & 0xff;
}

int logicalShift(int x, int n) {
    // 使用 mask 将高 n 位置0
    // 0x1 << 31 = 0x8000000
    // 0x80000000 >> (n-1) = 高n位为1的数
    // 最后取反,得到高n位位0的数
    int mask = ~((0x1 << 31) >> n << 1);
    return x >> n & mask;
    // 在帮他人调试代码时,发现这样一个 bug
    // x << (32 + ~n + 1)
    // 当 n = 0 时, x 并没有如预期那样左移32位
    // 编写测试代码, 使用 gdb 调试后发现, x << 32 = x
    // 说明 C 语言中, 移位运算具有补模性, 移位个数最好不要超过自身 bit 位数
    // 否则,移位个数自动取余,造成意料之外的结果
}

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

