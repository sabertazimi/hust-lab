#!/usr/bin/perl 

#######################################################
# makebomb.pl - Builds a CS:APP binary bomb 
#
# Copyright (c) 2004-2011, R. Bryant and D. O'Hallaron.
#######################################################

use strict 'vars';
use Getopt::Std;

use lib ".";
use Bomblab;

my $NUMPHASES = 6;   # number of phases (not counting secret phase)
my $quiet;

# 
# Generic settings
#
$| = 1;      # Autoflush output on every print statement


##############
# Main routine
##############

my $notify;
my $notifyflag;
my $bombid;
my $srcdir;
my $usermail;
my $username;
my $labid;

my $topbombdir;
my $bombdir;
my $phases;
my $phasearg;
my $explicit_phases;
my $bombflags;
my $redirect;
my @phasearray;
my @list;
my $i;

# 
# Parse and check the command line arguments
#
no strict 'vars';
getopts('hqni:p:s:b:u:v:l:');

# Run in quiet mode if using as a CGI script
$quiet = $opt_q;

# In quiet mode redirect all stdout and stderr output to /dev/null
$redirect = "";
if ($quiet) {
    $redirect = "> /dev/null 2>&1";
}

if ($opt_h) {
    usage($quiet, "");
}

# Check for required arguments
if (!($srcdir = $opt_s)) {
    usage($quiet, "Required argument (-s) misssing");
}
if (!($topbombdir = $opt_b)) {
    usage($quiet, "Required argument (-b) missing");
}

# Assign command line args to more meaningful names
$notify = $opt_n;
($usermail = $opt_u)
    or $usermail = "";
($username = $opt_v)
    or $username = "";
($labid = $opt_l)
    or $labid = "";

# Every bomb gets a non-negative integer bomb ID  (default is 0)
if (!defined($opt_i)) {
    $opt_i = 0;
}
if (($bombid = $opt_i) < 0) {
    usage($quiet, "Invalid bomb ID (-i)");
}

