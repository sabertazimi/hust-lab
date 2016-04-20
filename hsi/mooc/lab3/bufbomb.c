/* 
 * bufbomb.c - Bomb program that is solved using a buffer overflow attack 
 * 
 * Copyright (c) 2002, R. Bryant and D. O'Hallaron, All rights reserved.
 * May not be used, modified, or copied without permission.
 */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <unistd.h>
#include <setjmp.h>
#include <string.h>
#include <signal.h>
#include <alloca.h>
#include "gencookie.h"
#include "config.h"
#include <inttypes.h>
#include <sys/mman.h>

#define NEW_STACK_SIZE  (4096*4)

#ifdef __CYGWIN__
#include "getopt.h"
#endif

/* Binary code for HLT (halt) instruction */
#define HALT_INSTR 0xF4

#define KABOOM_CNT 5
#define NORMAL_CNT 1

FILE *infile = NULL;

int submit = NOTIFY;

int quiet = 0; 
unsigned hexformat = 0;

unsigned long long cookie = 0;
char *team = NULL;
int grade = 0;

int success = 0;

/**************************************************************************
The following is the part of the code students will actually look at.
They are put at the beginning of the file to make them easier to find
in the diassembly, and to make their locations more stable when other
parts of the code get modified.
**************************************************************************/

/* Forward pointers */
void entry_check(int);
void validate(int);
char *Gets(char *);
unsigned long long getbuf();

/* $begin smoke-c */
void smoke()
{
  entry_check(0);  /* Make sure entered this function properly */
  printf("Smoke!: You called smoke()\n");
  validate(0);
  exit(0);
}
/* $end smoke-c */

/* $begin fizz-c */
void fizz(int arg1, char arg2, long arg3, char* arg4, short arg5, short arg6, unsigned long long val)
{
  entry_check(1);  /* Make sure entered this function properly */
  if (val == cookie) {
	printf("Fizz!: You called fizz(0x%llx)\n", val);
	validate(1);
  } else {
	printf("Misfire: You called fizz(0x%llx)\n", val);
  }
  exit(0);
}
/* $end fizz-c */

/* $begin bang-c */
unsigned long long global_value = 0;

void bang(unsigned long long val)
{
  entry_check(2);  /* Make sure entered this function properly */
  if (global_value == cookie) {
	printf("Bang!: You set global_value to 0x%llx\n", global_value);
	validate(2);
  } else {
	printf("Misfire: global_value = 0x%llx\n", global_value);
  }
  exit(0);
}
/* $end bang-c */

/* $begin boom-c */
void test()
{
  unsigned long long val;
  volatile unsigned long long local = 0xdeadbeef;
  char* variable_length;
  entry_check(3);  /* Make sure entered this function properly */
  val = getbuf();
  if (val <= 40) {
	variable_length = alloca(val);
  }
  entry_check(3);
  /* Check for corrupted stack */
  if (local != 0xdeadbeef) {
	printf("Sabotaged!: the stack has been corrupted\n");
  }
  else if (val == cookie) {
	printf("Boom!: getbuf returned 0x%llx\n", val);
	if (local != 0xdeadbeef) {
	  printf("Sabotaged!: the stack has been corrupted\n");
	}
	validate(3);
  }
  else {
	printf("Dud: getbuf returned 0x%llx\n", val);
  }
}
/* $end boom-c */

/* $begin getbuf-c */
unsigned long long getbuf()
{
  char buf[36];
  volatile char* variable_length;
  int i;
  unsigned long long val = (unsigned long long)Gets(buf);
  variable_length = alloca((val % 40) < 36 ? 36 : val % 40);
  for(i = 0; i < 36; i++)
  {
	variable_length[i] = buf[i];
  }
  return val % 40;
}
/* $end getbuf-c */

/* /\* $begin kaboom-c *\/ */
/* int getbufn() */
/* { */
/*     char buf[512]; */
/*     Gets(buf); */
/*     return 1; */
/* } */
/* /\* $end kaboom-c *\/ */

