# 分析反汇编代码
dump:
	objdump -D bufbomb > bufbomb.asm && vim bufbomb.asm

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

# 利用 hex2raw 生成攻击字符串
raw:
	cat smoke_U201414800.txt | ./hex2raw > smoke_U201414800_raw.txt
	cat fizz_U201414800.txt | ./hex2raw > fizz_U201414800_raw.txt
	cat bang_U201414800.txt | ./hex2raw > bang_U201414800_raw.txt
	cat boom_U201414800.txt | ./hex2raw > boom_U201414800_raw.txt
	cat nitro_U201414800.txt | ./hex2raw > nitro_U201414800_raw.txt

# 进行攻击测试
test:
	./bufbomb -n -u U201414800 < nitro_U201414800_raw.txt
# ./bufbomb -u U201414800 < smoke_U201414800_raw.txt
# ./bufbomb -u U201414800 < fizz_U201414800_raw.txt
# ./bufbomb -u U201414800 < bang_U201414800_raw.txt
# ./bufbomb -u U201414800 < boom_U201414800_raw.txt
	
