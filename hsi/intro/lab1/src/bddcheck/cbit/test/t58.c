int trueFiveEighths(int x)
{
  int storebottom = x & 7;
  int divbyeight = x >> 3;
  int multbyfive = (divbyeight << 2) + divbyeight;
  int bottomup = (storebottom << 2) + storebottom;
  int biasedbottom = bottomup + (7 & (x >> 31));
  int fullsize = (biasedbottom >> 3) + multbyfive;
  return fullsize;
}
