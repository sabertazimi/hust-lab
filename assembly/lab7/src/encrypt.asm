.386

stack   segment use16 stack
    db  200 dup(0)
stack   ends

data    segment use16
    d1  db  0dh,0ah,'student name: $'
    d2  db  0dh,0ah,'chn score: $'
    d3  db  0dh,0ah,'math score: $'
    d4  db  0dh,0ah,'eng score: $'

    radx    db  10

    ; 加密成绩信息表
    buf     db  'z' xor 'b', 'h' xor 'a', 'a' xor 't', 7 dup(0)
            db  100 xor 'b', 85 xor 'a', 80 xor 't', ?
            db  'l' xor 'b', 'i' xor 'a', 's' xor 't', 'i' xor 'b', 6 dup(0)
            db  80 xor 'b', 98 xor 'a', 70 xor 't', ?

    ; 加密密码(暗文)
    pwd     db  3 xor 'c'           ; 密码串的长度为 ３
            db  ('b' - 29h) * 3     ; 真实密码为 bat
            db  ('a' - 29h) * 3
            db  ('t' - 29h) * 3
            db  0a1h, 5fh, 0d3h     ; 用随机数填充密码至６个字符,阻碍破解者推测密码长度

    in_pwd  db  7                   ; 使用者输入密码的缓冲区，最大长度为６个字符
            db  ?
            db  7   dup(0)

    prompt    db  0dh, 0ah, 'please enter password: $'

    ; 地址表(用于间接转移反跟踪)
    p1      dw  pass1
    e1      dw  over
    p2      dw  pass2

    ; 1/3号中断的原中断矢量(用于中断矢量表反跟踪)
    oldint1 dw  0, 0
    oldint3 dw  0, 0
data    ends

code    segment     use16
        assume      cs:code,ds:data,ss:stack

start:
        mov ax,data
        mov ds,ax
        lea dx,prompt
        mov ah,9
        int 21h
        lea dx,in_pwd               ;输入密码字符串
        mov ah,10
        int 21h

        cli                         ;计时反跟踪开始
        mov  ah,2ch
        int  21h
        push dx                     ;保存获取的秒和百分秒
        mov cl,in_pwd+1             ;比较输入的串长与密码长度是否一样
        xor cl,'c'
        sub cl,pwd
        movsx  bx,cl
        add  bx,offset p1
        mov  ah,2ch                 ;获取第二次秒与百分秒
        int  21h
        sti
        cmp  dx,[esp]               ;计时是否相同
        pop  dx
        jz   ok1                    ;如果计时相同，通过本次计时反跟踪
        mov  bx,offset e1           ;如果计时不同，则把转移地址偏离p1
        
ok1:
        mov  bx,[bx]
        cmp  word ptr cs:[bx],0b60fh   ;是否是pass1处的指令，其实是用于判断前面比较的
        ;串长是否相同
        jz   ok2
        jmp   e1
ok2:
        jmp   bx
        db  'uproar:how to go'            ;定义的冗余信息，扰乱视线
pass1:
        movzx cx,in_pwd+1
        cli                       ;堆栈检查反跟踪
        push  p2                  ;pass2的地址压栈
        mov  si,0
        mov  dl,3
        pop  ax
        mov  bx,[esp-2]           ;把栈顶上面的字（pass2的地址）取到
        sti
        jmp  bx                   ;如果被跟踪，将不会转移到pass2
        db  'i do not know！'
pass2:
        movzx  ax,in_pwd+2[si]    ;比较密码是否相同。把输入的串变成密文，与保存的密文比较
        sub  ax,29h
        mul  dl
        cmp  al,pwd+1[si]
        jnz  err2
        inc  si
        loop pass2
        jmp  pass3
err2:
        mov  ebx,offset p1          ;当密码不等时，通过地址表计算出over（退出）的位置
        mov  edx,1
        jmp  word ptr [ebx+edx*2]   ;指向over
        db  'yes,get it'

pass3:
        mov  bx,es:[1*4]             ;检查中断矢量表是否被调试工具阻止修改或恢复
        inc  bx
        jmp  bx                 ;正常修改了的化，这里将转移到testint，否则就不知道转到哪了
        db   'now,you see.'

pass4:
        lea dx,d1              ;进入实际功能区。这里仅实现显示buf区第2个学生的姓名和成绩
        mov ah,9
        int 21h
        mov si,0
next:
        mov dl,buf+14[si]
        cmp dl,0
        je  score
        mov ax,si
        div in_pwd+1             ;求密码长度的模数（因为名字长度可能超过密码长度，
        ; 取模之后可以保证循环使用密码串）
        movzx di,ah
        xor dl,in_pwd+2[di]      ;注意，使用用户输入的明文密码串进行解密，不仅不用去解密

        ; 程序中的密码，而且可以抵抗跟踪者跳过密码判断过程直接
        ; 转移到实际功能区后获取密文信息的做法
        mov ah,2
        int 21h
        inc si
        jmp next
score:
        lea dx,d2                ;显示三科成绩
        mov ah,9
        int 21h
        mov si,0
        mov al,buf+14+10[si]
        xor al,in_pwd+2[si]
        mov ah,0
        div radx                  ;这里假设成绩最大为99，所以只除一次10
        add ax,3030h
        push ax
        mov dl,al
        mov ah,2
        int 21h
        pop ax
        mov dl,ah
        mov ah,2
        int 21h
        inc si
        lea dx,d3
        mov ah,9
        int 21h
        mov al,buf+14+10[si]
        xor al,in_pwd+2[si]
        mov ah,0
        div radx
        add ax,3030h
        push ax
        mov dl,al
        mov ah,2
        int 21h
        pop ax
        mov dl,ah
        mov ah,2
        int 21h
        inc si
        lea dx,d4
        mov ah,9
        int 21h
        mov al,buf+14+10[si]
        xor al,in_pwd+2[si]
        mov ah,0
        div radx
        add ax,3030h
        push ax
        mov dl,al
        mov ah,2
        int 21h
        pop ax
        mov dl,ah
        mov ah,2
        int 21h

;.........注意，本实验中是要实现查找学生姓名的，在查找学生姓名时，应将学生姓名串
; .........转换成密文后再去成绩表中搜索，也就是用密文比较。
;..........计算平均成绩时需要解密各科成绩，但不要把成绩表中的密文数据给覆盖掉了。

        jmp over
newint:
        iret
testint:
        jmp pass4
over:
        cli                           ;还原中断矢量
        mov  ax,oldint1
        mov  es:[1*4],ax
        mov  ax,oldint1+2
        mov  es:[1*4+2],ax
        mov  ax,oldint3
        mov  es:[3*4],ax
        mov  ax,oldint3+2
        mov  es:[3*4+2],ax
        sti
        mov ah,4ch
        int 21h

code   ends
       end start
