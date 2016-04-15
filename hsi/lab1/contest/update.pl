#!/usr/bin/perl
#######################################################################
# update.pl - The Data Lab contest scoreboard updater
#
# Reads autoresult entries from log.txt and creates an html scoreboard
# with the most recent entries from each student. 
#
# Copyright (c) 2011, R. Bryant and D. O'Hallaron
#######################################################################

use strict 'vars';
use Getopt::Std;
use CGI qw(:standard :netscape :cgi_error);
use Fcntl qw(:DEFAULT :flock);
use Cwd;

use lib ".";
use Contest;

# 
# Generic settings
#
$| = 1;          # Autoflush output on every print statement
my $verbose = 0; # For debugging

##############
# Main routine
##############
my $BIGNUM = 999999;   # Arbitrary no. of ops assigned to incorrect solution
my $THRESHOLD = -1000; # Total score < threshhold -> incorrect solution

my %RESULTS = ();    # Hash of most recent autoresult from each student
my %NOPS = ();       # Hash of number of ops per student per puzzle
my %SCORE = ();      # Hash of total score for each student

my @puzzlename = (); # Array of puzzle names
my @baseops;         # Array of opcounts from the instructor's submission

my $logfile;         # Autoresults from calls to driver.pl -u $nickname
my $webpage;         # Scoreboard
my $base_userid;     # Instructor's userid
my $userid;          # User login id extracted from autoresult
my $nickname;        # User nickname extracted from autoresult
my $puzzlecnt;       # Number of puzzles in this instance of the lab

# Other variables
my ($i, $score, $cols, $entry, $iswinner, $winners, $color, $ops);

#
# Process the command line args
#
no strict 'vars';
getopts('h');
if ($opt_h) {
    usage();
}
use strict 'vars';

#
# Initialize some paths and filenames from the config file
#
$logfile = $Contest::LOGFILE;
$webpage = $Contest::SCOREBOARDPAGE;
$base_userid = $Contest::BASE_USERID;

#
#
# Create an empty logfile if one doesn't exist
#
if (!-e $Contest::LOGFILE) {
    unless (open(LOGFILE, ">>$Contest::LOGFILE")) {
	log_die("$0: Error: Unable to open $Contest::LOGFILE for appending: $!");
    }
}

# Scan the log file and store a record of the most recent autoresult
# for each user in the RESULTS hash.
#
read_logfile($logfile);

#
# Extract the number of operators for each user and puzzle and store
# them in the NOPS hash. While we're at it, also determine the number
# of puzzles and the name of each puzzle.
#
foreach $userid (sort {$a cmp $b} keys %RESULTS) { 
    my ($item, $unused, $pname, $cpoints, $ppoints, $ops);
    my @puzzles = split(/\|/, $RESULTS{$userid}[6]);

    $i=0;
    foreach $item (@puzzles) {
	($pname, $cpoints, $unused, $ppoints, $ops) = split(/:/, $item);

	# Update the array of puzzle names for later
	if (!$puzzlename[$i]) {
	    $puzzlename[$i] = $pname;
	}

	# Assign the number of ops for this userid and puzzle number
	$ops = int($ops);    # Tricky: gets rid of any text strings embedded 
	                     # in the result
	if ($cpoints == 0) { 
	    $ops = $BIGNUM;  # incorrect puzzles get the max number of ops
	}
	$NOPS{$userid}[$i++] = $ops;
    }

    # Update the puzzle count for later
    if ($i > $puzzlecnt) {
	$puzzlecnt = $i;
    }

}

# 
# Determine the baseline (instructor) operation counts for each puzzle
#
for ($i = 0; $i < $puzzlecnt; $i++) {
    $baseops[$i] = $NOPS{$base_userid}[$i];
}

#
# Build a hash of the total score for each user, where score is the
# difference between the instructor's baseline op count and the
# student's op count.
#
foreach $userid (sort {$a <=> $b} keys %NOPS) {
    $score = 0;
    for ($i = 0; $i < $puzzlecnt; $i++) {
	$score += ($baseops[$i] - $NOPS{$userid}[$i]);
    }
    $SCORE{$userid} = $score;
}

#
# Open and lock the output Web page
# 
open(WEB, ">$webpage") 
    or log_die("Unable to open $webpage: $!");
flock(WEB, LOCK_EX)
    or log_die("Unable to lock $webpage: $!");

##################### 
# Print the Web page
#####################

