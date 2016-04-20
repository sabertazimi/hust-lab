#!/usr/bin/perl 
#######################################################################
# bomblab-reportd.pl - Binary bomb reporting daemon
#
# Copyright (c) 2011, R. Bryant and D. O'Hallaron, All rights reserved.
#
# Repeatedly calls the update script to generate the scoreboard web page.
#
#######################################################################
use strict 'vars';
use Getopt::Std;

use lib ".";
use Bomblab;

$| = 1; # autoflush output on every print statement

##############
# Main routine
##############

# 
# Parse and check the command line arguments
#
no strict 'vars';
getopts('hq');
if ($opt_h) {
    usage("");
}

$Bomblab::QUIET = 0;
if ($opt_q) {
    $Bomblab::QUIET = 1;
}
use strict 'vars';

# Check that the autograder exists 
-e $Bomblab::UPDATE and -x $Bomblab::UPDATE
    or log_die("ERROR: Update script ($Bomblab::UPDATE) either missing or not executable\n");

#
# Repeatedly call the update script and create a new scoreboard web page.
#
while (1) {
    system("./$Bomblab::UPDATE") == 0
	or log_msg("Error: Update script ($Bomblab::UPDATE) failed: $!");
    
    sleep($Bomblab::UPDATE_PERIOD);
}

# Control never actually reaches here
exit;

#
# void usage - print help message and terminate
#
sub usage 
{
    printf STDERR "$_[0]\n";
    printf STDERR "Usage: $0 [-h]\n";
    printf STDERR "Options:\n";
    printf STDERR "  -h   Print this message.\n";
    printf STDERR "  -q   Quiet. Send error and status msgs to $Bomblab::STATUSLOG instead of tty.\n";
    die "\n" ;
}

