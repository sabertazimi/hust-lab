NAME = main
OBJS = $(NAME).obj
RES = $(NAME).res
EXE = $(NAME).exe
SIMPLE_MODE = ;

$(NAME).exe: $(OBJS) $(RES)
	Link /DEBUG /SUBSYSTEM:WINDOWS $(OBJS) $(RES) $(SIMPLE_MODE)
$(RES): $(NAME).rc
	Rc $(NAME).rc
.asm.obj:
	Ml /c /coff $(NAME).asm

clean:
	del *.obj

debug:
	td $(EXE)
	del *.tr

run:
	$(EXE)


