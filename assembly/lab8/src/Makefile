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
	del *.pdb

debug:
	td $(EXE)
	del *.tr

run:
	$(EXE)

