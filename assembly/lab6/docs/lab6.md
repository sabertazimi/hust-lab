
* [Task 1](#task-1)
	* [Method 1 - TD.exe](#method-1---tdexe)
	* [Method 2 - dos 系统调用](#method-2---dos-系统调用)
	* [Method 3 - Memory](#method-3---memory)
* [Task 2](#task-2)
* [Task 3](#task-3)

## Task 1

### Method 1 - TD.exe

tab to ds, Ctrl+G -> 0:40h

-   020a
-   08a9

### Method 2 - dos 系统调用

-   es: 020a
-   bx: 08a9

### Method 3 - Memory

-   ax: 020a
-   dx: 08a9

## Task 2

为防止调试时,键盘错乱,可在自己编写的中断程序中调用旧的键盘驱动程序

## Task 3

**BUG** - 从1-9号端口取出来的信息都为0

需要在 in 指令后添加 nop 指令
