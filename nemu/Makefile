NAME = nemu
INC_DIR += ./include
BUILD_DIR ?= ./build
OBJ_DIR ?= $(BUILD_DIR)/obj
BINARY ?= $(BUILD_DIR)/$(NAME)

include Makefile.git

.DEFAULT_GOAL = app

# Compilation flags
CC = gcc
LD = gcc
INCLUDES  = $(addprefix -I, $(INC_DIR))
CFLAGS   += -O2 -MMD -Wall -Werror -ggdb $(INCLUDES)

# Files to be compiled
SRCS = $(shell find src/ -name "*.c")
OBJS = $(SRCS:src/%.c=$(OBJ_DIR)/%.o)

# Compilation patterns
$(OBJ_DIR)/%.o: src/%.c
	@echo + CC $<
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c -o $@ $<

# Depencies
-include $(OBJS:.o=.d)

# Some convinient rules

.PHONY: app run submit clean
app: $(BINARY)

ARGS ?= -l $(BUILD_DIR)/nemu-log.txt

# Command to execute NEMU
NEMU_EXEC := $(BINARY) $(ARGS)

$(BINARY): $(OBJS)
	$(call git_commit, "compile")
	@echo + LD $@
	@$(LD) -O2 -o $@ $^ -lSDL2 -lreadline

run: $(BINARY)
	$(call git_commit, "run")
	$(NEMU_EXEC)

gdb: $(BINARY)
	$(call git_commit, "gdb")
	gdb -s $(BINARY) --args $(NEMU_EXEC)

clean: 
	rm -rf $(BUILD_DIR)

count: 
	find . -name "*.[ch]" | xargs cat| grep -v ^$$ | wc -l

sp=.
ss=TODO\(\)

search:
	find $(sp) -name "*.[ch]" | xargs grep "$(ss)"

ARCH?=x86-nemu
ALL=unalign
ASM_FILE=$(ALL)-$(ARCH).txt

test:
	cd ../nexus-am/tests/cputest && make ARCH=$(ARCH) ALL=$(ALL) run

testcase:
	ls ../nexus-am/tests/cputest/tests

asm:
	less ../nexus-am/tests/cputest/build/$(ASM_FILE)

log:
	less ../nexus-am/tests/cputest/build/nemu-log.txt

