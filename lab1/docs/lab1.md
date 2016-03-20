# 汇编程序设计上机实验一

## 练习一: TD 中直接求和/差

|Hex|33H|5AH|D7H|A3H|65H|A3H|
|:-----:|:-----:|:------:|:-----:|:------:|:-----:|:------:|
|Operator|Add|Sub|Add|Sub|Add|Sub|
|SF|1|1|0|0|0|1|
|OF|1|0|1|0|0|1|
|CF|0|1|1|0|1|1|
|ZF|0|0|0|0|0|0|

## 练习二: 教材 2-3 与 教材 2-4

### 2-3

-   BUF2: 0 1 2
-   BUF3: 1 2 3
-   BUF4: 4 5 6

### 2-4

```asm
START:  MOV     AX, DATA
        MOV     DS, AX
        MOV     SI, 0
        MOV     CX, 10
LOPA:   MOV     AL, [SI + BUF1]
        MOV     [SI + BUF2], AL
        INC     AL
        MOV     [SI + BUF3], AL
        ADD     AL, 3
        MOV     [SI + BUF4], AL
        INC     SI
        DEC     CX
        JNZ     LOPA
        MOV     AH, 4CH
        INT     21H
```   
