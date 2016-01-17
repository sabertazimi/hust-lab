Simulation.exe:Priority.o AssertTest.o
	gcc -Wall -std=c99 -static -g -o Simulation.exe Priority.o AssertTest.o
AssertTest.o:AssertTest.c Priority.h
	gcc -Wall -std=c99 -static -g -c AssertTest.c
Priority.o:Priority.c Priority.h
	gcc -Wall -std=c99 -static -g -c Priority.c

clean:
	rm -fr *.o