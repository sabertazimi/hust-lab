int test_odd_ones(unsigned x)
{
    int i;
    int result = 0;
    for (i = 0; i < 8 * sizeof(int); i++)
	if (x & (1<<i))
	    result = !result;
    return result;
}
