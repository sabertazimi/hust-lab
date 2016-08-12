#
# Makefile
# sabertazimi, 2016-08-12 11:39
#

all:
	@echo "Makefile needs your attention"
	make clean
	flex -o ex2.cpp ex2.l
	g++ ex2.cpp -o ex2

.PHONY=clean run

clean:
	rm -fr ex2.cpp ex2
run:
	./ex2


# vim:ft=make
#
