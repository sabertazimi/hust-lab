        name    child
        extern  m_num: dword, m_table: word
        public  c_sort, c_print

.386

stack   segment use16   para    stack   'stack'
        db  200 dup(0)
stack   ends

data  segment use16   para    public  'data'
        c_max_num       equ 1000
        c_print_promt   db  "Please choose print style: ", 0ah, 0dh
                        db  "1. Binary", 0ah, 0dh
                        db  "2. Octal", 0ah, 0dh
                        db  "3. Decimal", 0ah, 0dh
                        db  "4. Hexadecimal$", 0ah, 0dh
        c_tmp_grade     db  "tmp$"
data ends

code    segment use16   para    public  'code'
        assume  cs:code, ds:data, ss:stack

c_crlf  macro
        push    eax
        push    edx                     ; 以上为保护现场
        mov     ah, 2h
        mov     dl, 0ah
        int     21h
        mov     dl, 0dh
        int     21h
        pop     edx                     ; 以下为恢复现场
        pop     eax
        endm

; 函数名称: c_exchange
; 交换学生成绩表中两个学生的位置
; 入口参数: esi, edi 分别为两个学生信息的偏移地址
; 出口参数: 无
c_exchange  proc    far
            push    ecx
            push    edx
            xor     ecx, ecx            ; 计数器初始化为0
c_exchange_loop:
            mov     dl, [esi + ecx]
            xchg    dl, [edi + ecx]
            mov     [esi + ecx], dl     ; 逐字符交换两个学生的信息
            inc     ecx
            cmp     ecx, 0eh
            jne     c_exchange_loop     ; 交换14个字节为止
            pop     edx
            pop     ecx
            ret
c_exchange  endp

; 函数名称: c_sort
; 按照平均成绩对学生成绩表进行排序
; 入口参数: 无
; 出口参数: 无
c_sort      proc    far
            push    eax
            push    ebx
            push    ecx
            push    edx
            push    esi
            push    edi
            xor     ebx, ebx
            xor     ecx, ecx
            xor     edx, edx
            ;       冒泡排序算法
            xor     eax, eax            ; 外循环计数器
c_sort_outer:
            cmp     eax, m_num
            jge     c_sort_finish
            imul    ebx, eax, 14
            lea     esi, [ebx + m_table]; avg[i]
            lea     ecx, [eax + 1]      ; 内循环计数器
c_sort_inner:
            cmp     ecx, m_num
            jge     c_sort_outer_next
            imul    ebx, ecx, 14
            lea     edi, [ebx + m_table]; avg[j]
            mov     dl, [esi + 13]
            cmp     [edi + 13], dl
            jge     c_sort_inner_next
            call    c_exchange          ; 若　avg[j] < avg[i], 交换两者信息
c_sort_inner_next:
            inc     ecx                 ; 内循环计数器自增
            jmp     c_sort_inner
c_sort_outer_next:
            inc     eax
            jmp     c_sort_outer
c_sort_finish:
            pop     edi
            pop     esi
            pop     edx
            pop     ecx
            pop     ebx
            pop     eax
            ret
c_sort      endp

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
; edx - 作除法时存放被除数高位或余数
c_radix     proc
            push    cx
            push    edx
            xor     cx, cx          ; 计数器初始化为0
c_radix_loop1:
            xor     edx, edx
            div     ebx
            push    dx              ; (eax) / P 所得商 -> eax, 余数入栈
            inc     cx              ; (cx)++, 记录余数个数
            or      eax, eax
            jnz     c_radix_loop1   ; (eax) != 0
c_radix_loop2:                      ; 将栈中的余数依次转化成字符,输入目标缓冲区
            pop     ax
            cmp     al, 10
            jb      c_radix_l1
            add     al, 7
c_radix_l1:
            add     al, 30h         ; 数字 -> 字符
            mov     [si], al        ; 送入缓冲区
            inc     si
            loop    c_radix_loop2   ; (cx)--
            pop     edx
            pop     cx
            ret
c_radix     endp

; 函数名称: c_print
; 打印学生成绩表
; 入口参数: 无
; 出口参数: 无
c_print     proc    far
            push    eax
            push    ebx
            push    ecx
            push    edx
            push    esi
            push    edi                     ; 以上为保护现场
            c_crlf
            lea     dx, c_print_promt       ; 输出菜单
            mov     ah, 9h
            int     21h
            c_crlf
            mov     ah, 1h                  ; 用户输入所需功能 - 选择以何种进制显示成绩
            int     21h
            c_crlf
            cmp     al, 31h                 ; 用户选择 2 进制
            jne     c_print_l1
            mov     ebx, 2h
            jmp     c_print_next
c_print_l1:
            cmp     al, 32h                 ; 用户选择 8 进制
            jne     c_print_l2
            mov     ebx, 8h
            jmp     c_print_next
c_print_l2:
            cmp     al, 33h                 ; 用户选择 10 进制
            jne     c_print_l3
            mov     ebx, 0ah
            jmp     c_print_next
c_print_l3:
            cmp     al, 34h                 ; 用户选择 16 进制
            jne     c_print_next
            mov     ebx, 10h
c_print_next:
            xor     ecx, ecx                ; 计数器初始化为0
c_print_loop:
            cmp     ecx, m_num
            jge     c_print_finish
            imul    esi, ecx, 14
            lea     edi, [esi + m_table]    ; 按照下表取出目标学生信息的偏移地址
            push    ecx                     ; 保护外循环计数器
            xor     ecx, ecx                ; 打印学生姓名,计数器初始化为0
c_print_name:
            mov     dl, [edi + ecx]         ; 依次打印学生姓名各个字符
            mov     ah, 2h
            int     21h
            inc     ecx
            cmp     ecx, 10
            jne     c_print_name            ; 打印完10个字符为止
            xor     ecx, ecx                ; 打印学生成绩,计数器初始化为0
c_print_grade:
            xor     eax, eax
            mov     al, [edi + ecx + 10]    ; 取出学生成绩
            lea     si, c_tmp_grade         ; 用于存放转化结果的缓冲区
            call    c_radix
            lea     dx, c_tmp_grade         ; 打印转化后的成绩数字串
            mov     byte ptr [si], 20h
            mov     byte ptr [si + 1], 20h  ; 成绩之间用空格分隔
            mov     byte ptr [si + 2], '$'  ; 形成字符串
            mov     ah, 9h
            int     21h
            inc     ecx
            cmp     ecx, 4
            jne     c_print_grade           ; 打印 3 + 1　门成绩为止
            pop     ecx                     ; 恢复外循环计数器
            c_crlf                          ; 换行
            inc     ecx
            jmp     c_print_loop
c_print_finish:
            pop     edi                     ; 以下为恢复现场
            pop     esi
            pop     edx
            pop     ecx
            pop     ebx
            pop     eax
            ret
c_print     endp

code    ends
        end
