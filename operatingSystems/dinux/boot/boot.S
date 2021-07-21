;   boot.S -- 内核从这里开始

; Multiboot 魔数，由规范决定的
MBOOT_HEADER_MAGIC  equ     0x1BADB002

; 0 号位表示所有的引导模块将按页(4KB)边界对齐
MBOOT_PAGE_ALIGN    equ     1 << 0

; 1 号位通过 Multiboot 信息结构的 mem_* 域包括可用内存的信息
; (告诉GRUB把内存空间的信息包含在Multiboot信息结构中)
MBOOT_MEM_INFO      equ     1 << 1    

; 定义我们使用的 Multiboot 的标记
MBOOT_HEADER_FLAGS  equ     MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO

; 域checksum是一个32位的无符号值，当与其他的magic域(也就是magic和flags)
; 相加时，要求其结果必须是32位的无符号值 0 (即 magic+flags+checksum = 0)
MBOOT_CHECKSUM      equ     -(MBOOT_HEADER_MAGIC+MBOOT_HEADER_FLAGS)

; Multiboot 头的分布必须如下表所示：
; 偏移量  类型  域名        备注
;
;   0     u32   magic       必需
;   4     u32   flags       必需 
;   8     u32   checksum    必需 
;

[bits 32]   ; 所有代码以 32-bit 的方式编译
section .init.text

; 在代码段的起始位置设置符合 Multiboot 规范的标记

dd MBOOT_HEADER_MAGIC   ; GRUB 会通过这个魔数判断该映像是否支持
dd MBOOT_HEADER_FLAGS   ; GRUB 的一些加载时选项，其详细注释在定义处
dd MBOOT_CHECKSUM       ; 检测数值，其含义在定义处

[global start]
[global mboot_ptr_tmp]  ; struct multiboot * 临时变量
[extern kern_entry]     ; C 函数: int kern_entry(void)

start:
    cli
    mov [mboot_ptr_tmp], ebx
    mov esp, STACK_TOP
    mov ebp, 0
    and esp, 0fffffff0h  ; 栈地址 16 bytes 对齐
    call kern_entry
stop:
    hlt
    jmp stop

section .init.data
stack:
    times 1024 db 0     ; kernal stck
STACK_TOP equ $-stack-1

mboot_ptr_tmp: dd 0
