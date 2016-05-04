# 分析反汇编代码
dump:
	objdump -d bufbomb > bufbomb.asm && vim bufbomb.asm

# 分析 bufbomb C源码
source:
	vim bufbomb.c

# 利用 gdb 进行有限的动态分析
debug:
	gdb bufbomb

# 利用 makecookie 得到 cookie 字符串
cookie:
	./makecookie U201414800 && ./makecookie U201414800 > cookie.txt

# 利用 hex2raw 去除攻击指令中的注释
raw:
	./hex2raw smoke_U201414800.txt > smoke_U201414800.txt
	./hex2raw fizz_U201414800.txt > fizz_U201414800.txt
	./hex2raw bang_U201414800.txt > bang_U201414800.txt
	./hex2raw boom_U201414800.txt > boom_U201414800.txt
	./hex2raw nitro_U201414800.txt > nitro_U201414800.txt

# 进行攻击测试
test:
	./bufbomb -u U201414800 < smoke_ U201414800_raw.txt
	./bufbomb -u U201414800 < fizz_ U201414800_raw.txt
	./bufbomb -u U201414800 < bang_ U201414800_raw.txt
	./bufbomb -u U201414800 < boom_U201414800_raw.txt
	./bufbomb -u U201414800 < nitro_U201414800_raw.txt
	
