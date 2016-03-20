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
        ;JMP     READ

GRADEA: MOV     DL, 41H
        MOV     AH, 2H
        INT     21H
        JMP     READY
GRADEB: MOV     DL, 42H
        MOV     AH, 2H
        INT     21H
        JMP     READY
GRADEC: MOV     DL, 43H
        MOV     AH, 2H
        INT     21H
        JMP     READY
GRADED: MOV     DL, 44H
        MOV     AH, 2H
        INT     21H
        JMP     READY
GRADEE: MOV     DL, 45H
        MOV     AH, 2H
        INT     21H
        JMP     READY

READY:  MOV     AH, 4CH
        INT     21H

READ:   MOV     CX, NUM     ; 学生个数
        LEA     DX, OFFSET MSG
        MOV     AH, 9H
        INT     21H
        LEA     DX, OFFSET INPUT   ; 输入学生姓名, 以 '$' 符号结尾
        MOV     AH, 0AH
        INT     21H
        ; LEA     DX, INPUT
        ; MOV     AH, 9H
        ; INT     21H
        MOV     AH, 4CH
        INT     21H

CAL:    MOV     BX, NUM     ; 计算目标学生下标值, 存放至 BX
        SUB     BX, CX
        IMUL    BX, 14      ; 根据目标学生下标值, 找到分数缓冲区首地址
        ADD     BX, 10      ; BX = 0 + Index * 14 + 10
        MOV     AL, [BX]    ; 计算平均成绩
        ADD     AL, AL      ; AL = ZH * 2
        ADD     AL, [BX + 1]; AL = ZH * 2 + MA
        MOV     DL, [BX + 2]
        SAR     DL, 1
        ADD     AL, DL      ; AL = ZH * 2 + MA + EN / 2
        MOV     DL, AL
        SAL     AL, 3
        SUB     AL, DL      ; 7AL = 8AL - AL
        SAR     AL, 2       ; 3.5AL = 7AL / 2
        CMP     AX, 90      ; switch 语句
        JBE     GRADEA
        CMP     AX, 80
        JBE     GRADEB
        CMP     AX, 70
        JBE     GRADEC
        CMP     AX, 60
        JBE     GRADED
        JMP     GRADEE

CODE    ENDS
        END     START
