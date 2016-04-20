int shift(int x, int amt)
{
    int at32 = amt & ~0x1F;
    return (x == x >> at32) && (x == x << at32);
}
