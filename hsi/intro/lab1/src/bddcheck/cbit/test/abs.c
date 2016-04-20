int abs(int x) {
    int sign = x >> 31;
    return (x^sign) + (1 && sign);
}
