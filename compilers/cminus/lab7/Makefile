CC=gcc
LEX=flex
YACC=bison

g--.exe: c--.tab.o lex.yy.o ast.o list.o semant.o main.o 
	$(CC) -o g--.exe lex.yy.o c--.tab.o ast.o list.o semant.o main.o

c--.tab.c: c--.y
	$(YACC) -d c--.y

c--.tab.o: c--.tab.c
	$(CC) -c c--.tab.c

lex.yy.o: lex.yy.c
	$(CC) -c lex.yy.c

lex.yy.c: c--.lex
	$(LEX) c--.lex

ast.o: ast.c
	$(CC) -c ast.c

list.o: list.c
	$(CC) -c list.c

semant.o: semant.c
	$(CC) -c semant.c

main.o: main.c
	$(CC) -c main.c

.PHONY=build clean purge run gdb

build:
	make purge
	make
	make clean

clean:
	rm -rf c--.tab.h c--.tab.c lex.yy.c *.o *~

purge:
	rm -rf g--.exe c--.tab.h c--.tab.c lex.yy.c *.o *~

run:
	./g--.exe < test.code

gdb:
	gdb g--.exe

