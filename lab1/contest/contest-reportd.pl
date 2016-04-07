#!/usr/bin/perl 
#######################################################################
# contest-reportd.pl - Datalab contest reporting daemon
#
# Repeatedly calls the update script to generate the scoreboard page
# from the entries in the log.txt file.
#
# Copyright (c) 2011, R. Bryant and D. O'Hallaron, All rights reserved.
#######################################################################
use strict 'vars';
use Getopt::Std;

use lib ".";
use Contest;

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

$Contest::QUIET = 0;
if ($opt_q) {
    $Contest::QUIET = 1;
}
use strict 'vars';

# Check that the autograding update script exists 
-e $Contest::UPDATE and -x $Contest::UPDATE
    or log_die("ERROR: Update script ($Contest::UPDATE) either missing or not executable\n");

#
# Repeatedly call the update script and create a new scoreboard web page.
#
while (1) {
    system("./$Contest::UPDATE") == 0
	or log_msg("Error: Update script ($Contest::UPDATE) failed: $!");
    
    sleep($Contest::UPDATE_PERIOD);
}

# Control never actually reaches here
exit;

#
# void usage - print help message and terminate
#
sub usage 
{
    printf STDERR "$_[0]\n";
    printf STDERR "Usage: $0 [-hq]\n";
    printf STDERR "Options:\n";
    printf STDERR "  -h   Print this message.\n";
    printf STDERR "  -q   Quiet. Send error and status msgs to $Contest::STATUSLOG instead of tty.\n";
    die "\n" ;
}

