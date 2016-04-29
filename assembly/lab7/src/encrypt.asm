.386

stack segment use16 stack

STACK SEGMENT USE16 STACK
      DB 200 DUP(0)
STACK ENDS

DATA SEGMENT USE16
D1   DB 0DH,0AH,'STUDENT NAME:$'
D2   DB 0DH,0AH,'CHN SCORE:$'
D3   DB 0DH,0AH,'MATH SCORE:$'
D4   DB 0DH,0AH,'ENG SCORE:$'
RADX DB 10
;以下对成绩表信息进行了简单的加密
BUF  DB  'z' XOR  'B','h'XOR 'a','a'XOR 't', 7 DUP(0)     ;学生名字为“zha”，采用与密码串
;依次异或的方式加密
     DB    100 XOR 'B' ,85 XOR 'a', 80 XOR 't', ?         ;学生的成绩也依次与密码串异或。
     DB  'l' XOR  'B','i'XOR 'a','s'XOR 't','i' XOR 'B',6 DUP(0)
     DB    80 XOR 'B', 98 XOR 'a', 70 XOR 't',?
;以下对密码进行了简单的加密
PWD  DB  3 XOR 'C'       ;密码串的长度为3，采用与常数43H异或的方式编码成密文
     DB  ('B' -29H)*3    ;真实密码为Bat。采用函数(X-29H)*3对保存的密码进行编码。
     DB  ('a' -29H)*3
     DB  ('t' -29H)*3
     DB  0A1H,5FH,0D3H   ;用随机数填充密码区到6个字符，防止破解者猜到密码长度
;
IN_PWD  DB 7             ;使用者输入的密码区，最大长度6个字符
        DB ?
        DB 7 DUP(0)
STR1 DB 0DH,0AH,'PLEASE ENTER PASSWORD:$'
;
P1      DW  PASS1             ;地址表（用于间接转移反跟踪）
E1      DW  OVER
P2      DW  PASS2
OLDINT1 DW  0,0               ;1号中断的原中断矢量（用于中断矢量表反跟踪）
OLDINT3 DW  0,0               ;3号中断的原中断矢量
DATA ENDS
;
CODE SEGMENT USE16
     ASSUME CS:CODE,DS:DATA,SS:STACK
START: MOV AX,DATA
       MOV DS,AX
       xor  ax,ax                  ;接管调试用中断，中断矢量表反跟踪
       mov  es,ax
       mov  ax,es:[1*4]            ;保存原1号和3号中断矢量
       mov  OLDINT1,ax
       mov  ax,es:[1*4+2]
       mov  OLDINT1+2,ax
       mov  ax,es:[3*4]
       mov  OLDINT3,ax
       mov  ax,es:[3*4+2]
       mov  OLDINT3+2,ax
       cli                           ;设置新的中断矢量
       mov  ax,OFFSET NEWINT
       mov  es:[1*4],ax
       mov  es:[1*4+2],cs
       mov  es:[3*4],ax
       mov  es:[3*4+2],cs
       sti
       LEA DX,STR1
       MOV AH,9
       INT 21H
       LEA DX,IN_PWD               ;输入密码字符串
       MOV AH,10
       INT 21H
         cli                       ;计时反跟踪开始
         mov  ah,2ch
         int  21h
         push dx                   ;保存获取的秒和百分秒
       MOV CL,IN_PWD+1             ;比较输入的串长与密码长度是否一样
       XOR CL,'C'
       SUB CL,PWD
       MOVSX  BX,CL
       ADD  BX,OFFSET P1
         mov  ah,2ch                 ;获取第二次秒与百分秒
         int  21h
         sti
         cmp  dx,[esp]               ;计时是否相同
         pop  dx
         jz   OK1                    ;如果计时相同，通过本次计时反跟踪
         mov  bx,offset E1           ;如果计时不同，则把转移地址偏离P1
OK1:     mov  bx,[bx]
         cmp  word ptr cs:[bx],0B60FH   ;是否是PASS1处的指令，其实是用于判断前面比较的
;串长是否相同
         jz   OK2
         jmp   E1
OK2:     jmp   bx
         db  'How to go'            ;定义的冗余信息，扰乱视线

