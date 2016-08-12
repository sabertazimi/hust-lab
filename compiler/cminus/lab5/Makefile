#
# Makefile
# sabertazimi, 2016-08-10 23:12
#

PROG=calculate
RM=rm -fr

all:
	make purge
	make bison
	gcc -Wall -std=c99 $(PROG).tab.c -o $(PROG)
	make clean

.PHONY = bison clean purge run

bison:
	bison $(PROG).y

clean:
	$(RM) $(PROG).tab.c

purge:
	$(RM) $(PROG).tab.c $(PROG)

run:
	./$(PROG)


# vim:ft=make
#
