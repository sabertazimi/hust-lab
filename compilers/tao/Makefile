# Makefile for Java
# sabertazimi, 2016-09-12 20:12
# Version: 1.0
#
# Report BUGs to <sabertazimi@gmail.com>

# define a variable for compiler flags (JFLAGS)
# define a variable for the compiler (JC)
# define a variable for the Java Virtual Machine (JVM)

JFLAGS = -encoding UTF-8 -d $(DSTPATH) -sourcepath $(SRCPATH) -classpath $(DSTPATH) -g
JC = javac
JVM= java -cp $(DSTPATH)
RM= rm -fr
MV= mv
SRCPATH= src
DSTPATH= dist
FILE=

.SUFFIXES: .java .class

# DSTS:
#	rule
# DSTS (Dependency Suffix Target Suffix)
# 'TS' is the suffix of the target file, 'DS' is the suffix of the dependency
#  file, and 'rule'  is the rule for building a target
# '$*' is a built-in macro that gets the basename of the current target

.java.class:
	$(JC) $(JFLAGS) $*.java

# Recursive wildcard function from SO
rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

# ALL_INDEX_HTMLS := $(call rwildcard,foo/,index.html)
# ALL_HTMLS := $(call rwildcard,foo/,*.html)
SOURCE=$(call rwildcard, src/, *.java)
CLASSES=$(SOURCE:.java=.class)
MAIN = com.sabertazimi.tao.Tao

# the default make target entry
# for this example it is the target classes

default: classes

# $(macroname:string1=string2)
# In the words in the macro named 'macroname' replace 'string1' with 'string2'

classes: $(CLASSES)

.PHONY= build run clean show help

build:
	make clean
	make

run:
	$(JVM) $(MAIN)

clean:
	$(RM) $(subst src, dist, $(CLASSES))

show:
	@echo 'SOURCE FILES  = '$(SOURCE)
	@echo 'COMPILE FLAGS = '$(JFLAGS)

help:
	@echo 'Generic Makefile for Java Programs version 1.0'
	@echo
	@echo 'Usage: make [TARGET]'
	@echo 'TARGETS:'
	@echo '  all       (=make) compile and link.'
	@echo '  build     generate .class bytecode.'
	@echo '  run       run main program.'
	@echo '  clean     clean .class bytecode.'
	@echo '  show      show variables (for debug use only).'
	@echo '  help      print this message.'
	@echo
	@echo 'Report bugs to <sabertazimi@gmail.com>.'
