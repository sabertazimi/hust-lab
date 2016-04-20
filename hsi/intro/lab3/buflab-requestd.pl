#!/usr/bin/perl
require 5.002;

#####################################################################
# buflab-requestd.pl - The CS:APP Buffer Bomb Request Daemon
#
# Copyright (c) 2003-2011, R. Bryant and D. O'Hallaron
#
# The request daemon is a simple special purpose HTTP server that
# allows students to use their Web browser to request buffer bombs 
# and to view the realtime scoreboard.
#
# Students request a bomb by pointing their browser at
#
#     http://$SERVER_NAME:$REQUESTD_PORT
#
# The server  builds the buffer bomb and tars it up (if necessary) 
# and returns the tar file to the browser.
#
# Students check the realtime scoreboard by pointing their browser at
#
#    http://$SERVER_NAME:$REQUESTD_PORT/scoreboard
#
#####################################################################

use strict 'vars';
use Getopt::Std;
use Socket;
use Sys::Hostname; 

use lib ".";
use Buflab;

# 
# Generic settings
#
$| = 1;          # Autoflush output on every print statement
$0 =~ s#.*/##s;  # Extract the base name from argv[0] 

# 
# Ignore any SIGPIPE signals caused by the server writing 
# to a connection that has already been closed by the client
#
$SIG{PIPE} = 'IGNORE'; 

#
# Configuration variables 
#
my $server_port = $Buflab::REQUESTD_PORT;
my $handoutdir = $Buflab::HANDOUTDIR;

#
# Other variables 
#
my ($server_dname, $client_port, $client_dname, $client_iaddr);
my $request_hdr;
my $content;
my $item;
my $tarfilename;
my $buffer;

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

#
# Print a startup message
#
$server_dname = hostname();
log_msg("Request server started on $server_dname:$server_port");

#
# Make sure the files and directories we need are available
#
(-e $Buflab::MAKEBOMB and -x $Buflab::MAKEBOMB)
    or log_die("Error: Couldn't find an executable $Buflab::MAKEBOMB script.");

#
# Establish a listening descriptor
# 
socket(SERVER, PF_INET, SOCK_STREAM, getprotobyname('tcp'))
    or log_die("socket: $!");
setsockopt(SERVER, SOL_SOCKET, SO_REUSEADDR, 1)
    or log_die("setsockopt: $!");
bind(SERVER, sockaddr_in($server_port, INADDR_ANY))
    or log_die("Couldn't bind to port $server_port: $!");
listen(SERVER, SOMAXCONN)     
    or log_die("listen: $!");

#
# Repeatedly wait for scoreboard and bomb requests
#
while (1) {

    # 
    # Wait for a connection request from a client
    #
    my $client_paddr = accept(CLIENT, SERVER)
		or die "accept: $!\n";
    ($client_port, $client_iaddr) = sockaddr_in($client_paddr);
    $client_dname = gethostbyaddr($client_iaddr, AF_INET);

    # 
    # Read the request header (the first text line in the request)
    #
    $request_hdr = <CLIENT>;
    chomp($request_hdr);

    #
    # Ignore requests for favicon.ico
    #
    # NOTE: To avoid memory leak, be careful to close CLIENT fd before 
    # each "next" statement in this while loop.
    #
    if ($request_hdr =~ /favicon/) {
		#log_msg("Ignoring favicon request");
		close CLIENT; 
		next;         
    }

    #
    # If this is a scoreboard request, then simply return the scoreboard
    #
    if ($request_hdr =~ /\/scoreboard/) {
		$content = "No scoreboard yet...";
		if (-e $Buflab::SCOREBOARDPAGE) {
			$content = `cat $Buflab::SCOREBOARDPAGE`;
		}
		sendcontent($content);
    }

    # Otherwise, we interpret this as a bomb request.  So build the
    # bomb, tar it up, and transfer it back over the connection to the
    # client.

    else {
		log_msg ("Bomb request from $client_dname");

        # Build a new handout directory
		system("./$Buflab::MAKEBOMB", "-n", "-q") == 0 
			or log_die "ERROR: Couldn't make $handoutdir\n";
		log_msg("Made new $handoutdir directory");

		# Tar up the handout directory
		$tarfilename = "$handoutdir.tar";
		system("(tar cf - $handoutdir > $tarfilename)") == 0 
			or die "ERROR: Couldn't create $tarfilename\n";
		
		#
		# Now send the tarfile across the connection to the client
		#
		print CLIENT "HTTP/1.1 200 OK\r\n";
		print CLIENT "Connection: close\r\n";
		print CLIENT "MIME-Version: 1.0\r\n";
		print CLIENT "Content-Type: application/x-tar\r\n";
		print CLIENT "Content-Disposition: file; filename=\"$tarfilename\"\r\n";
		print CLIENT "\r\n"; 
		open(INFILE, "$tarfilename")
			or die "ERROR: Couldn't open $tarfilename\n";
		binmode(INFILE, ":raw");
		binmode(CLIENT, ":raw");
		select((select(CLIENT), $| = 1)[0]);
		while (sysread(INFILE, $buffer, 1)) {
			syswrite(CLIENT, $buffer, 1);
		}
		close(INFILE);
		
		# 
		# Log the successful delivery of the bomb to the browser
		#
		log_msg ("Sent buffer bomb to $client_dname.");
		
    } # if-then-elsif-else statement

    #
    # Close the client connection after each request/response pair
    #
    close CLIENT;

} # while loop

exit;

###################
# Helper functions
##################

#
# void usage(void) - print help message and terminate
#
sub usage 
{
    printf STDERR "$_[0]\n";
    printf STDERR "Usage: $0 [-hq]\n";
    printf STDERR "Options:\n";
    printf STDERR "  -h   Print this message.\n";
    printf STDERR "  -q   Quiet. Send all messages to $Buflab::STATUSLOG instead of tty.\n";
    die "\n" ;
}

#
# void sendcontent(char *content) - Sends content to the client
#
sub sendcontent
{
    my $content = $_[0];
    my $contentlength = length($content);
    print CLIENT "HTTP/1.0 200 OK\r\n";
    print CLIENT "MIME-Version: 1.0\r\n";
    print CLIENT "Content-Type: text/html\r\n";
    print CLIENT "Content-Length: $contentlength\r\n";
    print CLIENT "\r\n"; 
    print CLIENT $content;
}

