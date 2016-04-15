int ezThreeFourths(int x) {
  int xs1 = x >> 1;
  int xs2 = x >> 2;
  /* Compute value from low-order 2 bits */
  int bias = (x >> 31) & 0x3;
  int xl2 = x & 0x3;
  int xl1 = (x & 0x1) << 1;
  int incr = (xl2 + xl1 + bias) >> 2;
  return xs1 + xs2 + incr;
}

