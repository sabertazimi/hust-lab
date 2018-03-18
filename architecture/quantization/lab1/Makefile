#
# Makefile
# sabertazimi, 2017-05-01 19:54
#

all:
	nasm -f elf t1_s1.asm && ld -m elf_i386 -s -o t1_s1 t1_s1.o
	nasm -f elf t1_s2.asm && ld -m elf_i386 -s -o t1_s2 t1_s2.o
	gcc -m32 t1.c -o t1.o

run:
	./t1.o

clean:
	rm -fr *.o

# vim:ft=make
#
