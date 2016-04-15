#####################################################################
# CS:APP Buffer Lab
# Main makefile 
######################################################################

all:
	@echo "Please enter a specific rule"

# Starts the Buffer Lab by running the main buflab daemon, which nannies the
# request and result servers and the report deamon.
start:
	@touch log.txt
	@./buflab.pl -q &
	@ sleep 1

# Stops the Buffer Lab by killing all buflab daemons
stop:
	@killall -q -9 buflab.pl buflab-requestd.pl buflab-reportd.pl \
	buflab-resultd.pl ; true

# Cleans soft state from the directory. You can do this at any time
# without hurting anything.
clean:
	rm -rf *.tar buflab-handout *~ 
	(cd src; make clean)
	(cd writeup; make clean)

#
# Cleans the entire directory tree of all soft state, as well as the
# hard state releated to a specific instance of the course, such as
# various log files and scoreboard.
#
# Do this whenver you need a fresh directory, for example while you're
# getting the lab set up and just testing things out for yourself, or
# at the beginning of the term when you need to reset the lab.
#
# DON'T DO THIS UNLESS YOU'RE REALLY SURE!  
#
cleanallfiles:
	rm -rf *.tar buflab-handout *~ 
	rm -rf scores.txt log.txt log-status.txt *.html handin
	(cd src; make clean)
	(cd writeup; make clean)
	(cd src/solve; make clean)



