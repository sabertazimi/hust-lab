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

# 利用 hex2raw 生成攻击字符串
raw:
	cat smoke_U201414800.txt | ./hex2raw > smoke_U201414800_raw.txt
	cat fizz_U201414800.txt | ./hex2raw > fizz_U201414800_raw.txt
	cat bang_U201414800.txt | ./hex2raw > bang_U201414800_raw.txt
	cat boom_U201414800.txt | ./hex2raw > boom_U201414800_raw.txt
	cat nitro_U201414800.txt | ./hex2raw > nitro_U201414800_raw.txt

# 进行攻击测试
test:
	./bufbomb -u U201414800 < smoke_U201414800_raw.txt
# ./bufbomb -u U201414800 < fizz_U201414800_raw.txt
# ./bufbomb -u U201414800 < bang_U201414800_raw.txt
# ./bufbomb -u U201414800 < boom_U201414800_raw.txt
# ./bufbomb -u U201414800 < nitro_U201414800_raw.txt
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

## 基本流程

```bash
; 静态分析 + 动态分析
make src
make dump
(make debug)

; 编写汇编代码  
vim attack.s
make asm
; 得到对应机器字节码,添加必要注释
vim phase_U201414800.txt attack.asm
; 生成攻击字符串
make raw

; 进行攻击测试
make test
```

## Smoke Phase

键入 make dump,开始静态分析
利用 vim 编辑器 在 bufbomb.asm 中搜索 `<smoke>`, 得地址为 0x08048c90.
结合 linux 系统小端模式的特性,故将攻击字符串最低４个字节设为 90 8c 04 08

## Fizz Phase

键入 make dump,开始静态分析
此阶段需要传入 cookie 参数.
利用 vim 编辑器 在 bufbomb.asm 中搜索 `<fizz>`
地址为 0x08048cba

```asm
08048cba <fizz>:                                            
8048cba:   55                      push   %ebp             
8048cbb:   89 e5                   mov    %esp,%ebp        
8048cbd:   83 ec 18                sub    $0x18,%esp       
; 从此句可得 fizz 函数取得在 0x8(%ebp)处取得第一个参数
; 由于 push %ebp 语句的存在,故 cookie 应置于 返回地址 4 个字节第 4 个字节开始
8048cc0:   8b 45 08                mov    0x8(%ebp),%eax   
; 键入 x/wx 0x804c220,输出: 0x804c220 <cookie>: 0x6898ac90
8048cc3:   3b 05 20 c2 04 08       cmp    0x804c220,%eax   
8048cc9:   75 1e                   jne    8048ce9 <fizz+0x2f>
8048ccb:   89 44 24 04             mov    %eax,0x4(%esp)   
8048ccf:   c7 04 24 2e a1 04 08    movl   $0x804a12e,(%esp)
8048cd6:   e8 f5 fb ff ff          call   80488d0 <printf@plt>
8048cdb:   c7 04 24 01 00 00 00    movl   $0x1,(%esp)      
8048ce2:   e8 5d 06 00 00          call   8049344 <validate>
8048ce7:   eb 10                   jmp    8048cf9 <fizz+0x3f>
8048ce9:   89 44 24 04             mov    %eax,0x4(%esp)   
8048ced:   c7 04 24 c4 a2 04 08    movl   $0x804a2c4,(%esp)   
8048cf4:   e8 d7 fb ff ff          call   80488d0 <printf@plt>
8048cf9:   c7 04 24 00 00 00 00    movl   $0x0,(%esp)      
8048d00:   e8 8b fc ff ff          call   8048990 <exit@plt>
```

0x28+0x4(%ebp)+0x4(return address)+0x8(first argument) = 56 bytes

> 使用 gdb 进行调试时，发现不能像以往那样在某一行设置断点，只能在某些函数处设置断点.故 (gdb) b getbuf, 在 getbuf 函数处设置断点
