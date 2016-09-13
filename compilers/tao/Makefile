# Makefile for Java
# sabertazimi, 2016-09-12 20:12
# Version: 1.5
#
# Compatible to Gradle Projects
#
# Report BUGs to <sabertazimi@gmail.com>

# define a variable for compiler flags (JFLAGS)
# define a variable for the compiler (JC)
# define a variable for the Java Virtual Machine (JVM)

JFLAGS = -encoding UTF-8 -d $(CLASS_PATH) -sourcepath $(SOURCE_PATH) -classpath $(CLASS_PATH) -g
JC = javac
JVM= java
BUILD= gradle
BROWSER=google-chrome
RM= rm -fr
MV= mv
MKDIR=mkdir -p
SOURCE_PATH= src/main/java
TEST_PATH= src/test/java
CLASS_PATH= build/classes/main
JAR_PATH= build/libs
REPORT_PATH= build/reports/tests
MAIN_CLASS = com.sabertazimi.tao.Tao
MAIN_JAR = tao.jar

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
SOURCE=$(call rwildcard, $(SOURCE_PATH), *.java)
CLASSES=$(SOURCE:.java=.class)

# the default make target entry
# for this example it is the target classes

default: classes

# $(macroname:string1=string2)
# In the words in the macro named 'macroname' replace 'string1' with 'string2'

classes: $(CLASSES)

.PHONY= build dist dir run test clean report show help

build:
	make clean
	make dir
	make

dist:
	$(BUILD) distZip

dir:
	$(MKDIR) $(SOURCE_PATH)
	$(MKDIR) $(TEST_PATH)
	$(MKDIR) $(CLASS_PATH)
	$(MKDIR) $(JAR_PATH)

run:
	# $(JVM) -cp $(CLASS_PATH) $(MAIN_CLASS)
	# $(JVM) -jar $(JAR_PATH)/$(MAIN_JAR)
	$(BUILD) run

test:
	$(BUILD) test

clean:
	$(RM) $(CLASS_PATH)/*
	$(RM) $(JAR_PATH)/*

report:
	$(BROWSER) $(REPORT_PATH)/index.html

show:
	@echo 'SOURCE FILES  = $(SOURCE)'
	@echo 'COMPILE FLAGS = $(JFLAGS)'

help:
	@echo 'Generic Makefile for Java Programs version 1.0'
	@echo
	@echo 'Usage: make [TARGET]'
	@echo 'TARGETS:'
	@echo '  all       (=make) compile and link.'
	@echo '  build     generate .class bytecode.'
	@echo '  dist      generate distributions.'
	@echo '  dir       generate directories of project.'
	@echo '  run       run main class.'
	@echo '  test      run unit tests.'
	@echo '  clean     clean generated files.'
	@echo '  report    browser reports of unit tests.'
	@echo '  show      show variables (for debug use only).'
	@echo '  help      print this message.'
	@echo
	@echo 'Report bugs to <sabertazimi@gmail.com>.'