my $title = "Scoreboard for the Data Lab \"Beat the Prof\" Contest";
print WEB start_html(-bgcolor => "white", -title => $title), "\n";
print WEB h2($title), "\n";

# 
# Don't display the scoreboard if the instructor hasn't submitted an
# entry to the contest yet
# 
if (!$RESULTS{$base_userid}) {
    print WEB "<p><font color=red>Warning:</font> The instructor ($base_userid) must submit an entry before the results of the contest can be displayed.</p>\n";
    print WEB "<p>To submit your instructor's entry: <kbd>linux> ./src/driver.pl -u \"The Prof\"</kbd></p>\n";
    print WEB end_html(), "\n";;
    close(WEB);
    exit(0);
}

print WEB <<"DONE";
<table width=$Contest::WIDTH_TEXTTABLE><tr><td>
This page shows the operator counts for the students who
have submitted entries to the Data Lab "Beat the Prof" contest. 
<ul> 
<li> To enter the contest, run the driver with the -u option: 
<kbd>./driver.pl -u "nickname"</kbd>.  
<li> Enter as often as you like. The page will show only your most recent submission.
<li> 
<font color='blue'>Blue entries match the instructor.</font>  
<font color='red'>Red entries beat the instructor.</font> 
Incorrect entries are denoted by "&mdash;".
<li> Entries are sorted by score, defined as 
(<i>total instructor operations</i> - <i>total student operations</i>). Higher scores are better.
<li> If all of your puzzle entries are correct and they each match or beat 
the instructor, then you're a <b>winner!</b>
</ul>
DONE

#
# Display the puzzle key
#
print WEB "<p>Puzzle key: ";
for ($i = 0; $i < $puzzlecnt-1; $i++) {
    print WEB $i+1, "=$puzzlename[$i], ";
}
print WEB "$puzzlecnt=$puzzlename[$i]";

#
# Display the last update time
#
print WEB "<p>Last updated: ", scalar localtime, " (updated every $Contest::UPDATE_PERIOD secs)<br>\n";

print WEB "</td></tr></table>\n"; # end text table
#
# Display the scoreboard headers
#
$cols = $puzzlecnt+3;
print WEB "<table border=0 cellspacing=1 cellpadding=1 cols=$cols>\n<p>\n";
print WEB "<tr align=\"center\">\n";

for ($i = 0; $i < $puzzlecnt; $i++) {
    print WEB "<td bgcolor=#cccccc width=$Contest::WIDTH_INTEGER><b>", $i+1, "</b></td>"
}
print WEB "<td bgcolor=#cccccc><b>&nbsp;Winner?&nbsp;</b></td>";
print WEB "<td bgcolor=#cccccc><b>&nbsp;Score&nbsp;</b></td>";
print WEB "<td bgcolor=#cccccc width=$Contest::WIDTH_USERID><b>Nickname</b></td>";
print WEB "</tr>\n";

#
# Sorting Hack: make sure that every student who matches the instructor's
# total score sorts above the instructor on the scoreboard.
#
$SCORE{$base_userid} = -0.5;

