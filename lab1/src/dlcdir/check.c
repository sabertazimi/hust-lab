/*
 * check.c - module that checks CS:APP Data Lab programs for 
 *           legal operators and constructs
 * droh 8/2001 
 * reb 8/2006
 */
#include <stdio.h>
#include "ast.h"
#include "check.h"

/* 
 * global data for the check.c module
 */
int numillegal = 0; /* number of illegal insts in current proc */
int numops = 0;     /* number of operators encountered in current proc */
char currentfunc[128] = "none"; /* current function being parsed */
int infunction = 0; /* true when parser is inside a function */
int checking_type = 0; /* true when data types should be checked */

/* 
 * globals defined elsewhere 
 */
extern struct legallist legallist[MAXFUNCS]; /* See legallist.c */
extern char *Filename; /* current filename */
extern int Line; /* current linenumber */
extern int PrintOpCount; /* print the operator count for each func? */

/* 
 *  The -z flag tells us if we should zap illegal function bodies
 *  and replace them with a return statement that always returns
 *  the wrong values.
 * 
 *  The -Z flag does everything that -z does, and in addition zaps functions
 *  that use an excessive number of operations.
 */
extern int ZapCode;      /* -z */
extern int ZapLongCode;  /* -Z */
/* end of global data */

/* 
 * checkop - check that op is a legal operator 
 */
void checkop(int op) {
    int i,j;

    numops++;

    for (i=0; legallist[i].name[0] != 0; i++) {
	if (!strcmp(legallist[i].name, currentfunc)) {
	    for (j=0; legallist[i].ops[j] != 0; j++) {
	        if (legallist[i].ops[j] == '$' || op == legallist[i].ops[j]) {
		    return;
		}
	    }
	    numillegal++;
	    printf("dlc:%s:%d:%s: Illegal operator (", 
		   Filename, Line, currentfunc);
	    PrintOp(stdout, op);
	    printf(")\n");
	    return;
	}
    }
}

/*
 * arrayop - Encountered a possibly illegal array operator
 */
void arrayop()
{
    if (infunction) {
	numillegal++;
	printf("dlc:%s:%d:%s: Illegal array operator '[]'.\n", 
	       Filename, Line, currentfunc);
    }

    return;
}


/*
 * checkconst - constants must be within the prescribed range
 */
void checkconst(Node *node) {
    int i;
    int isfloat = 0;
    int ishex = 0;
    int longcnt = 0;
    int isunsigned = 0;
    const char *sval = node->u.Const.text;
    int whatsok = 0;
    for (i=0; legallist[i].name[0] != 0; i++) {
	if (!strcmp(legallist[i].name, currentfunc)) {
	  whatsok = legallist[i].whatsok;
	  break;
	}
    }
    for (i = 0; sval[i]; i++) {
      int c = sval[i];
      switch (c) {
      case 'x':
      case 'X':
	ishex = 1;
	break;
      case 'u':
      case 'U':
	isunsigned = 1;
	break;
      case 'l':
      case 'L':
	longcnt++;
	break;
      case '.':
	isfloat = 1;
	break;
      case 'e':
      case 'E':
	if (!ishex)
	  isfloat = 1;
      default:
	break;
      }
    }

    if (whatsok & OTHERINT_OK) {
      /* Anything but float */
      if (isfloat) {
	numillegal++;
	printf("dlc:%s:%d:%s: Illegal constant type (%s)\n", 
	       Filename, Line, currentfunc, node->u.Const.text);
      }
      return;
    }
    if (whatsok & BIGCONST_OK) {
      /* Any (long) signed integers are OK */
      if (isfloat||isunsigned||longcnt > 1) {
	numillegal++;
	printf("dlc:%s:%d:%s: Illegal constant type (%s)\n", 
	       Filename, Line, currentfunc, node->u.Const.text);
      }
      return;
    }
    if (isfloat||isunsigned||longcnt>1) {
      numillegal++;
      printf("dlc:%s:%d:%s: Illegal constant type (%s)\n", 
	     Filename, Line, currentfunc, node->u.Const.text);
      return;
    }
    if (((node->u.Const.value.i < 0) || (node->u.Const.value.i > 255)) ||
	((node->u.Const.value.u < 0) || (node->u.Const.value.u > 255)) ||
	((node->u.Const.value.l < 0) || (node->u.Const.value.l > 255)) ||
	((node->u.Const.value.ul < 0) || (node->u.Const.value.ul > 255))) {
      numillegal++;
      printf("dlc:%s:%d:%s: Illegal constant (%s) (only 0x0 - 0xff allowed)\n", 
	     Filename, Line, currentfunc, node->u.Const.text);
    }
#if 0
    {
      char c = node->u.Const.text[strlen(node->u.Const.text)-1];
      /* this is only an issue on Alphas */
      if (c != 'L' && WarningLevel >= 4) {
	printf("dlc:%s:%d:%s: Warning: non-long integer constant (%s).\n", 
	       Filename, Line, currentfunc, node->u.Const.text);
      }
    }
#endif
}

/*
 * checkstmt - check whether disallowed statement
 */
