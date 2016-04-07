#!/usr/bin/perl
#######################################################################
# solve.pl - Automatically solves a buffer bomb
#
# Copyright (c) 2002-2011, R. Bryant and D. O'Hallaron.
#######################################################################
use strict;
use Getopt::Std;

use lib ".";
use Solve;

my $MAX_LEVEL = 4;
my @levelnames = ("smoke", "fizz", "bang", "boom", "kaboom");

$| = 1; # autoflush output on every print statement

#
# usage - print help message and terminate
#
sub usage 
{
    printf STDERR "$_[0]\n";
    printf STDERR "Usage: $0 [-hs] -u <userid> -l <level>\n";
    printf STDERR "Options:\n";
    printf STDERR "  -h          Print this message\n";
    printf STDERR "  -u <userid> User ID name\n";
    printf STDERR "  -l <level>  Level to solve [0,1,2,3,4]\n";
    printf STDERR "  -s          Submit results to grading server\n";
    die "\n";
}

##############
# Main routine
##############
my $userid;
my $level;
my $cmd;
my $submitflag;

# Get specified userid and level
no strict;
getopts('hsu:l:');
if ($opt_h) {
    usage();
}

if (!$opt_u) {
    usage("Missing userid name (-u)");
}

$submitflag = "";
if ($opt_s) {
    $submitflag = "-s";
}
$userid = $opt_u;
$level = $opt_l;
($level >= 0 && $level <= $MAX_LEVEL) 
    or usage("Can only have levels 0-$MAX_LEVEL");

use strict 'vars';

# Make sure the makecookie binary is there 
system("cd $Solve::BINDIR; make > /dev/null 2>&1"); 

# Solve buffer bomb for specified userid and level
$cmd = "make $levelnames[$level] BUFBOMB=$Solve::EXECUTABLE USERID=$userid SFLAG='$submitflag'";
print "Calling $cmd\n";
print `$cmd`;

exit;

