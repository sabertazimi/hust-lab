#
# Makefile
# sabertazimi, 2017-02-19 16:51
#

SRC_PATH=src
TEST_PATH=test
OUT_PATH=out
VCD_PATH=vcd

ROOT  = mips_tb

SRC   = $(shell ls $(SRC_PATH) *.v)
OUT   = $(shell ls $(OUT_PATH) *tb.v)
TEST  = $(shell ls $(TEST_PATH) *tb.v)

CC=iverilog
CFLAGS=-y$(SRC_PATH) -I$(SRC_PATH)/include
VM=vvp
EDA=gtkwave

# OBJS  = $(shell ls t*.asm | sed -e 's/.asm//')
# OUTS  = $(shell ls t*.asm | sed -e 's/.asm/.out/')
# HEXS  = $(shell ls t*.asm | sed -e 's/.asm/.hex/')

all:
	mkdir -p $(OUT_PATH)
	$(CC) $(CFLAGS) -s $(ROOT) -o $(OUT_PATH)/$(ROOT).vvp $(TEST_PATH)/$(ROOT).v

.PHONY=clean test wave

run:
	$(VM) $(OUT_PATH)/$(ROOT).vvp
	# $(VM) $(OUT_PATH)/$(ROOT) -lxt2

wave:
	$(EDA) $(VCD_PATH)/$(ROOT).vcd &


clean:
	-rm -fr $(OUT_PATH)/*.vvp
	-rm -fr $(VCD_PATH)/*.vcd

# vim:ft=make
