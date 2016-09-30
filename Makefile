#
# Makefile
# Author: sabertazimi, 2016-09-28
# Report BUGs to <sabertazimi@gmail.com>
#

SOURCES = $(shell find . -path ./test -prune -o -name "*.cpp" -print)
OBJECTS = $(patsubst %.cpp, %.o, $(SOURCES))
C_OBJ = $(patsubst %.o, $(OBJ_DIR)/%.o, $(notdir $(OBJECTS)))
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
FLAGS = -c -Wall -g $(addprefix -I, $(INCLUDE))

# path macro
BIN_DIR = ./bin
OBJ_DIR = ./obj
DOCS_DIR = ./docs

# include macro
INCLUDE += src/include/

all: $(OBJECTS) link

.cpp.o:
	@echo Compiling C Source Files $< ...
	$(MKDIR) $(OBJ_DIR)
	$(CC) $(FLAGS) $< -o $@
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
	@echo 'SOURCES    = $(SOURCES)'
	@echo 'OBJECTS    = $(OBJECTS)'
	@echo 'C_OBJ        = $(C_OBJ)'
	@echo 'PROG         = $(PROG)'
	@echo 'FLAGS      = $(FLAGS)'


.PHONY:count
count:
	./tools/line_counter

# vim:ft=make
#
