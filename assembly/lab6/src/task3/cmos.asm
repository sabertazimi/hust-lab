.386

stack   segment use16 stack
        db 200 dup(0)
stack   ends

data    segment use16
        buf     db 10 dup(0)
data    ends

code    segment use16
        assume  cs:code, ds: data,ss:stack
        
; 函数名称: c_radix
; 将eax中的32位无符号二进制数转化为Ｐ进制数(16位段)
; 入口参数:
; eax - 存放待转换的32位无符号二进制数
; ebx - 存放要转换数制的基数
; si - 存放转换后的P进制 ascii 数字串的字节缓冲区首址
; 出口参数:
; si - 指向字节缓冲区中最后一个 ascii 码的下一个字节处
; 寄存器:
; cx - P进制数字入栈／出栈时的计数器
; edx - 作法时存放被除数高位或余数除
radix     proc
            push    cx
            push    edx
            xor     cx, cx          ; 计数器初始化为0
radix_loop1:
            xor     edx, edx
            div     ebx
            push    dx              ; (eax) / P 所得商 -> eax, 余数入栈
            inc     cx              ; (cx)++, 记录余数个数
            or      eax, eax
            jnz     radix_loop1   ; (eax) != 0
radix_loop2:                      ; 将栈中的余数依次转化成字符,输入目标缓冲区
            pop     ax
            cmp     al, 10
            jb      radix_l1
            add     al, 7
radix_l1:
            add     al, 30h         ; 数字 -> 字符
            mov     [si], al        ; 送入缓冲区
            inc     si
            loop    radix_loop2   ; (cx)--
            mov     byte ptr [si], 0ah
            inc     si
            mov     byte ptr [si], 0dh
            inc     si
            mov     byte ptr [si], '$'       ;写入结束符
            inc     si
            pop     edx
            pop     cx
            ret
radix     endp


start:  
        mov     ah, 1h
        int     21h
        cmp     al, 'q'     ; 输入q退出
        je      finish
        sub     al, '0'     ; 将输入字符转化为数字
        xor     edx, edx
        mov     dl, al      ; 将端口号送入dx
        xor     eax, eax
        in      eax, dx      ; 读取端口信息至al
        nop
        mov     ebx, 10h
        lea     si, buf
        call    radix       ; 将端口信息化为16进制数字串
        mov     dl, ' '
        mov     ah, 2h
        int     21h
        mov     dl, '0'
        mov     ah, 2h
        int     21h
        mov     dl, 'x'
        mov     ah, 2h
        int     21h
        lea     dx, buf
        mov     ah, 9h
        int     21h         ; 输出16进制数字串
        jmp     start
finish:
        mov     ah, 4ch
        int     21h
code    ends
        end start
