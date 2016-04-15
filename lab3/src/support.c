/*
 * support.c - Helper functions for the buffer bomb autograding service
 */
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include "support.h"
#include "gencookie.h"
#include "config.h"
#include "driverlib.h"


/* Globals defined in bufbomb.c  */
extern char gets_buf[]; /* the exploit string */
extern char *userid;    /* userid of person submitting the string */
extern unsigned cookie; /* cookie generated from userid */
extern int success;     /* indicates success of exploit back to bufbomb */
extern int notify;      /* should the bomb send each exploit string to a server */
extern int autograde;   /* should bomb run in autograde mode and set timeout */

/* Globals private to support.c */
#define NUM_LEVELS 5

static int level_counts[NUM_LEVELS] = {1,1,1,1,5}; /* counts for each level */

/* 
 * intialize_bomb - If this is a notifying bomb, make sure we are
 * running on a legal machine and can talk to the server.
 */
void initialize_bomb(void)
{
    int i;
    char hostname[MAXHOSTNAMELEN];
    char status_msg[SUBMITR_MAXBUF];
    int valid_host = 0;
    
	/* Set up the time out condition to the default AUTOGRADE_TIMEOUT
	   to guard against infinite loops during autograding (-g option) */
	if (autograde) {
		init_timeout(-1);
	}

    if (notify) {
		/* Get the host name of the machine */
		if (gethostname(hostname, MAXHOSTNAMELEN) != 0)	{
			printf("initialize_bomb: Could not get hostname of this machine\n");
			exit(8);
		}
	
		/* Make sure this host is in the list of legal machines */
		for (i = 0; host_table[i]; i++)	{
			if (strcasecmp(host_table[i], hostname) == 0) {
				valid_host = 1;
				break;
			}
		}

		if (!valid_host) {
			printf("initialize_bomb: Error: %s is not one of the legal hosts:\n", hostname);
			for (i = 0; host_table[i]; i++)	
				printf("%s\n", host_table[i]); 
			exit(8);
		}
	
		/* Initialize the driverlib package */
		if (init_driver(status_msg) < 0) {
			printf("initialize_bomb: %s\n", status_msg);
			exit(8);
		}

    }
}

/*
 * validate - Do some simple sanity checks and optionally report results 
 * to the grading server. 
 *
 * Note: Some students might try to avoid doing the assignment by
 * constructing an exploit string that simply jumps to the validate()
 * routine with a legal level stored on the stack.  This is a
 * vulnerability in the current autograding scheme that we haven't
 * completely solved. To be thorough, you should manually check that
 * exploit strings submitted by your students don't contain the
 * address of the validate() routine.
 */
void validate(int level)
{
    char autoresult[SUBMITR_MAXBUF];
    char status_msg[SUBMITR_MAXBUF];
    int status;

    /* Simple sanity checks */
    if (!userid) {
		printf("No userid indicated.  Results not validated\n");
		return;
    }
    if (level < 0 || level >= NUM_LEVELS) {
		printf("Invalid level.  Results not validated\n");
		return;
    }
    
    /* Let the caller know that the exploit succeeded */
    success = 1;
    
    /* Recall that nitro mode produces 5 exploit strings */
    if (--level_counts[level] > 0) {
		printf("Keep going\n");
    } 

    /* Passed, send exploit string to the autograding server  */
    else {
		printf("VALID\n");
		if(notify) {
			if (strlen(gets_buf) + 32 > SUBMITR_MAXBUF)	{
				printf("Warning: Input string too large. Results not validated\n");
				return;
			}
			sprintf(autoresult, "%d:%x:%s", level, cookie, gets_buf);
			status = driver_post(userid, autoresult, 0, status_msg);
			if (status == 0) {
				printf("Sent exploit string to server to be validated.\n");
			}
			else {
				printf("Warning: Unable to send exploit string to grading server:\n%s\n", status_msg);
			}
		}

		/* Regardless, print a success message */
		printf("NICE JOB!\n");
    }
}

