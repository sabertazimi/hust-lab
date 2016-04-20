MYNAME  = Makefile
CC      = gcc
YACC    = bison -y
LEX     = flex

_CFLAGS = -g  -O2
WARNINGS =

CFLAGS  = $(_CFLAGS) $(WARNINGS)


# These are the source and object files for the parser
MSRC =  ast.c            complex-types.c  container.c    \
        constexpr.c      conversions.c    initializer.c  \
        list.c           main.c           operators.c    \
        output.c         print-ast.c      procedure.c    \
        sem-check.c      strings.c        sue.c          \
        symbol.c         transform.c      type.c         \
        type2.c          verify-parse.c   warning.c      \
        dataflow.c       analyze.c	  check.c 	legallist.c

MOBJ = $(MSRC:.c=.o)

PSRC =  c4.l ANSI-C.y
PC   =  lex.c parser.c
POBJ =  lex.o parser.o

SRC  = $(PSRC) $(MSRC)
CSRC = $(PC)  $(MSRC)
OBJ  = $(POBJ) $(MOBJ)

all: dlc

# These are the top level rules
dlc:  $(OBJ)
	$(CC) $(_CFLAGS) -o dlc $(OBJ)
	cp -p dlc ..

parser.c y.tab.h: ANSI-C.y
	$(YACC) -dv ANSI-C.y
	mv y.tab.c parser.c

lex.c: c4.l y.tab.h
	$(LEX) c4.l
	mv lex.yy.c lex.c

lex.o: lex.c
	$(CC) $(_CFLAGS) -I. -c lex.c -o lex.o

parser.o: parser.c
	$(CC) $(_CFLAGS) -DYYDEBUG -I. -c parser.c -o parser.o

superclean:
	rm -f *~ *.bak *.orig core y.output tmp* *.o

clean:
	rm -f *~ *.bak *.orig core dlc *.o

depend: $(PC)
	makedepend -f $(MYNAME) -- $(CFLAGS) -- $(CSRC)

tags:
	ctags -f tags $(SRC)
	etags -f TAGS $(SRC)

# DO NOT DELETE THIS LINE -- make depend depends on it.
