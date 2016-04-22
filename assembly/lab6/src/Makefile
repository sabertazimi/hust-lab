MNAME = main
CNAME = child

EXE = $(MNAME).exe
SIMPLE_MODE = ;

$(EXE): $(MNAME).obj $(CNAME).obj
    link $(MNAME).obj $(CNAME).obj $(SIMPLE_MODE)
$(MNAME).obj: $(MNAME).asm
    masm $(MNAME).asm $(SIMPLE_MODE)
$(CNAME).obj: $(CNAME).asm
	masm $(CNAME).asm $(SIMPLE_MODE)

clean:
	del *.obj

debug:
	td $(EXE)
	del *.tr

run:
	$(EXE)
