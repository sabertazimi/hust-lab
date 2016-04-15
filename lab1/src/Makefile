#
# Makefile that builds the CS:APP Data Lab
# There is no need to ever change this Makefile

# General variables
CPP = cpp
CPPFLAGS = -P -C
CC = gcc
CFLAGS = -O1 -g -Wall -m32 
LIBS = -lm
SELECTIONS = selections.c
CONTEST_DIR = ../contest

all: btest bits-handout.c fshow ishow Driverhdrs-module

# Build the headerfile that the driver needs to submit autoresults for
# the "Beat the Prof" contest (students submit autoresults by calling
# the driver with the -u option). If you're not running the contest,
# the driver still needs this file, but none of the values are ever
# referenced.
Driverhdrs-module:
	./genhdrs.pl -l datalab -p $(CONTEST_DIR)/Contest.pm -t 'perl' > Driverhdrs.pm

#
# Build the customized source and include files (from $(SELECTIONS))
#
bits.h:	$(SELECTIONS)
	$(CPP) $(CPPFLAGS) -DPROTOTYPE $(SELECTIONS) -Ipuzzles > bits.h

bits-handout.c: bits-header.c $(SELECTIONS)
	$(CPP) $(CPPFLAGS) -DCODE $(SELECTIONS) -Ipuzzles > bits-middle.c
	cat bits-header.c bits-middle.c > bits-handout.c
	rm bits-middle.c

decl.c: decl-header.c decl-footer.c $(SELECTIONS)
	$(CPP) $(CPPFLAGS) -DDECL $(SELECTIONS) -Ipuzzles > decl-middle.c
	cat decl-header.c decl-middle.c decl-footer.c > decl.c
	rm decl-middle.c

tests.c: tests-header.c $(SELECTIONS)
	$(CPP) $(CPPFLAGS) -DTEST $(SELECTIONS) -Ipuzzles > tests-middle.c
	cat tests-header.c tests-middle.c > tests.c
	rm tests-middle.c

#
# Build the btest test harness that checks bits.c for correctness
#
bits.o: bits.c btest.h
	$(CC) $(CFLAGS) -c bits.c

decl.o: decl.c btest.h bits.h
	$(CC) $(CFLAGS) -c decl.c

tests.o: tests.c
	$(CC) $(CFLAGS) -c tests.c

btest.o: btest.c btest.h
	$(CC) $(CFLAGS) -c btest.c

btest: btest.o tests.o decl.o bits.o
	$(CC) $(CFLAGS) $(LIBS) -o btest btest.o tests.o decl.o bits.o


#
# Build the instructor's bits.c solution.
#
bits.c: bits-header.c $(SELECTIONS)
	$(CPP) $(CPPFLAGS) -DCODE -DFIX $(SELECTIONS) -Ipuzzles > bits-middle.c
	cat bits-header.c bits-middle.c > bits.c
	rm bits-middle.c
	cp bits.c bits.c-solution

# Forces a recompile. Used by the driver program. 
btestexplicit:
	$(CC) $(CFLAGS) $(LIBS) -o btest bits.c btest.c decl.c tests.c 

#
# Build some useful helper programs for working with floats and ints
#
fshow: fshow.c
	$(CC) $(CFLAGS) -o fshow fshow.c

ishow: ishow.c
	$(CC) $(CFLAGS) -o ishow ishow.c


#
# Build the dlc package
#
dlc-code:
	(cd dlcdir; make)


#
# Clean the top-level src directory
#
clean:
	rm -f *.o *~ Driverhdrs.pm btest fshow ishow bits-handout.c bits-middle.c bits.c bits.p.c decl.c tests.c bits.h *.exe 

#
# Clean the dlc directory as well
#
cleanallfiles:
	(make clean)
	(cd dlcdir; make clean)





