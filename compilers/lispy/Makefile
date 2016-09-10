#
# Makefile
# sabertazimi, 2016-09-10 10:14
# Report BUGs to <sabertazimi@gmail.com>

PROG=lispy
CC=gcc
CC_FLAG=-std=c99 -Wall -ledit
MV=mv
RM=rm -fr

$(PROG):
	$(CC) -o $(PROG) $(CC_FLAG) lispy.c mpc.c

.PHONY=build clean purge run

build:
	make purge
	make
	make clean

clean:
	$(RM) *.o

purge:
	$(RM) *.o $(PROG)

run:
	./$(PROG)

# vim:ft=make
#
