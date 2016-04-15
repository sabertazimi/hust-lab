# 
# Builds the CS:APP Data Lab
#
# Instructor: No need to ever change anything below here

# Writeup files and tar files will use this name.
LAB = $(notdir $(PWD))

all: btest-code dlc-code lab-writeup handout handout-tarfile

btest-code:
	######################################
	# Build the btest test harness sources
	######################################
	(cd src; make clean; make)

dlc-code:
	#############################################
	# Build the dlc rule-checking compiler binary
	#############################################
	(cd src/dlcdir; make)

lab-writeup:
	########################
	# Format the lab writeup 
	########################
	(cd writeup; make)

handout: btest-code dlc-code lab-writeup
	###################################################
	# Copy the necessary files to the handout directory
	###################################################
	(rm -rf $(LAB)-handout; mkdir $(LAB)-handout)
	cp -p src/bits-handout.c $(LAB)-handout/bits.c
	cp -p src/Makefile-handout $(LAB)-handout/Makefile
	cp -p src/README-handout $(LAB)-handout/README
	cp -p src/btest.h $(LAB)-handout
	cp -p src/btest.c $(LAB)-handout
	cp -p src/bits.h $(LAB)-handout
	cp -p src/decl.c $(LAB)-handout
	cp -p src/tests.c $(LAB)-handout
	cp -p src/fshow.c $(LAB)-handout
	cp -p src/ishow.c $(LAB)-handout
	cp -p src/dlcdir/dlc$(EXE) $(LAB)-handout
	cp -p src/driver.pl $(LAB)-handout
	cp -p src/Driverlib.pm $(LAB)-handout
	cp -p src/Driverhdrs.pm $(LAB)-handout

handout-tarfile: handout
	########################################
	# Build tarfile of the handout directory
	########################################
	(tar cvf $(LAB)-handout.tar $(LAB)-handout)

#
# This is the one you'll use once you've built the dlc compiler
#
clean:
	#####################################################
	# Clean the first-level of the datalab directory tree
	#####################################################
	rm -f *~ *.tar
	(rm -rf $(LAB)-handout)
	(cd src; make clean)
	(cd writeup; make clean)

#
# We use this one to rebuild the dlc compiler as well
#
cleanallfiles:
	#########################################
	# Clean the entire datalab directory tree
	#########################################
	rm -f *~ *.tar
	(rm -rf $(LAB)-handout)
	(cd src; make clean)
	(cd writeup; make clean)
	(cd src/dlcdir; make clean)
	(cd contest; make cleanallfiles)
