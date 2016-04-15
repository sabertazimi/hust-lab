#!/usr/bin/perl 
#!/usr/local/bin/perl 
use Getopt::Std;
use Cwd;
use lib ".";
use config;

#########################################################################
# grade-datalab.pl - Data Lab autograder
#
# Copyright (c) 2002-2011, R. Bryant and D. O'Hallaron.
#
# This program automatically grades a Data Lab handin bits.c file and 
# prints a report on stdout that can be handed back to the students. 
#
# Example usage:
#     unix> ./grade-datalab.pl -f bovik-bits.c
# 
#########################################################################

$| = 1; # autoflush output on every print statement

# Any files created by this script are readable only by the user
umask(0077); 

#
# usage - print help message and terminate
#
sub usage {
    printf STDERR "$_[0]\n";
    printf STDERR "Usage: $0 [-he] -f <filename> [-s <srcdir>]\n";
    printf STDERR "Options:\n";
    printf STDERR "  -h           Print this message.\n";
    printf STDERR "  -f <file>    C file to be graded.\n";
    printf STDERR "  -s <srcdir>  Location of directory with support code\n";
    printf STDERR "  -e           Don't include the original handin file on the grade sheet\n";
    die "\n";
}

##############
# Main routine
##############

# 
# Parse the command line arguments
#
getopts('hef:s:');
if ($opt_h) {
    usage();
}
if ((!$opt_f)) {
    usage("Missing required argument (-f)");
}

# 
# These optional flags override defaults in config.pm
#
if ($opt_s) {         # driver src directory
    $SRCDIR = $opt_s;
}

# 
# Initialize some file and path names
#
$infile = $opt_f;                         # input C file
($infile_basename = $infile) =~ s#.*/##s; # basename of input file

# absolute pathname of src directory
$srcdir_abs = `cd $SRCDIR; pwd`; 
chomp($srcdir_abs);

$tmpdir = "/var/tmp/$infile_basename.$$";        # scratch directory
$0 =~ s#.*/##s;                                  # this prog's basename

# 
# This is a message we use in several places when the program dies
#
$diemsg = "The files are in $tmpdir.";

# 
# Make sure the input file exists and is readable
#
open(INFILE, $infile) 
    or die "$0: ERROR: could not open file $infile\n";
close(INFILE);

#
# Make sure the driver program exists and is executable
# 
(-e "$srcdir_abs/driver.pl" and -x "$srcdir_abs/driver.pl")
    or  die "$0: ERROR: No executable driver.pl program in $srcdir_abs.\n";


# 
# Set up the contents of the scratch directory
#
system("mkdir $tmpdir");

# Source file to be graded
system("cp $infile $tmpdir/bits.c") == 0
    or die "ERROR: Unable to copy $infile to $tmpdir.";

# Autograding tools
system("cp $srcdir_abs/driver.pl $tmpdir") == 0
    or die "ERROR: Unable to copy $srcdir_abs/driver.pl to $tmpdir.";
system("cp $srcdir_abs/Driverlib.pm $tmpdir") == 0
    or die "ERROR: Unable to copy $srcdir_abs/Driverlib.pm to $tmpdir.";
system("cp $srcdir_abs/Driverhdrs.pm $tmpdir") == 0
    or die "ERROR: Unable to copy $srcdir_abs/Driverhdrs.pm to $tmpdir.";
system("cp $srcdir_abs/dlc $tmpdir") == 0       
    or die "ERROR: Unable to copy $srcdir_abs/dlc to $tmpdir.";
system("cp $srcdir_abs/btest.c $tmpdir") == 0
    or die "ERROR: Unable to copy $srcdir_abs/btest.c to $tmpdir.";
system("cp $srcdir_abs/decl.c $tmpdir") == 0
    or die "ERROR: Unable to copy $srcdir_abs/decl.c to $tmpdir.";
system("cp $srcdir_abs/tests.c $tmpdir") == 0
    or die "ERROR: Unable to copy $srcdir_abs/tests.c to $tmpdir.";
system("cp $srcdir_abs/btest.h $tmpdir") == 0
    or die "ERROR: Unable to copy $srcdir_abs/btest.h to $tmpdir.";
system("cp $srcdir_abs/bits.h $tmpdir") == 0
    or die "ERROR: Unable to copy $srcdir_abs/bits.h to $tmpdir.";
system("cp $srcdir_abs/Makefile-handout $tmpdir/Makefile") == 0
    or die "ERROR: Unable to copy $srcdir_abs/Makefile-handout to $tmpdir.";

# Print header
print "\nCS:APP Data Lab: Grading Sheet for $infile_basename\n\n";

#
# Run the driver in the scratch directory
#
$cwd = getcwd(); 
chdir($tmpdir) 
    or die "ERROR: Unable to switch to scratch directory $tmpdir\n";
system("./driver.pl") == 0
    or die "ERROR: Unable to run driver.";
chdir($cwd) 
    or die "ERROR: Unable to switch back to current working directory\n";

#
# Print the grade summary template that the instructor fills in
#
print "\nPart 4: Grade\n\n";
print "Correctness: \t\t     / $MAXCORR\n\n";
print "Performance: \t\t     / $MAXPERF\n\n";
print "Coding Style:\t\t     / $MAXSTYLE\n\n";
print "             \t\t__________\n\n";
print "Total:       \t\t     / ", $MAXCORR+$MAXPERF+$MAXSTYLE, "\n";   

# 
# Optionally print the original handin file 
#
if (!$opt_e) {
  print "\f\nPart 5: Original $infile file\n\n";
  system("cat $infile") == 0
    or die "ERROR: Unable to print $infile.";
}

#
# Everything went OK, so remove the scratch directory
#
system("rm -fr $tmpdir");
exit;


