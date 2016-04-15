#!/usr/bin/perl
##############################################################################
# buflab.pl - Main daemon that starts and nannies the various buflab servers
#
# Copyright (c) 2011, R. Bryant and D. O'Hallaron.
#
##############################################################################

use strict 'vars';
use Getopt::Std;
use Sys::Hostname;

use lib ".";
use Buflab;

# 
# Generic settings
#
$| = 1;          # Autoflush output on every print statement
$0 =~ s#.*/##s;  # Extract the base name from argv[0] 

#
# Generic SIGINT, SIGHUP, and SIGTERM signal handler
#
sub handler {
    my $signame = shift;

    log_msg("Received SIG$signame. Cleaning up daemons and terminating.");
    system("killall -q -9 $Buflab::REQUESTD $Buflab::REPORTD $Buflab::RESULTD > /dev/null 2>&1");
    exit 0;
}

$SIG{PIPE} = 'IGNORE'; 
$SIG{TERM} = 'handler';
$SIG{INT} = 'handler';
$SIG{HUP} = 'handler';

##############
# Main routine
##############

my $ps;
my $line;
my $pid;
my $cmd;
my $quietflag;
my $server_dname;
my $found_requestd;
my $found_resultd;
my $found_reportd; 

# How often (secs) do we want to check that the daemons are running
my $sleeptime = 5;

# 
# Parse and check the command line arguments
#
no strict 'vars';
getopts('hq');
if ($opt_h) {
    usage();
}

$Buflab::QUIET = 0;
if ($opt_q) {
    $Buflab::QUIET = 1;
}
use strict 'vars';

#
# Print a startup message
#
$server_dname = hostname();
log_msg("Buflab daemon started on $server_dname");

#
# Make sure the buflab daemons all exist and are executable
#
(-e "./$Buflab::REPORTD" and -x "./$Buflab::REPORTD")
    or log_die("Error: $Buflab::REPORTD does not exist or is not executable.");

(-e "./$Buflab::REQUESTD" and -x "./$Buflab::REQUESTD")
    or log_die("Error: $Buflab::REQUESTD does not exist or is not executable.");

(-e "./$Buflab::RESULTD" and -x "./$Buflab::RESULTD")
    or log_die("Error: $Buflab::RESULTD does not exist or is not executable.");

#
# Kill any other instances of this program 
#
open(PS, "ps -eo pid,args |")
    or log_die("Error: Unable to run ps command");

while ($line = <PS>) {
    chomp($line);
    $line =~ m/^\s*(\d+)\s+(.*)$/;
    $pid = $1;
    $cmd = $2;
    if ($pid != $$ and $cmd =~ /$0/) { 
	log_msg("Found duplicate $0 (pid=$pid). Killing it.");
	system("kill -9 $pid > /dev/null 2>&1");
    }
}

close(PS);

#
# Kill all instances of the request, response, and report daemons
#
system("killall -q -9 $Buflab::REQUESTD $Buflab::REPORTD $Buflab::RESULTD > /dev/null 2>&1");


#
# Set the quiet flag that we will pass to the daemons when we start them 
#
$quietflag = "";
if ($Buflab::QUIET) {
    $quietflag = "-q";
}

#
# Periodically check that all the daemons are running, restarting them
# if necessary.
#
while (1) { 
    open(PS, "ps -eo pid,args |")
	or log_die("Error: Unable to run ps command");

    $found_requestd = 0;
    $found_resultd = 0;
    $found_reportd = 0;
    while ($line = <PS>) {
	chomp($line);
	if ($line =~ $Buflab::REQUESTD) {
	    $found_requestd++;
	}
	if ($line =~ $Buflab::RESULTD) {
	    $found_resultd++;
	}
	if ($line =~ $Buflab::REPORTD) {
	    $found_reportd++;
	}
    }
    close(PS);

    # If there is is not exactly one instance of each server, then kill
    # them all instances and restart one.
    if ($found_requestd != 1) {
	system("killall -q -9 $Buflab::REQUESTD > /dev/null 2>&1");
	system("./$Buflab::REQUESTD $quietflag &") == 0
	    or log_die("Unable to start $Buflab::REQUESTD ($!)");
	log_msg("Restarting $Buflab::REQUESTD.");
    }
    if ($found_resultd != 1) {
	system("killall -q -9 $Buflab::RESULTD > /dev/null 2>&1");
	system("./$Buflab::RESULTD $quietflag &") == 0
	    or log_die("Unable to start $Buflab::RESULTD ($!)");
	log_msg("Restarting $Buflab::RESULTD.");
    }
    if ($found_reportd != 1) {
	system("killall -q -9 $Buflab::REPORTD > /dev/null 2>&1");
	system("./$Buflab::REPORTD $quietflag &") == 0
	    or log_die("Unable to start $Buflab::REPORTD ($!)");
	log_msg("Restarting $Buflab::REPORTD.");
    }

    sleep($sleeptime);
}


exit(0); 



##################
# End main routine
##################

#
# usage - print help message and terminate
#
sub usage 
{
    printf STDERR "$_[0]\n";
    printf STDERR "Usage: $0 [-hq]\n";
    printf STDERR "Options:\n";
    printf STDERR "  -h    Print this message\n";
    printf STDERR "  -q    Quiet. Send error and status msgs to $Buflab::STATUSLOG instead of tty.\n";
    exit(1);
}



