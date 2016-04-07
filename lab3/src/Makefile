####################################
# CS:APP Buffer Lab
# Makefile that builds a buffer bomb
####################################

# NOTE: This makefile is used by the ./makebomb.pl program. Don't
# use it directly unless you're sure what you're doing.

#
# The following variables determine how the buffer bomb is built.  The
# default values shown here build a quiet bomb. The makebomb.pl script
# overrides these defaults by defining environment variables of the
# same name, and then calling make with the -e option. You can change
# these variables manually here to build different kinds of bombs.
#

# 
# Is this a quiet (NOTIFY=0) or notifying bomb (NOTIFY=1)?  Quiet
# bombs will silently ignore the -s command line argument. Notifying
# bombs called with the -s command line argument will send each
# exploit string to the result server.
# 
NOTIFY = 0

#
# Default result server name and port (not needed for quiet bombs)
# 
SERVERNAME = bluefish.ics.cs.cmu.edu
SERVERPORT = 18214

# The following address is used for locating the runtime stack at a fixed address
# This one has been determined empirically to work with many Linux systems,
# but you may need to experiment with other values
STACK = 0x55586000

####################################### 
# No need to change anything below here
#######################################
CC = gcc
CFLAGS = -Wall -O1 

# The buffer bomb is always a 32-bit binary
# We give it an address where it should locate the runtime stack
BOMBFLAGS = -m32 -DSTACK=$(STACK) -fno-omit-frame-pointer

# The buffer bomb requires special flags to the linker
LINKFLAGS = -Wl,--section-start -Wl,bstack=$(STACK)

all: bufbomb hex2raw makecookie 

# Build the buffer bomb
bufbomb: bufbomb.c buf.o support.c driverlib.c gencookie.c stack.c config.h driverlib.h support.h stack.h
	$(CC) $(CFLAGS) $(BOMBFLAGS) $(LINKFLAGS) -DSERVER_NAME=\"$(SERVERNAME)\" -DSERVER_PORT=$(SERVERPORT) -DNOTIFY=$(NOTIFY) -o bufbomb bufbomb.c buf.o support.c driverlib.c gencookie.c stack.c

buf.o: buf.c
	$(CC) $(CFLAGS) $(BOMBFLAGS) -fno-stack-protector -c buf.c

# Build hex2raw utility
hex2raw: hex2raw.c
	$(CC) $(CFLAGS) -o hex2raw hex2raw.c

# Build makecookie utility
makecookie: makecookie.c gencookie.c
	$(CC) $(CFLAGS) -m32 -o makecookie makecookie.c gencookie.c


# Handy file for examining machine code
bufbomb.32d: bufbomb
	objdump -d bufbomb > bufbomb.32d

# Use this when you want to recompile
clean:
	-rm -f *.o bufbomb hex2raw makecookie *~

