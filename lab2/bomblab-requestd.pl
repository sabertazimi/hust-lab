#!/usr/bin/perl
require 5.002;

#######################################################################
# bomblab-requestd.pl - The CS:APP Binary Bomb Request Daemon
#
# Copyright (c) 2003-2011, R. Bryant and D. O'Hallaron
#
# The request daemon is a simple special purpose HTTP server that
# allows students to use their Web browser to request binary bombs 
# and to view the realtime scoreboard.
#
# Students request a bomb by pointing their browser at
#
#     http://$SERVER_NAME:$REQUESTD_PORT
#
# After they submit the resulting form with their personal
# information, the server builds a custom bomb for the student, tars
# it up and returns the tar file to the browser.
#
# Students check the realtime scoreboard by pointing their browser at
#
#    http://$SERVER_NAME:$REQUESTD_PORT/scoreboard
#
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

#
# Canned client error messages
#
my $bad_usermail_msg = "Invalid email address.";
my $bad_username_msg = "You forgot to enter a user name.";
my $usermail_taint_msg = "The email address contains an illegal character.";
my $username_taint_msg = "The user name contains an illegal character.";

#
# Configuration variables from Bomblab.pm
#
my $server_port = $Bomblab::REQUESTD_PORT;
my $labid = $Bomblab::LABID;
my $server_dname = $Bomblab::SERVER_NAME;

#
# Other variables 
#
my $notifyflag;
my ($client_port, $client_dname, $client_iaddr);
my $request_hdr;
my $content;
my ($usermail, $username);
my ($bombnum, $maxbombnum);
my $item;
my $tarfilename;
my $buffer;
my @bombs=();

##############
# Main routine
##############

# 
# Parse and check the command line arguments
#
no strict 'vars';
getopts('hsq');
if ($opt_h) {
    usage("");
}

$notifyflag = "-n";
if ($opt_s) {
    $notifyflag = "";
}

$Bomblab::QUIET = 0;
if ($opt_q) {
    $Bomblab::QUIET = 1;
}
use strict 'vars';

#
# Print a startup message
#
log_msg("Request server started on $server_dname:$server_port");

#
# Make sure the files and directories we need are available
#
(-e $Bomblab::MAKEBOMB and -x $Bomblab::MAKEBOMB)
    or log_die("Error: Couldn't find an executable $Bomblab::MAKEBOMB script.");

