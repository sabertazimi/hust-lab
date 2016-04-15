#!/usr/bin/perl
#######################################################################
#
# buflab-update.pl - CS:APP Buffer Lab Web updater
#
# Copyright (c) 2003-2011, R. Bryant and D. O'Hallaron.
#
#######################################################################

use strict 'vars';
use Getopt::Std;
use Fcntl qw(:DEFAULT :flock);
use Cwd;

use lib ".";
use Buflab;

# Generic settings
$| = 1;      # Autoflush output on every print statement

#
# Initialization of constants
#
my $RESULT_VALID   = 2;
my $RESULT_INVALID = 1;
my $UNTRIED        = 0;
my $TESTER_TIMEOUT = 6;
my $MAX_LEVEL      = 4;
my $BINDIR         = $Buflab::BOMBSRC;
my $MAXSTRLEN      = 4096;

my $handindir   = $Buflab::HANDINDIR;
my $logfile     = $Buflab::LOGFILE;
my $gradefile   = $Buflab::SCOREFILE;
my $webpage     = $Buflab::SCOREBOARDPAGE;

my @scores = ( 10, 10, 15, 20, 10);
my @keywords   = ("Smoke", "Fizz", "Bang", "Boom", "KABOOM");
my @levelnames = ("Candle", "Sparkler", "Firecracker", "Dynamite", "Nitro");

my %HIST = ();
my %RESULTS = ();
my %COOKIES = ();
my %RANKINGS = ();

#
# Other variables
#
my $ignored;

#
# Create a clean handin directory that will contain the exploit strings
# and reports for each user 
#
system("(rm -rf $handindir; mkdir $handindir)") == 0 
    or log_die("Unable to create new $handindir");

#
# If there is no log file yet, create an empty one
#
if (!-e $logfile) {
    system("touch $logfile") == 0
		or log_die("Unable to create empty logfile");
    exit(0);
} 

#
# Scan the log file and store a complete record of the most recent exploit
# strings for each user in the HIST hash.
#
my %HIST = read_logfile($logfile);

#
# Run each solution to see whether it passes...
#

foreach my $userid ( keys %HIST ) {
    for (my $level = 0; $level <= $MAX_LEVEL; $level++ ) {
		my $timesecs = $HIST{$userid}[$level][0];
		my $cookie   = $HIST{$userid}[$level][1];
		my $string   = $HIST{$userid}[$level][2];
		
		# ignore if student has not submitted anything for this level
		if (!defined($HIST{$userid}[$level][0])) {
			$RESULTS{$userid}[$level] = $UNTRIED;
			next;
		}    

		#
		# Step 1: Store exploit string
		#
		open(STRINGFILE, ">$handindir/$userid-$level-exploit.txt")
			or log_die("Couldn't open $handindir/$userid-$level-exploit.txt for writing");
		print STRINGFILE $string;
		close STRINGFILE;
		
		#
		# Step 2: Compute what the cookie should be
		#
		my $realcookie = `$BINDIR/makecookie $userid`;
		chomp($realcookie);
		$realcookie =~ s/\n//g; # remove any trailing newlines
		$realcookie =~ s/0x//;  # remove 0x from the beginning
		$COOKIES{$userid} = $realcookie;

		#
		# Step 3: Run the exploit
		#
		my $outcome;
		my $evalstring;
		if ( $level < $MAX_LEVEL ) {
			# normal mode
			$evalstring = "$BINDIR/hex2raw < $handindir/$userid-$level-exploit.txt | $BINDIR/bufbomb -g -u $userid";
		}
		else {
			# nitro mode
			$evalstring = "$BINDIR/hex2raw -n < $handindir/$userid-$level-exploit.txt | $BINDIR/bufbomb -g -n -u $userid";
		}
		eval {
			local $SIG{ALRM} = sub { log_die "Tester timed out." };
			alarm $TESTER_TIMEOUT;
			$outcome = `$evalstring`;
			alarm 0;
		};

		#
		# Step 4: Check for timeout
		#

		# Each most recently submitted exploit string gets a report file
		# in the handin directory with information about the results 
		# of the evaluation that the instructor can look at.

		my $reportfile = "$handindir/$userid-$level-report.txt";
		open( REPORTFILE, ">$reportfile" )
			or log_die("Couldn't open report file $reportfile");

		if ($@)	{ # timeout case
			# Tester timeout!
			kill_zombies(); 

			# FAILED!
			$RESULTS{$userid}[$level] = $RESULT_INVALID;

			# Update the report the report file
			print REPORTFILE "$BINDIR/bufbomb timed out on $levelnames[$level].\n";
		}

		else {  # no-timeout case
			#
			# Step 5: Check results against what we should get on success
			#
			if (hex($realcookie) == hex($cookie)
				&& $outcome =~ /VALID/
				&& !($outcome =~ /Better luck next time/)
				&& $outcome =~ $keywords[$level]) {

				# SUCCESS!
				if (!defined($RESULTS{$userid}[$level])) {
					# Update ranking and time of solved...
					$RANKINGS{$userid}[0]++;
					if ( $RANKINGS{$userid}[1] < $timesecs ) {
						$RANKINGS{$userid}[1] = $timesecs;
					}
				}
				$RESULTS{$userid}[$level] = $RESULT_VALID;

				# Update the report file
				print REPORTFILE 
					"Exploit string ./$userid-$level-exploit.txt passed.\n";
				print REPORTFILE
					"Here is the output from bufbomb:\n-----\n", 
					$outcome;
			}

            # FAILED!
			else { 
				if (!defined( $RANKINGS{$userid})) {
					$RANKINGS{$userid}[0] = 0;
					$RANKINGS{$userid}[1] = $timesecs;
				}

				$RESULTS{$userid}[$level] = $RESULT_INVALID;
				
				print REPORTFILE 
					"Exploit string ./$userid-$level-exploit.txt failed.\n";

				# Try to add some information about error.
				if (hex($realcookie) != hex($cookie)) {
					print REPORTFILE
						"Cookie for $userid should be $realcookie, not $cookie\n";
				}
				elsif (!($outcome =~ /accepted/)) {
					print REPORTFILE 
						"Failed test for level $levelnames[$level]\n";
				}
				elsif (!($outcome =~ $keywords[$level])) {
					print REPORTFILE 
						"Passed, but not for level $levelnames[$level]\n";
				}

				# Print the output from the buffer bomb
				print REPORTFILE
					"Here is the output from bufbomb:\n-----\n", 
					$outcome;
			} # failure case
		} # end of no-timeout case

		# Close the report file this user and level
		close REPORTFILE;

    } # end foreach level

} # end foreach user

