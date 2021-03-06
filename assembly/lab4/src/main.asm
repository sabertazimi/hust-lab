; team: 刘一龙,  曾圳
; author: 刘一龙

        name    main
        extern  c_sort: far, c_print: far, c_radix: near
        public  m_num, m_table

.386

stack   segment use16   para    stack   'stack'
        db  200 dup(0)
stack   ends

data  segment use16   para    public  'data'
        m_num       dd  3
        m_max_num   equ 1000
        m_table     db  'saber',  5 dup(0), 99, 99, 99, ?
                    db  'lancer', 4 dup(0), 88, 88, 88, ?
                    db  'archer', 4 dup(0), 77, 77, 77, ?
                    db  m_max_num-3 dup(10  dup(0), 60, 60, 60, ?)
        m_menu      db  "Please enter function selection:", 0ah, 0dh
                    db  "1: Input student name and grade", 0ah, 0dh
                    db  "2: Calculate sum and average grade", 0ah, 0dh
                    db  "3: Sort", 0ah, 0dh
                    db  "4: Show grade table", 0ah, 0dh
                    db  "5: Quit$", 0ah, 0dh
        m_input_prompt  db  "Please input student name: $", 0ah, 0dh
        m_input_grade   db  "Please input grade: $", 0ah, 0dh
        m_input_name    db  11
                        db  ?
                        db  11  dup(0)
        m_input_score   db  4
                        db  ?
                        db  4   dup(0)
data ends

code    segment use16   para    public  'code'
        assume  cs:code, ds:data, ss:stack

;　换行操作
m_crlf  macro
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
m_dos9  macro   str
        push    eax
        push    edx                     ;以上为保护现场
        lea     dx, str
        mov     ah, 9
        int     21h
        pop     edx                     ;以下为恢复现场
        pop     eax
        endm
; 10号功能调用
m_dos10 macro   adr
        push    eax
        push    edx
        lea     dx, adr
        mov     ah, 10
        int     21h
        pop     edx
        pop     eax
        endm

; 函数名称: m_trans
; 将数字串转化为标准数字
; 入口参数: 无, 直接从 m_ipnut_score 取数字串
; 出口参数: eax, 存放转化厚的标准数字
; eax - 存放转化结果
; ebx - 存放数字串偏移地址
; ecx - 循环计数器
; edx - 保存每一位数字
m_trans proc    far
        push    ebx
        push    ecx
        push    edx
        lea     ebx, m_input_score + 1      ; (ebx) = & string.length
        xor     eax, eax                    ; 转化结果初始化为0
        xor     ecx, ecx                    ; 计数器初始化为0
m_trans_loop:
        xor     edx, edx
        mov     dl, [ebx + ecx + 1]         ; 从高位开始取出数字串的每一个数字字符
        sub     edx, 30h                    ; 将取出字符转化为标准数字
        imul    eax, 0ah                    ; 上一次和 * 基数
        add     eax, edx                    ; 进位
        inc     ecx
        cmp     cl, [ebx]
        jne     m_trans_loop                ; i < string.length
        pop     edx
        pop     ecx
        pop     ebx
        ret
m_trans endp

; 函数名称: m_input
; 添加学生信息
; 入口参数: 无, 学生信息直接由键盘录入，存至 m_input_name 与 m_input_score
; 出口参数: 无, 处理过的学生信息直接添加至 m_table 尾部
; esi: 姓名输入处地址
; edi: 暂存学生成绩信息尾地址
; ecx: 计数器
; eax: 系统调用
; ebx: 调用c_radix函数的参数
; edx: 系统调用
m_input proc    far
        push    esi
        push    edi
        push    eax
        push    ebx
        push    ecx
        push    edx                         ; 以上为保护现场
        mov     edx, m_num
        imul    edx, 14
        lea     edi, m_table[edx]           ; 将学生成绩表尾的偏移地址存至 edi
        m_dos9 m_input_prompt        ; 输出提示语
        mov     eax, m_num
        inc        eax                                  ; 显示当前输入学生序号
        lea       si, m_input_name+2
        mov     ebx, 0ah
        call    c_radix                             ; 将学生个数转化为字符串
        m_dos9 m_input_name+2
        m_crlf
        m_dos10 m_input_name         ; 输入学生姓名
        m_crlf
        lea     esi, m_input_name + 1       ; (esi) = & string.length
        xor     ecx, ecx                    ; 计数器初始化为０
