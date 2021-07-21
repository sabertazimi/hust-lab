#
# Makefile
# sabertazimi, 2016-09-17 14:16
#

C_SOURCES = $(shell find . -path ./test -prune -o -name "*.c" -print)
C_OBJECTS = $(patsubst %.c, %.o, $(C_SOURCES))
C_OBJ = $(patsubst %.o, $(OBJ_DIR)/%.o, $(notdir $(C_OBJECTS)))
S_SOURCES = $(shell find . -path ./test -prune -o -name "*.S" -print)
S_OBJECTS = $(patsubst %.S, %.o, $(S_SOURCES))
S_OBJ = $(patsubst %.o, $(OBJ_DIR)/%.o, $(notdir $(S_OBJECTS)))
T_SOURCES = $(shell find ./test -name "*.c" -print)
T_OBJECTS = $(patsubst %.c, %.o, $(T_SOURCES))
T_OBJ = $(patsubst %.o, $(OBJ_DIR)/%.o, $(notdir $(T_OBJECTS)))

# macro for tools
CC = gcc
LD = ld
ASM = nasm
EMU= qemu-system-i386
RM = rm -fr
MV = mv
CP = cp -fr
MKDIR = mkdir -p

# macro for flags
C_FLAGS = -c -Wall -m32 -ggdb -gstabs+ -nostdinc -fno-builtin -fno-stack-protector $(addprefix -I, $(KINCLUDE))
LD_FLAGS = -T $(TOOLS_DIR)/kernel.ld -m elf_i386 -nostdlib
ASM_FLAGS = -f elf -g -F stabs

# names macro
KERNEL_NAME=dinux

# path macro
BIN_DIR = ./bin
OBJ_DIR = ./obj
MOUNT_DIR = /mnt/dinux
TOOLS_DIR = ./tools

# include macro
KINCLUDE += libs/ 			\
			kern/drivers 	\
			kern/debug 		\
			kern/gdt 		\
			kern/idt 		\
			kern/mm 		\
			kern/process 	\
			test 			\

all: $(S_OBJECTS) $(C_OBJECTS) $(T_OBJECTS) link update_image

.c.o:
	@echo Compiling C Source Files $< ...
	$(MKDIR) $(OBJ_DIR)
	$(CC) $(C_FLAGS) $< -o $@
	$(MV) $@ $(OBJ_DIR)/$(notdir $@)

.S.o:
	@echo Compiling Asm Source Files $< ...
	$(MKDIR) $(OBJ_DIR)
	$(ASM) $(ASM_FLAGS) $< -o $@
	$(MV) $@ $(OBJ_DIR)/$(notdir $@)

link:
	@echo Linking kernel image
	$(MKDIR) $(BIN_DIR)
	$(LD) $(LD_FLAGS) $(S_OBJ) $(C_OBJ) $(T_OBJ) -o $(BIN_DIR)/$(KERNEL_NAME)

.PHONY:clean
clean:
	$(RM) $(OBJ_DIR)/* $(BIN_DIR)/$(KERNEL_NAME)
	$(RM) .gdb_history

.PHONY:test
test:

.PHONY:create_image
create_image:
	dd if=/dev/zero of=floppy.img bs=512 count=2880
	mkfs.vfat floppy.img
	mv floppy.img $(BIN_DIR)

.PHONY:install_grub
install_grub:
	make mount
	$(CP) /boot/grub/state1 $(MOUNT_DIR)

.PHONY:update_image
.IGNORE:update_image
update_image:
	make mount_image
	sudo $(CP) $(BIN_DIR)/$(KERNEL_NAME) $(MOUNT_DIR)/$(KERNEL_NAME)
	sleep 1
	make umount_image

.PHONY:mount_image
.IGNORE:mount_image
mount_image:
	sudo $(MKDIR) $(MOUNT_DIR)
	sudo mount $(BIN_DIR)/floppy.img $(MOUNT_DIR)

.PHONY:umount_image
umount_image:
	sudo umount $(MOUNT_DIR)

.PHONY:qemu
qemu:
	$(EMU) -fda $(BIN_DIR)/floppy.img -boot a

.PHONY:bochs
bochs:
	bochs -f $(TOOLS_DIR)/bochsrc.conf

.PHONY:debug
debug:
	$(EMU) -fda $(BIN_DIR)/floppy.img -boot a -gdb tcp::1234 -S &
	sleep 1
	gdb -q -x $(TOOLS_DIR)/gdbinit

.PHONY:count
count:
	@echo 'Assembly Source Code = '
	@find . -name "*.S" | xargs cat | wc -l
	@echo 'C Source Code = '
	@find . -name "*.[ch]" | xargs cat | wc -l

.PHONY:show
show:
	@echo 'C_SOURCES = $(C_SOURCES)'
	@echo 'C_OBJECTS = $(C_OBJECTS)'
	@echo 'C_OBJ     = $(C_OBJ)'
	@echo 'S_SOURCES = $(S_SOURCES)'
	@echo 'S_OBJECTS = $(S_OBJECTS)'
	@echo 'S_OBJ     = $(S_OBJ)'
	@echo 'T_SOURCES = $(T_SOURCES)'
	@echo 'T_OBJECTS = $(T_OBJECTS)'
	@echo 'T_OBJ     = $(T_OBJ)'

# vim:ft=make
#
