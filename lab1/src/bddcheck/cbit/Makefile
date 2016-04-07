CC=gcc
CFLAGS=-Wall -g -m32
LCFLAGS=-g -m32
LEX = flex
YACC=bison
LEXLIB = -lfl
CUDDDIR = ../cudd-2.4.1
CUDDINC = -I$(CUDDDIR)/cudd -I$(CUDDDIR)/mtr -I$(CUDDDIR)/epd -I$(CUDDDIR)/util
INC = $(CUDDINC)
CUDDLIBS = $(CUDDDIR)/cudd/libcudd.a  $(CUDDDIR)/mtr/libmtr.a  $(CUDDDIR)/st/libst.a $(CUDDDIR)/epd/libepd.a $(CUDDDIR)/util/libutil.a -lm

all: cbit

cbit: boolnet.h ast.h gen-hash.h mem.h lex.yy.o simplec.tab.o ast-gen.c boolnet.c ast-eval.c gen-hash.c mem.c
	$(CC) $(CFLAGS) $(INC) lex.yy.o simplec.tab.o ast-gen.c boolnet.c ast-eval.c gen-hash.c mem.c $(CUDDLIBS) -o cbit

cbit32: boolnet.h ast.h gen-hash.h mem.h lex.yy.o simplec.tab.o ast-gen.c boolnet.c ast-eval.c gen-hash.c mem.c
	$(CC) $(CFLAGS) $(INC) -DWSIZE=32 lex.yy.o simplec.tab.o ast-gen.c boolnet.c ast-eval.c gen-hash.c mem.c $(CUDDLIBS) -o cbit32

lex.yy.c: simplec.lex
	$(LEX) simplec.lex

lex.yy.o: lex.yy.c boolnet.h ast.h simplec.tab.c gen-hash.h
	$(CC) $(LCFLAGS) -c $(INC) lex.yy.c

simplec.tab.o: simplec.tab.c boolnet.h ast.h
	$(CC) $(LCFLAGS) -c $(INC) simplec.tab.c

simplec.tab.c: simplec.y
	$(YACC) -d simplec.y

fcheck: fcheck.c boolnet.h boolnet.c gen-hash.h gen-hash.c
	$(CC) $(CFLAGS) $(INC) fcheck.c boolnet.c gen-hash.c $(CUDDLIBS) -o fcheck

float-mul: float-mul.c boolnet.h boolnet.c gen-hash.h gen-hash.c
	$(CC) $(CFLAGS) $(INC) float-mul.c boolnet.c gen-hash.c $(CUDDLIBS) -o float-mul

clean:
	rm -f *.o *.exe cbit simplec.tab.c simplec.tab.h lex.yy.c *~


