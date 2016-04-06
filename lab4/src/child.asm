        name    child
        extern  m_num: double word, m_table: word
        public  m_num, m_table

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

; 函数名称: c_finish
; 结束应用程序
; 入口参数: 无
; 出口参数: 无
c_finish    proc    far
            mov     ah, 4ch
            int     21h
c_finish    endp

; 函数名称: c_exchange
; 交换学生成绩表中两个学生的位置
; 入口参数: esi, edi 分别为两个学生信息的偏移地址
; 出口参数: 无
c_exchange  proc    far
            push    ecx
            push    edx
            xor     ecx, ecx        ; 计数器初始化为0
            mov     dl, [esi + ecx]
            xchg    dl, [edi + ecx]
            mov     [esi + ecx], dl ; 逐字符交换两个学生的信息
            inc     ecx
            cmp     ecx, 0eh
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
            pop     edi
            pop     esi
            pop     edx
            pop     ecx
            pop     ebx
            pop     eax
            ret
c_sort      endp

; 函数名称: c_print
; 打印学生成绩表
; 入口参数: 无
; 出口参数: 无
c_print     proc    far
c_print     endp

c_start:
c_showmenu:     ; 输出菜单
        m_crlf
        lea     dx, m_menu
        mov     ah, 9h
        int     21h
        m_crlf
c_select:
        mov     ah, 1h                  ; 用户输入所需功能
        int     21h
        c_crlf
        cmp     al, 31h
        jne     c_sel_l1
        call    c_input
        jmp     c_showmenu
c_sel_l1:
        cmp     al, 32h
        jne     c_sel_l2
        call    c_cal
        jmp     c_showmenu
c_sel_l2:
        cmp     al, 33h
        jne     c_sel_l3
        call    c_finish
        jmp     c_showmenu
c_sel_l3:
        cmp     al, 34h
        jne     c_sel_l4
        call    c_finish
        jmp     c_showmenu
c_sel_l4:
        cmp     al, 35h
        jne     c_sel_l5
        call    c_finish
c_sel_l5:
        jmp     c_showmenu

code    ends
        end