#
# Generate the grade file for each student.
#

open(GRADES, ">$gradefile")
    or log_die("Unable to open output gradefile $gradefile: $!");
flock(GRADES, LOCK_EX)
    or log_die("Unable to lock $gradefile: $!");

foreach my $userid ( sort keys %RESULTS) {
    print GRADES "$userid";
    print GRADES "\t";
    print GRADES $COOKIES{$userid};
    print GRADES "\t";
    print GRADES compute_score($userid);
    print GRADES "\n";
}

close GRADES;

#
# Generate HTML report page. Once again, this is so heavily dependent
# on the structure of the lab that I hardcode the structure.
#

#
# Open and lock the output Web page
#
open(WEB, ">$webpage")
    or log_die("Unable to open $webpage: $!");
flock(WEB, LOCK_EX)
    or log_die("Unable to lock $webpage: $!");


#
# Emit the basic header information
#

print_webpage_header();

# 
# Sort students first in descending order by number of phases defused, 
# then in ascending order by time of latest valid submission.
#     RANKINGS{$userid}[0] stores the number of phases defused
#     RANKINGS{$userid}[1] stores the time of the latest valid submission
#

my $num_students = 0;
my @valid_submissions = (0, 0, 0, 0, 0);

foreach my $userid (sort {$RANKINGS{$b}[0] <=> $RANKINGS{$a}[0] ||
							  $RANKINGS{$a}[1] <=> $RANKINGS{$b}[1] ||
							  $a <=> $b}
					keys %RANKINGS) {
    $num_students++;

    my $cookie = $COOKIES{$userid};
    my $total_score = compute_score($userid);

    # Print the aggregate info for this userid
    print WEB "<tr bgcolor=$Buflab::LIGHT_GREY align=center>\n";
    print WEB "<td align=right>$num_students</td>\n";
    print WEB "<td align=center>$cookie</td>\n";
    print WEB "<td align=right>$total_score</td>\n";

    # Print the results of each phase for this userid
    for (my $level = 0; $level <= $MAX_LEVEL; $level++) {
		print WEB "<td>";

        # Must be UNTRIED, RESULT_VALID, or RESULT_INVALID
		my $valid = $RESULTS{$userid}[$level]; 
		
		if ($valid == $UNTRIED) {
			print WEB "-";
		}
		if ($valid == $RESULT_VALID) {
			print WEB "$scores[$level]";
			$valid_submissions[$level]++;
		}
		if ( $valid == $RESULT_INVALID) {
			print WEB "<font color=red><b>Invalid</b>";
		}
		print WEB "</td>\n";
    }
    print WEB "</tr>\n";
}

#
# Print class statistics
#
print WEB <<HTML;
</table>
<p>
$num_students students.
<br>
Valid submissions:
Level 0: $valid_submissions[0],
Level 1: $valid_submissions[1],
Level 2: $valid_submissions[2],
Level 3: $valid_submissions[3],
Level 4: $valid_submissions[4]
<p>

