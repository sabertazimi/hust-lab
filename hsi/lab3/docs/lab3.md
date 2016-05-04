# Lab 3 Notes

## Intro

### Phase List

-   `smoke_U201414800.txt`
-   `fizz_U201414800.txt`
-   `bang_U201414800.txt`
-   `boom_U201414800.txt`
-   `nitro_U201414800.txt`

### Basic Running Command

#### Get Cookie

```bash
$ makecookie U201414800 && makecookie U201414800 >> cookie.txt
```

#### Run

```bash
$ ./hex2raw smoke_U201414800.txt smoke_U201414800_raw.txt
$ ./bufbomb -u U201414800 < smoke_ U201414800_raw.txt
(gdb) run -u U201414800 < smoke_ U201414800_raw.txt
```

#### Attack

```bash
$ gcc -m32 -c attack.s
$ objdump -d attack.o >> attack.asm
```

## Ready Phase

### Makfile

-   编写 Makefile，简化工作流

```makefile
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
```

-   make cookie 得到 cookie
-   make dump 得到反汇编代码

## Analysis Phase

-   launcher() -> launch() -> test()/testn() -> getbuf()/getbufn() 

```c
int getbuf() {
    char buf[NORMAL_BUFFER_SIZE];
    Gets(buf);
    return 1;
}
```

-　 利用 vim 编辑器 在 bufbomb.asm 中搜索 `<getbuf>`
-   攻击字符串长度应为 0x28+0x4+0x4 = 48 bytes,最后4个字节为返回地址

```asm
080491ec <getbuf>:   
80491ec:   55                      push   %ebp
80491ed:   89 e5                   mov    %esp,%ebp
80491ef:   83 ec 38                sub    $0x38,%esp
80491f2:   8d 45 d8                lea    -0x28(%ebp),%eax
80491f5:   89 04 24                mov    %eax,(%esp)
80491f8:   e8 55 fb ff ff          call   8048d52 <Gets>      
80491fd:   b8 01 00 00 00          mov    $0x1,%eax
8049202:   c9                      leave  
8049203:   c3                      ret    
```

-   基本流程

```bash
; 静态分析 + 动态分析
make src
make dump
(make debug)

; 编写汇编代码，保存攻击字符串  
vim attack.s
make asm
vim phase_U201414800.txt attack.asm

; 进行攻击测试
make test
```

## Smoke Phase

利用 vim 编辑器 在 bufbomb.asm 中搜索 `<smoke>`, 得地址为 0x08048c90.
结合 linux 系统小端模式的特性,故将攻击字符串最低４个字节设为 90 8c 04 08
