#!/usr/bin/perl 
##################################################
# makebomb.pl - Builds a CS:APP buffer bomb
#
# Copyright (c) 2011, R. Bryant and D. O'Hallaron.
##################################################

use strict 'vars';
use Getopt::Std;

use lib ".";
use Buflab;

$| = 1; # Autoflush output on every print statement


##############
# Main routine
##############

my $quiet;
my $redirect;
my $srcdir;
my $notify;
my $handoutfiles;
my $handoutdir = $Buflab::HANDOUTDIR; 

# 
# Parse and check the command line arguments
#
no strict 'vars';
getopts('hqns:');

# Run in quiet mode if using as a CGI script


$Buflab::QUIET = 0;
if ($opt_q) {
	$Buflab::QUIET = 1;
}
$quiet = $Buflab::QUIET;

# Print some usage info and exit
if ($opt_h) {
    usage($quiet, "");
}

# In quiet mode redirect all stdout and stderr output to /dev/null
$redirect = "";
if ($quiet) {
    $redirect = "> /dev/null 2>&1";
}

# Assign src directory
$srcdir = $Buflab::BOMBSRC;
if ($opt_s) {
    $srcdir = $opt_s;
}

# Determine whether to build a notifying or quiet bomb
$notify = 0; # default is a quiet bomb
if ($opt_n) {
    $notify = 1;
}
use strict 'vars';

if ($notify) {
    log_msg("Making notifying buffer bomb...\n");
}
else {
    log_msg("Making quiet buffer bomb...\n");
}

# 
# Make sure the src directory exists and is valid
#
(-e $srcdir)
    or goodbye("$srcdir does not exist");
(-d $srcdir)
    or goodbye("$srcdir is not a directory");

#
# Build the buffer bomb and the other support binaries
#
system("(cd $srcdir; make clean; export SERVERNAME=$Buflab::SERVER_NAME; export SERVERPORT=$Buflab::RESULTD_PORT; export NOTIFY=$notify; make -e ) $redirect ") == 0
    or goodbye("Could not make $srcdir/bufbomb");

#
# Rebuild the bufbomb handout
# 
$handoutfiles = "$srcdir/bufbomb $srcdir/hex2raw $srcdir/makecookie";
system("(rm -rf $handoutdir; mkdir $handoutdir; cp $handoutfiles $handoutdir)") == 0
    or goodbye("Could not make $handoutdir");


# That's a wrap!
exit(0);


#####################
# End of main routine
#####################

#
# goodbye - print an error message and return
#
sub goodbye($) {
    my $msg = shift;
    log_die "Error (makebomb.pl): $msg\n";
}

#
# usage - Print help message and terminate
#
sub usage 
{
    my $quiet = shift;
    my $msg = shift;
    
    # In quiet mode log the message to the course log file and exit
    if ($quiet) {
		if ($msg ne "") {
			log_msg(0, "$0: Error (makebomb.pl): $msg");
		}
		exit(1);
    }

    
    # In non-quiet mode, print the message on the screen
    if ($msg ne "") {
		printf STDERR "$0: Error: $msg\n";
    }
    printf STDERR "Usage: $0 [-hnq] [-s <srcdir>]\n";
    printf STDERR "Options:\n";
    printf STDERR "  -h          Print this message\n";
    printf STDERR "  -n          Build a notifying bomb (default is quiet)\n";
    printf STDERR "  -q          Work quietly, logging messages to course log file only\n";
    printf STDERR "  -s <srcdir> Directory that contains bomb sources (default $Buflab::BOMBSRC)\n";
    die "\n";
}


