#
# Makefile
# sabertazimi, 2016-08-12 16:50
#

all:
	@echo "Makefile needs your attention"
	bison exp.y
	make compile
	make clean

.PHONY=compile clean purge run gdb

compile:
	gcc -o g--.exe main.c exp.tab.c ast.c 

clean:
	rm -fr exp.tab.c

purge:
	rm -fr exp.tab.c g--.exe

run:
	./g--.exe < test.code

gdb:
	gdb g--.exe

# vim:ft=make
#
