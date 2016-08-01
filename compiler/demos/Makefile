#############################################################
# Makefile for Cool(Classroom Object-Oriented Language) Programs (coolmakefile)
#
# License: MIT/HPL
# Author : sabertazimi <sabertazimi@gmail.com>
# Date   : 2016/07/31 (version 1.0)
#
# Description:
# ------------
# This is an easily customizable makefile template. The purpose is to
# provide an instant building environment for cool programs.
#
# GNU make is expected to use the Makefile. Other versions of makes
# may or may not work.
#
# Usage:
# ------
# 1. Copy the Makefile to your program directory.
# 2. Customize in the "Customizable Section" only if necessary
# 3. Type make to start building your program.
#
# Make Target:
# ------------
# The Makefile provides the following targets to make:
#
#   $ make cl   	 compile and run program
#   $ make asm   	 compile .cl code file to .s code file
#   $ make clean     clean objects and the executable file
#   $ make emu   	 run assembly code in emulator
#   $ make show      show variables (for debug use only)
#   $ make help      print this message
#

## Customizable Section: adapt those variables to suit your program.
##==========================================================================

EXE=hello_world
DEPS=
MV=mv
MV_FLAG=
RM=rm
RM_FLAG=-fr
COM=./cool
COM_FLAG=
ASM_FLAG=--asm
EMU=spim

##==========================================================================

cl:
	$(COM) $(COM_FLAG) $(EXE).cl $(DEPS)

asm:
	$(COM) $(ASM_FLAG) $(EXE).cl $(DEPS)
	$(MV) $(MV_FLAG) $(EXE).cl-asm $(EXE).s

clean:
	$(RM) $(RM_FLAG) *.cl-asm *.s

emu:
	$(EMU) $(EXE).s

show:
	@echo 'EXE      :' $(EXE)
	@echo 'DEPS     :' $(DEPS)
	@echo 'MV       :' $(MV)
	@echo 'MV_FLAG  :' $(MV_FLAG)
	@echo 'RM       :' $(RM)
	@echo 'RM_FLAG  :' $(RM_FLAG)
	@echo 'COM      :' $(COM)
	@echo 'COM_FLAG :' $(COM_FLAG)
	@echo 'ASM_FLAG :' $(ASM_FLAG)
	@echo 'EMU      :' $(EMU)

help:
	@echo 'Makefile for Cool(Classroom Object-Oriented Language) Programs (coolmakefile) version 1.0'
	@echo
	@echo 'Usage: make [TARGET]'
	@echo
	@echo 'TARGETS:'
	@echo '  cl        compile and run program.'
	@echo '  asm       compile .cl code file to .s code file.'
	@echo '  clean     clean objects and the executable file.'
	@echo '  emu       run assembly code in emulator.'
	@echo '  show      show variables (for debug use only).'
	@echo '  help      print this message.'
	@echo
	@echo 'Report bugs to <sabertazimi@gmail.com>.'