(-e $Bomblab::BOMBDIR)
    or system("mkdir ./$Bomblab::BOMBDIR");

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
# Repeatedly wait for scoreboard, form, and bomb requests
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
        if (-e $Bomblab::SCOREBOARDPAGE) {
            $content = `cat $Bomblab::SCOREBOARDPAGE`;
        }
        sendform($content);
    }

    # 
    # If there aren't any specific HTML form arguments, then we interpret
    # this as an initial request for an HTML form. So we build the 
    # form and send it back to the client.
    #

    elsif (!($request_hdr =~ /usermail=/)) {
        #log_msg("Form request from $client_dname");
        sendform(buildform($server_dname, $server_port, $labid, 
                           "", "", "", "", ""));
    }

    #
    # If this is a reset request, just send the client a clean form
    #
    elsif ($request_hdr =~ /reset=/) {
        #log_msg("Reset request from $client_dname");
        sendform(buildform($server_dname, $server_port, $labid, 
                           "", "", "", "", ""));
    }

    #  Otherwise, since it's not a reset (clean form) request and the
    # URI contains a specific HTML form argument, we interpret this as
    # a bomb request.  So we parse the URI, build the bomb, tar it up,
    # and transfer it back over the connection to the client.

    else {
        

        #
        # Undo the browser's URI translations of special characters
        #
        $request_hdr =~ s/%25/%/g;  # Do first to handle %xx inputs

        $request_hdr =~ s/%20/ /g; 
        $request_hdr =~ s/\+/ /g; 
        $request_hdr =~ s/%21/!/g;  
        $request_hdr =~ s/%23/#/g;  
        $request_hdr =~ s/%24/\$/g; 
        $request_hdr =~ s/%26/&/g;  
        $request_hdr =~ s/%27/'/g;    
        $request_hdr =~ s/%28/(/g;    
        $request_hdr =~ s/%29/)/g;    
        $request_hdr =~ s/%2A/*/g;    
        $request_hdr =~ s/%2B/+/g;    
        $request_hdr =~ s/%2C/,/g;    
        $request_hdr =~ s/%2D/-/g;    
        $request_hdr =~ s/%2d/-/g;    
        $request_hdr =~ s/%2E/./g;    
        $request_hdr =~ s/%2e/./g;    
        $request_hdr =~ s/%2F/\//g;    

        $request_hdr =~ s/%3A/:/g;    
        $request_hdr =~ s/%3B/;/g;    
        $request_hdr =~ s/%3C/</g;    
        $request_hdr =~ s/%3D/=/g;    
        $request_hdr =~ s/%3E/>/g;    
        $request_hdr =~ s/%3F/?/g;    

        $request_hdr =~ s/%40/@/g;

        $request_hdr =~ s/%5B/[/g;
        $request_hdr =~ s/%5C/\\/g;
        $request_hdr =~ s/%5D/[/g;
        $request_hdr =~ s/%5E/\^/g;
        $request_hdr =~ s/%5F/_/g;
        $request_hdr =~ s/%5f/_/g;

        $request_hdr =~ s/%60/`/g;

        $request_hdr =~ s/%7B/\{/g;
        $request_hdr =~ s/%7C/\|/g;
        $request_hdr =~ s/%7D/\}/g;
        $request_hdr =~ s/%7E/~/g;


        # Parse the request URI to get the user information
        $request_hdr =~ /username=(.*)&usermail=(.*)&/;
        $username = $1;
        $usermail = $2;

        #
        # For security purposes, make sure the form inputs contain only 
        # non-shell metacharacters. The only legal characters are spaces, 
        # letters, numbers, hyphens, underscores, at signs, and dots.
        #

        # email field
        if ($usermail ne "") {
            if (!($usermail =~ /^([\s-\@\w.]+)$/)) {
                log_msg ("Invalid bomb request from $client_dname: Illegal character in email address ($usermail):"); 
                sendform(buildform($server_dname, $server_port, $labid, 
                                   $usermail, $username, 
                                   $usermail_taint_msg));
                close CLIENT;
                next;
            }
        }

        # user name field
        if ($username ne "") {
            if (!($username =~ /^([\s-\@\w.]+)$/)) {
                log_msg ("Invalid bomb request from $client_dname: Illegal character in user name ($username):"); 
                sendform(buildform($server_dname, $server_port, $labid, 
                                   $usermail, $username, 
                                   $username_taint_msg));
                close CLIENT;
                next;
            }
        }

        # The user name field is also required. If it's not filled in,
        # or it's all blanks, then it's invalid
        if (!$username or $username eq "" or $username =~ /^ +$/) {
            log_msg ("Invalid bomb request from $client_dname: Missing user name:");

            sendform(buildform($server_dname, $server_port, $labid, 
                               $usermail, $username, 
                               $bad_username_msg)); 
            close CLIENT;
            next;
        }


        #
        # The user mail field is required. If it's not filled in,
        # or it's all blanks, or it doesn't have an @ sign, then it's invalid
        #
        if (!$usermail or $usermail eq "" or 
            $usermail =~ /^ +$/ or
            !($usermail =~ /\@/)) {
            log_msg ("Invalid bomb request from $client_dname: Invalid email address ($usermail):"); 
            sendform(buildform($server_dname, $server_port, $labid, 
                               $usermail, $username, 
                               $bad_usermail_msg));
            close CLIENT;
            next;
        }

        #
        # Everything checks out OK. So now we build and deliver the 
        # bomb to the client.
        # 
        log_msg ("Bomb request from $client_dname:$username:$usermail:");
        
        # Get a list of all of the bombs in the bomb directory
        opendir(DIR, $Bomblab::BOMBDIR) 
            or die "ERROR: Couldn't open $Bomblab::BOMBDIR\n";
        @bombs = grep(/bomb/, readdir(DIR)); 
        closedir(DIR);
        
        #
        # Find the largest bomb number, being careful to use numeric 
        # instead of lexicographic comparisons.
        #
        map s/bomb//, @bombs;
        $maxbombnum = 0;
        foreach $item (@bombs) {
            if ($item > $maxbombnum) {
                $maxbombnum = $item;
            }
        } 
        $bombnum = $maxbombnum + 1;
        
        #
        # Build a new bomb, being careful, for security reasons, 
        # to invoke the list version of system and thus avoid 
        # running a shell.
        #
        system("./$Bomblab::MAKEBOMB", "-q", "$notifyflag", "-l", "$labid", "-i", "$bombnum", "-b", "./$Bomblab::BOMBDIR", "-s", "./$Bomblab::BOMBSRC", "-u", "$usermail", "-v", "$username") == 0 
            or die "ERROR: Couldn't make bomb$bombnum\n";
        
        #
        # Tar up the bomb
        #
        $tarfilename = "bomb$bombnum.tar";
        system("(cd $Bomblab::BOMBDIR; tar cf - bomb$bombnum/README bomb$bombnum/bomb.c bomb$bombnum/bomb > $tarfilename)") == 0 
            or die "ERROR: Couldn't tar $tarfilename\n";
        
        #
        # Now send the bomb across the connection to the client
        #
        print CLIENT "HTTP/1.0 200 OK\r\n";
        print CLIENT "Connection: close\r\n";
        print CLIENT "MIME-Version: 1.0\r\n";
        print CLIENT "Content-Type: application/x-tar\r\n";
        print CLIENT "Content-Disposition: file; filename=\"$tarfilename\"\r\n";
        print CLIENT "\r\n"; 
        open(INFILE, "$Bomblab::BOMBDIR/$tarfilename")
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
        log_msg ("Sent bomb $bombnum to $client_dname:$username:$usermail:");
        
        # 
        # Remove the tarfile
        # 
        unlink("$Bomblab::BOMBDIR/$tarfilename")
            or die "ERROR: Couldn't delete $tarfilename: $!\n";

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
    printf STDERR "Usage: $0 [-hqs]\n";
    printf STDERR "Options:\n";
    printf STDERR "  -h   Print this message.\n";
    printf STDERR "  -s   Silent. Build bombs with NONOTIFY option.\n";
    printf STDERR "  -q   Quiet. Send error and status msgs to $Bomblab::STATUSLOG instead of tty.\n";
    die "\n" ;
}

#
# char *buildform(char *hostname, int port, char *labid, 
#                 char *usermail, char *username,
#                 *char *errmsg)
#
# This routine builds an HTML form as a single string.
# The <hostname,port> pair identifies the request daemon.
# The labid is the unique name for this instance of the Lab.
# The user* fields define the default values for the HTML form fields. 
# The errmsg is optional and informs users about input mistakes.
#
sub buildform 
{
    my $hostname = $_[0];
    my $port = $_[1];
    my $labid = $_[2];
    my $usermail = $_[3];
    my $username = $_[4];
    my $errmsg = $_[5];
    my $form = "";
    $form .= "<html><title>CS:APP Binary Bomb Request</title>\n";
    $form .= "<body bgcolor=white>\n";
    $form .= "<h2>CS:APP Binary Bomb Request</h2>\n";
    $form .= "<p>Fill in the form and then click the Submit button.</p>\n";
    $form .= "<p>Hit the Reset button to get a clean form.</p>\n";
    $form .= "<p>Legal characters are spaces, letters, numbers, underscores ('_'),<br>";
    $form .= "hyphens ('-'), at signs ('\@'), and dots ('.').</p>\n";
    $form .= "<form action=http://$hostname:$port method=get>\n";
    $form .= "<table>\n";
    $form .= "<tr>\n";
    $form .= "<td><b>User name</b><br><font size=-1><i>$Bomblab::USERNAME_HINT&nbsp;</i></font></td>\n";
    $form .= "<td><input type=text size=$Bomblab::MAX_TEXTBOX maxlength=$Bomblab::MAX_TEXTBOX name=username value=\"$username\"></td>\n";
    $form .= "</tr>\n";
    $form .= "<tr>\n";
    $form .= "<td><b>Email address</b></td>\n";
    $form .= "<td><input type=text size=$Bomblab::MAX_TEXTBOX maxlength=$Bomblab::MAX_TEXTBOX name=usermail value=\"$usermail\"></td>\n";
    $form .= "</tr>\n";
    $form .= "<tr><td>&nbsp;</td></tr>\n";
    $form .= "<tr>\n";
    $form .= "<td><input type=submit name=submit value=\"Submit\"></td>\n";
    $form .= "<td><input type=submit name=reset value=\"Reset\"></td>\n";
    $form .= "</tr>\n";
    $form .= "</table></form>\n";
    if ($errmsg and $errmsg ne "") {
        $form .= "<p><font color=red><b>$errmsg</b></font><p>\n";
    }
    $form .= "</body></html>\n";
    return $form;
}

#
# void sendform(char *form) - Sends a form to the client   
#
sub sendform
{
    my $form = $_[0];
    my $formlength = length($form);
    print CLIENT "HTTP/1.0 200 OK\r\n";
    print CLIENT "MIME-Version: 1.0\r\n";
    print CLIENT "Content-Type: text/html\r\n";
    print CLIENT "Content-Length: $formlength\r\n";
    print CLIENT "\r\n"; 
    print CLIENT $form;
}

