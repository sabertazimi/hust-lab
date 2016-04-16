NAME = main
OBJS = $(NAME).obj
EXE = $(NAME).exe
SIMPLE_MODE = ;

$(EXE): $(OBJS)
	Link /DEBUG $(OBJS) $(SIMPLE_MODE)
$(OBJS): $(NAME).asm
	Ml /c /coff $(NAME).asm

clean:
	del *.obj

debug:
	td $(EXE)
	del *.tr

run:
	$(EXE)


