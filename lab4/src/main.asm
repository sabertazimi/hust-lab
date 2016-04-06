.386

stack       segment       use16   stack
                db      200     dup(0)
stack       ends


data        segment           use 16
                m_num       equ      100
                m_table      db      num     dup(10 dup(0), 0, 0, 0, 0)
                m_menu     db        "Please enter function selection:", 0ah, 0dh
                                                        "1: Input student name and grade", 0ah, 0dh
                                                        "2: Calculate sum and average grade", 0ah, 0dh
                                                        "3: Sort", 0ah, 0dh
                                                        "4: Show grade table$", 0ah, 0dh
                m_input_name      db      10
                                          db       ?
                                          db    10 dup(0)
                m_input_score       db   3
                                                db ?
                                                db 3 dup(0)
data ends

code segment use16
        assume cs:code, ds:data, ss:stack

CODE    SEGMENT     USE16
        ASSUME  CS:CODE, DS:DATA, SS:STACK

START:  MOV     AX, DATA
        MOV     DS, AX
        MOV     CX, NUM
SHOWMENU:       ; 输出菜单
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
        LEA     DX, MENU5
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
