; Hello World

.386
STACK   SEGMENT USE16   STACK
        DB 200  DUP(0)
STACK   ENDS

DATA    SEGMENT USE16
        MSG DB  'HELLO WORLD$'
DATA    ENDS

CODE    SEGMENT USE16
        ASSUME  CS:CODE, DS:DATA, SS:STACK
START:
        MOV AX, DATA
        MOV DS, AX
        LEA DX, MSG
        MOV AH, 9
        INT 21H
        MOV AH, 4CH
        INT 21H
CODE    ENDS
        END START