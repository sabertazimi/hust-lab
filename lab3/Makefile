#
# Makefile
# sabertazimi, 2016-11-11 23:12
#

# program name
PROG=process

# tools and their flags
CC=gcc
CFLAGS=-static -Wall -Wextra -std=gnu99 -O2 -g $(addprefix -I, $(INCLUDE_PATH)) -pthread
GDB=gdb
GFLAGS= -q -x ../tools/gdbinit
RM=rm -fr
MKDIR=mkdir -p
MV=mv
ZIP=zip

# paths
SRC_PATH=src
OBJ_PATH=obj
BIN_PATH=bin
TEST_PATH=test
TOOLS_PATH=tools
INCLUDE_PATH=$(SRC_PATH)

# objects
SRCS=$(shell find $(SRC_PATH) -path $(SRC_PATH)/main.c -o -path $(SRC_PATH)/get.c -o -path $(SRC_PATH)/copy.c -o -path $(SRC_PATH)/put.c -prune -o -name "*.c" -print)
OBJS=$(patsubst %.c, %.o, $(SRCS))

# rules
%.o: %.c
	@echo '***' Compiling C Source Files $< ... '***'
	test -d $(OBJ_PATH) || $(MKDIR) $(OBJ_PATH)
	$(CC) -o $@ $(CFLAGS) -c $<
	$(MV) $@ $(OBJ_PATH)/$(notdir $@)
	@echo '***' Compile $< Success! '***'

all: get copy put $(PROG)

# dependencies
$(PROG): $(SRC_PATH)/main.o $(OBJS)
	$(CC) -o $(SRC_PATH)/$(PROG) $(CFLAGS) $(OBJ_PATH)/main.o $(patsubst %.o, $(OBJ_PATH)/%.o, $(notdir $(OBJS)))
	make release
	make clean
	@echo
	@echo '***' Build Success! '***'

get: $(SRC_PATH)/get.o $(OBJS)
	$(CC) -o $(SRC_PATH)/get $(CFLAGS) $(OBJ_PATH)/get.o $(patsubst %.o, $(OBJ_PATH)/%.o, $(notdir $(OBJS)))
	test -d $(BIN_PATH) || $(MKDIR) $(BIN_PATH)
	$(MV) $(SRC_PATH)/get $(BIN_PATH)/get

copy: $(SRC_PATH)/copy.o $(OBJS)
	$(CC) -o $(SRC_PATH)/copy $(CFLAGS) $(OBJ_PATH)/copy.o $(patsubst %.o, $(OBJ_PATH)/%.o, $(notdir $(OBJS)))
	test -d $(BIN_PATH) || $(MKDIR) $(BIN_PATH)
	$(MV) $(SRC_PATH)/copy $(BIN_PATH)/copy

put: $(SRC_PATH)/put.o $(OBJS)
	$(CC) -o $(SRC_PATH)/put $(CFLAGS) $(OBJ_PATH)/put.o $(patsubst %.o, $(OBJ_PATH)/%.o, $(notdir $(OBJS)))
	test -d $(BIN_PATH) || $(MKDIR) $(BIN_PATH)
	$(MV) $(SRC_PATH)/put $(BIN_PATH)/put

.PHONY = clean release run count spec debug ipc proc

clean:
	$(RM) $(OBJ_PATH) $(OBJS)
	$(RM) core
# $(RM) .gdb_history

release:
	test -d $(BIN_PATH) || $(MKDIR) $(BIN_PATH)
	$(MV) $(SRC_PATH)/$(PROG) $(BIN_PATH)/$(PROG)

run:
	cd ./$(BIN_PATH) && \
	./$(PROG)
	make ipc
	make proc

count:
	./$(TOOLS_PATH)/line_counter

spec:

debug:
	cd ./$(BIN_PATH) && \
	$(GDB) $(GFLAGS) $(PROG) core
# $(RM) .gdb_history

ipc:
	./$(TOOLS_PATH)/ipcrm

proc:
	-pkill get
	-pkill copy
	-pkill put

# vim:ft=make
#
