.386

code    segment use16
        assume  cs:code,ss:stack

old_int dw  ?, ?

new_16h:
        ; 查看用户是否调用键盘驱动程序的读入键盘功能
        cmp ah, 0h
        je input_0 
        cmp ah, 10h
        je input_0
        ; 若不是,则直接跳转至旧的键盘驱动程序
        jmp dword ptr old_int
        ; 否则,运行扩展程序
input_0:
        pushf
        ; 调用旧的键盘驱动程序
        call dword ptr old_int
        cmp al, 'a'     ; 若按下字母A,则返回B
        jne input_1
        mov al, 'b';
        jmp finish
input_1:
        cmp al, 'A'
        jne input_2
        mov al, 'B'
        jmp finish
input_2:
        cmp al, 'b'     ; 若按下字母B,则返回A
        jne input_3
        mov al, 'a'
        jmp finish
input_3:
        cmp al, 'B'     ; 若按下字母B,则返回A
        jne finish
        mov al, 'A'
finish:
        iret 
; 初始化(安装新中段矢量并使其常驻内存)
start:  
        xor     ax, ax
        mov     ds, ax
        mov     ax, ds:[16h*4]
        mov     old_int, ax
        mov     ax, ds:[16h*4+2]
        mov     old_int+2, ax
        ; mov     ax, 3516h           ; 获取16h的中断矢量
        ; int     21h                 ; 段址保存在 es, 偏移址保存在 bx
        ; mov     old_int, bx         ; 保存旧程序偏移址
        ; mov     old_int+2, es       ; 保存旧程序段首址
        ; 修改中断矢量表
        ; push  cs
        ; pop   ds
        ; mov     dx, offset new_16h
        ; mov     ax, 2516h
        ; int     21h
        ; 修改中断矢量表
        cli
        mov     word ptr ds:[58h], offset new_16h
        mov     ds:[5ah], cs
        sti
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
