﻿# Verilog Basic Notes

## Key Words

```verilog
module
input, output, inout
wire, reg, parameter
always@(), assign
posedge, negedge
if-else, case, begin ... end
```

```verilog
port, signal
```

## Module

-   Inout(Net) -> (Net)Module(Net) -> Inout(Net)
-   Input(Net/Register) -> (Net)Module(Net/Register) -> Output(Net)

```verilog
module moduleName( In1, In2, Out1, Out2, InOut1);
    // 输入输出定义: 说明端口是输入还是输出
    input In1, In2;
    output Out1, Out2;
    inout InOut1;

    // 数据类型定义: 说明端口数据类型 - Net/Register
    wire In1, In2, Out1;
    wire InOut1;
    reg Out2;
    // Instantiation of lower level modules

    // Functionality

    // 三种层次的描述: 逻辑层次(Gate Level), 数据流层次(Dataflow Level), 行为层次(Behavior Level)
    // and/or - gate level
    and and1( Out1, In1, In2);
    // assign - dataflow level
    assign #2 Out1 = In1 & In2;
    // always/initial - behavior level
    allways @(*)
        begin
            Out2 = In1 & In2
        end

    // Timing specification

endmodule
```

## Variable/Data Structure

### 常量

-   0: 逻辑0
-   1: 逻辑1
-   x/X: Unknow/Floating
-   z/Z: 高阻抗状态(High Impendence)
-   parameter: #define

```verilog
localparam idle = 2'b00;
parameter Bit = 8, cnt_up = 1'b1;

output [Bit - 1:0] A;
reg [Bit - 1:0] A;

A = A + cnt_up;
```

### 定义

#### 向量

```verilog
[MSB: LSB] 或 [LSB: MSB]
```

```verilog
output [3:0] A;    // 4 bit
reg [0:3] B, C;    // 4 bit
wire [63:0] D;    // 64 bit
wire E;               // 1 bit

A[2:1] = B[0] & C[1:2];    // A[2] = 0 & C[1], A[1] = B[0] & C[2]
B[0:1] = 0;
C = 4'b1011;                   // C[0] = 1, C[1] = 0, C[2] = 1, C[3] = 1
```

```verilog
integer [7:0] A [3:0];        // 4元素数组. 每个元素为16bit元
reg B [3:0] [15:0];            // arr[4][16]数组, 每个元素为1bit元
reg [7:0] C [3:0] [15:0];    // arr[4][16]数组, 每个元素为8bit元

A[3] = 0;                     // 置零A中第三个元素(8 bit)
A = 0;                        // 置零A
B[1][0] = 1;                  // B[1][0](1 bit)置1
C[0][0][3:0] = 4'b0010;      // C[0][0] 低4bit为0010
C[2][8][5] = 1;               // C[2][8] 第5bit为1
```

### 数字

```verilog
<Bits长度>'<进制><数值>
```

```verilog
Num = 5'b01101;               // 二进制
Num = 22;                     // 十进制
Num = 12'b0000_1111_0000;    // 可读性
Num = 4'hf;                  // 十六进制(1111)
Num = 4'bxxx1;              // 前三位未知
Num = 4'bz01;               // 前两位为z, 后两位为01
```

### Net - wire/wand/wor

-   局部变量, 没有记忆性
-   默认值: z
-   wire 间不可直接相连, wand/wor 间课直接相连

### Register - reg/integer/time/real/realtime

-   有记忆性
-   默认值: x

#### integer

长度为32 Bit, 补码表示, 常用于计数器

```verilog
always @(posedge CLK)
    begin
        integer i;
        for (i = 0;i <= 7; i = i + 1) tmp[i] = In;
    end
```

## Level

### Gate Level

#### Basic Gate

-   and
-   nand(与非)
-   or
-   nor(或非)
-   xor(异或)
-   xnor(同或)

#### Use Gate

```verilog
and (w1, In1, In2);        // w1 = Int and In2
or or1(w2, w1, In2);      // w2 = w1 or In2
xor xor(Out, w1, w2);    // Out = w1 xor w2
```

### Dataflow Level

-    assign net = net/reg: **左式只能是net**

#### [Operators](https://hom-wang.gitbooks.io/verilog-hdl/content/Chapter_04.html)

```verilog
赋值: <=, =
>, <, <=, >=
!=. ==
[ ]. { }
<<, >>
+, -, *, /, %
```

##### { }

**可实现 haskell 中的模式匹配**

```verilog
// 连接运算符
A = { 1'b0, 1'b1};                // A = 2'b01
A = { B[1:0], C[0], D[2] };    // A = B[1], B[2], C[0], D[2]
A = { 2{2'b01} };                  // A = 4'b0101
A = { 3'b101, 2{1'b0} };        // A = 5'b101_00
```

### Behavior Level

-   reg = net/reg: **左式只能是reg*

#### 时延

```verilog
#num

parameter cycle = 30;

# 2
# cycle/2
```

#### 事件

```verilog
@(*);
@( sel, a, b);
@(sel or a or b);
@(posedge CLK);
@(negedge CLK);
```

#### always

```verilog
always @(事件1, 事件2, ...)
    begin
        ...;
    end
```

#### if-else

```verilog
if (condition1)
    begin
        ...;
    end
else if (condition2)
    begin
        ...;
    end
else
    begin
        ...;
    end
```

#### case/casex/casez

-   expr: 常量/变量/连接运算符{ }/x/z

```verilog
case (expr)
    item 1:
        begin
            ...;
        end
    item 2:
        begin
            ...;
        end
    item 3:
        begin
            ...;
        end
    default:
        ...;
endcase
```

#### for

```verilog
for (循环初值; 循环条件; 控制部分)
    begin
        ...;
    end
```

#### Blocking/Non-Blocking

-   Blocking(=): 顺序执行
-   Non-Blocking(<=): 并行执行

```verilog
output = input_logic;

output <= input_logic;
```

## Demos

-   [gitbooks.io](https://hom-wang.gitbooks.io/verilog-hdl/content/Chapter_07.html)
