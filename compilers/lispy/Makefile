#
# Makefile
# sabertazimi, 2016-09-10 10:14
# Report BUGs to <sabertazimi@gmail.com>

PROG=lispy
CC=gcc
CC_FLAG=-std=c99 -Wall -g
MV=mv
RM=rm -fr

$(PROG):
	$(CC) -o $(PROG) $(CC_FLAG) lispy.c lval_read.c lval_eval.c lval_print.c lval_lib.c lval_lenv.c lval_list.c lval_new.c mpc.c -ledit

.PHONY=build clean purge run gdb

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

gdb:
	gdb $(PROG)

# vim:ft=make
#
