#
# Student makefile for Cache Lab
# Note: requires a 64-bit x86-64 system
#
CC = gcc
CFLAGS = -g -Wall -Werror -std=c99 -m64

all: csim test-trans tracegen
	# Generate a handin tar file each time you compile
	-tar -cvf ${USER}-handin.tar  csim.c trans.c

csim: csim.c cachelab.c cachelab.h
	$(CC) $(CFLAGS) -o csim csim.c cachelab.c -lm

test-trans: test-trans.c trans.o cachelab.c cachelab.h
	$(CC) $(CFLAGS) -o test-trans test-trans.c cachelab.c trans.o

tracegen: tracegen.c trans.o cachelab.c
	$(CC) $(CFLAGS) -O0 -o tracegen tracegen.c trans.o cachelab.c

trans.o: trans.c
	$(CC) $(CFLAGS) -O0 -c trans.c

#
# Clean the src dirctory
#
clean:
	rm -rf *.o
	rm -f *.tar
	rm -f csim
	rm -f test-trans tracegen
	rm -f trace.all trace.f*
	rm -f .csim_results .marker

rebuild:
	make clean && make

test:
	./csim -s 1 -E 1 -b 1 -t traces/yi2.trace
	./csim -s 4 -E 2 -b 4 -t traces/yi.traces
	./csim -s 2 -E 1 -b 4 -t traces/dave.trace
	./csim -s 2 -E 1 -b 3 -t traces/trans.trace
	./csim -s 2 -E 2 -b 3 -t traces/trans.trace
