CC=gcc
LEX=flex
YACC=bison

g--.exe: c--.tab.o lex.yy.o ast.o list.o semant.o stack-machine.o gen-stack.o stack2x86.o main.o 
	$(CC) -o g--.exe lex.yy.o c--.tab.o ast.o list.o semant.o stack-machine.o gen-stack.o stack2x86.o main.o

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

stack-machine.o: stack-machine.c
	$(CC) -c stack-machine.c

gen-stack.o: gen-stack.c
	$(CC) -c gen-stack.c

stack2x86.o: stack2x86.c
	$(CC) -c stack2x86.c

main.o: main.c
	$(CC) -c main.c

.PHONY=build clean purge run test gdb

build:
	make purge
	make
	make clean
	@echo
	@echo '===== Build success!'

clean:
	rm -rf c--.tab.h c--.tab.c lex.yy.c *.o *~ *.s

purge:
	rm -rf c--.tab.h c--.tab.c lex.yy.c *.o *~ *.exe *.s

run:
	./g--.exe < test.code
	@echo
	@echo '===== Compile success!'


test:
	make clean
	./stack.exe

gdb:
	gdb stack.exe
