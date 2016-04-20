LAB = buflab

# Perl script that extracts code from bufbomb.c file
C2TEX = ./c2tex

# Location of bufbomb.c sources
CFILE = ../src/bufbomb.c
CBFILE = ../src/buf.c

all: codefiles
	latex $(LAB).tex
	latex $(LAB).tex # again to resolve references
	dvips -o $(LAB).ps -t letter $(LAB).dvi
	ps2pdf $(LAB).ps

codefiles:
	$(C2TEX) -n -f $(CBFILE) -t getbuf-c
	$(C2TEX) -f $(CFILE) -t smoke-c
	$(C2TEX) -f $(CFILE) -t fizz-c
	$(C2TEX) -f $(CFILE) -t bang-c
	$(C2TEX) -n -f $(CFILE) -t boom-c
	$(C2TEX) -f $(CFILE) -t kaboom-c

clean:
	rm -f *.aux *.ps *.pdf *.dvi *.log *.d *.o *~