/* void testn() */
/* { */
/*     int val; */
/*     volatile int local = 0xdeadbeef; */
/*     entry_check(4);  /\* Make sure entered this function properly *\/ */
/*     val = getbufn(); */
/*     /\* Check for corrupted stack *\/ */
/*     if (local != 0xdeadbeef) { */
/* 	printf("Sabotaged!: the stack has been corrupted\n"); */
/*     } */
/*     else if (val == cookie) { */
/* 	printf("KABOOM!: getbufn returned 0x%x\n", val); */
/* 	validate(4); */
/*     } */
/*     else { */
/* 	printf("Dud: getbufn returned 0x%x\n", val); */
/*     } */
/* } */


/* Like gets, except that can optionally (when hexformat nonzero)
   accept format where characters are typed as pairs of hex digits.
   Nondigit characters are ignored.  Stops when encounters newline.
   In addition, it stores the string in global buffer gets_buf
*/
#define GETLEN 1024
static char gets_buf[3*GETLEN+1];
int gets_cnt = 0;

static char trans_char[16] = 
  {'0', '1', '2', '3', '4', '5', '6', '7', 
   '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

static void save_char(char c) {
  if (gets_cnt < GETLEN) {
	gets_buf[3*gets_cnt] = trans_char[(c>>4)&0xF];
	gets_buf[3*gets_cnt+1] = trans_char[c&0xF];
	gets_buf[3*gets_cnt+2] = ' ';
	gets_cnt++;
  }
}

static void save_term()
{
  gets_buf[3*gets_cnt] = '\0';
}

char *Gets(char *dest)
{
  int c, hc;
  int even = 1; /* Have read even number of digits */
  int otherd = 0; /* Other hex digit of pair */
  char *sp = dest;

  gets_cnt = 0;
  if (!hexformat) {
	while ((c = getc(infile)) != EOF && c != '\n') {
	  *sp++ = c;
	  save_char(c);
	}
  } else {
	while ((hc = getc(infile)) != EOF && hc != '\n') {
	  if (isxdigit(hc)) {
		int val;
		if ('0' <= hc && hc <= '9')
		  val = hc - '0';
		else if ('A' <= hc && hc <= 'F')
		  val = hc - 'A' + 10;
		else
		  val = hc - 'a' + 10;
		if (even) {
		  otherd = val;
		  even = 0;
		} else {
		  c = otherd * 16 + val;
		  *sp++ = c;
		  save_char(c);
		  even = 1;
		}
	  }
	}
  }
  *sp++ = '\0';
  save_term();
  return dest;
}

/* Track successful results */
static int level_counts[5] = 
  {NORMAL_CNT, NORMAL_CNT, NORMAL_CNT, NORMAL_CNT, KABOOM_CNT};

int check_level = -1;
/* Simple check to make sure validation only happens after proper
   function entry */
void entry_check(int level)
{
  check_level = level;
}

void validate(int level)
{
  if (!team) {
	printf("No username indicated.  Results not validated\n");
	return;
  }
  if (level < 0 || level >= 5) {
	printf("Invalid level.  Results not validated\n");
	return;
  }
  if (level != check_level) {
	printf("Improper call to validate function.  Results not validated\n");
	return;
  }

  success = 1;
  if (--level_counts[level] > 0) {
	printf("Keep going\n");
  } else if (grade) {
	printf("Level %d VALID\n", level);
  }
}

static void usage(char *name)
{
  printf("Usage: %s -u username\n",  name);
  printf("\t-u username:   Specify username\n");
  exit(0);
}

/* Signal handler to catch bus errors */
void bushandler(int sig)
{
  printf("Crash!: You caused a bus error!\n");
  printf("Better luck next time\n");
  exit(0);
}

/* Signal handler to catch segmentation violations */
void seghandler(int sig)
{
  printf("Ouch!: You caused a segmentation fault!\n");
  printf("Better luck next time\n");
  exit(0);
}


/* Alarm handler to catch infinite loops */
static int alarm_time = 600;

void alarmhandler(int sig)
{
  printf("Dead!: getbuf didn't complete within %d seconds\n", alarm_time);
  printf("Better luck next time\n");
  exit(0);
}

/* Illegal instruction handler */
void illegalhandler(int sig)
{
  printf("Oops!: You executed an illegal instruction\n");
  printf("Better luck next time\n");
  exit(0);
}

/* Run either test or testn */
static void launch(int nitro, int offset) {
  int localbuf[16];
  int stable_tweak = 0;
  int *space;
  /*
	This little hack adjusts the stack.  For normal mode, it
	tries to put it into a stable position from one run to the next.
	In nitro mode, it makes it even less stable than it would normally be.
	You don't need to understand it to do the assignment.
  */
  stable_tweak = (((int) localbuf) & 0x3FF8) + offset; 
  space = (int *) alloca(stable_tweak);
  /* Fill full of halt instructions, so that will get seg fault */
  memset(space, HALT_INSTR, stable_tweak);

  if (!quiet) {
	if (hexformat)
	  printf("Type Hex string: ");
	else {
	  printf("Type string: ");
	}
  }

  test();
  if (!success) {
	printf("Better luck next time\n");
	success = 0;
  }
}

void test_function() {
  // printf("This is a test\n");
   }

void shift_stack_and_invoke_function(
       uint64_t new_rsp,
       void (*func_ptr)()) {
   uint64_t old_rsp;

   __asm__ volatile("movq %%rsp, %0\n" : "=a" (old_rsp));
   __asm__ volatile("movq %0, %%rsp\n" : : "q" (new_rsp) : "memory", "rsp");
   func_ptr();
   __asm__ volatile("movq %0, %%rsp\n" : : "q" (old_rsp) : "memory", "rsp");
}

int main(int argc, char *argv[])
{
  int cookie_tweak = 0;
  int nitro = 0; /* Run in unstable mode? */
  int i;
  int *offsets;
  int cnt = NORMAL_CNT;
  char c;

  char *m = memalign(NEW_STACK_SIZE, NEW_STACK_SIZE);
  uint64_t    new_rsp;
  if(mprotect(m, NEW_STACK_SIZE, PROT_READ|PROT_WRITE|PROT_EXEC) 
!= 0) {
       perror("Failure to set stack permissions\n");
       exit(0);
       }

   new_rsp = (uint64_t)m + NEW_STACK_SIZE - 128;

   shift_stack_and_invoke_function(new_rsp, test_function);

  signal(SIGSEGV, seghandler);
  signal(SIGBUS, bushandler);
  signal(SIGALRM, alarmhandler);
  signal(SIGILL,  illegalhandler);
  infile = stdin;


  while ((c = getopt(argc, argv, "gt:u:")) != -1)
	switch(c) {
	case 'g': /* Hidden switch */
	  grade = 1;
	  quiet = 1;
	  alarm_time = 1; /* Should get immediate response */
	  break;
	  /* 	case 'h': */
	  /* 	    usage(argv[0]); */
	  /* 	    break; */
	  /* 	case 'q': /\* Disabled *\/ */
	  /* 	    quiet = 1; */
	  /* 	    break; */
	  /* 	case 'n': */
	  /* 	    nitro = 1; */
	  /* 	    cnt = KABOOM_CNT; */
	  /* 	    break; */
	  /* 	case 'x': /\* Disabled *\/ */
	  /* 	    hexformat = 1; */
	  /* 	    break; */
	case 't':
	case 'u':
	  team = strdup(optarg);
	  printf("Username: %s\n", team);
	  cookie = gencookie(team);
	  printf("Cookie: 0x%llx\n", cookie);
	  break;
	  /* 	case 'f': /\* Disabled *\/ */
	  /* 	    infile = fopen(optarg, "r"); */
	  /* 	    if (!infile) { */
	  /* 		printf("Can't open file: %s\n", optarg); */
	  /* 		usage(argv[0]); */
	  /* 	    } */
	  /* 	    break; */
	  /* 	case 's': /\* automatically submit solution via email *\/ */
	  /* 	    submit = 1; */
	  /* 	    break; */
	default:
	  usage(argv[0]);
	}

  if (!team) {
	printf("You must include a username with -u\n");
	usage(argv[0]);
  }

  srandom(cookie);
  cookie_tweak =  random() & 0xFF8;

  /* Set up set of stack offsets */
  offsets = (int *) calloc(cnt, sizeof(int));
  for (i = 0; i < cnt-2; i++)
	offsets[i] = random() & 0x38;
  if  (cnt >= 2)
	offsets[cnt-2] = 0x38;
  offsets[cnt-1] = 0;

  /* Set up time out condition */
  alarm(alarm_time);

  for (i = 0; i < cnt; i++)
	launch(nitro, offsets[i]+cookie_tweak);

  return 0;
}

