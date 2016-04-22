# 二进制炸弹实验(Bomb Lab)

* 74  - 阶段1：字符串比较
* 82  - 阶段2：循环
* 89  - 阶段3：条件/分支
* 95  - 阶段4：递归调用和栈
* 101 - 阶段5：指针
* 108 - 阶段6：链表/指针/结构

## 基本指令

```shell
; 运行/退出
; 设置断点
(gdb) b 1
; 显示反汇编代码
(gdb) disas
; 显示C源码
(gdb) l
; 以汇编代码粒度执行代码
(gdb) ni
(gdb) si
; 以C代码粒度执行代码
(gdb) n
(gdb) s
; 显示必要信息
; 寄存器
(gdb) info r
; 函数调用栈
(gdb) bt/info stack
; 指定地址单元
(gdb) x/s
```

```shell
(gdb) x/4bd $esp + 0x18
(gdb) x/4hx $eax
(gdb) x/4wi $pc
(gdb) x/s   0x804a277
(gdb) x/wx  $ebp - 0x24
(gdb) x     0xffffd528
```

```shell
$ objdump -d bomb >> bomb.asm
```

## Phase 1

### 基本指令

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

## Phase 2

### `read_six_numbers`

```asm
; 读入6个数字
; (%eax) = 0xffffd528
0x08049231 <+7>:  lea    0x14(%eax),%edx
0x08049234 <+10>: mov    %edx,0x1c(%esp)
0x08049238 <+14>: lea    0x10(%eax),%edx
0x0804923b <+17>: mov    %edx,0x18(%esp)
0x0804923f <+21>: lea    0xc(%eax),%edx
0x08049242 <+24>: mov    %edx,0x14(%esp)
0x08049246 <+28>: lea    0x8(%eax),%edx
0x08049249 <+31>: mov    %edx,0x10(%esp)
0x0804924d <+35>: lea    0x4(%eax),%edx
0x08049250 <+38>: mov    %edx,0xc(%esp)
0x08049254 <+42>: mov    %eax,0x8(%esp)
```

```asm
; 键入 x/s 0x804a277
; 显示  0x804a277: "%d %d %d %d %d %d"
; 说明 0x08049258 处存放 scanf 格式字符串, 6个整型数字
0x08049258 read_six_numbers+46 movl   $0x804a277,0x4(%esp)
...

0x08049267 <+61>:    call   0x8048890 <__isoc99_sscanf@plt>
```

```asm
; 查询手册可得, eax 存放 scanf 的返回值,表示成功读入数据的个数
; 当输入数字个数少于 6 时,炸弹爆炸
0x0804926c <+66>: cmp    $0x5,%eax
0x0804926f <+69>: jg     0x8049276 <read_six_numbers+76>
0x08049271 <+71>: call   0x80490f7 <explode_bomb>
0x08049276 <+76>: add    $0x2c,%esp
0x08049279 <+79>: ret
```

### `phase_2`

```asm
; ($esp) = 0xfffd510
; ($esp) + 0x18 = 0xfffd528, 结合上一步对 read_six_numbers 的分析可得
; 此处存放输入的第一个数字
; 键入 x/6d 0xffffd528
; 显示 0xffffd528: 1   2   3   4
;      0xffffd538: 5   6
; 故以下两条语句是判断第一个是否为正数
; 若为正数,则跳转至 <phase_2+65>处
; 若为负数,炸弹爆炸
0x08048bac <+24>: cmpl   $0x0,0x18(%esp)
0x08048bb1 <+29>: jns    0x8048bd5 <phase_2+65>
0x08048bb3 <+31>: call   0x80490f7 <explode_bomb>
```

-    循环体

```asm
0x08048bba <+38>: mov    %ebx,%eax
0x08048bbc <+40>: add    0x14(%esp,%ebx,4),%eax
0x08048bc0 <+44>: cmp    %eax,0x18(%esp,%ebx,4)
0x08048bc4 <+48>: je     0x8048bcb <phase_2+55>
0x08048bc6 <+50>: call   0x80490f7 <explode_bomb>
0x08048bcb <+55>: add    $0x1,%ebx
0x08048bce <+58>: cmp    $0x6,%ebx
0x08048bd1 <+61>: jne    0x8048bba <phase_2+38>
0x08048bd3 <+63>: jmp    0x8048bdc <phase_2+72>
0x08048bd5 <+65>: mov    $0x1,%ebx
```

