.386

STACK   SEGMENT     USE16   STACK
        DB 200  DUP(0)
STACK   ENDS


DATA    SEGMENT     USE16
        NUM     EQU 3
        BUF     DB  'saber'
        LEN1    EQU $-BUF
        ZLEN1   EQU 10-LEN1
                DB  ZLEN1 DUP(0)
        ZH      DB  90
        MA      DB  80
        EN      DB  85
        AVG     DB  ?
        ARCH    DB  'archer'
        LEN2    EQU $-ARCH
        ZLEN2   EQU 10-LEN2
                DB  ZLEN2 DUP(0)
                DB  80
                DB  75
                DB  85
                DB  ?
        LANC    DB  'lancer'
        LEN3    EQU $-LANC
        ZLEN3   EQU 10-LEN3
                DB  ZLEN3 DUP(0)
                DB  70
                DB  80
                DB  75
                DB  ?
        MSG     DB  'Please input target name : $'
        CONTINU DB  'Enter any keys to continue(except q):$'
        FAIL    DB  'Not Exist!$'
        INPUT   DB  10
                DB  ?
                DB  10 DUP(0)
DATA    ENDS


CODE    SEGMENT     USE16
        ASSUME  CS:CODE, DS:DATA, SS:STACK

START:  MOV     AX, DATA
        MOV     DS, AX
        JMP     READ

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


FAILED: LEA     DX, OFFSET FAIL     ; 输出提示信息 - 查找失败
        MOV     AH, 9H
        INT     21H
READY:  MOV     DL, 0AH     ; 输出换行符
        MOV     AH, 2H
        INT     21H
        LEA     DX, OFFSET CONTINU  ; 输出提示信息 - 是否继续
        MOV     AH, 9H
        INT     21H
        MOV     DL, 0AH     ; 输出换行符
        MOV     AH, 2H
        INT     21H
        MOV     AH, 8H
        INT     21H
        CMP     AL, 71H
        JE      OVER        ; 输入 'q', 退出程序

READ:   MOV     CX, NUM     ; 学生个数
        LEA     DX, OFFSET MSG     ; 输出提示信息 - 请输入姓名
        MOV     AH, 9H
        INT     21H
        MOV     DL, 0AH     ; 输出换行符
        MOV     AH, 2H
        INT     21H
        LEA     DX, OFFSET INPUT   ; 读入学生姓名, 以 '$' 符号结尾
        MOV     AH, 0AH
        INT     21H

        MOV     DL, 0AH     ; 输出换行符
        MOV     AH, 2H
        INT     21H
        ; LEA     DX, OFFSET INPUT
        ; MOV     AH, 9H
        ; INT     21H
        LEA     BP, OFFSET INPUT; 将 INPUT 基址存放至 BP
        ADD     BP,2
        CMP     DS:BYTE PTR [BP - 1], 0H   ; 空字符串检查
        JE      READY
        INC     CX
COMPA:  DEC     CX
        JE      FAILED      ; 查找失败, 重新输入
        MOV     BX, NUM     ; 计算目标学生下标值, 存放至 BX
        SUB     BX, CX
        IMUL    BX, 14      ; 根据目标学生下标值, 找到分数缓冲区首地址
        MOV     AX, 10      ; 临时计数器
        MOV     SI, 0
COMPB:  MOV     DL, [BX + SI]
        MOV     DH, BYTE PTR DS:[BP + SI]
        CMP     DL, 0       ; 如果缓冲区姓名已结束,说明查找成功
        JE      CAL         ; 跳转至平均成绩计算处
        CMP     DH, DL      ; 比较 当前缓冲区姓名 与 输入姓名 字符
        JNE     COMPA       ; 当前字符相同,继续循环以比较下一字符
        INC     SI
        DEC     AX
        JNE     COMPB

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
        CMP     AL, 90      ; switch 语句
        JGE     GRADEA
        CMP     AL, 80
        JGE     GRADEB
        CMP     AL, 70
        JGE     GRADEC
        CMP     AL, 60
        JGE     GRADED
        JMP     GRADEE

OVER:   MOV     AH, 4CH
        INT     21H

CODE    ENDS
        END     START
