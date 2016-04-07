int ezThreeFourths(int x) {
    int tmin = 0x80 << 24;
    int mask = tmin | 0x3;
    int mult3 = x + x + x;
    int init_z = mult3 >> 2;
    int add1 = !!((mult3 & mask) ^ tmin);
    int z = init_z + add1;
    return z;
}
