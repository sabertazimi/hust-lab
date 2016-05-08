# Lab 8 Notes

## Intro

-   Windows.inc中定义了 `VK_F1` equ 70h
-   `WM_PAINT`

## Workflow

### env.bat

建立 win32 编译/链接环境

```bat
set Masm32Dir=c:\Masm32
set include=%Masm32Dir%\Include;%include%
set lib=%Masm32Dir%\lib;%lib%
```

### Makefile

通过 nmake 工具简化工作流

```makefile
NAME = lab8
OBJS = $(NAME).obj
RES = $(NAME).res
EXE = $(NAME).exe

$(EXE): $(OBJS) $(RES)
	link /debug /debugtype:cv /subsystem:windows $(OBJS) $(RES)
$(RES): $(NAME).rc
	rc $(NAME).rc
$(OBJS): $(NAME).asm
	ml /c /coff /Zi $(NAME).asm

clean:
	del *.obj
	del *.res
	del *.ilk

debug:
	td $(EXE)
	del *.tr

run:
	$(EXE)
```

## Bug

### Caller Reservation

调用函数 TextOut 时，需将 eax/ebx/ecx/edx 值保护起来

-   若不保护 ebx, 则不能正常输出成绩信息，程序直接退出: ebx 用于取出成绩，将其转化为数字字符串
-   若不保护 ecx, 则只能成功输出 1 个学生信息: ecx 为计数器
-   若不保护 edx, 则只能成功输出每个学生的姓名: edx 用于计算打印位置

### `WM_PAINT`

-   `WM_MOVE/SETFOCUS/SIZING` -> 重绘
-   TODO: Maximize/Minimize
