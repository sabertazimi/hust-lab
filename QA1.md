### QAs

#### 理解基础设施

*   270000 s = 4500 m = 75 h
*   90000  s = 1500 m = 25 h
*   75 h - 25 h = 50 h

#### i386 Manual

*   Page 34/421: CF = Carry Flag

*   Page 241-244/421: mod(7 6) reg/opcode(5 4 3) r/m(2 1 0)

mod 域与 r/m 域结合可以有 32 种值：8 寄存器，24 种索引模式，用于寄存器寻址等各种寻址方式
reg/opcode 表示寄存器编号或指令编号, 由第一个 opcode 决定其意义

*  Page 345-347/421: MOV DEST, SRC

#### shell

```sh
find . -name "*.[ch]" | xargs cat | grep -v ^$ | wc -l
```

3275

#### -Wall -Werror

```sh
sudo apt-get install man-db
```

*   开启大部分警告选项
*   将警告强制转为错误

使得所有隐藏的逻辑错误都可以在编译阶段得到修正

```c
if (num = 0) {
    printf("num == 0\n");
} else {
    printf("num != 0\n");
}
```
