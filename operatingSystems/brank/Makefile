CFLAG=-Wall -O -m32 -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I ./include -c -o

all:
	@echo Now starting to assemble, compile and link kernel:
	make assemble
	make compile
	make link
	make clean
	@echo Done!

.PHONY=assemble compile link clean count

assemble:
	nasm -f elf -o bin/boot.o boot/boot.asm

compile:
	gcc $(CFLAG) bin/main.o kern/main.c
	gcc $(CFLAG) bin/scrn.o kern/scrn.c
	gcc $(CFLAG) bin/gdt.o kern/gdt.c
	gcc $(CFLAG) bin/idt.o kern/idt.c

link:
	ld -T link.ld -m elf_i386 -o bin/kernel.bin bin/boot.o bin/main.o bin/scrn.o bin/gdt.o bin/idt.o

clean:
	rm -fr bin/*.o

count:
	@echo 'Asm: '
	@find . -name "*.asm" | xargs cat | wc -l
	@echo 'C: '
	@find . -name "*.[ch]" | xargs cat | wc -l
