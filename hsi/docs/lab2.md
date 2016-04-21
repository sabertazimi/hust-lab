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

