UnitTest.exe:UnitTest.o PriorityQueue.o
	gcc -Wall -std=c99 -static -g -o UnitTest.exe UnitTest.o PriorityQueue.o
UnitTest.o:UnitTest.c ../../Lib/PriorityQueue.h
	gcc -Wall -std=c99 -static -g -c UnitTest.c
PriorityQueue.o:../../Lib/PriorityQueue.c ../../Lib/PriorityQueue.h
	gcc -Wall -std=c99 -static -g -c ../../Lib/PriorityQueue.c

clean:
	rm -fr *.o

test:
	./UnitTest.exe