</body>
</html>
HTML


close(WEB);

# That's a wrap
exit(0);

##################
# Helper functions
##################

#
# read_logfile - Scan log file and extract the most recent submission for
# each combination of userid and level. 
#
# On exit, for each userid and level:
#     HIST{$userid}[$level][0] = time of most recent submission
#     HIST{$userid}[$level][1] = cookie
#     HIST{$userid}[$level][2] = exploit string
#
sub read_logfile {
    my $logfile = shift;
    
    my $linenum;
    my $line;
    my $hostname;
    my $time;
    my $timesecs;
    my $userid;
    my $pwd;
    my $resultstr;
    my $level;
    my $cookie;
    my $string;
    my $cnt;
    my $status;

    my %HIST = ();
    
    open(LOGFILE, $logfile) 
		or log_die("Couldn't open logfile $logfile: $!");
    flock(LOGFILE, LOCK_SH)
		or log_die("Couldn't lock logfile $logfile: $!");
    
    $cnt = 0;
    $linenum = 0;
    while ($line = <LOGFILE>) {
		$linenum++;
		chomp($line);

		# Skip blank lines
		if ($line eq "") {
			next;
		}
		
		# Parse the input line, each field separated by a '|'
		$line =~ /(.*)\|(.*)\|(.*)\|(.*)\|(.*)/;
		$time = $2;
		$userid = $3;
		$resultstr = $5;	
		
		if (!$time or !$userid or !$resultstr) {
			next;
		}

		# Parse the result field from the bufbomb client
		($level, $cookie, $string) = split(/:/, $resultstr, 3);
		chomp($cookie);
		if (($level < 0) or ($level > $MAX_LEVEL)) {
			log_die("Bad level in line $linenum. Ignored");
			next;
		}
		if (length($string) > $MAXSTRLEN) {
			log_die("Input string too long in line $linenum. Ignored");
			next;
		}

        $timesecs = date2time($time);
		$HIST{$userid}[$level] = [$timesecs, $cookie, $string];
    }
    
    close(LOGFILE);
    return %HIST;
}

# 
# print_webpage_header - Print the header for the Web page
#
sub print_webpage_header {
    my $title = "Buffer Lab Scoreboard";
    my $max_score = 0;

print WEB "
<html>
<head>
<title>$title</title>
</head>
<body bgcolor=ffffff>

<table width=650><tr><td>
<h2>$title</h2>
<p>
Here is the latest information that we have received from your buffer
bomb. If your submission is marked as <font
color=red><b>invalid</b></font>, then the testing code
thinks your solution is invalid.  Some possible reasons are:
<ul>
<li>
Your solution is not sufficiently robust, a good
possibility at the nitroglycerin level.  Try to design your exploit to be
more tolerant of fluctuations in the stack position.

<li>You somehow bypassed the protocol used by our autograding service. 
</td></tr></table>
";
print WEB "Last updated: ", scalar localtime, 
   " (updated every $Buflab::UPDATE_PERIOD secs)<br>\n";

print WEB "
<p>
<table border=0 cellspacing=1 cellpadding=1>
<tr bgcolor=$Buflab::DARK_GREY align=center>
<th align=center> <b>#</b> </th>
<th align=center width=80> <b>Cookie</b> </th>
";

    for ( my $i = 0; $i <= $MAX_LEVEL; $i++ ) {
		$max_score += $scores[$i];
    }
    
    # print maximum total score
    print WEB "<th align=center width=60><strong>Score<br>($max_score)</strong></th>\n";

    for (my $i = 0; $i <= $MAX_LEVEL; $i++ ) {
		# print maximum score for each level
		print WEB "<th align=center width=80><strong>$levelnames[$i]<br>($i: $scores[$i]pt)</strong></th>\n";
    }

    print WEB "</tr>";
}


#
# kill_zombies - Even though a test case may time out, the process
# that was created for it is still on the system. This function clears
# out any bufbomb processes that are currently running.
#
sub kill_zombies
{
    my $ps_output = `ps -e -f | grep bufbomb`;
    my @processes = split(/\n/, $ps_output);

    foreach my $process (@processes) {
		# the first output field is the user
		# the next is the PID
		if ( $process =~ m/^\S+\s+(\d+).*/ ) {
			system("kill $1");
		}
    }
}


#
# compute_score - Compute total scores from valid solutions.
#

sub compute_score
{

    my $userid = shift;
    my $total = 0;

    for (my $i = 0; $i <= $MAX_LEVEL; $i++ ) {
		if ( $RESULTS{$userid}[$i] == $RESULT_VALID ) {
			$total +=  $scores[$i];
		}
    }
    return $total;
}

