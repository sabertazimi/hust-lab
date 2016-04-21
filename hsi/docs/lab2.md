## Phase 1

### 基本指令

```shell
(gdb) b 1
(gdb) disass
(gdb) ni
(gdb) si
(gdb) info r
(gdb) x/s
```

```asm
; 将返回地址压栈
0x08048b7b phase_1+11 mov    0x20(%esp),%eax
0x08048b7f phase_1+15 mov    %eax,(%esp)
```

```asm
; 调用strings_not_equal前, 将输入字符串地址传入函数
0x08048b73 phase_1+3  movl   $0x804a09c,0x4(%esp)
; 调用字符串比较函数
0x08048b82 phase_1+18 call   0x8048fea <strings_not_equal>
```

```shell
(gdb) x/s 0x804a09c
```

打印结果为 "The future will be better tomorrow."

```asm
0x08048b87 phase_1+23 test   %eax,%eax
0x08048b89 phase_1+25 je     0x8048b90 <phase_1+32>
0x08048b8b phase_1+27 call   0x80490f7 <explode_bomb>
0x08048b90 phase_1+32 add    $0x1c,%esp
```

当 eax 为0时,炸弹不会爆炸,拆弹成功;结合对函数 `strings_not_equal`的分析,可知 phase1 的谜底即为**The future will be better tomorrow.**

### `strings_not_equal`

-   键入si,进入 `strings_not_equal`
-   返回值为1,表示输入字符串与目标字符串不相同
-   返回值为0,表示输入字符串与目标字符串相同

```asm
; 调用两次 string_length 函数, 将输入字符串与目标字符串的长度分别存在 eax 与 edi
0x08048ff8 <+14>:   mov    %ebx,(%esp)
0x08048ffb <+17>:   call   0x8048fcb <string_length>
0x08049000 <+22>:   mov    %eax,%edi
0x08049002 <+24>:   mov    %esi,(%esp)
0x08049005 <+27>:   call   0x8048fcb <string_length>
; 比较输入字符串与目标字符串的长度
; 若长度不同,返回值为1,存至 eax
0x0804900f <+37>:   cmp    %eax,%edi
0x08049011 <+39>:   jne    0x804904f <strings_not_equal+101>
```

```asm
; 返回值存放在 eax 中
0x0804904a <+96>:   mov    $0x1,%edx
0x0804904f <+101>:  mov    %edx,%eax
```

```asm
; 当前字符为空字符'\0',两字符串比较完毕
0x08049016 <+44>: test   %al,%al
0x08049018 <+46>: je     0x804903c <strings_not_equal+82>
```

-   比较字符串的循环体


```asm
; 将输入字符串与目标字符串的地址移至 eax 与 edx
0x0804901e <+52>:   mov    %esi,%edx
0x08049020 <+54>:   mov    %ebx,%eax
0x08049022 <+56>:   jmp    0x8049028 <strings_not_equal+62>
; 比较输入字符串与目标字符串对应字符
0x08049024 <+58>:   cmp    (%edx),%cl
0x08049026 <+60>:   jne    0x804904a <strings_not_equal+96>
; 循环控制部分, 地址 + 1
0x08049028 <+62>:   add    $0x1,%eax
0x0804902b <+65>:   add    $0x1,%edx
; 将输入字符串一个字符移至 cl
0x0804902e <+68>:   movzbl (%eax),%ecx
; 检查字符串是否已经结束
0x08049031 <+71>:   test   %cl,%cl
0x08049033 <+73>:   jne    0x8049024 <strings_not_equal+58>
```
