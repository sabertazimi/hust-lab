-   0158 call 02c2: main
-   0322 call 125d: print addr
-   033d call 0392: Average()
-   0344 call 03e5: Search(name)

```asm
0392:
push bp
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
