START:  MOV     AX, DATA
        MOV     DS, AX
        MOV     SI, 0
        MOV     CX, 10
LOPA:   MOV     AL, [SI + OFFSET BUF1]
        MOV     [SI + OFFSET BUF2], AL
        INC     AL
        MOV     [SI + OFFSET BUF3], AL
        ADD     AL, 3
        MOV     [SI + OFFSET BUF4], AL
        INC     SI
        DEC     CX
        JNZ     LOPA
        MOV     AH, 4CH
        INT     21H
