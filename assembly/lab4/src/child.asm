; team: 刘一龙,  曾圳
; author: 曾圳

        name    child
        extern  m_num: dword, m_table: byte
        public  c_sort, c_print,c_radix

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
        c_choose        db  ?
        c_null          db  '  $'
        c_stu_name      db  '**student name:$'
        c_stu_grade     db  '**grade:$'
        c_tmp_grade     db  5 dup("tmp$")
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
; 9号dos功能调用
c_dos9  macro   str
        push    eax
        push    edx                     ;以上为保护现场
        lea     dx, str
        mov     ah, 9
        int     21h
        pop     edx                     ;以下为恢复现场
        pop     eax
        endm
; 10号功能调用
c_dos10 macro   adr
        push    eax
        push    edx
        lea     dx, adr
        mov     ah, 10
        int     21h
        pop     edx
        pop     eax
        endm
; 1号功能调用
c_dos1 macro    c_choose
        push    eax
        push    edx
        mov     ah, 1
        int     21h
        mov     c_choose, al
        c_crlf
        pop     edx
        pop     eax
        endm

; 函数名称: c_exchange
; 交换学生成绩表中两个学生的位置
; 入口参数: esi, edi 分别为两个学生信息的偏移地址
; 出口参数: 无
; 所使用寄存器：
; al - 用于交换信息
c_exchange  proc    far
                push    eax
                push    ebx
                push    ecx                         ;以上为保护现场
                mov     ecx, 0
c_exchange_loop1:
                mov     al, [esi][ecx]
                xchg    al, [edi][ecx]
                mov     [esi][ecx], al                ;交换
                inc     ecx
                cmp     ecx, 14
                jne     c_exchange_loop1
                pop     ecx                         ;以下为恢复现场
                pop     ebx
                pop     eax
                ret
c_exchange  endp

; 函数名称: c_sort
; 按照平均成绩对学生成绩表进行排序
; 入口参数: 无
; 出口参数: 无
c_sort      proc    far

                                            ; 以上为保护现场
            mov     ecx, m_num         ; 外循环计数器
            ;mov     edx, offset m_table
c_sort_loop1:
            mov     ebx, 1                  ; 内循环计数器
c_sort_loop2:
            imul    eax, ebx, 14
            mov     dl, m_table[eax - 1]
            cmp     dl, m_table[eax + 13]
            jge    c_sort_loop3
            lea     esi, m_table[eax - 14]
            lea     edi, m_table[eax]
            call    far ptr c_exchange              ;交换学生位置
c_sort_loop3:
            inc     ebx
            cmp     ebx, m_num
            jnz     c_sort_loop2
            loop    c_sort_loop1
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
; edx - 作法时存放被除数高位或余数除
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

; 函数名称：c_print_name
; 打印学生名字
; 入口参数：
; edi - 学生信息的偏移地址
; 出口参数：无
c_print_name     proc
                push    ecx
                push    ebx
                mov     ecx, 0
c_print_name_loop:
                mov     dl, [edi][ecx]
                mov     ah, 2
                int     21h
                inc     ecx
                cmp     byte ptr [edi][ecx], 0
                jne     c_print_name_loop
                c_dos9  c_null
                pop     ebx
                pop     ecx
                ret
c_print_name    endp

; 函数名称: c_print
; 打印学生成绩表
; 入口参数: 无
; 出口参数: 无
c_print     proc    far
            c_dos9      c_print_promt   ;9号功能调用
            c_dos1     c_choose
            mov     bl, c_choose
c_print_loop1:
            cmp     bl, '1'
            jne     c_print_loop2
            mov     ebx, 2
            jmp     c_print_loop5
c_print_loop2:
            cmp     bl, '2'
            jne     c_print_loop3
            mov     ebx, 8
            jmp     c_print_loop5
c_print_loop3:
            cmp     bl, '3'
            jne     c_print_loop4
            mov     ebx, 10
            jmp     c_print_loop5
c_print_loop4:
            cmp     bl, '4'
            jne     c_print_loop5
            mov     ebx, 16
            jmp     c_print_loop5
c_print_loop5:
            mov     ecx, m_num      ;循环记数
            lea     edi, m_table        ;学生信息的偏移地址
c_print_loop6:
            lea     si, c_tmp_grade
            c_dos9  c_stu_name
            call    c_print_name
            mov     al, [edi + 13]
            movzx   eax, al          ;扩展为32位无符号二进制数
            call    c_radix
            c_dos9  c_stu_grade
            c_dos9  c_tmp_grade
            c_crlf
            add     edi, 14
            loop    c_print_loop6
            ret
c_print     endp

code    ends
        end