void checkstmt(char *stmt) {
    int i;
    for (i=0; legallist[i].name[0] != 0; i++) {
	if (!strcmp(legallist[i].name, currentfunc)) {
	    if ((legallist[i].whatsok & CONTROL_OK) != 0)
	        return;
	}
    }
    numillegal++;
    printf("dlc:%s:%d:%s: Illegal %s\n", 
	   Filename, Line, currentfunc, stmt);
}

/*
 * disable_check - temporarily suspend type check
 */
void disable_check()
{
  checking_type = 0;
}



/*
 * checktype - check whether disallowed type
 */
void checktype(BasicType basic, char *tname) {
    int i;
    if (!checking_type)
      return;
    if (basic != Float && basic != Double) {
      for (i=0; legallist[i].name[0] != 0; i++) {
	if (!strcmp(legallist[i].name, currentfunc)) {
	  if ((legallist[i].whatsok & OTHERINT_OK) != 0)
	    return;
	}
      }
    }
    numillegal++;
    printf("dlc:%s:%d:%s: Illegal data type: %s\n", 
	   Filename, Line, currentfunc, tname);
}

/*
 * castwarning - illegal cast
 */
void castwarning() {
    numillegal++;
    printf("dlc:%s:%d:%s: Illegal cast\n", Filename, Line, currentfunc);
}

/*
 * islegal - is this a legal function definition?
 */
int islegal(char *funcname) {
    int i;

    for (i=0; legallist[i].name[0] != 0; i++) {
	if (!strcmp(legallist[i].name, funcname)) {
	    return(1);
	}
    }
    return(0);
}

/*
 * checkcall - is this a legal function invocation?
 */
void checkcall(char const *funcname) {
    int i;
    char refname[MAXSTR];

    /* first, see if we've disallowed all function calls from this function */
    for (i=0; legallist[i].name[0] != 0; i++) {
	if (!strcmp(legallist[i].name, currentfunc)) {
	    if ((legallist[i].whatsok & CALLS_OK) == 0) {
		printf("dlc:%s:%d:%s: Illegal function invocation (%s)\n", 
		       Filename, Line, currentfunc, funcname);
		numillegal++;
		return;
	    }
	}
    }

    /* Some calls are allowed, is this a legal one? */
    for (i=0; legallist[i].name[0] != 0; i++) {
	sprintf(refname, "test_%s", legallist[i].name);
	if (!strcmp(refname, funcname) || 
	    !strcmp(funcname,legallist[i].name)) { 
	    /* we're calling either an internal function xxx or test_xxx */
	    /* so now just make sure we're not calling test_xxx from inside xxx */
	    if (!strcmp(legallist[i].name, currentfunc)) {
		printf("dlc:%s:%d:%s: Illegal function invocation (%s)\n", 
		       Filename, Line, currentfunc, funcname);
		numillegal++;
		return;
	    }
	    else
		return;
	}
    }
    printf("dlc:%s:%d:%s: Illegal function invocation (%s)\n", 
	   Filename, Line, currentfunc, funcname);
    numillegal++;
}

/*
 * newfunc - entering a new function
 */
void newfunc(Node *decl) {
    checking_type = 1;
    infunction = 1;
    numillegal = 0;
    numops = 0;
    strcpy(currentfunc, decl->u.tdef.name);
    if (!islegal(currentfunc)) {
	printf("dlc:%s:%d:%s: Illegal function definition\n", 
	       Filename, Line, currentfunc);
	numillegal++;
    }
}

/*
 * funccall - checks for valid function calls 
 */
void funccall(Node *node) {
    checkcall(node->u.Const.text);
}


GLOBAL void My213SetItem(List *list, Generic *element);

/*
 * endfunc - encountered the end of a function. 
 *           Zap function body if called for.
 */
void endfunc(Node *node) {
    Node *retnode;
    Coord coord = {0,0,0,0};
    ListMarker marker;
    Node *item;
    int i;
    char refname[MAXSTR];
    int exceedOps = 0;

    infunction = 0;

    /* print a message if the function exceeds the legal number of ops */
    for (i=0; legallist[i].name[0] != 0; i++) {
	sprintf(refname, "%s", legallist[i].name);
	if (!strcmp(refname, currentfunc)) { 
	    if (numops > legallist[i].maxops) {
		exceedOps = 1;
		printf("dlc:%s:%d:%s: Warning: %d operators exceeds max of %d\n",
		       Filename, Line, currentfunc, numops, legallist[i].maxops);
	    }
	    else {
		if (PrintOpCount) {
		    printf("dlc:%s:%d:%s: %d operators\n", 
			   Filename, Line, currentfunc, numops);
		}
	    }
	}
    }
  
    if ((numillegal > 0 && (ZapCode || ZapLongCode)) || (exceedOps && ZapLongCode)) {
	printf("dlc:%s:%d:%s: Zapping function body!\n", 
	       Filename, Line, currentfunc);
	retnode = AddReturn(MakeReturnCoord(MakeConstSlong(4L), coord));   
	IterateList(&marker, node->u.Block.stmts);
	NextOnList(&marker,(GenericREF)&item);
	My213SetItem(marker.current, retnode);
    }
}
