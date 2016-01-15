Simulation.exe:Heap.o AssertTest.o
	gcc -Wall -std=c99 -static -g -o Simulation.exe Heap.o AssertTest.o
AssertTest.o:AssertTest.c Heap.h
	gcc -Wall -std=c99 -static -g -c AssertTest.c
Heap.o:Heap.c Heap.h
	gcc -Wall -std=c99 -static -g -c Heap.c

clean:
	rm -fr *.o