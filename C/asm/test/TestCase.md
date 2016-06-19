                                        # 作者:计科1409班 U201414800 刘一龙
                                        # 累加1+…+15
	LOADI	A	15		# 0.循环的上界设为15
	LOADI	B	1		# 1.将循环次数存入寄存器B中
	LOADI	C	0		# 2.将和数存入寄存器C中
	LOADI	D       1               # 3.将循环步长设置为1并存入寄存器D中
	LTE	B 	A		# 4.判断B <= A
	NOT                             # 5.!(B <= A) --> (B > A)
	CJMP    0x28               	# 6.当(B > A)时，结束循环，跳至第10行
	ADD	C	C	B	# 7.计算C += B
	ADD	B	B       D	# 8.计算B += 1
	JMP	0x10		        # 9.跳至循环顶部(第4行)
	OUT    	C       15              # 10.输出C对应ASCII码字符
	SUB     E       C       D       # 11.计算C -= 1
	OUT     E       15              # 12.输出C对应ASCII码字符
	IN      F       0               # 13.从键盘输入一个字符并存入寄存器E中
	OUT     F       15              # 14.输出字符F
	STORE   F       0x24            # 15.将字符F存至第9行
	LOAD    G       0x24            # 16.从第9行读取字符值
	OUT     G       15      	# 17.输出字符G
	HLT			   	# 18.结束