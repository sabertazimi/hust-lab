.386

code    segment use16   para    public  'code'
        assume  cs: code, ss: stack

old_int dw  8a9h, 20ah

start:
        mov ah, 0h       ; 手动调用系统原有键盘驱动程序,处理键盘输入
        pushf            ; 标志寄存器压栈
        cli              ; 关中断
        ; 关闭单步异常
        pushf
        pop ax           ; 将标志位送入ax
        and ah, 0feh     ; 关单步异常(tf置0)
        push ax
        popf             ; 将修改后的标志位送入标志寄存器
        ; 设置返回地址
        push    cs       ; 当前段首址压栈
        ; 当前ip值压栈
        mov     ax, offset a_input
        push    ax
        ; 跳转至系统原有键盘驱动程序
        jmp     dword ptr old_int
a_input:
        cmp al, 41h     ; 若按下字母A,则输出B
        jne b_input
        mov dl, 42h
        mov ah, 2h
        int 21h         ; 输出B
b_input:
        cmp al, 42h     ; 若按下字母B,则输出A
        jne finish
        mov dl, 41h
        mov ah, 2h
        int 21h         ; 输出A
finish:
        mov     ah, 4ch
        int     21h
code    ends

stack   segment use16   para    stack   'stack'
        db 200 dup(0)
stack   ends

        end start
