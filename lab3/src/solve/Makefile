####################################################################### 
# CS:APP buffer lab
#
# This is the Makefile that solve.pl uses to solve arbitrary buffer bombs.
# 
######################################################################


############################################
# No need to ever change anything below here
############################################
USERID = csapp
SFLAG = ""
BINDIR = ..

BUFBOMB = $(BINDIR)/bufbomb$(EXE)
HEX2RAW = $(BINDIR)/hex2raw$(EXE)

# For Cygwin, files end with .exe
# EXE = .exe
EXE =

# Level 0
smoke: $(HEX2RAW) $(BUFBOMB) 
	./smoke.pl -u $(USERID) > smoke-$(USERID).txt
	$(HEX2RAW) < smoke-$(USERID).txt | $(BUFBOMB) -u $(USERID) $(SFLAG)

# Level 1
fizz: $(HEX2RAW) $(BUFBOMB)
	./fizz.pl -u $(USERID) > fizz-$(USERID).txt
	$(HEX2RAW) < fizz-$(USERID).txt | $(BUFBOMB) -u $(USERID)  $(SFLAG)

# Level 2
bang: $(HEX2RAW) $(BUFBOMB)
	./bang.pl -u $(USERID) > bang-$(USERID).txt 
	$(HEX2RAW) < bang-$(USERID).txt | $(BUFBOMB) -u $(USERID) $(SFLAG)

# Level 3
boom: $(HEX2RAW) $(BUFBOMB)
	./boom.pl -u $(USERID) > boom-$(USERID).txt 
	$(HEX2RAW) < boom-$(USERID).txt | $(BUFBOMB) -u $(USERID) $(SFLAG)

# Level 4
kaboom: $(BUFBOMB) $(HEX2RAW)
	./kaboom.pl -u $(USERID) > kaboom-$(USERID).txt
	$(HEX2RAW) -n < kaboom-$(USERID).txt | $(BUFBOMB) -u $(USERID) -n $(SFLAG)

$(BUFBOMB): $(BINDIR)/bufbomb.c \
	    $(BINDIR)/config.h \
	    $(BINDIR)/support.c \
	    $(BINDIR)/support.h \
	    $(BINDIR)/driverlib.c\
	    $(BINDIR)/driverlib.h
	@echo "Error: Use makebomb.pl to build a new buffer bomb."; false;


# Clean up all of the current solution files
clean:
	rm -f *~ *.txt *.d *.o *.S *.gdb