# Get the optional request for a particular phase set
# If omitted, we'll generate a random phase set
$phases = $opt_p;
if ($phases) {
    @phasearray = split(//, $phases);
    unless ((@phasearray == $NUMPHASES) and 
			(($phases =~ tr/a-c//) == $NUMPHASES)) { 
		usage($quiet, "Invalid phase pattern");
    }
} 

# Validate args for custom or notifying bombs
if ($notify or $bombid > 0) {
    unless ($opt_u and $opt_v and $opt_l) {
		usage($quiet, "missing required arg for custom/notifying bomb (-u, -v, or -l)\n");
    }
}

use strict 'vars';

# 
# Get the location of the bomb src directory and make sure it exists
#
(-e $srcdir)
    or goodbye("$srcdir does not exist");
(-d $srcdir)
    or goodbye("$srcdir is not a directory");

# 
# Get the directory where we will create the new bomb subdirectory
#
(-e $topbombdir)
    or goodbye("$topbombdir does not exist");
(-d $topbombdir)
    or goodbye("$topbombdir is not a directory");

# 
# Should we use random or predetermined phase variants?
# In either case, we will call makephases.pl (via src/Makefile)
# with explicit phase variants
#
if (!$phases) { # user has asked for random phase variants
    @list = ("a", "b", "c");
    for ($i=0; $i < $NUMPHASES; $i++) {
		$phasearray[$i] = $list[rand(@list)];
    }
    $phases = join("", @phasearray);
}
$phasearg = "-p $phases";

#
# Generic bombs (id=0) are not allowed to notify.
#
if ($notify and $bombid == 0) {
    usage($quiet, "A generic bomb (-i 0) may not notify (-n)");
}

# 
# Create the directory that will hold the bomb files
#
$bombdir = $topbombdir."/bomb".$bombid;
(!(-e $bombdir))
    or goodbye("$bombdir already exists");


system("mkdir $bombdir > /dev/null 2>&1") == 0
    or goodbye("Could not create $bombdir");

#
# Now go ahead and make the new bomb in the src directory
#

#
# Should the bomb notify the instructor on every explosion and defusion?
#
if ($notify) {
    $bombflags="-DNOTIFY";
    $notifyflag="-n";
    if (!$quiet) {
		print STDERR "Making bomb$bombid with notification turned on.\n";
    }
}
else {
    $bombflags="";
    $notifyflag="";
    if (!$quiet) {
		print STDERR "Making bomb$bombid with notification turned off.\n";
    }
}    

# 
# Remove all traces of previous bombs in the src directory
#
system("(cd $srcdir; make -s cleanall) $redirect") == 0
    or goodbye("Could not clean bomb source directory");

#
# Now we're ready to make the bomb that will be sent to the
# student. Note that $Bomblab::CFLAGS must be quoted because
# it can contain spaces.  
#
system("(cd $srcdir; export CFLAGS='$Bomblab::CFLAGS'; export SERVERNAME=$Bomblab::SERVER_NAME; export SERVERPORT=$Bomblab::RESULTD_PORT; export USERID='$username'; export LABID='$labid'; export BOMBFLAGS='$bombflags'; export NOTIFYFLAG='$notifyflag'; export BOMBPHASES='$phasearg'; export BOMBID=$bombid; make -e bomb; make -e bomb-solve; make solution.txt) $redirect ") == 0
    or goodbye("Could not make $srcdir/bomb");

# 
# Make a quiet (non-notifying) version of the same bomb for validation. Again
# note that $Bomblab::CFLAGS need to be quoted.
#
if (!$quiet) {
    print STDERR "Making quiet bomb$bombid with notification turned off.\n";
}
system("(cd $srcdir; rm -f *.o bomb-quiet; export CFLAGS='$Bomblab::CFLAGS'; export BOMBFLAGS='-DNONOTIFY'; export BOMBPHASES='$phasearg'; export BOMBID=$bombid; make -e bomb-quiet) $redirect") == 0
    or die "Could not make $srcdir./bomb-quiet\n";

#
# Copy the new bombs to the bomb directory
#
system("cp $srcdir/bomb $srcdir/bomb-quiet $srcdir/bomb.c $srcdir/phases.c $srcdir/solution.txt $bombdir $redirect ") == 0
    or goodbye("Could not copy the bomb files from $srcdir to $bombdir");

#
# Create the ID file with the name of the student associated with this bomb
#
system("(echo $username > $bombdir/ID) $redirect") == 0
    or goodbye("Could not write to $bombdir/ID file");

#
# Create the README file that identifies the bomb number and 
# the students who own the bomb.
#
system("(echo \"This is bomb $bombid.\n\nIt belongs to $username ($usermail)\" > $bombdir/README) $redirect ") == 0
    or goodbye("Could not create $bombdir/README file");

exit(0);


#####################
# End of main routine
#####################

#
# goodbye - print an error message and return
#
sub goodbye($) {
    my $msg = shift;
    die "Error(makebomb.pl): $msg\n";
}

#
# usage - Print help message and terminate
#
sub usage 
{
    my $quiet = shift;
    my $msg = shift;
    
    # In quiet mode log the message to the course log file
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
    printf STDERR "Usage: $0 [-hqn] -s <dir> -b <dir> [-i <bombid>  -p <phases> -u <usermail> -v <username> -l <lab>]\n";
    printf STDERR "Options:\n";
    printf STDERR "  -b <bombdir> Output bomb directory (bomb goes in <bombdir>/bomb<bombid>)\n";
    printf STDERR "  -h           Print this message\n";
    printf STDERR "  -i <bombid>  Integer bomb id (default 0: generic bomb)\n";
    printf STDERR "  -l <labid>   Unique lab name for this instance of the assmt\n";
    printf STDERR "  -n           Build bomb with notification enabled (default: disabled)\n";
    printf STDERR "  -p <phases>  Specifies variant for each phase [-p abccba] (default: random)\n";
    printf STDERR "  -q           Work quietly, logging messages to course log file only\n";
    printf STDERR "  -s <srcdir>  Directory that contains bomb sources\n";
    printf STDERR "  -u <usrmail> Email address (required for custom bombs)\n";
    printf STDERR "  -v <usrname> User name (required for custom bombs)\n";
    die "\n";
}


