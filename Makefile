#
# Makefile
# Author: sabertazimi, 2016-09-28
# Report BUGs to <sabertazimi@gmail.com>
#

C_SOURCES = $(shell find . -path ./test -prune -o -name "*.cpp" -print)
C_OBJECTS = $(patsubst %.cpp, %.o, $(C_SOURCES))
C_OBJ = $(patsubst %.o, $(OBJ_DIR)/%.o, $(notdir $(C_OBJECTS)))
PROG=stack

# macro for tools
CC = g++
RM = rm -fr
MV = mv
CP = cp -fr
MKDIR = mkdir -p
BROWSER = google-chrome
# DOCS = doxygen

# macro for flags
C_FLAGS = -c -Wall -g

# path macro
BIN_DIR = ./bin
OBJ_DIR = ./obj
DOCS_DIR = ./docs

# include macro
# INCLUDE += include/ 			\

all: $(C_OBJECTS) link

.cpp.o:
	@echo Compiling C Source Files $< ...
	$(MKDIR) $(OBJ_DIR)
	$(CC) $(C_FLAGS) $< -o $@
	$(MV) $@ $(OBJ_DIR)/$(notdir $@)

link:
	@echo Linking Binary File
	$(MKDIR) $(BIN_DIR)
	$(CC) $(C_OBJ) -o $(BIN_DIR)/$(PROG)

.PHONY:clean
clean:
	$(RM) $(OBJ_DIR) $(BIN_DIR)
	$(RM) .gdb_history

.PHONY:run
run:
	./bin/$(PROG)

.PHONY:docs
docs:
	$(BROWSER) $(DOCS_DIR)/html/index.html

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
