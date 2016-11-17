#
# Makefile
# sabertazimi, 2016-11-11 23:12
#

# program name
PROG=variable

# tools and their flags
CC=gcc
CFLAGS=-static -Wall -Wextra -std=gnu99 -O2 -g $(addprefix -I, $(INCLUDE_PATH)) -pthread
GDB=gdb
GFLAGS= -q -x tools/gdbinit
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
SRCS=$(shell find $(SRC_PATH) -name "*.c" -print)
OBJS=$(patsubst %.c, %.o, $(SRCS))

# rules
%.o: %.c
	@echo '***' Compiling C Source Files $< ... '***'
	test -d $(OBJ_PATH) ||$(MKDIR) $(OBJ_PATH)
	$(CC) -o $@ $(CFLAGS) -c $<
	$(MV) $@ $(OBJ_PATH)/$(notdir $@)
	@echo '***' Compile $< Success! '***'

all: $(PROG)

# dependencies
$(PROG): $(OBJS)
	$(CC) -o $(SRC_PATH)/$(PROG) $(CFLAGS) $(patsubst %.o, $(OBJ_PATH)/%.o, $(notdir $(OBJS)))
	make release
	make clean
	@echo
	@echo '***' Build Success! '***'

.PHONY = clean release run count debug

clean:
	$(RM) $(OBJ_PATH) $(OBJS)
	$(RM) core
# $(RM) .gdb_history

release:
	$(MKDIR) $(BIN_PATH)
	$(MV) $(SRC_PATH)/$(PROG) $(BIN_PATH)/$(PROG)

run:
	./$(BIN_PATH)/$(PROG)

count:
	./$(TOOLS_PATH)/line_counter

debug:
	$(GDB) $(GFLAGS) $(BIN_PATH)/$(PROG) core
# $(RM) .gdb_history

# vim:ft=make
#