PASS1: MOVZX CX,IN_PWD+1
          cli                       ;堆栈检查反跟踪
          push  P2                  ;PASS2的地址压栈
       MOV  SI,0
       MOV  DL,3
          pop  ax
          mov  bx,[esp-2]           ;把栈顶上面的字（PASS2的地址）取到
          sti
          jmp  bx                   ;如果被跟踪，将不会转移到PASS2
          db  'i do not know！'
PASS2:  MOVZX  AX,IN_PWD+2[SI]    ;比较密码是否相同。把输入的串变成密文，与保存的密文比较
        SUB  AX,29H
        MUL  DL
        CMP  AL,PWD+1[SI]
        JNZ  ERR2
        INC  SI
        LOOP PASS2
        JMP  PASS3
ERR2:   mov  ebx,OFFSET P1          ;当密码不等时，通过地址表计算出OVER（退出）的位置
        mov  edx,1
        jmp  word ptr [ebx+edx*2]   ;指向OVER
        db  'YES,get it'
;
PASS3: mov  bx,es:[1*4]             ;检查中断矢量表是否被调试工具阻止修改或恢复
       inc  bx
       jmp  bx                 ;正常修改了的化，这里将转移到TESTINT，否则就不知道转到哪了
       db   'Now,you see.'
;
PASS4: LEA DX,D1              ;进入实际功能区。这里仅实现显示BUF区第2个学生的姓名和成绩
       MOV AH,9
       INT 21H
       MOV SI,0
NEXT:  MOV DL,BUF+14[SI]
       CMP DL,0
       JE  SCORE
       MOV AX,SI
       DIV IN_PWD+1             ;求密码长度的模数（因为名字长度可能超过密码长度，
;取模之后可以保证循环使用密码串）
       MOVZX DI,AH
       XOR DL,IN_PWD+2[DI]      ;注意，使用用户输入的明文密码串进行解密，不仅不用去解密
;程序中的密码，而且可以抵抗跟踪者跳过密码判断过程直接
;转移到实际功能区后获取密文信息的做法
       MOV AH,2
       INT 21H
       INC SI
       JMP NEXT
SCORE: LEA DX,D2                ;显示三科成绩
       MOV AH,9
       INT 21H
       MOV SI,0
       MOV AL,BUF+14+10[SI]
       XOR AL,IN_PWD+2[SI]
       MOV AH,0
       DIV RADX                  ;这里假设成绩最大为99，所以只除一次10
       ADD AX,3030H
       PUSH AX
       MOV DL,AL
       MOV AH,2
       INT 21H
       POP AX
       MOV DL,AH
       MOV AH,2
       INT 21H
       INC SI
;
       LEA DX,D3
       MOV AH,9
       INT 21H
       MOV AL,BUF+14+10[SI]
       XOR AL,IN_PWD+2[SI]
       MOV AH,0
       DIV RADX
       ADD AX,3030H
       PUSH AX
       MOV DL,AL
       MOV AH,2
       INT 21H
       POP AX
       MOV DL,AH
       MOV AH,2
       INT 21H
       INC SI
;
       LEA DX,D4
       MOV AH,9
       INT 21H
       MOV AL,BUF+14+10[SI]
       XOR AL,IN_PWD+2[SI]
       MOV AH,0
       DIV RADX
       ADD AX,3030H
       PUSH AX
       MOV DL,AL
       MOV AH,2
       INT 21H
       POP AX
       MOV DL,AH
       MOV AH,2
       INT 21H
       ;.........注意，本实验中是要实现查找学生姓名的，在查找学生姓名时，应将学生姓名串
; .........转换成密文后再去成绩表中搜索，也就是用密文比较。
       ;..........计算平均成绩时需要解密各科成绩，但不要把成绩表中的密文数据给覆盖掉了。
       JMP OVER
;
NEWINT: iret
TESTINT: jmp PASS4
;
OVER:
       cli                           ;还原中断矢量
       mov  ax,OLDINT1
       mov  es:[1*4],ax
       mov  ax,OLDINT1+2
       mov  es:[1*4+2],ax
       mov  ax,OLDINT3
       mov  es:[3*4],ax
       mov  ax,OLDINT3+2
       mov  es:[3*4+2],ax
       sti
       MOV AH,4CH
       INT 21H
CODE   ENDS
       END START
