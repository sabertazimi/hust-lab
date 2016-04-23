.386

stack   segment use16   para    stack   'stack'
    db 200 dup(0)
stack   ends

code    segment use16   para    public  'code'
start:  
        push    cs
        push    ds
        mov     ax, 3510h   ; 获取10h的中断矢量
        int     21h         ; 段址保存在 es, 偏移址保存在 bx
        mov     ah, 4ch
        int     21h
code    ends
        end start
