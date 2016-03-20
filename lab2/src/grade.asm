.386

STACK   SEGMENT     USE16   STACK
        DB 200  DUP(0)
STACK   ENDS

DATA    SEGMENT     USE16
        NUM     EQU 1
        BUF     DB  'saber'
        LEN     EQU $-BUF
        ZLEN    EQU 10-LEN
                DB  ZLEN DUP(0)
        ZH      DB  90
        MA      DB  80
        EN      DB  85
        AVG     DB  ?
        MSG     DB  'Please input target name: $'
        FAIL    DB  'Not Exist\n$'
        INPUT   DB  10 DUP(10)
DATA    ENDS

CODE    SEGMENT     USE16
        ASSUME  CS:CODE, DS:DATA, SS:STACK
START:  MOV     AX, DATA
        MOV     DS, AX
READ:   MOV     CX, NUM     ; 学生个数
        LEA     DX, MSG
        MOV     AH, 9H
        INT     21H
        LEA     DX, INPUT   ; 输入学生姓名, 以 '$' 符号结尾
        MOV     AH, 0AH
        INT     21H
        ; LEA     DX, INPUT
        ; MOV     AH, 9H
        ; INT     21H
        MOV     AH, 4CH
        INT     21H

CAL:    MOV     BX, NUM     ; 计算目标学生下标值, 存放至 DX
        SUB     BX, CX
        IMUL    BX, 14      ; 根据目标学生下标值, 找到分数缓冲区首地址
        ADD     BX, 10      ; BX = 0 + Index * 14 + 10

CODE    ENDS
        END     START
