#
# Makefile
# sabertazimi, 2016-08-10 23:12
#

PROG=calculate
LEX_FLAG=
BISON_FLAG=-dv
RM=rm -fr

all:
	make purge
	make bison
	make lex
	gcc -Wall -std=c99 $(PROG).tab.c lex.yy.c -o $(PROG)
	make clean

.PHONY = lex bison clean purge run

lex:
	lex $(PROG).l

bison:
	bison $(BISON_FLAG) $(PROG).y

clean:
	$(RM) $(PROG).tab.[ch] $(PROG).output lex.yy.c 

purge:
	make clean
	$(RM) $(PROG)

run:
	./$(PROG)

# vim:ft=make
#
