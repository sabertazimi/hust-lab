 二进制炸弹实验(Bomb Lab)

* 74  - 阶段1：字符串比较
* 82  - 阶段2：循环
* 89  - 阶段3：条件/分支
* 95  - 阶段4：递归调用和栈
* 101 - 阶段5：指针
* 108 - 阶段6：链表/指针/结构

## 基本指令

通过对实验资料的学习，掌握了如下工具使用的技巧:

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

最后,可从[这个网站](https://github.com/cyrus-and/gdb-dashboard)获取 .gdbinit 文件

```
(gdb) source .gdbinit
```

可使得 gdb 一部分功能可视化.

## Phase 1

### 分析 `strings_not_equal`

键入 si ,进入 `strings_not_equal`

```asm
0x0804909a <+0>:  push   %edi
0x0804909b <+1>:  push   %esi
0x0804909c <+2>:  push   %ebx
0x0804909d <+3>:  sub    $0x4,%esp
0x080490a0 <+6>:  mov    0x14(%esp),%ebx
0x080490a4 <+10>: mov    0x18(%esp),%esi

; (%esi) 为内置字符串地址, (%ebx)为输入字符串地址

; 调用两次 `string_length` 函数
; 若两字符串长度不等,跳转至 +99 处,返回1
0x080490a8 <+14>: mov    %ebx,(%esp)
0x080490ab <+17>: call   0x804907b <string_length>
0x080490b0 <+22>: mov    %eax,%edi
0x080490b2 <+24>: mov    %esi,(%esp)
0x080490b5 <+27>: call   0x804907b <string_length>
0x080490ba <+32>: mov    $0x1,%edx
0x080490bf <+37>: cmp    %eax,%edi
0x080490c1 <+39>: jne    0x80490fd <strings_not_equal+99>

; 输入字符串结束('\0'), 跳转至 +80 处,返回0
0x080490c3 <+41>: movzbl (%ebx),%eax
0x080490c6 <+44>: test   %al,%al
0x080490c8 <+46>: je     0x80490ea <strings_not_equal+80>

; 比较两字符串首字符，若不等，则返回1
0x080490ca <+48>: cmp    (%esi),%al
0x080490cc <+50>: je     0x80490d6 <strings_not_equal+60>
0x080490ce <+52>: xchg   %ax,%ax
0x080490d0 <+54>: jmp    0x80490f1 <strings_not_equal+87>

; 比较字符串循环体
; 逐字符比较两字符串
; 若两字符串相等，则返回0
; 否则，返回1
0x080490d2 <+56>: cmp    (%esi),%al
0x080490d4 <+58>: jne    0x80490f8 <strings_not_equal+94>
; 循环控制部分, 两字符串指针后移，inner_str++, input_str++
0x080490d6 <+60>: add    $0x1,%ebx
0x080490d9 <+63>: add    $0x1,%esi
; 检测输入字符串是否已结束,若未结束则继续循环
0x080490dc <+66>: movzbl (%ebx),%eax
0x080490df <+69>: test   %al,%al
0x080490e1 <+71>: jne    0x80490d2 <strings_not_equal+56>

; return 区段
0x080490e3 <+73>: mov    $0x0,%edx
0x080490e8 <+78>: jmp    0x80490fd <strings_not_equal+99>
0x080490ea <+80>: mov    $0x0,%edx
0x080490ef <+85>: jmp    0x80490fd <strings_not_equal+99>
0x080490f1 <+87>: mov    $0x1,%edx
0x080490f6 <+92>: jmp    0x80490fd <strings_not_equal+99>
0x080490f8 <+94>: mov    $0x1,%edx
0x080490fd <+99>: mov    %edx,%eax
0x080490ff <+101>:add    $0x4,%esp
0x08049102 <+104>:pop    %ebx
0x08049103 <+105>:pop    %esi
0x08049104 <+106>:pop    %edi
0x08049105 <+107>:ret    
```

### 主函数

```asm
; 传参: 内置比较字符串
0x08048b93 <+3>:  movl   $0x804a1c4,0x4(%esp)
0x08048b9b <+11>: mov    0x20(%esp),%eax
; 传参:输入字符串地址
0x08048b9f <+15>: mov    %eax,(%esp)
; 调用字符串比较函数
0x08048ba2 <+18>: call   0x804909a <strings_not_equal>
```

-   返回值为1,表示输入字符串与目标字符串不相同
-   返回值为0,表示输入字符串与目标字符串相同

```asm
0x08048b87 phase_1+23 test   %eax,%eax
0x08048b89 phase_1+25 je     0x8048b90 <phase_1+32>
0x08048b8b phase_1+27 call   0x80490f7 <explode_bomb>
0x08048b90 phase_1+32 add    $0x1c,%esp
```

```shell
(gdb) x/s 0x804a1c4
```

输出结果: "I was trying to give Tina Fey more material."

当 eax 为0时,炸弹不会爆炸,拆弹成功;结合对函数 `strings_not_equal`的分析,可知 phase1 的谜底即为**I was trying to give Tina Fey more material.**

## Phase 2

### 分析 `read_six_numbers`

可以看出，以下一段代码是传参及调用 scanf 函数

```asm
; 传入6个数字的地址
0x080491d3 <+7>: lea    0x14(%eax),%edx
0x080491d6 <+10>:mov    %edx,0x1c(%esp)
0x080491da <+14>:lea    0x10(%eax),%edx
0x080491dd <+17>:mov    %edx,0x18(%esp)
0x080491e1 <+21>:lea    0xc(%eax),%edx
0x080491e4 <+24>:mov    %edx,0x14(%esp)
0x080491e8 <+28>:lea    0x8(%eax),%edx
0x080491eb <+31>:mov    %edx,0x10(%esp)
0x080491ef <+35>:lea    0x4(%eax),%edx
0x080491f2 <+38>:mov    %edx,0xc(%esp)
; (%eax) = 0xffffd624
0x080491f6 <+42>:mov    %eax,0x8(%esp)

; 键入 x/s 0x804a3a3
; 输出 0x804a3a3: "%d %d %d %d %d %d"
; 此处存放的是 scanf 的格式字符串参数
; 可以看出，需要输入6个整型数字
0x080491fa <+46>:movl   $0x804a3a3,0x4(%esp)
0x08049202 <+54>:mov    0x30(%esp),%eax
0x08049206 <+58>:mov    %eax,(%esp)
0x08049209 <+61>:call   0x8048860 <__isoc99_sscanf@plt>
```

```asm
; 输入数字个数作为 scanf 的返回值存入 eax
; 当输入数字个数少于 6 时,炸弹爆炸
0x0804920e <+66>: cmp    $0x5,%eax
0x08049211 <+69>: jg     0x8049218 <read_six_numbers+76>
0x08049213 <+71>: call   0x80491a5 <explode_bomb>
```

### 主函数

运行至 +16 处时，键入 x/s $eax,输出'1 2 3 4 5 6'

```asm
0x08048bb8 <+4>: lea    0x18(%esp),%eax
0x08048bbc <+8>: mov    %eax,0x4(%esp)
0x08048bc0 <+12>:mov    0x40(%esp),%eax
0x08048bc4 <+16>:mov    %eax,(%esp)
0x08048bc7 <+19>:call   0x80491cc <read_six_numbers>
```

键入 x/6wd $esp+0x18, 输出:

```asm
0xffffd548: 0   1   3   6
0xffffd558: 10  15
```

```asm
; 以下两条语句是判断第一个是否为正数
; 若为正数,则跳转至 +65 处,进行循环体初始化
; 若为负数,炸弹爆炸
0x08048bcc <+24>: cmpl   $0x0,0x18(%esp)
0x08048bd1 <+29>: jns    0x8048bf5 <phase_2+65>
0x08048bd3 <+31>: call   0x80491a5 <explode_bomb>
```

以下为循环体，从 +65 处指令可以看出，(%ebx) 初始化为1

```asm
0x08048bda <+38>: mov    %ebx,%eax
; (%eax) = number[i-1] + i 
0x08048bdc <+40>: add    0x14(%esp,%ebx,4),%eax
; number[i] == (%eax) == number[i-1] + i
0x08048be0 <+44>: cmp    %eax,0x18(%esp,%ebx,4)
0x08048be4 <+48>: je     0x8048beb <phase_2+55>
; 若上述表达式不成立，炸弹爆炸
0x08048be6 <+50>: call   0x80491a5 <explode_bomb>
0x08048beb <+55>: add    $0x1,%ebx
0x08048bee <+58>: cmp    $0x6,%ebx
0x08048bf1 <+61>: jne    0x8048bda <phase_2+38>
```

-   以上汇编代码可转化为如下C代码
-   假设 x 为第 i 个数字, y 为第 i+1 个数字
-   则必须满足 y = x + i;

```c
for (i = 1;i < 6;i++) {
    x = i + number[i - 1];
    if (x != number[i]) {
        exlpode_bomb();
        return ;
    }
}

return ;
```

### 解决方法

综合上述两个函数的分析, 现得到如下信息:

-   输入6个数字
-   第一个数字必须为正数
-   满足 number[i] = number[i - 1] + i;

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
; 键入 x/s 0x804a21a
; 输出 "%d %c %d"，说明需输入 两个整型与一个字符
0x08048c04 <+3>:  lea    0x2c(%esp),%eax
0x08048c08 <+7>:  mov    %eax,0x10(%esp)
0x08048c0c <+11>: lea    0x27(%esp),%eax
0x08048c10 <+15>: mov    %eax,0xc(%esp)
0x08048c14 <+19>: lea    0x28(%esp),%eax
0x08048c18 <+23>: mov    %eax,0x8(%esp)
0x08048c1c <+27>: movl   $0x804a21a,0x4(%esp)
0x08048c24 <+35>: mov    0x40(%esp),%eax
0x08048c28 <+39>: mov    %eax,(%esp)
0x08048c2b <+42>: call   0x8048860 <__isoc99_sscanf@plt>


; 重新运行程序,输入 1 a 3
; 运行完 scanf 后，键入 x/9bd $esp+0x27
; 输出 97 1 0 0 0 3 0 0 0
; 说明 $esp+0x27 存放输入字符
; $esp+0x28 开始连续4个字节存放第一个整数
; $esp+0x2c 开始连续4个字节存放第二个整数
```

```asm
; 第一个参数必须 <= 7
; 否则,炸弹爆炸(+320 处)
0x08048c3a <+57>: cmpl   $0x7,0x28(%esp)
0x08048c3f <+62>: ja     0x8048d41 <phase_3+320>
```

```asm
; 此句为 switch 条件控制部分
; * 代表间接跳转, 即
; 以 0x804a240(, %eax, 4)为地址的内存单元的内容 为地址，进行跳转
; 故，可推出当 (%eax) 为 0-7 时，跳转目标偏移地址分别为:
; 0: 键入x/1wx 0x804a240，输出 0x08048c50
; 1: 键入x/1wx 0x804a244，输出 0x08048c72
; 2: 键入x/1wx 0x804a248，输出 0x08048c94
; 3: 键入x/1wx 0x804a24c，输出 0x08048cb6
; 4: 键入x/1wx 0x804a250，输出 0x08048cd5
; 5: 键入x/1wx 0x804a254，输出 0x08048cf0
; 6: 键入x/1wx 0x804a258，输出 0x08048d0b
; 7: 键入x/1wx 0x804a25c，输出 0x08048d26
```

```asm
; switch 语句
; 根据第一个数字,选择不同的分支,总共有 8 个分支
; 根据前面的信息可得, $esp+0x2c 处存放第二个输入整数
; 故，观察每个分支可得，每个分支都进行了两项同样操作:
; 1. 将某个字符的ASCII码送入 eax, 并随后跳转至 +330 处
; 根据前面所得信息，$esp+0x27处存放输入字符
; 故，+330 处指令是将输入字符与 eax 低8个字节(高24个字节已为0)进行比较
; 若不相等，炸弹爆炸
0x08048d4b <+330>:cmp    0x27(%esp),%al
0x08048d4f <+334>:je     0x8048d56 <phase_3+341>
0x08048d51 <+336>:call   0x80491a5 <explode_bomb>
; 2.将第二个整数与某个数进行比较，若不相等，炸弹爆炸
0x08048c55 <+84>: cmpl   $0x2e2,0x2c(%esp)
0x08048c5d <+92>: je     0x8048d4b <phase_3+330>
```

故, 可将各分支语句转化成如下 C 代码
```c
case 0: // 0x08048c50
    if (input_char != 0x63) explode_bomb();    // 'c'
    if (input_number != 0x2e2) explode_bomb(); // 738
	break;
case 1: // 0x08048c72
    if (input_char != 0x6e) explode_bomb();    // 'n'
    if (input_number != 0x3ce) explode_bomb(); // 974
	break;
case 2: // 0x08048c94
    if (input_char != 0x71) explode_bomb();    // 'q'
    if (input_number != 0x3d4) explode_bomb(); // 980
	break;
case 3: // 0x08048cb6
    if (input_char != 0x65) explode_bomb();    // 'e'
    if (input_number != 0x356) explode_bomb(); // 854
	break;
case 4: // 0x08048cd5
    if (input_char != 0x68) explode_bomb();    // 'h'
    if (input_number != 0x3c3) explode_bomb(); // 963
	break;
case 5: // 0x08048cf0
    if (input_char != 0x75) explode_bomb();    // 'u'
    if (input_number != 0x2e1) explode_bomb(); // 737
	break;
case 6: // 0x08048d0b
    if (input_char != 0x76) explode_bomb();    // 'v'
    if (input_number != 0xc7) explode_bomb();  // 199
	break;
case 7: // 0x08048d26
    if (input_char != 0x79) explode_bomb();    // 'y'
    if (input_number != 0x86) explode_bomb();  // 134
	break;
```

## Phase 4

```asm
; 键入 x/s 0x804a3af
; 输出 "%d %d",说明输入两个整型数字, 存放地址分别为
; $esp+0x1c , $esp+0x18
0x08048da7 <+3>: lea    0x18(%esp),%eax
0x08048dab <+7>: mov    %eax,0xc(%esp)
0x08048daf <+11>:lea    0x1c(%esp),%eax
0x08048db3 <+15>:mov    %eax,0x8(%esp)
0x08048db7 <+19>:movl   $0x804a3af,0x4(%esp)
0x08048dbf <+27>:mov    0x30(%esp),%eax
0x08048dc3 <+31>:mov    %eax,(%esp)
0x08048dc6 <+34>:call   0x8048860 <__isoc99_sscanf@plt>
```

```asm
; 若第二个整数 > 4,炸弹爆炸
0x08048dd4 <+48>: sub    $0x2,%eax
0x08048dd7 <+51>: cmp    $0x2,%eax
0x08048dda <+54>: jbe    0x8048de1 <phase_4+61>
0x08048ddc <+56>: call   0x80491a5 <explode_bomb>
0x08048de1 <+61>: mov    0x18(%esp),%eax
```

```asm
; func4 返回值 == 第一个输入整数
; 否则, 炸弹爆炸
0x08048df5 <+81>: cmp    0x1c(%esp),%eax
0x08048df9 <+85>: je     0x8048e00 <phase_4+92>
0x08048dfb <+87>: call   0x80491a5 <explode_bomb>
```

### 分析 func4

```asm
; 通过以下4条代码,可推测出 func4 的函数原型为:
; int func4(int x, int y);
; 且此次调用传参为:
; func4(9, second_input_number);
0x08048de1 <+61>: mov    0x18(%esp),%eax
0x08048de5 <+65>: mov    %eax,0x4(%esp)
0x08048de9 <+69>: movl   $0x9,(%esp)
0x08048df0 <+76>: call   0x8048d5a <func4>
```

```asm
; 当 (%ebx) 即 x 为 0 时，返回0
; 当 (%ebx) 即 x 为 1 时， 返回y
0x08048d68 <+14>: test   %ebx,%ebx
0x08048d6a <+16>: jle    0x8048d98 <func4+62>
0x08048d6c <+18>: mov    %esi,%eax
0x08048d6e <+20>: cmp    $0x1,%ebx
0x08048d71 <+23>: je     0x8048d9d <func4+67>

...

0x08048d98 <+62>: mov    $0x0,%eax
0x08048d9d <+67>: add    $0x10,%esp
```

```asm
; 调用 func4(x - 1, y)
0x08048d73 <+25>: mov    %esi,0x4(%esp)
0x08048d77 <+29>: lea    -0x1(%ebx),%eax
0x08048d7a <+32>: mov    %eax,(%esp)
0x08048d7d <+35>: call   0x8048d5a <func4>
0x08048d82 <+40>: lea    (%eax,%esi,1),%edi
; return_val = y + func4(x - 1,y)

; 调用 func4(x - 2, y)
0x08048d82 <+40>: lea    (%eax,%esi,1),%edi
0x08048d85 <+43>: mov    %esi,0x4(%esp)
0x08048d89 <+47>: sub    $0x2,%ebx
0x08048d8c <+50>: mov    %ebx,(%esp)
0x08048d8f <+53>: call   0x8048d5a <func4>
0x08048d94 <+58>: add    %edi,%eax
; return_val = return_val + fun4(x - 2, y)
; 即 return_val = y + func4(x - 1, y) + func4(x - 2, y)
```

```c
int func4(int x, int y) {
    if ( 0 == x ) {
        return 0;
    } else if ( 1 == x ) {
        return y;
    } else {
        return y + func4(x - 1, y) + func4(x - 2,y);
    }
}
```

### 解决方法

-   第一个整数: first == func4(9, y) = 88y = 88 * second

func4(0, y) = 0, func4(1, y) = y, func4(2, y) = y + 0 + y = 2y,
func4(3, y) = y + 2y + y = 4y, func4(4, y) = y + 4y + 2y = 7y,
func4(5, y) = y + 7y + 4y = 12y, func4(6, y) = y + 12y + 7y = 20y,
func4(7, y) = y + 20y + 12 y = 33y, func4(8, y) = y + 33y + 20y = 54y,
func4(9, y) = y + 54y + 33y = 88y

-   第二个整数: second <= 4;

故当 second = 4 时，first = 352.

## Phase 5

```asm
; 输入字符串长度必须为6
; 否则, 炸弹爆炸
0x08048e08 <+4>:  mov    0x20(%esp),%ebx
0x08048e0c <+8>:  mov    %ebx,(%esp)
0x08048e0f <+11>: call   0x804907b <string_length>
0x08048e14 <+16>: cmp    $0x6,%eax
0x08048e17 <+19>: je     0x8048e1e <phase_5+26>
0x08048e19 <+21>: call   0x80491a5 <explode_bomb>
```

-   循环语句: 6个整数求和循环

```asm
;   初始化部分
0x08048e1e <+26>: mov    $0x0,%edx
0x08048e23 <+31>: mov    $0x0,%eax

; 循环体
; 将字符串第 i 个字符移至 ecx
0x08048e28 <+36>: movzbl (%ebx,%eax,1),%ecx

; 将字符 ASCII 码的高 4 位置0
0x08048e2c <+40>: and    $0xf,%ecx

; 键入 x/16d 0x804a260, 输出如下:
; - 0x804a260 <array.3142>:     2   10  6   1
; - 0x804a270 <array.3142+16>:  12  16  9   3
; - 0x804a280 <array.3142+32>:  4   7   14  5
; - 0x804a290 <array.3142+48>:  11  8   15  13
; 证明 0x804a260 处存放着一个长度为16的整型数组
0x08048e2f <+43>: add    0x804a260(,%ecx,4),%edx

; 循环控制部分: i++ , 若 i >= 6,循环结束
0x08048e36 <+50>: add    $0x1,%eax
0x08048e39 <+53>: cmp    $0x6,%eax
0x08048e3c <+56>: jne    0x8048e28 <phase_5+36>
```

-   拆弹条件

```asm
; 循环语句的求和结果必须为 0x42(66d)
; 否则，炸弹爆炸
0x08048e3e <+58>: cmp    $0x42,%edx
0x08048e41 <+61>: je     0x8048e48 <phase_5+68>
0x08048e43 <+63>: call   0x80491a5 <explode_bomb>
```

根据以上分析，可知，需要输入6个字符,
以其低4位的ascii码控制取出数组中的6个整型元素,并使6个元素之和为 66.
可取 10+12+16+3+14+11 = 66,它们分别为第 1, 4, 5, 7, 10, 12号元素.
此时输入6个字符的低4位ASCII码须为 0x0001, 0x0100, 0x0101, 0x0111, 0x1010, 0x1100.
查表可得, adegjl ADEGJL qtuwz| QTUWZ\ 符合标准