#
# Print each student's latest entry in descending order by total
# score, then by ascending order of submission time.
#
foreach $userid (sort {$SCORE{$b} <=> $SCORE{$a} ||         # Score
		       $RESULTS{$a}[7] <=> $RESULTS{$b}[7]} # Time
		 keys %SCORE) {
    $winners = 0;
    print WEB "<tr align = \"center\">\n";
    for ($i = 0; $i < $puzzlecnt; $i++) {
	$ops = $NOPS{$userid}[$i];

	# The instructor's score is a special case
	if ($userid eq $base_userid) {
	    print WEB "<td bgcolor=#eeeeee><font color=blue><b>$ops</b></font></td>";
	}
	# Handle the student's submissions
	else {
	    # This is an entry that meets or beats the instructor
	    if ($ops <= $baseops[$i]) {
		$winners++;
		$color = "blue";
		if ($ops < $baseops[$i]) { 
		    $color = "red";
		}
		print WEB "<td bgcolor=#eeeeee><font color=$color>$ops</font></td>";
	    }

	    # This is an entry that didn't beat the instructor
	    else {
		if ($ops == $BIGNUM) { # btest found an error
		    print WEB "<td bgcolor=#eeeeee>&mdash;</td>";
		}
		else {  # OK, but too many ops
		    print WEB "<td bgcolor=#eeeeee><i>$ops</i></td>";
		}
	    }
	}
    }

    # This user wins if all puzzles meet or beat the instructor's
    $iswinner = ($winners == $puzzlecnt and $userid ne $base_userid);
    $entry = "";
    if ($iswinner) {
	$entry = "<font color=red>Winner!</font>";
    }
    print WEB "<td bgcolor=#eeeeee>$entry</td>";
    
    # Undo the sorting hack and adjust the instructor's total score
    # back to zero
    if ($userid eq $base_userid) {
	$SCORE{$userid} = 0;
    }

    # Print the total score
    if ($SCORE{$userid} > $THRESHOLD) { # All puzzle solutions were correct
	print WEB "<td bgcolor=#eeeeee>$SCORE{$userid}</td>";
    } else { # One or more puzzle solutions were incorrect
	print WEB "<td bgcolor=#eeeeee>&mdash;</td>";
    }
    
    #  Print the user's nickname (truncated if necessary)
    $nickname = substr($RESULTS{$userid}[0], 0, $Contest::MAXCHARS_NICKNAME);
    if ($userid eq $base_userid) {
	print WEB "<td bgcolor=#eeeeee><font color=blue><b>$nickname</b></font></td>";
    }
    else {
	print WEB "<td bgcolor=#eeeeee>$nickname</td>";
    }
    print WEB "</tr>\n";
}


#
# Clean up and exit
#
print WEB "</table>\n"; # scoreboard table
print WEB end_html(), "\n";;
close(WEB);
exit(0);

#####
# End main routine
#

#####
# Helper functions
#

#
# read_logfile - Read logfile and make a suummarizing hash for each
# user. Each entry in the hash has the following form:
#
# RESULTS{userid} = [nickname, version, tpoints, cpoints, ppoints, 
#                    tops, rest-of-autoresult-string, submission time]
#
sub read_logfile {
    my $logfile = shift;

    my $linenum;
    my $line;
    my $hostname;
    my $date;
    my $userinfo;
    my $userid;
    my $login;
    my $result;
    my $status;
    my $nickname;
    my $version;
    my $tpoints;
    my $cpoints;
    my $ppoints;
    my $tops;
    my $rest;

    open(LOGFILE, $logfile) 
	or log_die("$0: Could not open $logfile: $!");
    flock(LOGFILE, LOCK_SH)
	or log_die("$0: Could not lock $logfile: $!");

     # Read log file and gather results for user 
    if ($verbose) {
	print "Reading log file.\n";
    }

    $linenum = 0;
    while ($line = <LOGFILE>) {
	$linenum++;
	chomp($line);
    
	# Skip blank lines
	if ($line eq "") {
	    next;
	}

	# Parse the input line 
	($hostname, $date, $userinfo, $version, $result) = 
	    split(/\|/, $line, 5);

	if (!$hostname or !$date or !$userinfo or !$result) {
	    next; # ignore any bad lines
	}

	# Extract the userid and nickname from the userinfo field
	($userid, $nickname) = split(/\:/, $userinfo, 2);
	$nickname = check_nickname($nickname);

	# Extract the point summaries and specific results
	($tpoints, $cpoints, $ppoints, $tops, $rest) = 
	    split(/\|/, $result, 5);

	#
	# Add the entry to the hash, possibly overwriting a previous
	# entry. Convert the ascii date string to Unix seconds.
	#
	$RESULTS{$userid} = [$nickname, $version, $tpoints, $cpoints, 
			     $ppoints, $tops, $rest, date2time($date)];
    }
    close(LOGFILE);

    if ($verbose) {
	print "Done reading log file.\n";
    }

}


#
# check_nickname - Check a nickname for legality. Return null nickname
# if there is any problem.
#
sub check_nickname {
    my $nickname = shift;

    if ((length($nickname) < 1) ||           # too short
	!($nickname =~ /^[_-\w.,'@ ]+$/) ||  # illegal character
	($nickname =~ /^\s*$/)) {            # all white space
	return "---";
    }
    return $nickname;
}
    
#
# usage - print help message and terminate
#
sub usage 
{
    my $msg = shift;

    if ($msg) {
	printf STDERR "$0: ERROR: $msg\n";
    }

    printf STDERR "Usage: $0 [-h\n";
    printf STDERR "Options:\n";
    printf STDERR "  -h    Print this message\n";
    die "\n";
}

