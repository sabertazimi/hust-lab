/* Buffer procedures used by buffer bomb */

/* Function declarations */
char *Gets(char *);

/* $begin getbuf-c */
/* Buffer size for getbuf */
#define NORMAL_BUFFER_SIZE 32

/* $end getbuf-c */

/* $begin kaboom-c */
/* Buffer size for getbufn */
#define KABOOM_BUFFER_SIZE 512

/* $end kaboom-c */

/*
 * getbuf - Has the buffer overflow bug exploited by levels 0-3
 */
/* $begin getbuf-c */
int getbuf()
{
    char buf[NORMAL_BUFFER_SIZE];
    Gets(buf);
    return 1;
}
/* $end getbuf-c */

/* 
 * getbufn - Has the buffer overflow bug exploited by level 4.
 */
/* $begin kaboom-c */
int getbufn()
{
    char buf[KABOOM_BUFFER_SIZE];
    Gets(buf);
    return 1;
}
/* $end kaboom-c */
