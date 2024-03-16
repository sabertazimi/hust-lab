#
# Makefile
# sabertazimi, 2017-05-23 23:58
#

CXX = g++
CPPFLAGS=-Wall -Wextra -std=c++11
EXEC = solarsystem
SOURCES = main.cpp Stars.cpp SolarSystem.cpp
OBJECTS = main.o Stars.o SolarSystem.o
LDFLAGS = -lglut -lGL -lGLU

all :
	$(CXX) $(SOURCES) $(LDFLAGS) -o $(EXEC)

clean:
	    rm -f $(EXEC) *.gdb *.o

run:
	./$(EXEC)

# vim:ft=make
#
