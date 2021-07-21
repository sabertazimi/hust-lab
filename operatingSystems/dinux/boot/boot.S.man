[global start]
[extern kern_entry]

start:
    mov     ax, cs
    mov     ds, ax
    mov     es, ax
    call    kern_entry
    jmp     $       ; infinite loop

times   510-($-$$)  db  0   ; $ - current address $$ - current section address
dw      0xaa55      ; MBR(master boot record) flag
