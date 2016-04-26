.386

code    segment use16
        assume  cs:code,ds:code,ss:stack

old_int dw  ?, ?

new_16h proc
        ; 手动调用系统原有键盘驱动程序,处理键盘输入
        pushf           ; 标志寄存器压栈
        cli             ; 关中断
        ; 关闭单步异常
        pushf
        pop ax          ; 将标志位送入ax
        and ah, 0feh    ; 关单步异常(tf置0)
        push ax
        popf            ; 将修改后的标志位送入标志寄存器
        ; 设置返回地址
        push    cs      ; 段首址压栈
        mov     ax, offset a_input
        push    ax      ; ip值压栈
        ; 跳转至系统原有键盘驱动程序
        mov ah, 0h
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
        iret
new_16h endp

; 初始化(安装新中段矢量并使其常驻内存)
start:  
        push    cs
        push    ds
        mov     ax, 3516h           ; 获取16h的中断矢量
        int     21h                 ; 段址保存在 es, 偏移址保存在 bx
        mov     old_int, bx         ; 保存旧程序偏移址
        mov     old_int+2, es       ; 保存旧程序段首址
        ; 修改中断矢量表
        mov     dx, offset new_16h
        mov     ax, 2516h
        int     21h
        ; 修改中断矢量表
        ; xor     ax, ax
        ; mov     ds, ax
        ; cli
        ; mov     word ptr ds:[58h], offset new_16h
        ; mov     ds:[5ah], cs
        ; sti
        ; mov     dx, offset new_16h
        ; mov     ax, 2516h
        ; int     21h
        ; 驻留内存
        mov     dx, offset start + 15
        mov     cl, 4
        shr     dx, cl              ; 每节代表16个字节
        add     dx, 10h             ; 加上段前缀内容
        ; 调用21号软中断, 退出时dx节的主存单元驻留
        mov     al, 0
        mov     ah, 31h
        int     21h
code    ends

stack   segment stack use16 
        db 200 dup(0)
stack   ends

        end start
