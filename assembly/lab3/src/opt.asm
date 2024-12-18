.386

STACK   SEGMENT     USE16   STACK
        DB 200  DUP(0)
STACK   ENDS

DATA    SEGMENT     USE16
        COUNT   EQU 100000
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


START:
        MOV     AX, DATA
        MOV     DS, AX
        MOV     EDI, COUNT  ; 程序执行次数
        MOV     AX, 0
        CALL    TIMER
L1:
        MOV     CX, NUM
CAL:
        MOV     BX, NUM     ; 计算目标学生下标值, 存放至 BX
        SUB     BX, CX
        IMUL   BX, 14
        ADD     BX, 10         ; BX = 0 + Index * 14 + 10
        XOR     EAX, EAX         ; 初始化寄存器，使得代码上下文无关，减少bug
        XOR     EDX, EDX         ; 初始化寄存器，使得代码上下文无关，减少bug
        MOV     AL, [BX]        ; 计算平均成绩
        MOV     DL, [BX + 1]
        LEA       EAX, [EDX + EAX*2]
        XOR     EDX, EDX
        MOV     DL, [BX+2]
        LEA       ESI, [EDX+EAX*2]
        MOV     EAX, 92492493h       ;(1)  (1)~(7)是计算 (ESI) / 7 并将商保存到EDX
        IMUL     ESI          ;(2)  IDIV指令的执行时间远比IMUL指令长
        ADD      EDX, ESI  ;(3)  (1)~(7)用乘法指令实现整数除法
        SAR       EDX, 2     ;(4)
        MOV     EAX, EDX;(5)
        SHR       EAX, 1Fh  ;(6)
        ADD      EDX, EAX ;(7)
        MOV     [EBX + 3], DL; AVG = AL ( AL / 3.5)
        DEC     CX
        JNE     CAL         ; 未计算完100个学生，继续计算

        MOV   CX, NUM     ; 学生个数
        LEA     BP, TARGET  ; 将 TARGET 基址存放至 BP
        INC     CX
COMPA:
        DEC       CX
        JE           NEXT        ; 查找失败, 重新输入
        MOV     BX, NUM     ; 计算目标学生下标值, 存放至 BX
        SUB      BX, CX
        IMUL    BX, 14      ; 根据目标学生下标值, 找到姓名缓冲区首地址
        MOV     AX, 10      ; 临时计数器
        MOV     SI, 0
COMPB:
        MOV     DL, [BX + SI]
        MOV     DH, BYTE PTR DS:[BP + SI]
        CMP     DL, 0       ; 如果缓冲区姓名已结束,说明可能查找成功
        JE      ZERO        ; 验证用户键入字符串是否也结束
        CMP     DH, DL      ; 比较 当前缓冲区姓名 与 输入姓名 字符
        JNE     COMPA       ; 当前字符相同,继续循环以比较下一字符
        INC     SI
        DEC     AX
        JNE     COMPB
ZERO:
        CMP     DH, 24H     ; 检查数据段姓名是否为用户输入字符串的子串
        JE      NEXT        ; 不是子串，说明查找成功
        JMP     COMPA       ; 是子串，说明查找失败，继续比较下一个学生姓名

NEXT:
        DEC     EDI
        JNE     L1
OVER:
        MOV     AX, 1
        CALL    TIMER
        MOV     AH, 4CH
        INT     21H

CODE    ENDS
        END     START
