CUDDDIR = cudd-2.4.1
CFLAGS=-O2 -m32

all:
	(cd $(CUDDDIR); make CFLAGS='$(CFLAGS)')
	(cd cbit; make all CFLAGS='$(CFLAGS)' LCFLAGS='$(CFLAGS)')

clean:
	rm -f *~
	(cd $(CUDDDIR); make clean)
	(cd cbit; make clean)


