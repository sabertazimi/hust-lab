NAME = opt-v2

EXE = $(NAME).exe
OBJS = $(NAME).obj
SRCS = $(NAME).asm
SIMPLE_MODE = ;

LINK_FLAG = /subsystem:dos
ML_FLAG = /c/coff/zi
MASM_FLAG = /Zi/Zd

$(EXE): $(OBJS)
    link $(LINK_FLAG) $(OBJS) $(SIMPLE_MODE)
$(OBJS): $(SRCS)
    masm $(MASM_FLAG) $(SRCS) $(SIMPLE_MODE)

clean:
	del *.obj

debug:
	td $(EXE)
	del *.tr

run:
	$(EXE)