-   以上汇编代码可转化为如下C代码
-   假设x为第 i 个数字,y为第 i+1 个数字
-   则必须满足 y = x + i;

```c
for (i = 1;i < 6;i++) {
    x = i + arr[i - 1];
    if (x != arr[i]) {
        exlpode_bomb();
        return ;
    }
}

return ;
```

### 解决

综合上述两个函数的分析, 现得到如下线索:

-   输入6个数字
-   第一个数字必须为正数
-   满足 y = x + i;

即:

-   a0 >= 0
-   a1 = a0+1, a2 = a1+2, a3 = a2+2, a4 = a3+3, a5 = a4+4, a6 = a5+5

```c
0 1 3 6 10 15
1 2 4 7 11 16
2 3 5 8 12 17

...

x x+1 x+3 x+6 x+10 x+15
```

## Phase 3

```asm
; 键入 x/s 0x804a283
; 显示 "%d %d"
; 说明输入两个整型数字, 存放地址分别为
; (%esp) + 0x1c = 0xffffd53c, (%esp) + 0x18 = 0xffffd538
0x08048be4 <+3>:  lea    0x18(%esp),%eax
0x08048be8 <+7>:  mov    %eax,0xc(%esp)
0x08048bec <+11>: lea    0x1c(%esp),%eax
0x08048bf0 <+15>: mov    %eax,0x8(%esp)
0x08048bf4 <+19>: movl   $0x804a283,0x4(%esp)
0x08048bfc <+27>: mov    0x30(%esp),%eax
0x08048c00 <+31>: mov    %eax,(%esp)
0x08048c03 <+34>: call   0x8048890 <__isoc99_sscanf@plt>
```

```asm
; 第一个参数必须 <= 7
; 否则,炸弹爆炸
0x08048c12 <+49>:  cmpl   $0x7,0x1c(%esp)
0x08048c17 <+54>:  ja     0x8048c55 <phase_3+116>
0x08048c55 <+116>: call   0x80490f7 <explode_bomb>
```

```asm
; 此句为 switch 条件控制部分
0x08048c1d <+60>:  jmp    *0x804a0f0(,%eax,4)
```

```asm
; switch 语句中分支部分
; 根据第一个数字,选择不同的分支,给 eax 赋新值
; 总共有 8 个分支
0x08048c24 <+67>:  mov    $0x32f,%eax			; 815
0x08048c29 <+72>:  jmp    0x8048c66 <phase_3+133>
0x08048c2b <+74>:  mov    $0x184,%eax			; 388
0x08048c30 <+79>:  jmp    0x8048c66 <phase_3+133>
0x08048c32 <+81>:  mov    $0x28e,%eax			; 654
0x08048c37 <+86>:  jmp    0x8048c66 <phase_3+133>
0x08048c39 <+88>:  mov    $0x11c,%eax			; 284
0x08048c3e <+93>:  jmp    0x8048c66 <phase_3+133>
0x08048c40 <+95>:  mov    $0x201,%eax			; 513
0x08048c45 <+100>: jmp    0x8048c66 <phase_3+133>
0x08048c47 <+102>: mov    $0x1a9,%eax			; 425
0x08048c4c <+107>: jmp    0x8048c66 <phase_3+133>
0x08048c4e <+109>: mov    $0x374,%eax			; 884
0x08048c53 <+114>: jmp    0x8048c66 <phase_3+133>
0x08048c61 <+128>: mov    $0x130,%eax			; 304
0x08048c66 <+133>: cmp    0x18(%esp),%eax
```

-   转化为C代码

```c
case 0:
	x = 815;  // 0x32f
	break;
case 1:
	x = 304;  // 0x130
	break;
case 2:
	x = 388;  // 0x184
	break;
case 3:
	x = 654;  // 0x28e
	break;
case 4:
	x = 284;  // 0x11c
	break;
case 5:
	x = 513;  // 0x201
	break;
case 6:
	x = 425;  // 0x1a9
	break;
case 7:
	x = 884;  //0x374
	break;
```

