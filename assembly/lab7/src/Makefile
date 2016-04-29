NAME = encrypt

SRCS = $(NAME).asm
OBJS = $(NAME).obj
EXE = $(NAME).exe
SIMPLE_MODE = ;

$(EXE): $(OBJS)
    link $(OBJS) $(SIMPLE_MODE)
$(OBJS): $(SRCS)
    masm $(SRCS)

clean:
	del *.obj

debug:
	td $(EXE)
	del *.tr

run:
	$(EXE)
