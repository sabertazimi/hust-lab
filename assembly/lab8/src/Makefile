NAME = main
OBJS = $(NAME).obj
RES = $(NAME).res
EXE = $(NAME).exe

$(EXE): $(OBJS) $(RES)
	Link /DEBUG /SUBSYSTEM:WINDOWS /LIBPATH:C:\masm32\lib $(OBJS) $(RES)
$(RES): $(NAME).rc
	Rc $(NAME).rc
$(OBJS): $(NAME).asm
	Ml /c /coff $(NAME).asm

clean:
	del *.obj
	del *.res
	del *.ilk

debug:
	td $(EXE)
	del *.tr

run:
	$(EXE)


