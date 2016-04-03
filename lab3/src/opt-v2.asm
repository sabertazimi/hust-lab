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

TIMER	PROC
	    PUSH  DX
	    PUSH  CX
	    PUSH  BX
	    MOV   BX, AX
	    MOV   AH, 2CH
	    INT   21H	     ;CH=hour(0-23),CL=minute(0-59),DH=second(0-59),DL=centisecond(0-100)
	    MOV   AL, DH
	    MOV   AH, 0
	    IMUL  AX,AX,1000
	    MOV   DH, 0
	    IMUL  DX,DX,10
	    ADD   AX, DX
	    CMP   BX, 0
	    JNZ   _T1
	    MOV   CS:_TS, AX
_T0:	POP   BX
	    POP   CX
	    POP   DX
	    RET
_T1:	SUB   AX, CS:_TS
	    JNC   _T2
	    ADD   AX, 60000
_T2:	MOV   CX, 0
	    MOV   BX, 10
_T3:	MOV   DX, 0
	    DIV   BX
	    PUSH  DX
	    INC   CX
	    CMP   AX, 0
	    JNZ   _T3
	    MOV   BX, 0
_T4:	POP   AX
	    ADD   AL, '0'
	    MOV   CS:_TMSG[BX], AL
	    INC   BX
	    LOOP  _T4
	    PUSH  DS
	    MOV   CS:_TMSG[BX+0], 0AH
	    MOV   CS:_TMSG[BX+1], 0DH
	    MOV   CS:_TMSG[BX+2], '$'
	    LEA   DX, _TS+2
	    PUSH  CS
	    POP   DS
	    MOV   AH, 9
	    INT   21H
	    POP   DS
	    JMP   _T0
_TS	    DW    ?
 	    DB    'Time elapsed in ms is '
_TMSG	DB    12 DUP(0)
TIMER   ENDP


START:  MOV     AX, DATA
        MOV     DS, AX
        MOV     EDI, COUNT  ; 程序执行次数
        MOV     AX, 0
        CALL    TIMER
        MOV     CX, NUM
;       在查找开始前，先把所有成绩计算好
CAL:    MOV     BX, NUM     ; 计算目标学生下标值, 存放至 BX
        SUB     BX, CX
        MOV     DX, BX
        ADD     DX, DX
        SAL     BX, 4
        SUB     BX, DX      ; 根据目标学生下标值, 找到分数缓冲区首地址
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
        JE      L1          ; 计算完100个学生,开始模拟查找
        JMP     CAL         ; 未计算完100个学生，继续计算

L1:     MOV     CX, NUM     ; 学生个数
        LEA     BP, TARGET  ; 将 TARGET 基址存放至 BP
        INC     CX
COMPA:  DEC     CX
        JE      NEXT        ; 查找失败, 重新输入
        MOV     BX, NUM     ; 计算目标学生下标值, 存放至 BX
        SUB     BX, CX
        MOV     AX, BX
        ADD     AX, AX      ; 2 * index
        SAL     BX, 4       ; 16 * index
        SUB     BX, AX      ; 根据目标学生下标值, 找到分数   缓冲区首地址
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
ZERO:   CMP     DH, 24H     ; 检查数据段姓名是否为用户输入字符串的子串
        JE      NEXT        ; 不是子串，说明查找成功
        JMP     COMPA       ; 是子串，说明查找失败，继续比较下一个学生姓名

NEXT:   DEC     EDI
        JNE     L1
OVER:   MOV     AX, 1
        CALL    TIMER
        MOV     AH, 4CH
        INT     21H

CODE    ENDS
        END     START
