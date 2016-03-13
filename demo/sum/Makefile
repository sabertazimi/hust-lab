NAME = sum

EXE = $(NAME).exe
OBJS = $(NAME).obj
SRCS = $(NAME).asm

LINK_FLAG = /subsystem:windows
ML_FLAG = /c/coff
MASM_FLAG = /Zi/Zd

$(EXE): $(OBJS)
    link $(LINK_FLAG) $(OBJS)
$(OBJS): $(SRCS)
    masm $(MASM_FLAG) $(SRCS)

clean:
	del *.obj

test:
	td $(EXE) && del *.tr
