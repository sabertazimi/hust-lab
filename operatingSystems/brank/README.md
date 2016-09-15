# Bran's Kernel Dev Notes

## Installation

```sh
$ sudo apt install build-essential nasm bochs
```

## Linker File

*   ENTRY: represent for the file where program start to run
*   SECTIONS: set elf sections
*   .text/.data/.bss: name of sections, code/data/bss/end: name of variables
*   `nasm -f elf` 适配 `ld -m elf_i386`

## IDT

*   中断矢量表存放中断处理例程(函数)的地址
