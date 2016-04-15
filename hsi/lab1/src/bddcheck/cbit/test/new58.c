int trueFiveEighths(int x)
{
 
  int mod8 = 7; /* all 0's and 3 1's */
  int eighthx;
  int fivex;
  int remainder;
  int sign = !!(x>>31); /* 1 if neg 0 if pos */
  int test = !((1<<31)^x); /* 1 if x = 0x800000 */
  mod8 =  x & mod8; /* mod8=the 3 lowest order bits of x - equivalent to x mod 8, so it is the remainder of x/8 */
  eighthx = x>>3; /* divide x by 8 */
 
  fivex = (eighthx<<2)+eighthx;
  remainder = (mod8<<2)+mod8;
  remainder = remainder>>3;

 
 
  return fivex + remainder + sign + 1 + (~test);
 


}
