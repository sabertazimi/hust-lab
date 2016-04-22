.386

stack   segment use16   para    stack   'stack'
    db 200 dup(0)
stack   ends

data    segment use16   para    public  'data'
data    ends

code    segment use16   para    public  'code'
start:  
        push    cs
        push    ds
        mov     ax, 3510h   ; 获取10h的中断矢量
        int     21h         ; 其保存在 bx 寄存器中
        mov     ah, 4ch
        int     21h
code    ends
        end start
