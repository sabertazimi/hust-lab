
* [Lab 1 Notes](#lab-1-notes)
	* [Ex 1 - Make workflow](#ex-1---make-workflow)
	* [Ex 2 - Debug with gdb](#ex-2---debug-with-gdb)
	* [Ex3 - enable protected mode(bootloader)](#ex3---enable-protected-modebootloader)
		* [A20](#a20)
		* [GDT(简化)](#gdt简化)
		* [CR0](#cr0)
		* [开启保护模式](#开启保护模式)
	* [Ex4 - load elf kernel(bootloader)](#ex4---load-elf-kernelbootloader)
	* [Contact](#contact)

# Lab 1 Notes

## Ex 1 - Make workflow

+ cc kern/init/init.c

gcc -Ikern/init/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/init/init.c -o obj/kern/init/init.o

+ cc kern/libs/stdio.c

gcc -Ikern/libs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/stdio.c -o obj/kern/libs/stdio.o

+ cc kern/libs/readline.c

gcc -Ikern/libs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/readline.c -o obj/kern/libs/readline.o

+ cc kern/debug/panic.c

gcc -Ikern/debug/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/debug/panic.c -o obj/kern/debug/panic.o

+ cc kern/debug/kdebug.c

gcc -Ikern/debug/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/debug/kdebug.c -o obj/kern/debug/kdebug.o

+ cc kern/debug/kmonitor.c

gcc -Ikern/debug/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/debug/kmonitor.c -o obj/kern/debug/kmonitor.o

+ cc kern/driver/clock.c

gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/clock.c -o obj/kern/driver/clock.o

+ cc kern/driver/console.c

gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/console.c -o obj/kern/driver/console.o

+ cc kern/driver/picirq.c

gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/picirq.c -o obj/kern/driver/picirq.o

+ cc kern/driver/intr.c

gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/intr.c -o obj/kern/driver/intr.o

+ cc kern/trap/trap.c

gcc -Ikern/trap/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/trap/trap.c -o obj/kern/trap/trap.o

+ cc kern/trap/vectors.S

gcc -Ikern/trap/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/trap/vectors.S -o obj/kern/trap/vectors.o

+ cc kern/trap/trapentry.S

gcc -Ikern/trap/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/trap/trapentry.S -o obj/kern/trap/trapentry.o

+ cc kern/mm/pmm.c

gcc -Ikern/mm/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/mm/pmm.c -o obj/kern/mm/pmm.o

+ cc libs/string.c

gcc -Ilibs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/  -c libs/string.c -o obj/libs/string.o

+ cc libs/printfmt.c

gcc -Ilibs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/  -c libs/printfmt.c -o obj/libs/printfmt.o

+ ld bin/kernel

ld -m    elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel  obj/kern/init/init.o obj/kern/libs/stdio.o obj/kern/libs/readline.o obj/kern/debug/panic.o obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o obj/kern/driver/clock.o obj/kern/driver/console.o obj/kern/driver/picirq.o obj/kern/driver/intr.o obj/kern/trap/trap.o obj/kern/trap/vectors.o obj/kern/trap/trapentry.o obj/kern/mm/pmm.o  obj/libs/string.o obj/libs/printfmt.o

+ cc boot/bootasm.S

gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootasm.S -o obj/boot/bootasm.o

+ cc boot/bootmain.c

gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootmain.c -o obj/boot/bootmain.o

+ cc tools/sign.c

gcc -Itools/ -g -Wall -O2 -c tools/sign.c -o obj/sign/tools/sign.o

gcc -g -Wall -O2 obj/sign/tools/sign.o -o bin/sign

+ ld bin/bootblock

ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o

-   'obj/bootblock.out' size: 488 bytes
-   build 512 bytes boot sector: 'bin/bootblock' success!

dd if=/dev/zero of=bin/ucore.img count=10000

dd if=bin/bootblock of=bin/ucore.img conv=notrunc

dd if=bin/kernel of=bin/ucore.img seek=1 conv=notrunc

## Ex 2 - Debug with gdb

-   tools/gdbinit

```sh
$ vim tools/gdbinit
```

```gdb
file bin/kernel
target remote:1234
```

-   stop at 0x7c00, print instructions here

```gdb
set architecture i8086
b *0x7c00
continue
x /8i $pc
```

```sh
$ make debug
```

## Ex3 - enable protected mode(bootloader)

-   boot/asm.h
-   boot/bootasm.S

### A20

-   内存回滚 - 保持向下兼容
-   关闭 A20 才能使得访问更多的内存空间, 否则 1-2M,3-4M,... 永远只能访问1M

```asm
# 0xdl -> port 0x64
# 0xdf -> port 0x60

movb $0xdl, %al
outb %al, $0x64
movb $0xdf, %al
outb %al, $0x60
```

### GDT(简化)

-   gdt 全局描述符表每项保存着一个段描述符(段的所有信息, 如特权级, 段首址, 段大小等)
-   lgdt 指令将全局描述符表的地址与大小信息装入 gdt 寄存器

```c
// SEG_ASM 用于展开为全局描述符表中的有效项
// 根据 段描述符 的相关格式建立表项
#define SEG_ASM(type, base, limit)                          \
    .word (((limit) >> 12) & 0xffff), ((base) & 0xffff);    \
    .byte (((base) >> 16) & 0xff), (0x90 | type)),          \
        (0xC0 | (((limit) >> 28) & 0xf)), (((base) >> 24) & 0xff)
```

```asm
gdt:
    .word 0, 0;
    .byte 0, 0, 0, 0
    .word ...;
    .byte ...
    SEG_ASM(type1, base1, limit1)
    SEG_ASM(type2, base2, limit2)

gdtdesc:
    .word 0x17 # sizeof(gdt) - 1
    .long gdt  # address gdt

lgdt gdtdesc
```

**实际上**全局描述符表往往保存着指向局部描述符表的指针, 局部描述符表中才保存着真正的段描述符.本次实验做了简化处理.

### CR0

将 CR0 寄存器的最低 bit 位置1, 开启保护模式

```asm
.set CR0_PE_ON 0x1

movl %cr0, %eax
orl $CR0_PE_ON, %eax
mov %eax, %cr0
```

### 开启保护模式

-   将段寄存器全部置为 0x10
-   ebp = 0, esp = 0x7c00

```asm
# start = 0x7c00
.global start
start:

...

    movl $0x0, %ebp
    movl $start, %esp
```

## Ex4 - load elf kernel(bootloader)

Nothing new: everything has learned in csapp

-   boot/bootmain.c

```sh
$ readelf <elf-excutable>
```

## Ex5 - print stackframe

Nothing new: everything has learned in csapp

-   kern/debug/kdebug.c -> `void print_stackframe(void)`
    -   kern/debug/kdebug.c -> `uint32_t popup_stackframe(uint32_t old_ebp)`


```asm
call: pushl %eip
      movl $func_address, %eip

caller:
    pushl %ebp
    movl %esp, %ebp
    subl $0x..., %esp

    ...

    movl %ebp, %esp 
    popl %ebp

    pool %eip
```

## Ex6

-   kern/trap/trap.c -> `idt_init`
    -   kern/mm/mmu.h
    -   kern/trap/vectors.S
-   kern/trap/trap.c -> `trap_dispatch()`

### trap handler

trapentry.S::alltraps() -> trap.c::trap() -> trap.c::`trap_dispatch()`