```asm
; 必须使得 switch 语句执行完后, 改变后的 x 与 y 相等
; 即 x == y
; 否则, 炸弹爆炸
0x08048c66 <+133>: cmp    0x18(%esp),%eax
0x08048c6a <+137>: je     0x8048c71 <phase_3+144>
0x08048c6c <+139>: call   0x80490f7 <explode_bomb>
```

## Phase 4

```asm
; 与前三个阶段相同
; 键入 x/s 0x804a283
; 显示 "%d %d"
; 说明输入两个整型数字, 存放地址分别为
; (%esp) + 0x1c = 0xffffd53c, (%esp) + 0x18 = 0xffffd538
; 输入整数个数不为2,炸弹爆炸
0x08048ce5 <+3>:  lea    0x18(%esp),%eax
0x08048ce9 <+7>:  mov    %eax,0xc(%esp)
0x08048ced <+11>: lea    0x1c(%esp),%eax
0x08048cf1 <+15>: mov    %eax,0x8(%esp)
0x08048cf5 <+19>: movl   $0x804a283,0x4(%esp)
0x08048cfd <+27>: mov    0x30(%esp),%eax
0x08048d01 <+31>: mov    %eax,(%esp)
0x08048d04 <+34>: call   0x8048890 <__isoc99_sscanf@plt>

0x08048d09 <+39>:    cmp    $0x2,%eax
0x08048d0c <+42>: jne    0x8048d1b <phase_4+57>
```

```asm
; 第一个整数必须 >= 0
; 否则,炸弹爆炸
0x08048d0e <+44>: mov    0x1c(%esp),%eax
0x08048d12 <+48>: test   %eax,%eax
0x08048d14 <+50>: js     0x8048d1b <phase_4+57>
```

```asm
; 第一个整数必须 <= 14
; 否则,炸弹爆炸
0x08048d16 <+52>: cmp    $0xe,%eax
0x08048d19 <+55>: jle    0x8048d20 <phase_4+62>
0x08048d1b <+57>: call   0x80490f7 <explode_bomb>
```

```asm
; 第二个整数必须为7
; 否则,炸弹爆炸
0x08048d41 <+95>:  cmpl   $0x7,0x18(%esp)
0x08048d46 <+100>: je     0x8048d4d <phase_4+107>
0x08048d48 <+102>: call   0x80490f7 <explode_bomb>
0x08048d4d <+107>: add    $0x2c,%esp
```

```asm
; 通过以下6条代码,可推测出 func4 的函数原型
; int func4(int , int ,int );
; 且此次调用传参为:
; func4(first_input_number, 0, 14);
0x08048d20 <+62>: movl   $0xe,0x8(%esp)
0x08048d28 <+70>: movl   $0x0,0x4(%esp)
0x08048d30 <+78>: mov    0x1c(%esp),%eax
0x08048d34 <+82>: mov    %eax,(%esp)
0x08048d37 <+85>: call   0x8048c75 <func4>
0x08048d3c <+90>: cmp    $0x7,%eax
```

```asm
; 调用递归函数 func4 的返回值必须为 7
; 否则, 炸弹爆炸
0x08048d37 <+85>: call   0x8048c75 <func4>
0x08048d3c <+90>: cmp    $0x7,%eax
0x08048d3f <+93>: jne    0x8048d48 <phase_4+102>

0x08048d48 <+102>:call   0x80490f7 <explode_bomb>
```

### func4

现有以下已知条件:

-   函数原型: int func4(int target, int lo, int hi);
-   0 <= target <= 14

```asm
; (%edx) = target/first_input_number, (%eax) = 0, (%ebx) = 14
0x08048c80 <+11>: mov    0x20(%esp),%edx
0x08048c84 <+15>: mov    0x24(%esp),%eax
0x08048c88 <+19>: mov    0x28(%esp),%ebx
```

