NAME = dos

EXE = $(NAME).exe
SIMPLE_MODE = ;

$(EXE): $(NAME).obj
    link $(NAME).obj $(SIMPLE_MODE)
$(NAME).obj: $(NAME).asm
    masm $(NAME).asm $(SIMPLE_MODE)

clean:
	del *.obj

debug:
	td $(EXE)
	del *.tr

run:
	$(EXE)
