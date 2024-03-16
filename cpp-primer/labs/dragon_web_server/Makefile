#
# Makefile
# sabertazimi, 2017-05-08 23:23
#

# program name
PROG=dws

# tools and their flags
CC=g++
CPPFLAGS=-pedantic -Wall -Wextra -Wno-unused-parameter -g -std=c++11 $(addprefix -I, $(INCLUDE_PATH))
LDFLAGS=-lboost_system -lboost_filesystem -pthread
GDB=gdb
GFLAGS=
#GFLAGS= -q -x tools/gdbinit
RM=rm -fr
MKDIR=mkdir -p
MV=mv
ZIP=zip

# paths
SRC_PATH=src
OBJ_PATH=obj
BIN_PATH=bin
TOOLS_PATH=tools
INCLUDE_PATH=src

# objects
SRCS=$(shell find $(SRC_PATH) -name "*.cpp" -print)
OBJS=$(patsubst %.cpp, %.o, $(SRCS))

# rules
%.o: %.cpp
	@echo '> Compiling C Source Files $< ... '
	$(CC) -o $@ $(CPPFLAGS) -c $< $(LDFLAGS)
	test -d $(OBJ_PATH) || $(MKDIR) $(OBJ_PATH)
	$(MV) $@ $(OBJ_PATH)/$(notdir $@)
	@echo '> Compile $< Success! '

all: $(PROG)

# dependencies
$(PROG): $(OBJS)
	$(CC) -o $(SRC_PATH)/$(PROG) $(CPPFLAGS) $(patsubst %.o, $(OBJ_PATH)/%.o, $(notdir $(OBJS))) $(LDFLAGS)
	make release
	make clean
	@echo
	@echo '> Build Success! '

.PHONY = clean release run debug

clean:
	$(RM) $(OBJ_PATH) $(OBJS)
	$(RM) core
# $(RM) .gdb_history

release:
	test -d $(BIN_PATH) || $(MKDIR) $(BIN_PATH)
	$(MV) $(SRC_PATH)/$(PROG) $(BIN_PATH)/$(PROG)

run:
	cd $(BIN_PATH) && ./$(PROG)

debug:
	$(GDB) $(GFLAGS) $(BIN_PATH)/$(PROG) core
# $(RM) .gdb_history

# vim:ft=make
#
