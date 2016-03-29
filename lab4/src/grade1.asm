.386

STACK   SEGMENT     USE16   STACK
        DB 200  DUP(0)
STACK   ENDS


DATA    SEGMENT     USE16
        NUM     EQU 100
        BUF     DB  99 DUP('lancer', 4 DUP(0), 90, 90, 90 , ?)
        LAST    DB  'saber'
                DB  5 DUP(0)
                DB  70
                DB  80
                DB  90
                DB  ?
        MENU    DB  0Ah, 0Dh, "Please enter function selection:$"
        MENU1   DB  0Ah, 0Dh, "1: Input student name and rade$"
        MENU2   DB  0Ah, 0Dh, "2: Calcute Sum Grade and Average Grade"
        MENU3   DB  0Ah, 0Dh, "3: Sort Grade$"
        MENU4   DB  0Ah, 0Dh, "4: Show Grade Table$"
        MSG     DB  "Please input target name (end with dollar): $"
        CONTINU DB  "Enter any keys to continue(except q):$"
        FAIL    DB  "Not Exist!$"
        INPUT   DB  10
                DB  ?
                DB  10 DUP(0)
DATA    ENDS


CODE    SEGMENT     USE16
        ASSUME  CS:CODE, DS:DATA, SS:STACK

START:  MOV     AX, DATA
        MOV     DS, AX
        MOV     CX, NUM
SHOWMENU:       ; 输出菜单
        LEA     DX, MENU
        MOV     AH, 9H
        INT     21H
        LEA     DX, MENU1
        MOV     AH, 9H
        INT     21H
        LEA     DX, MENU2
        MOV     AH, 9H
        INT     21H
        LEA     DX, MENU3
        MOV     AH, 9H
        INT     21H
        LEA     DX, MENU4
        MOV     AH, 9H
        INT     21H
SELECT:


CAL:
        MOV     CX, NUM
CALOOP:
        MOV     BX, NUM     ; 计算目标学生下标值, 存放至 BX
        SUB     BX, CX
        IMUL    BX, 14      ; 根据目标学生下标值, 找到分数缓冲区首地址
        ADD     BX, 10      ; BX = 0 + Index * 14 + 10
        MOV     AX, 0       ; 初始化寄存器，使得代码上下文无关，减少bug
        MOV     DX, 0       ; 初始化寄存器，使得代码上下文无关，减少bug
        MOV     AL, [BX]    ; 计算平均成绩
        ADD     AX, AX      ; AL = ZH * 2
        MOV     DL, [BX + 1]
        ADD     AX, DX      ; AL = ZH * 2 + MA
        MOV     DL, [BX + 2]
        SAR     DL, 1
        ADD     AX, DX      ; AL = ZH * 2 + MA + EN / 2
        SAL     AX, 1       ; AL = 2 * AL
        MOV     DX, 7
        IDIV    DL          ; AL = AL / 7
        MOV     [BX + 3], AL; AVG = AL ( AL / 3.5)
        DEC     CX
        JE      SHOWMENU    ; 计算完100个学生，跳转至用户输入
        JMP     CAL         ; 未计算完100个学生，继续计算

OVER:   MOV     AH, 4CH
        INT     21H

CODE    ENDS
        END     START
