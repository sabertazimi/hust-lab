#!/usr/bin/perl 
#######################################################################
# buflab-reportd.pl - Buffer bomb reporting daemon
#
# Copyright (c) 2011, R. Bryant and D. O'Hallaron, All rights reserved.
#
# Repeatedly calls the update script to generate the scoreboard web page.
#
#######################################################################
use strict 'vars';
use Getopt::Std;

use lib ".";
use Buflab;

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

$Buflab::QUIET = 0;
if ($opt_q) {
    $Buflab::QUIET = 1;
}
use strict 'vars';

# Check that the autograding update script exists 
-e $Buflab::UPDATE and -x $Buflab::UPDATE
    or log_die("ERROR: Update script ($Buflab::UPDATE) either missing or not executable\n");

#
# Repeatedly call the update script and create a new scoreboard web page.
#
while (1) {
    system("./$Buflab::UPDATE") == 0
		or log_msg("Error: Update script ($Buflab::UPDATE) failed: $!");
    
    sleep($Buflab::UPDATE_PERIOD);
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
    printf STDERR "  -q   Quiet. Send error and status msgs to $Buflab::STATUSLOG instead of tty.\n";
    die "\n" ;
}

