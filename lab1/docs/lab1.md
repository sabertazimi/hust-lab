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

-   BUF1: 0 0 0
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

```asm
66b8190b0000	mov     eax, 00000b19
668ed8		mov	ds, ax
66be00000000	mov	esi, 00000000
66b90a000000	mov	ecx, 0000000A
66b800000000	mov	eax, 00000000 
678a8600000000	mov	al, [esi]
6788860a000000	mov	[esi+0000000A], al
fec0		inc	al
67888614000000	mov	[esi+00000014], al
0403		add 	al, 03
6788861e000000	mov	[esi+0000001E],	al
6646		inc	esi
6649		dec	ecx
75da		jne	001B
b44c		mov	ah, 4C
cd21		int	21
```
