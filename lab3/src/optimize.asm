.386

STACK   SEGMENT     USE16   STACK
        DB 200  DUP(0)
STACK   ENDS

DATA    SEGMENT     USE16
        COUNT   EQU 10000000
        NUM     EQU 1000
        BUF     DB  NUM-1 DUP('lancer', 4 DUP(0), 80, 90, 70 , ?)
        LAST    DB  'saber'
                DB  5 DUP(0)
                DB  100
                DB  80
                DB  90
                DB  ?
        TARGET  DB  'saber$'    ; 将最后一个学生设定为每次查找的目标，加大程序执行时间
DATA    ENDS


CODE    SEGMENT     USE16
        ASSUME  CS:CODE, DS:DATA, SS:STACK

disptime proc
         local timestr[8]:byte     ;0,0,'"',0,0,0dh,0ah,'$'
         push cx
         push dx
         push ds
         push ss
         pop  ds
         mov  ah,2ch
         int  21h
         xor  ax,ax
         mov  al,dh
         mov  cl,10
         div  cl
         add  ax,3030h
         mov  word ptr timestr,ax
         mov  timestr+2, 22h
         xor  ax,ax
         mov  al,dl
         div  cl
         add  ax,3030h
         mov  word ptr timestr+3,ax
         mov  word ptr timestr+5,0a0dh
         mov  timestr+7,'$'
         lea  dx,timestr
         mov  ah,9
         int  21h
         pop  ds
         pop  dx
         pop  cx
         ret
disptime endp

START:  MOV     AX, DATA
        MOV     DS, AX
        MOV     EDI, COUNT   ; 程序执行次数
        CALL    disptime

L1:     MOV     CX, NUM     ; 学生个数
        LEA     BP, TARGET  ; 将 TARGET 基址存放至 BP
        INC     CX
COMPA:  DEC     CX
        JE      NEXT        ; 查找失败, 重新输入
        MOV     BX, NUM     ; 计算目标学生下标值, 存放至 BX
        SUB     BX, CX
        IMUL    BX, 14      ; 根据目标学生下标值, 找到姓名缓冲区首地址
        MOV     AX, 10      ; 临时计数器
        MOV     SI, 0
COMPB:  MOV     DL, [BX + SI]
        MOV     DH, BYTE PTR DS:[BP + SI]
        CMP     DL, 0       ; 如果缓冲区姓名已结束,说明可能查找成功
        JE      ZERO        ; 验证用户键入字符串是否也结束
        CMP     DH, DL      ; 比较 当前缓冲区姓名 与 输入姓名 字符
        JNE     COMPA       ; 当前字符相同,继续循环以比较下一字符
        INC     SI
        DEC     AX
        JNE     COMPB
ZERO:   CMP     BYTE PTR DS:[BP + SI], 24H   ; 检查数据段姓名是否为用户输入字符串的子串
        JE      CAL         ; 不是子串，说明查找成功，跳转至平均成绩计算处
        JMP     COMPA       ; 是子串，说明查找失败，继续比较下一个学生姓名

;       减少长时钟周期指令
CAL:    MOV     BX, NUM     ; 计算目标学生下标值, 存放至 BX
        SUB     BX, CX
        IMUL    BX, 14      ; 根据目标学生下标值, 找到分数缓冲区首地址
        ADD     BX, 10      ; BX = 0 + Index * 14 + 10
        MOV     AX, 0
        MOV     DX, 0
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
NEXT:   DEC     EDI
        JNE     L1
OVER:   CALL    disptime
        MOV     AH, 4CH
        INT     21H

CODE    ENDS
        END     START

;       在循环开始前，先把所有成绩计算好
;CAL:    MOV     BX, NUM     ; 计算目标学生下标值, 存放至 BX
        ;SUB     BX, CX
        ;IMUL    BX, 14      ; 根据目标学生下标值, 找到分数缓冲区首地址
        ;ADD     BX, 10      ; BX = 0 + Index * 14 + 10
        ;MOV     AX, 0       ; 初始化寄存器，使得代码上下文无关，减少bug
        ;MOV     DX, 0       ; 初始化寄存器，使得代码上下文无关，减少bug
        ;MOV     AL, [BX]    ; 计算平均成绩
        ;ADD     AX, AX      ; AL = ZH * 2
        ;MOV     DL, [BX + 1]
        ;ADD     AX, DX      ; AL = ZH * 2 + MA
        ;MOV     DL, [BX + 2]
        ;SAR     DL, 1
        ;ADD     AX, DX      ; AL = ZH * 2 + MA + EN / 2
        ;SAL     AX, 1       ; AL = 2 * AL
        ;MOV     DX, 7
        ;IDIV    DL          ; AL = AL / 7
        ;MOV     [BX + 3], AL; AVG = AL ( AL / 3.5)
        ;DEC     CX
        ;JE      READ        ; 计算完100个学生，跳转至用户输入
        ;JMP     CAL         ; 未计算完100个学生，继续计算
