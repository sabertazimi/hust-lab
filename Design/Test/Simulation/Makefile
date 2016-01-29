Simulation.exe:PriorityQueue.o Simulation.o
	gcc -Wall -std=c99 -static -g -o Simulation.exe PriorityQueue.o Simulation.o
Simulation.o:Simulation.c ../../Lib/PriorityQueue.h
	gcc -Wall -std=c99 -static -g -c Simulation.c
PriorityQueue.o:../../Lib/PriorityQueue.c ../../Lib/PriorityQueue.h
	gcc -Wall -std=c99 -static -g -c ../../Lib/PriorityQueue.c

clean:
	rm -fr *.o

test:
	./Simulation.exe
