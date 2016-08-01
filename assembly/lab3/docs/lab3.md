
* [Lab 3 Notes](#lab-3-notes)
	* [Task 2](#task-2)
		* [Grade 运行效率](#grade-运行效率)
			* [调优方法](#调优方法)
			* [调优结果](#调优结果)
	* [Task 3](#task-3)
		* [ex3D.exe 反汇编分析](#ex3dexe-反汇编分析)
			* [各主要函数调用入口](#各主要函数调用入口)
			* [Average()](#average)
			* [Search(name)](#searchname)
		* [ex3F.exe 反汇编分析](#ex3fexe-反汇编分析)
			* [各主要函数入口](#各主要函数入口)
			* [Average()](#average-1)
			* [Search(name)](#searchname-1)

# Lab 3 Notes

## Task 2

### Grade 运行效率

-   2690
-   2740
-   2750
-   2750
-   2740

#### 调优方法

-   将内存单元数据取至寄存器进行运算 `CMP BYTE PTR DS:[BP + SI], 24H` -> `CMP DH, 24H`

-   改变计算平均成绩指令,将长时间周期指令改写为短时间周期指令
    -   imul -> sal/add
    -   idiv -> sar/imul

#### 调优结果

-   1040
-   1040
-   990
-   980
-   1040

## Task 3

### ex3D.exe 反汇编分析

#### 各主要函数调用入口

-   0158 call 02c2 ; main()
-   0322 call 12a7 ; printf(addr)
-   033d call 0393 ; Average()
-   0344 call 040f ; Search(name)

#### Average()

-   `ds:[0a6h] - wangwu`

```asm
0393:push bp
mov bp,sp
sub sp,0008
push si
xor si, si
jmp 0400
039e mov ax,si   ; ax = index
mov dx,000e
imul dx
mov bx,ax        ; bx = index * 14
mov al,[bx+0398] ; chinese MEM[buf + index * 14 + 10]
mov ah,00
mov [bp-02],ax   ; store into stack segment
mov ax,si        ; ax = index
mov dx,000e
imul dx
mov bx,ax        ; bx = index * 14
mov al,[bx+0399] ; math  MEM[buf + index * 14 + 11]
mov ah,00
mov [bp-04],ax   ; store into stack segment
mov ax,si        ; ax = index
mov dx,000e
imul dx
mov bx,ax        ; bx = index * 14
mov al,[bx+039a] ; english  MEM[buf + index * 14 + 12]
mov ah,00
mov [bp-06],ax   ; store into stack segment
mov ax,[bp-02]   ; ax = chinese
mov cl,02
shl ax,cl        ; ax = chinese * 4
mov dx,[bp-04]   ; dx = math
shl dx,1         ; dx = math * 2
add ax,dx        ; ax = chinese * 4 + math * 2
add ax,[bp-06]   ; ax = chinese * 4 + math * 2 + english
; / 3.5 -> *2 / 7  above: *2
mov bx,0007
xor dx,dx
div bx           ; ax = (chinese * 4 + math * 2 + english) / 7
mov [bp-08],ax   ; average = ax
mov ax,si        ; ax = index
mov dx,000e
imul dx          ; ax = index * 14
mov dl,[bp-08]   ; dl = average
mov bx,ax        ; bx = index * 14
mov [bx+039B],dl ; average = average
inc si           ; si++
cmp	 si,03e8
jl 039e          ; if si < 1000, jmp
xor ax,ax
jmp 040a
040a pop si
mov sp,bp
pop bp
ret
```

#### Search(name)

-   `ds:[ffc6] wangwu // user input`
-   `ds:[038e] zhangsan00 100 85 80`

```asm
040f:
push bp
mov bp,sp
sub sp,0004
push si
push di
mov si,[bp+04]
mov word ptr [bp-04], 0000
xor di,di
jmp 0470     ; start loop
0423: mov ax,di ; ax = outerindex
mov dx,000e
imul dx
add ax,038e     ; ax = buf + outerindex * 14
mov [bp-02], ax ; store it into stack segment
xor cx,cx
jmp 0435        ; inner loop
0434: inc cx    ; inner loop control expression cx++
0435: mov bx,[bp-02] ; load buf + outerindex * 14 into bx
add bx,cx       ; bx = buf + outerindex * 14 + innerindex, ea of next char to compare
mov al,[bx]     ; ax = target char
mov bx,cx       ; bx = innerindex
cmp al,[bx+si]  ; userinput[innerindex] == buf[outerindex][innerindex]
jne 044e        ; not match
cmp cx,000a     ; match
jl 0434         ; if innerindex < 10 , continue compare left char of two strings
044e: mov bx,[bp-02] ; bx = buf + outerindex * 14
add bx,cx      ;  bx = buf + outerindex * 14 + innerindex
mov al,[bx]    ; al = target char
mov bx,cx      ; bx = innerindex
cmp al,[bx+si] ; userinput[innerindex] == buf[outerindex][innerindex]
jne 046f       ; not match
mov ax,[bp-02] ; if match and name[i] == 0
mov [038c], ax ;  poin = buf + outerindex * 14
mov word ptr [bp-04],0001 ; result = 1
jmp 0476
046f: inc di   ; outer loop control expression outerindex ++
0470: cmp di,03e8
jl 0423        ; if index < 1000 , continue to search
0476: mov ax,[bp-04]  ; resume the scene
jmp 047b
047b: pop di
pop si
mov sp,bp
pop bp
ret
```

### ex3F.exe 反汇编分析

#### 各主要函数入口

-   0158 call 02c2: main()
-   0322 call 125d: print(addr)
-   033d call 0392: Average()
-   0344 call 03e5: Search(name)

#### Average()

```asm
0392:push bp
mov bp,sp
sub sp,0002
push si
push di
xor di,di  ; di =0
xor si,si	;si=0
039e: mov al,[si+0398] ; chinese
mov ah,00
mov dx,ax        ; dx =chinese
mov al,[si+0399] ; math
mov ah,00
mov [bp-02],ax    ; store math into stack segment because of it's easy to calculate
mov al,[si+039a]  ; english
mov ah,00
mov bx,ax      ; bx = english
mov ax,dx      ; ax = chinese
mov cl,02
shl ax,cl      ; ax = chinese * 4
mov dx,[bp-02] ; dx =math
shl dx,1       ; dx = math *2
add ax,dx     ; ax = chinese * 4 + math * 2
add ax,bx     ; ax = chinese*4+math*2+english
mov bx,0007
xor dx,dx
div bx        ; ax = ax / 7
mov dx,ax     ; dx = (chinese*4+math*2+english)/7
mov [si+039b],dl; average=dx
add si,000e   ; si+=14 index++
inc di        ; di++ count++
cmp si 36b0
jne 039e      ; not cal 1000, continue loop
xor ax,ax
pop di
pop si
mov sp,bp
pop bp
ret
```

#### Search(name)

```asm
03e5:
push bp
mov bp,sp
sub sp,0006
push si
push di
mov word ptr [bp-06],0000
mov word ptr [bp-02],0000
mov cx,038e   ; buf
03fa: mov [bp-04], cx ; store 038e into stack segment
xor dx,dx
mov di,cx   ; di = 038e &buf[0]
mov si,[bp+04]
jmp 0409
0406: inc di
inc si
inc dx
0409: mov al,[di]
cmp al,[si] ; userinput[i] == buf[i][j]
jne 0419
cmp byte ptr [si],00
je 0419
cmp dx,000a
jl 0406
0419: mov bx,[bp-04] buf
add bx,dx
mov si,bx
cmp al,[bx] ;userinput[i] == buf[i][j]
jne 043d
cmp byte ptr [si],00
jne 043d
mov ax,[bp-04]
mov [038c],ax   ;poin = buf
mov word ptr [bp-06],0001 ;result = 1
jmp 044a
043d: add cx,000e ; find next student
inc word ptr [bp-02]   ; outerindex ++
cmp word ptr [bp-02], 03e8 ; <1000
jl 03fa
044a: mov ax,[bp-06] ; return result
pop di
pop si
mov sp,bp
pop bp
ret
```
