.386
STACK   SEGMENT     USE16   STACK
        DB  200 DUP(0)
STACK   ENDS

DATA    SEGMENT     USE16
        MSG     DB  'Press any key to begin!$'
        LEN     EQU $-MSG
        OVER    DB  'Program is over!$'
        BUF1    DB  0, 1, 2, 3, 4, 5, 6, 7, 8, 9
        BUF2    DB  10  DUP(0)
        BUF3    DB  10  DUP(0)
        BUF4    DB  10  DUP(0)
DATA    ENDS

CODE    SEGMENT     USE16
        ASSUME      CS:CODE, DS:DATA, SS:STACK
START:  MOV     AX, DATA
        MOV     DS, AX
        ; 通过DOS系统调用, 输出提示字符串
        MOV     DX, 0
        MOV     AH, 09H
        INT     21H
        ; 通过DOS系统调用, 等待用户键入字符(有回显)
        MOV     AH, 01H
        INT     21H
        ; 以下为原程序代码
        MOV     SI, OFFSET BUF1
        MOV     DI, OFFSET BUF2
        MOV     BX, OFFSET BUF3
        MOV     BP, OFFSET BUF4
        MOV     CX, 10
LOPA:   MOV     AL, [SI]
        MOV     [DI], AL
        INC     AL
        MOV     [BX], AL
        ADD     AL, 3
        MOV     DS:[BP], AL
        INC     SI
        INC     DI
        INC     BP
        INC     BX
        DEC     CX
        JNZ     LOPA
        ; 通过DOS系统调用, 提示用户程序已结束
        MOV     DX, LEN
        MOV     AH, 09H
        INT     21H
        MOV     AH, 4CH
        INT     21H
CODE    ENDS
        END     START
