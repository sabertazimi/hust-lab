/*
 * config.h - configuration info for the bomb's notification
 *
 */
#define MAXHOSTNAMELEN 1024

/*
 * We don't want copies of bombs from all over the world contacting 
 * our server, so restrict bomb execution to one of the machines on 
 * the following NULL-terminated list:
 */
char *host_table[MAXHOSTNAMELEN] = {

    "bluefish.ics.cs.cmu.edu",
    "angelshark.ics.cs.cmu.edu",
    "greatwhite.ics.cs.cmu.edu",
    "makoshark.ics.cs.cmu.edu",

    0 /* The zero terminates the list */
};






