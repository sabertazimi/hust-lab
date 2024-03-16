#
# Makefile
# sabertazimi, 2016-08-10 23:12
#

# program name
PROG=dragon

# tools and their flags
CC=g++
CFLAGS=-pedantic -Wall -Wextra -g $(addprefix -I, $(INCLUDE_PATH))
LEX=flex
LFLAGS=-v
YACC=bison
YFLAGS=-dv
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

# test enable flags
LEX_TEST=0
SYNTAX_TEST=0
AST_TEST=0
SEMA_TEST=0
IR_TEST=1
ASM_TEST=1

# objects
RAW_SRCS=$(shell find $(SRC_PATH) -name "*.cc" -print)
RAW_OBJS=$(patsubst %.cc, %.o, $(RAW_SRCS))
OBJS=$(SRC_PATH)/parser.o $(SRC_PATH)/scanner.o $(RAW_OBJS)

# rules
%.o: %.cc
	@echo '***' Compiling C Source Files $< ... '***'
	$(CC) -o $@ $(CFLAGS) -c $<
	$(MV) $@ $(OBJ_PATH)/$(notdir $@)
	@echo '***' Compile $< Success! '***'

%.cc: %.ll
	@echo '***' Compiling Lex Source Files $< ... '***'
	test -d $(OBJ_PATH) || $(MKDIR) $(OBJ_PATH)
	$(LEX) $(LFLAGS) -o $(@:%.o=%.d) $<
	@echo '***' Compile $< Success! '***'

%.cc: %.yy
	@echo '***' Compiling Yacc Source Files $< ... '***'
	test -d $(OBJ_PATH) || $(MKDIR) $(OBJ_PATH)
	$(YACC) $(YFLAGS) -o $(@:%.o=%.d) $<
	@echo '***' Compile $< Success! '***'

all: $(PROG)

# dependencies
$(PROG): $(OBJS)
	$(CC) -o $(SRC_PATH)/$(PROG) $(CFLAGS) $(patsubst %.o, $(OBJ_PATH)/%.o, $(notdir $(RAW_OBJS)))
	make release
	make clean
	@echo
	@echo '***' Build Success! '***'

.PHONY = clean release run count spec debug

clean:
	$(RM) $(OBJ_PATH) $(OBJS)
	$(RM) $(SRC_PATH)/parser.hh $(SRC_PATH)/parser.cc  $(SRC_PATH)/scanner.cc
	$(RM) $(SRC_PATH)/parser.output $(SRC_PATH)/$(PROG)
	$(RM) core
	$(RM) $(TEST_PATH)/*.exe
# $(RM) .gdb_history

release:
	test -d $(BIN_PATH) || $(MKDIR) $(BIN_PATH)
	$(MV) $(SRC_PATH)/parser.output  $(BIN_PATH)/parser.output
	$(MV) $(SRC_PATH)/$(PROG) $(BIN_PATH)/$(PROG)

run:
	./$(BIN_PATH)/$(PROG)

count:
	./$(TOOLS_PATH)/line_counter

spec:
ifeq ($(LEX_TEST), 1)
	$(foreach filename, $(shell find $(TEST_PATH) -name "lex_*"), echo "\n*** Lex test for" $(filename) "***\n" && ./$(BIN_PATH)/$(PROG) $(filename);)
	@echo
	@echo '***' Lex Test Passed! '***'
	@echo
endif
ifeq ($(SYNTAX_TEST), 1)
	$(foreach filename, $(shell find $(TEST_PATH) -name "errors_*"), echo "\n*** Syntax error report test for" $(filename) "***\n" && ./$(BIN_PATH)/$(PROG) $(filename);)
	@echo
	@echo '***' Syntax Error Report Test Passed! '***'
	@echo
endif
ifeq ($(AST_TEST), 1)
	$(foreach filename, $(shell find $(TEST_PATH) -name "ast_*"), echo "\n*** Ast test for" $(filename) "***\n" && ./$(BIN_PATH)/$(PROG) $(filename);)
	@echo
	@echo '***' Ast Test Passed! '***'
	@echo
endif
ifeq ($(SEMA_TEST), 1)
	$(foreach filename, $(shell find $(TEST_PATH) -name "sema_*"), echo "\n*** Semantic test for" $(filename) "***\n" && ./$(BIN_PATH)/$(PROG) $(filename);)
	@echo
	@echo '***' Semantic Test Passed! '***'
	@echo
endif
ifeq ($(IR_TEST), 1)
	$(foreach filename, $(shell find $(TEST_PATH) -name "ir_*"), echo "\n*** IR test for" $(filename) "***\n" && ./$(BIN_PATH)/$(PROG) $(filename);)
	@echo
	@echo '***' IR Test Passed! '***'
	@echo
endif
	make clean
ifeq ($(ASM_TEST), 1)
	$(foreach filename, $(shell find $(TEST_PATH) -name "asm_*"), echo "\n*** ASM test for" $(filename) "***\n" && ./$(BIN_PATH)/$(PROG) $(filename);)
	@echo
	@echo '***' ASM Test Passed! '***'
	@echo
endif

debug:
	$(GDB) $(GFLAGS) $(BIN_PATH)/$(PROG) core
# $(RM) .gdb_history

# vim:ft=make
#
