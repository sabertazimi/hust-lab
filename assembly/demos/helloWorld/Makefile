NAME = hello

EXE = $(NAME).exe
OBJS = $(NAME).obj
SRCS = $(NAME).asm
SIMPLE_MODE = ;

LINK_FLAG = /subsystem:windows
ML_FLAG = /c/coff/zi
MASM_FLAG = /Zi/Zd

$(EXE): $(OBJS)
    link $(LINK_FLAG) $(OBJS) $(SIMPLE_MODE)
$(OBJS): $(SRCS)
    masm $(MASM_FLAG) $(SRCS) $(SIMPLE_MODE)

clean:
	del *.obj

test:
	td $(EXE) && del *.tr
