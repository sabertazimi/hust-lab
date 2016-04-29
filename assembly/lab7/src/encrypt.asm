.386

stack   segment use16 stack
    db  200 dup(0)
stack   ends

data    segment use16

num     dd  3
radx    dd  10
base    db  10

d1      db  0dh,0ah,'student name: $'
d2      db  0dh,0ah,'grade: $'
prompt  db  0dh, 0ah, 'please enter password: $'
msg     db  0dh, 0ah, 'please input target name : $'

; 加密成绩信息表
buf     db  'l' xor 's', 'i' xor 's', 'u' xor 's', 'y' xor 's', 'l' xor 's', 5 dup(0)
        db  90  xor 'b', 90 xor 'a' ,90 xor 't', ?
        db  'z' xor 's', 'h' xor 's', 'a' xor 's', 7 dup(0)
        db  95 xor 'b', 95 xor 'a', 95 xor 't', ?
        db  'l' xor 's', 'i' xor 's', 's' xor 's', 'i' xor 's', 6 dup(0)
        db  80 xor 'b', 80 xor 'a', 80 xor 't', ?

; 加密密码(暗文)
pwd     db  3 xor 'c'           ; 密码串的长度为 ３
        db  ('b' - 29h) * 3     ; 真实密码为 bat
        db  ('a' - 29h) * 3
        db  ('t' - 29h) * 3
        db  0a1h, 5fh, 0d3h     ; 用随机数填充密码至６个字符,阻碍破解者推测密码长度

in_pwd  db  7                   ; 使用者输入密码的缓冲区，最大长度为６个字符
        db  ?
        db  7   dup(0)

input   db  11
        db  ?
        db  11 dup(0)

; 地址表(用于间接转移反跟踪)
p1      dw  pass1
e1      dw  over
p2      dw  pass2
p3      dw  pass3
data    ends

code    segment     use16
        assume      cs:code,ds:data,ss:stack

start:
        mov     ax,data
        mov     ds,ax
        lea     dx,prompt
        mov     ah,9
        int     21h
        lea     dx,in_pwd               ; 输入密码字符串
        mov     ah,10
        int     21h

        cli                         ; 计时反跟踪开始
        mov     ah,2ch
        int     21h
        push    dx                     ; 保存获取的秒和百分秒

        mov     cl,in_pwd + 1           ; 比较输入的串长与密码长度是否一样
        xor     cl,'c'
        sub     cl,pwd
        movsx   bx,cl                ; bx 存放比较结果,若长度不等则不为0
        add     bx,offset p1           ; 若长度不等, 则程序将不会跳转至 pass1 处

        mov     ah,2ch                 ; 获取第二次秒与百分秒
        int     21h
        sti

        cmp     dx,[esp]               ; 计时是否相同
        pop     dx

        jz      ok1                    ; 如果计时相同，通过本次计时反跟踪
        mov     bx,offset e1           ; 如果计时不同，则使得转移地址偏离 pass1,直接结束程序,阻碍程序正常运行
ok1:
        mov     bx,[bx]
        cmp     word ptr cs:[bx], 0b60fh; 是否是 pass1 处的指令 - movzx cx, in_pwd+1，其实是用于判断前面比较的串长是否相同
        jz      ok2
        jmp     e1
ok2:
        jmp     bx
        db  '@info: cs1049 u201414800'
pass1:
        movzx   cx,in_pwd+1
        cli                         ; 堆栈检查反跟踪
        push    p2                    ; pass2 的地址压栈
        mov     si,0
        mov     dl,3
        pop     ax
        mov     bx,[esp-2]             ; 把栈顶上面的字(pass2 的地址)取到
        sti

        jmp     bx                     ; 如果被跟踪，[esp-2]处的值很大可能被修改,则程序将不会转移到 pass2
        db  '@author: yilong liu'
pass2:
        movzx ax,in_pwd+2[si]      ; 比较密码是否相同。把输入的串变成密文，与保存的密文比较
        sub   ax,29h
        mul   dl
        cmp   al,pwd+1[si]
        jnz   err2
        inc   si
        dec   cx
        cmp   cx, 0
        jne   pass2
        jmp   pass3
err2:
        mov   ebx,offset p1          ; 当密码不等时，通过地址表计算出 over(退出)的位置
        mov   edx,1
        jmp   word ptr [ebx+edx*2]   ; 指向over
        db  '@date: 2015.05.01'
pass3:  ;　正常功能区
        lea   dx, msg                ; 输出提示信息 - 请输入姓名
        mov   ah, 9h
        int   21h
        lea   dx, input              ; 读入学生姓名, 以 '$' 符号结尾
        mov   ah, 0ah
        int   21h

        lea   esi, input+2
        lea   edi, buf
		xor	  ebx, ebx
		xor	  ecx, ecx
search_loop:
		cmp	  ecx, num
		jge	  search_finish
		xor	  eax, eax
search_inner:
		cmp	  eax, radx
		jge	  search_finish
		mov   dl, [esi + eax]
        xor   dl, 's'
        cmp   [edi + ebx], dl
		jnz   search_next
		cmp   byte ptr [edi + ebx + 1], 0
		jz    search_finish
		inc   eax
		inc   ebx
		jmp   search_inner
        db   '@website: https://github.com/sabertazimi'
search_next:
		inc   ecx
		imul  ebx, ecx, 14
		jmp   search_loop
        db  '@license: hpl'
search_finish:
		xor		ebx, ebx
output:
        sub     ebx,ecx
        imul    bx,14               ; 根据目标学生下标值, 找到分数缓冲区首地址
        mov     si,0
        mov     ax, 0
        mov     dx, 0
        mov     al,buf+10[bx+si]
        xor     al,in_pwd+2[si]
        add     ax, ax
        inc     si
        mov     dl, buf+10[bx+si]
        xor     dl,in_pwd+2[si]
        add     ax, dx              ; al = zh * 2 + ma
        inc     si
        mov     dl, buf+10[bx+si]
        xor     dl,in_pwd+2[si]
        sar     dl, 1
        add     ax, dx              ; al = zh * 2 + ma + en / 2
        sal     ax, 1               ; al = 2 * al
        mov     dx, 7
        idiv    dl                  ; al = al / 7
        inc     si
        mov     buf+10[bx+si], al   ; avg = al ( al / 3.5)
        push    ax
        mov     dl, 0ah
        mov     ah, 2h
        int     21h
        mov     dl, 0dh
        mov     ah, 2h
        int     21h
        pop     ax
        cmp     al, 90      ; switch 语句
        jge     gradea
        cmp     al, 80
        jge     gradeb
        cmp     al, 70
        jge     gradec
        cmp     al, 60
        jge     graded
        jmp     gradee
        db  '@weather: sunny'
gradea: mov     dl, 41h
        mov     ah, 2h
        int     21h
        jmp     pass3
gradeb: mov     dl, 42h
        mov     ah, 2h
        int     21h
        jmp     pass3
gradec: mov     dl, 43h
        mov     ah, 2h
        int     21h
        jmp     pass3
graded: mov     dl, 44h
        mov     ah, 2h
        int     21h
        jmp     pass3
gradee: mov     dl, 45h
        mov     ah, 2h
        int     21h
        jmp     pass3

over:
        mov     ah,4ch
        int     21h

code   ends
       end start
