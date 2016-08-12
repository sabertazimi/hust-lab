#
# Makefile
# sabertazimi, 2016-08-12 15:24
#

PROG=parser.exe

all:
	@echo "Makefile needs your attention"
	gcc -o $(PROG) main.c

.PHONY=clean run gdb

clean:
	rm -fr $(PROG)

run:
	./$(PROG)

gdb:
	gdb $(PROG)

# vim:ft=make
#
