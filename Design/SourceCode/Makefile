Simulation.exe:PriorityQueue.o Simulation.o
	gcc -Wall -std=c99 -static -g -o Simulation.exe PriorityQueue.o Simulation.o
Simulation.o:Simulation.c PriorityQueue.h
	gcc -Wall -std=c99 -static -g -c Simulation.c
PriorityQueue.o:PriorityQueue.c PriorityQueue.h
	gcc -Wall -std=c99 -static -g -c PriorityQueue.c

clean:
	rm -fr *.o