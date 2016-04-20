#!/usr/bin/perl
#######################################################################
# bomb-resultd.pl - The CS:APP binary bomb result server
#
# The result server is a simple, special-purpose HTTP server that
# collects real-time results from bombs that the students are
# defusing.  
#
# Copyright (c) 2011, R. Bryant and D. O'Hallaron.

#######################################################################
use strict 'vars';
use Getopt::Std;
use Socket;
use Sys::Hostname; 

use lib ".";
use Bomblab;

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

##############
# Main routine
##############
my $server_port = $Bomblab::RESULTD_PORT;
my $client_port;
my $client_iaddr;
my $client_dname;
my $server_dname;
my $request_hdr;
my $userid;
my $labid;
my $result;
my $date;
my $ps;


# 
# Parse and check the command line arguments
#
no strict 'vars';
getopts('hq');
if ($opt_h) {
    usage("");
}

$Bomblab::QUIET = 0;
if ($opt_q) {
    $Bomblab::QUIET = 1;
}

use strict 'vars';

#
# Print a startup message
#
$server_dname = hostname();
log_msg("Results server started on $server_dname:$server_port");

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
# Repeatedly wait for connection requests
#
while (1) {
    # 
    # Wait for a connection request from a client
    #
    my $client_paddr = accept(CLIENT, SERVER)
		or log_die("accept: $!");
    ($client_port, $client_iaddr) = sockaddr_in($client_paddr);
    $client_dname = lc(gethostbyaddr($client_iaddr, AF_INET));

    # 
    # Read the request header (the first text line in the request)
    #
    $request_hdr = <CLIENT>;
    chomp($request_hdr);

    # 
    # If request header is empty or too long, then ignore it
    #
    if ((length($request_hdr) > $Bomblab::MAXHDRLEN) or 
		(length($request_hdr) == 0)) {
		next;
    }

    
    #
    # Parse the name value pairs in the request header 
    #
    $request_hdr =~ /userid=(.*)&lab=(.*)&result=(.*)&/;
    $userid = decodeurl($1);
    $labid = decodeurl($2);
    $result = decodeurl($3);

    # 
    # Append the result string to the log file
    #
    unless (open(LOGFILE, ">>$Bomblab::LOGFILE")) {
		log_die("Error: Unable to open $Bomblab::LOGFILE for appending: $!");
    }
    $date = scalar localtime();
    print LOGFILE "$client_dname|$date|$userid|$labid|$result\n";
    close(LOGFILE);
    
    # 
    # Now send an HTTP response back to the client
    #
    print CLIENT "HTTP/1.0 200 OK\r\n";
    print CLIENT "Connection: close\r\n";
    print CLIENT "MIME-Version: 1.0\r\n";
    print CLIENT "Content-Type: text/plain\r\n\r\n";
    print CLIENT "OK";
    close(CLIENT);

} # while loop

exit(0);


###################
# Helper functions
##################


#
# decodeurl - Decode a URL encoded string
#
sub decodeurl {
    my $string = shift;

    # convert all '+' to ' '
    $string =~ s/\+/ /g;    

    # Convert %XX from hex numbers to ASCII 
    $string =~ s/%([0-9a-fA-F][0-9a-fA-F])/pack("c",hex($1))/eg; 
    return($string);
}

#
# void usage(void) - print help message and terminate
#
sub usage 
{
    printf STDERR "$_[0]\n";
    printf STDERR "Usage: $0 [-hq] [-p <port>]\n";
    printf STDERR "Options:\n";
    printf STDERR "  -h         Print this message.\n";
    printf STDERR "  -p <port>  Port to listen on for bomb results.\n";
    printf STDERR "  -q         Quiet. Send error and status msgs to $Bomblab::STATUSLOG instead of tty.\n";
    die "\n" ;
}

