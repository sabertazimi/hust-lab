all::
	gcc -o lexer main.c re.c nfa.c

.PHONY=clean run gdb

clean:
	rm -fr lexer

run:
	./lexer

gdb:
	gdb lexer

