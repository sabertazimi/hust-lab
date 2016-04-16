double x;

void proc1() {
	long long * px = &x;
	(*px) = 0x0000000200000101;
}
