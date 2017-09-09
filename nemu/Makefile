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

#################### append rules

count: 
	find . -name "*.[ch]" | xargs cat| grep -v ^$$ | wc -l

sp=.
ss=TODO\(\)
ARCH?=x86-nemu
ALL=hello-str
APP=microbench

search:
	find $(sp) -name "*.[ch]" | xargs grep "$(ss)"

test:
	cd ../nexus-am/tests/cputest && make ARCH=$(ARCH) ALL=$(ALL) run

testall:
	bash runall.sh

testcase:
	ls ../nexus-am/tests/cputest/tests

asm:
	less ../nexus-am/tests/cputest/build/$(ALL)-$(ARCH).txt

log:
	less ../nexus-am/tests/cputest/build/nemu-log.txt

runapp:
	cd ../nexus-am/apps/$(APP) && make run

asm2:
	less ../nexus-am/apps/$(APP)/build/$(APP)-$(ARCH).txt

log2:
	less ../nexus-am/apps/$(APP)/build/nemu-log.txt

IO=time

testio:
	cd ../nexus-am/tests/$(IO)test && make run

#################### append rules
