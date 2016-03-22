.386
STACK   SEGMENT     USE16   STACK
        DB  200 DUP(0)
STACK   ENDS

DATA    SEGMENT     USE16
        BUF1    DB  0, 1, 2, 3, 4, 5, 6, 7, 8, 9
        BUF2    DB  10  DUP(0)
        BUF3    DB  10  DUP(0)
        BUF4    DB  10  DUP(0)
DATA    ENDS

CODE    SEGMENT     USE16
        ASSUME      CS:CODE, DS:DATA, SS:STACK
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
CODE    ENDS
        END     START
