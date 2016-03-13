NAME = c1

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
    del *.obj && del *.tr

test:
	td $(EXE)
