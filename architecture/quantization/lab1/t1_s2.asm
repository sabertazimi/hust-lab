section .bss

section .data
    buff db 01H,02H,03H,04H

section .text

global _start

_start:
    mov ecx, 03FFFFFFFH; loop times = 2 ^ 30 - 1

l:
    mov al, [buff]
    mov ah, [buff + 1]
    mov bl, [buff + 2]
    mov bh, [buff + 3]

    add dl, al
    add dh, ah
    add dl, bl
    add dh, bh

LOOP l
    ; exit
    mov ebx, 0
    mov eax, 1
    int 0x80
