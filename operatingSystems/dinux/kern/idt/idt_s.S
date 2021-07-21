[global idt_flush]
idt_flush:
    mov     eax, [esp + 4]
    lidt    [eax]
    ret
.end:

%macro ISR_NOERRCODE 1
[global isr%1]
isr%1:
    cli
    push byte 0        ; invalid err code, simplify handler logic
    push byte %1        ; int_no
    jmp isr_common_stub
%endmacro

%macro ISR_ERRCODE 1
[global isr%1]
isr%1:
    cli
    push byte %1        ; int_no
    jmp isr_common_stub
%endmacro

%macro IRQ 2
[global irq%1]
irq%1:
    cli
    push byte 0
    push byte %2
    jmp irq_common_stub
%endmacro

; interrupt service routine
ISR_NOERRCODE   0
ISR_NOERRCODE   1
ISR_NOERRCODE   2
ISR_NOERRCODE   3
ISR_NOERRCODE   4
ISR_NOERRCODE   5
ISR_NOERRCODE   6
ISR_NOERRCODE   7
ISR_ERRCODE     8
ISR_NOERRCODE   9
ISR_ERRCODE     10
ISR_ERRCODE     11
ISR_ERRCODE     12
ISR_ERRCODE     13
ISR_ERRCODE     14
ISR_NOERRCODE   15
ISR_NOERRCODE   16
ISR_ERRCODE     17
ISR_NOERRCODE   18
ISR_NOERRCODE   19

ISR_NOERRCODE   20
ISR_NOERRCODE   21
ISR_NOERRCODE   22
ISR_NOERRCODE   23
ISR_NOERRCODE   24
ISR_NOERRCODE   25
ISR_NOERRCODE   26
ISR_NOERRCODE   27
ISR_NOERRCODE   28
ISR_NOERRCODE   29
ISR_NOERRCODE   30
ISR_NOERRCODE   31

ISR_NOERRCODE   255

IRQ     0,  32
IRQ     1,  33
IRQ     2,  34
IRQ     3,  35
IRQ     4,  36
IRQ     5,  37
IRQ     6,  38
IRQ     7,  39
IRQ     8,  40
IRQ     9,  41
IRQ     10, 42
IRQ     11, 43
IRQ     12, 44
IRQ     13, 45
IRQ     14, 46
IRQ     15, 47

[global isr_common_stub]
[extern isr_handler]
isr_common_stub:
    pusha           ; push edi, esi, ebp, esp, ebx, edx, ecx, eax
    push ds
    push es
    push fs
    push gs
    push ss

    mov ax, 0x10    ; load kernel data segment descriptor
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov eax, esp
    push eax        ; push (pt_regs *)
    mov eax, isr_handler
    call eax
    pop eax         ; clear pushed argument(pt_regs *)

    pop ss
    pop gs
    pop fs
    pop es
    pop ds
    popa            ; pop edi, esi, ebp, esp, ebx, edx, ecx, eax

    add esp, 8
    iret
.end:

[global irq_common_stub]
[extern irq_handler]
irq_common_stub:
    pusha

    push ds
    push es
    push fs
    push gs
    push ss

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov eax, esp
    push eax
    mov eax, irq_handler
    call eax
    pop eax

    pop ss
    pop gs
    pop fs
    pop es
    pop ds

    popa
    add esp, 8
    iret
.end:
