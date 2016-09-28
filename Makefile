#
# Makefile
# Author: sabertazimi, 2016-09-28
# Report BUGs to <sabertazimi@gmail.com>
#

C_SOURCES = $(shell find . -path ./test -prune -o -name "*.cpp" -print)
C_OBJECTS = $(patsubst %.cpp, %.o, $(C_SOURCES))
C_OBJ = $(patsubst %.o, $(OBJ_DIR)/%.o, $(notdir $(C_OBJECTS)))
PROG=link_list

# macro for tools
CC = gcc
LD = ld
RM = rm -fr
MV = mv
CP = cp -fr
MKDIR = mkdir -p

# macro for flags
C_FLAGS = -c -Wall -m32 -g -static-libstdc++ $(addprefix -I, $(INCLUDE))
LD_FLAGS = -static-libgcc -m elf_i386

# path macro
BIN_DIR = ./bin
OBJ_DIR = ./obj
TOOLS_DIR = ./tools

# include macro
INCLUDE += include/ 			\

all: $(C_OBJECTS) link

.cpp.o:
	@echo Compiling C Source Files $< ...
	$(MKDIR) $(OBJ_DIR)
	$(CC) $(C_FLAGS) $< -o $@
	$(MV) $@ $(OBJ_DIR)/$(notdir $@)

link:
	@echo Linking kernel image
	$(MKDIR) $(BIN_DIR)
	$(LD) $(LD_FLAGS) $(C_OBJ) -o $(BIN_DIR)/$(PROG)

.PHONY:clean
clean:
	$(RM) $(OBJ_DIR)/* $(BIN_DIR)/$(PROG)
	$(RM) .gdb_history

.PHONY:run
run:
	./bin/$(PROG)

.PHONY:debug
debug:
	gdb $(BIN_DIR)/$(PROG)

.PHONY:show
show:
	@echo 'C_SOURCES = $(C_SOURCES)'
	@echo 'C_OBJECTS = $(C_OBJECTS)'
	@echo 'C_OBJ     = $(C_OBJ)'
	@echo 'PROG      = $(PROG)'

# vim:ft=make
#
