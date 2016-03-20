START:  MOV     AX, DATA
        MOV     DS, AX
        MOV     SI, 0
        MOV     CX, 10
LOPA:   MOV     AL, [SI + BUF1]
        MOV     [SI + BUF2], AL
        INC     AL
        MOV     [SI + BUF3], AL
        ADD     AL, 3
        MOV     [SI + BUF4], AL
        INC     SI
        DEC     CX
        JNZ     LOPA
        MOV     AH, 4CH
        INT     21H
