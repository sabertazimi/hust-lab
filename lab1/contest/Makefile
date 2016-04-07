#########################################
# CS:APP Data Lab "Beat the Prof" Contest
# Main makefile 
#########################################

# Starts the contest by running the main contest daemon,
# which nannies the request and result servers and the report deamon.
start:
	@touch log.txt
	@./contest.pl -q &
	@ sleep 1

# Stops the contest by killing all contest servers and daemons
stop:
	@killall -q -9 contest.pl contest-requestd.pl contest-reportd.pl \
	contest-resultd.pl ; true

# Cleans soft state from the directory. You can do this at any time
# without hurting anything.
clean:
	rm -rf *~

# Cleans the contest directory of all soft state, as well as the hard
# state related to a specific instance of the contest, such as the
# various log files and the scoreboard.
#
# Do this whenver you need a fresh directory, for example while you're
# getting the contest set up and just testing things out for yourself, or
# at the beginning of the term when you need to reset the contest.
#
# DON'T DO THIS UNLESS YOU'RE REALLY SURE!  
#
cleanallfiles:
	rm -rf *~ 
	rm -rf scores.txt log.txt log-status.txt *.html