m_input_name_loop:
        mov     dl, [esi + ecx + 1]
        mov     [edi + ecx], dl             ; 将输入的学生姓名拷贝至表尾
        inc     ecx
        cmp     cl, [esi]
        jne     m_input_name_loop           ; i < string.length
        xor     ecx, ecx                    ; 计数器初始化为0,开始录入学生成绩
m_input_grade_loop:
        m_dos9   m_input_grade           ; 输出提示语
        m_dos10 m_input_score         ; 输入学生成绩
        m_crlf
        call    far ptr m_trans
        mov     [edi + ecx + 10], al        ; 将转化后的成绩存入表中
        inc     ecx
        cmp     ecx, 3h
        jne     m_input_grade_loop          ; 未录入３门成绩,继续录入
        inc     m_num                       ; 学生总数 + 1
        pop     edx                         ; 以下为恢复现场
        pop     ecx
        pop     ebx
        pop     eax
        pop     edi
        pop     esi
        ret
m_input endp

; 函数名称: m_cal
; 计算学生平均成绩
; 入口参数: 无, 直接从 m_table 读取信息
; 出口参数: 无
; eax: 计算平均成绩，取出相应成绩
; ebx: 存放成绩表首地址
; ecx: 计数器
; edx: 计算平均成绩，取出相应成绩
; esi: 存放总成绩
m_cal   proc    far
        push    eax
        push    ebx
        push    ecx
        push    edx
        push    esi                     ; 以上为保护现场
        xor     ecx, ecx                ; 计数器初始化置0
        lea     ebx, m_table            ; 取成绩表首地址
        add     ebx, 10                 ; 移动至语文成绩处
m_cal_loop:
        cmp     ecx, m_num
        jge     m_cal_finish            ; 已计算完所有学生的平均成绩，结束循环
        xor     eax, eax
        xor     edx, edx
        mov     al,  [ebx]              ; chinese
        mov     dl,  [ebx + 1]          ; math
        lea     eax, [edx + eax * 2]    ; (eax) = chinese * 2 + math
        xor     edx, edx
        mov     dl,  [ebx + 2]          ; english
        lea     esi, [edx + eax *2]     ; (esi) = (chinese * 2 + math) * 2 + english
        mov     eax, 92492493h          ; 计算 (esi) / 7 并将商保存到 edx
        imul    esi
        add     edx, esi
        sar     edx, 2
        mov     eax, edx
        shr     eax, 1fh
        add     edx, eax
        mov     [ebx + 3], dl           ; avg = sum / 3.5
        add     ebx, 14                 ; 移动至下一个学生语文成绩处
        inc     ecx                     ; 计数器自增
        jmp     m_cal_loop
m_cal_finish:
        pop     esi                     ; 以下为恢复现场
        pop     edx
        pop     ecx
        pop     ebx
        pop     eax
        ret
m_cal   endp

; 函数名称: m_finish
; 结束应用程序
; 入口参数: 无
; 出口参数: 无
m_finish    proc    far
            mov     ah, 4ch
            int     21h
m_finish    endp

; dx, ah: 系统调用
m_start:
        mov     ax, data
        mov     ds, ax
m_showmenu:     ; 输出菜单
        m_crlf
        m_dos9 m_menu
        m_crlf
m_select:
        mov     ah, 1h                  ; 用户输入所需功能
        int     21h
        m_crlf
        cmp     al, 31h
        jne     m_sel_l1
        call    far ptr m_input
        jmp     m_showmenu
m_sel_l1:
        cmp     al, 32h
        jne     m_sel_l2
        call    far ptr m_cal
        jmp     m_showmenu
m_sel_l2:
        cmp     al, 33h
        jne     m_sel_l3
        call    far ptr c_sort
        jmp     m_showmenu
m_sel_l3:
        cmp     al, 34h
        jne     m_sel_l4
        call    far ptr c_print
        jmp     m_showmenu
m_sel_l4:
        cmp     al, 35h
        jne     m_sel_l5
        call    far ptr m_finish
m_sel_l5:
        jmp     m_showmenu

code    ends
        end     m_start
