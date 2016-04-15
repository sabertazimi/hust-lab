# 汇编程序设计上机实验一

## 任务一: TD 中直接求和/差

|Hex|33H|5AH|D7H|A3H|65H|A3H|
|:-----:|:-----:|:------:|:-----:|:------:|:-----:|:------:|
|Operator|Add|Sub|Add|Sub|Add|Sub|
|SF|1|1|0|0|0|1|
|OF|1|0|1|0|0|1|
|CF|0|1|1|0|1|1|
|ZF|0|0|0|0|0|0|

## 任务二: 教材 2-3

### Register

-   MOV CX, 10 - BX:14 BP:1E SI:0 DI:A
-   INT 21H - BX:1E BP:28 SI:A DI:14

### Memory

-   BUF1: 0 1 2 3 4 5 6 7 8 9
-   BUF2: 0 1 2 3 4 5 6 7 8 9
-   BUF3: 1 2 3 4 5 6 7 8 9 A
-   BUF4: 4 5 6 7 8 9 A B C D


## 任务三: 教材 2-4

### Writing Code

```asm
START:  MOV     EAX, DATA
        MOV     DS, EAX
        MOV     ESI, 0
        MOV     ECX, 10
        MOV     EAX, 0
LOPA:   MOV     AL, BYTE PTR BUF1[ESI]
        MOV     BUF2[ESI], AL
        INC     AL
        MOV     BUF3[ESI], AL
        ADD     AL, 3
        MOV     BUF4[ESI], AL
        INC     ESI
        DEC     ECX
        JNZ     LOPA
        MOV     AH, 4CH
        INT     21H

```

### Machine Code and Ojbdump

```asm
66b8190b0000	mov     eax, 00000b19
668ed8	        mov	ds, ax
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
