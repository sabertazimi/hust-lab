#
# Makefile
# sabertazimi, 2017-01-18 22:20
#

# program name
PROG=dfs

# tools and their flags
CC=g++
CFLAGS=-pedantic -Wall -Wextra -g $(addprefix -I, $(INCLUDE_PATH))
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
INCLUDE_PATH=src

# objects
SRCS=$(shell find $(SRC_PATH) -name "*.c" -print)
OBJS=$(patsubst %.c, %.o, $(SRCS))

# rules
%.o: %.c
	@echo '***' Compiling Source Files $< ... '***'
	$(CC) -o $@ $(CFLAGS) -c $<
	$(MKDIR) $(OBJ_PATH)
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

.PHONY = clean release run test debug

COLOR_SCHEME=1

clean:
	$(RM) $(OBJ_PATH) $(OBJS)
	$(RM) core
	$(RM) $(TEST_PATH)/*.exe
# $(RM) .gdb_history

release:
	test -d $(BIN_PATH) || $(MKDIR) $(BIN_PATH)
	$(MV) $(SRC_PATH)/$(PROG) $(BIN_PATH)/$(PROG)

run:
	./$(BIN_PATH)/$(PROG) $(COLOR_SCHEME)

test:

debug:
	$(GDB) $(GFLAGS) $(BIN_PATH)/$(PROG) core
# $(RM) .gdb_history

# vim:ft=make
#
