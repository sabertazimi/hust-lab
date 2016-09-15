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
*   将中断服务例程与中断请求处理程序的函数地址在 IDT 中注册, 结合 CPU 等硬件的控制, 便可实现中断处理

### 中断处理流程(在实际逻辑置于 C 语言中)

*   发生中断
*   调用对应处理程序 isrs_x/irq_x
*   isrs_x/irq_x 负责压入相关信息(中断号/错误码), 然后跳转至统一处理函数
*   此函数进行压栈, 调用 fault_handler/req_handler, 出栈操作
*   进入 handler 后, 再根据中断号/错误码(结构体)以及栈帧信息(结构体), 进行实际处理(真正的处理逻辑)
*   在进入 handler 之前, 都是通过汇编代码进行最简单的处理(压入相关信息), 将实际中断处理逻辑放在 C 语言中, 再辅以内联汇编, 可大大地提升中断处理程序的编写效率以及中断处理程序的处理能力
