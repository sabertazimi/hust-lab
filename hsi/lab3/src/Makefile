# 分析反汇编代码
dump:
	objdump -d bufbomb > bufbomb.asm && vim bufbomb.asm

# 分析 bufbomb C源码
src:
	vim bufbomb.c

# 利用 gdb 进行有限的动态分析
debug:
	gdb bufbomb

# 利用 makecookie 得到 cookie 字符串
cookie:
	./makecookie U201414800 && ./makecookie U201414800 > cookie.txt

# 编写汇编代码，并得到其机器指令码
asm:
	gcc -m32 -c attack.s
	objdump -d attack.o >> attack.asm

# 进行攻击测试
test:
	cat smoke_U201414800.txt | ./hex2raw | ./bufbomb -u U201414800
# cat fizz_U201414800.txt | ./hex2raw | ./bufbomb -u U201414800
# cat bang_U201414800.txt | ./hex2raw | ./bufbomb -u U201414800
# cat boom_U201414800.txt | ./hex2raw | ./bufbomb -u U201414800
# cat nitro_U201414800.txt | ./hex2raw | ./bufbomb -u U201414800
	
