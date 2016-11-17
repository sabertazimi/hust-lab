#
# Makefile
# sabertazimi, 2016-11-11 23:12
#

# program name
PROG=lab3

# tools and their flags
CC=gcc
CFLAGS=-static -Wall -Wextra -std=gnu99 -O2 -g $(addprefix -I, $(INCLUDE_PATH))
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
SRCS=$(shell find $(SRC_PATH) -path $(SRC_PATH)/main.c -o -path $(SRC_PATH)/writebuf.c -o -path $(SRC_PATH)/readbuf.c -prune -o -name "*.c" -print)
OBJS=$(patsubst %.c, %.o, $(SRCS))

# rules
%.o: %.c
	@echo '***' Compiling C Source Files $< ... '***'
	test -d $(OBJ_PATH) || $(MKDIR) $(OBJ_PATH)
	$(CC) -o $@ $(CFLAGS) -c $<
	$(MV) $@ $(OBJ_PATH)/$(notdir $@)
	@echo '***' Compile $< Success! '***'

all: writebuf readbuf $(PROG)

# dependencies
$(PROG): $(SRC_PATH)/main.o $(OBJS)
	$(CC) -o $(SRC_PATH)/$(PROG) $(CFLAGS) $(OBJ_PATH)/main.o $(patsubst %.o, $(OBJ_PATH)/%.o, $(notdir $(OBJS)))
	make release
	make clean
	@echo
	@echo '***' Build Success! '***'

writebuf: $(SRC_PATH)/writebuf.o $(OBJS)
	$(CC) -o $(SRC_PATH)/writebuf $(CFLAGS) $(OBJ_PATH)/writebuf.o $(patsubst %.o, $(OBJ_PATH)/%.o, $(notdir $(OBJS)))
	test -d $(BIN_PATH) || $(MKDIR) $(BIN_PATH)
	$(MV) $(SRC_PATH)/writebuf $(BIN_PATH)/writebuf

readbuf: $(SRC_PATH)/readbuf.o $(OBJS)
	$(CC) -o $(SRC_PATH)/readbuf $(CFLAGS) $(OBJ_PATH)/readbuf.o $(patsubst %.o, $(OBJ_PATH)/%.o, $(notdir $(OBJS)))
	test -d $(BIN_PATH) || $(MKDIR) $(BIN_PATH)
	$(MV) $(SRC_PATH)/readbuf $(BIN_PATH)/readbuf

.PHONY = clean release run count spec debug ipc proc

clean:
	$(RM) $(OBJ_PATH) $(OBJS)
	$(RM) $(TEST_PATH)/*.dist
	$(RM) core
# $(RM) .gdb_history

release:
	test -d $(BIN_PATH) || $(MKDIR) $(BIN_PATH)
	$(MV) $(SRC_PATH)/$(PROG) $(BIN_PATH)/$(PROG)

# relative to $(PROG) binary
ARG_SRC=
ARG_DIST=

run:
	make ipc
	make proc
	cd ./$(BIN_PATH) && \
	./$(PROG) $(ARG_SRC) $(ARG_DIST)

count:
	./$(TOOLS_PATH)/line_counter

spec:
	$(foreach filename, $(patsubst %.src, ../%.src, $(shell find $(TEST_PATH) -name "*.src")), make run ARG_SRC=$(filename); )
	$(foreach filename, $(shell find $(TEST_PATH) -name "*.src"), diff $(filename) $(patsubst %.src, %.src.dist, $(filename)) || echo "[test] copy $(filename) failed."; )
	@echo

debug:
	cd ./$(BIN_PATH) && \
	$(GDB) $(GFLAGS) $(PROG) core
# $(RM) .gdb_history

ipc:
	./$(TOOLS_PATH)/ipcrm

proc:
	-pkill writebuf
	-pkill readbuf

# vim:ft=make
#
