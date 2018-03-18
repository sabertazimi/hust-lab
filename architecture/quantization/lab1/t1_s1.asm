section .bss

section .data
    buff db 01H,02H,03H,04H

section .text

global _start

_start:
    mov ecx, 03FFFFFFFH; loop times = 2 ^ 30 - 1

l:
    mov al, [buff]
    add dl, al

    mov ah, [buff + 1]
    add dh, ah

    mov bl, [buff + 2]
    add dl, bl

    mov bh, [buff + 3]
    add dh, bh

LOOP l
    ; exit
    mov ebx, 0
    mov eax, 1
    int 0x80