```asm
0x08048c8c <+23>: mov    %ebx,%ecx
0x08048c8e <+25>: sub    %eax,%ecx              ; (%ecx) = hi - lo

...

0x08048c97 <+34>: sar    %ecx                   ; (%ecx) /= 2
0x08048c99 <+36>: add    %eax,%ecx              ; mid: (%ecx) = (hi - lo)/2 + lo = (lo + hi) / 2

0x08048c9b <+38>: cmp    %edx,%ecx              ; 比较 mid 与 target 的大小关系
0x08048c9d <+40>: jle    0x8048cb6 <func4+65>   ; mid <=  target

0x08048c9f <+42>: sub    $0x1,%ecx              ; mid > target, 代码可运行至此处
0x08048ca2 <+45>: mov    %ecx,0x8(%esp)
0x08048ca6 <+49>: mov    %eax,0x4(%esp)
0x08048caa <+53>: mov    %edx,(%esp)    
0x08048cad <+56>: call   0x8048c75 <func4>      ; func4(target, lo, mid-1)

0x08048cb2 <+61>: add    %eax,%eax              ; 返回值为 func4(target, li, mid-1) * 2
0x08048cb4 <+63>: jmp    0x8048cd6 <func4+97>

0x08048cb6 <+65>: mov    $0x0,%eax
0x08048cbb <+70>: cmp    %edx,%ecx
0x08048cbd <+72>: jge    0x8048cd6 <func4+97>   ; mid >= target

0x08048cbf <+74>: mov    %ebx,0x8(%esp)         ; mid < target, 代码可运行至此处
0x08048cc3 <+78>: add    $0x1,%ecx
0x08048cc6 <+81>: mov    %ecx,0x4(%esp)
0x08048cca <+85>: mov    %edx,(%esp)
0x08048ccd <+88>: call   0x8048c75 <func4>      ; func4(target, mid+1, hi)

0x08048cd2 <+93>: lea    0x1(%eax,%eax,1),%eax  ; 返回值为 func4(target, mid+1, hi) * 2 + 1
```

画出二叉搜索树, 往左走返回值 * 2, 往右走返回值 * 2 + 1

-   7 : 0
-   3 : 0
-   11: 1
-   1 : 0
-   5 : 1
-   9 : 2
-   13: 3
-   0 : 0
-   2 : 1
-   4 : 2
-   6 : 3
-   8 : 4
-   10: 5
-   12: 6
-   14: 7

```shell
                        7
            3                           11
    1               5           9               13
0       2       4       6   8       10      12      14   
```

为保证函数返回值为７, 故第一个数字为 14

### 解决方法

-   first = 14
-   second = 7

## Phase 5

```asm
; 输入字符串长度必须为6
; 否则, 炸弹爆炸
0x08048d61 <+16>:  cmp    $0x6,%eax
0x08048d64 <+19>:  je     0x8048db2 <phase_5+97>
0x08048d66 <+21>:  call   0x80490f7 <explode_bomb>

...

0x08048db2 <+97>:  mov    $0x0,%eax
0x08048db7 <+102>: jmp    0x8048d72 <phase_5+33>
0x08048db9 <+104>: add    $0x28,%esp
0x08048dbc <+107>: pop    %ebx
0x08048dbd <+108>: ret    
```

```
0x08048d72 <+33>: movzbl (%ebx,%eax,1),%edx
0x08048d76 <+37>: and    $0xf,%edx
0x08048d79 <+40>: movzbl 0x804a110(%edx),%edx
0x08048d80 <+47>: mov    %dl,0x19(%esp,%eax,1)
0x08048d84 <+51>: add    $0x1,%eax
0x08048d87 <+54>: cmp    $0x6,%eax
0x08048d8a <+57>: jne    0x8048d72 <phase_5+33>
```

仔细观察发现,阶段５与阶段１反汇编代码极其类似

```asm
0x08048d91 <+64>: movl   $0x804a0e6,0x4(%esp)
0x08048d99 <+72>: lea    0x19(%esp),%eax
0x08048d9d <+76>: mov    %eax,(%esp)
0x08048da0 <+79>: call   0x8048fea <strings_not_equal>
0x08048da5 <+84>: test   %eax,%eax
0x08048da7 <+86>: je     0x8048db9 <phase_5+104>
0x08048da9 <+88>: call   0x80490f7 <explode_bomb>
```

键入 `x/s  0x804a0e6`, 得到 “bruins", 此字符串为目标字符串
