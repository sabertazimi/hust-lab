/*
 * dlc - The CS:APP Data Lab syntax checking program
 *       (based on the MIT CILK project's c2c ANSI C source-to-source translator)
 *       Dave O'Hallaron, CMU, 8/99
 *
 * In its default mode, dlc simply checks its input for errors. It flags 
 * the following kinds of errors: 
 *     - Calling functions from any other function
 *     - Defining new functions
 *     - Using illegal operators (tailored for each function) 
 *     - Using invalid control constructs, 
 *     - any form of casting (except it still misses some implicit casts)
 *     - Using out of range constants (> 255 or < 0). 
 *
 * It also issues warnings about not using long constants and about
 * using explicit casts.
 * 
 * With the zap option (-z), dlc outputs a C program where the body of any
 * offending function is replaced with a "return 4L;" statement, which
 * is always a wrong result.
 *
 * With the zap long option (-Z), dlc in addition zaps 
 * functions with an excessive number of operations
 * is replaced with a "return 4L;" statement, which
 * is always a wrong result.
 *
 * All the code you need to look at is in ANSI-C.y, main.c, check.c,
 * and a small list accessor function My213SetItem in list.c.
 *
 * Examples:
 * dlc -options              -- print summary of command line options.
 * dlc foo.c                 -- checks foo.c for correctness
 * dlc -z foo.c              -- produces zapped version in foo.p.c
 * dlc -z -o bar.c foo.c     -- produces zapped version in bar.c
 * dlc -z -Z -o bar.c foo.c  -- produces fully zapped version in bar.c
 *
 */


/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  main.c,v
 * Revision 1.22  1995/05/05  19:18:28  randall
 * Added #include reconstruction.
 *
 * Revision 1.21  1995/04/21  05:44:28  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.20  1995/04/09  21:30:48  rcm
 * Added Analysis phase to perform all analysis at one place in pipeline.
 * Also added checking for functions without return values and unreachable
 * code.  Added tests of live-variable analysis.
 *
 * Revision 1.19  1995/03/23  15:31:12  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.18  1995/02/13  02:00:13  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.17  1995/02/10  22:11:59  rcm
 * -nosem, -notrans, etc. options no longer toggle, so they can appear more than
 * once on the command line with same meaning.  Added -- option to accept
 * unknown options quietly.
 *
 * Revision 1.16  1995/02/01  07:33:18  rcm
 * Reorganized help message and renamed some compiler options
 *
 * Revision 1.15  1995/02/01  04:34:50  rcm
 * Added cc compatibility flags.
 *
 * Revision 1.14  1995/01/25  21:38:17  rcm
 * Added TypeModifiers to make type modifiers extensible
 *
 * Revision 1.13  1995/01/20  03:38:07  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.12  1995/01/11  17:19:16  rcm
 * Added -nopre option.
 *
 * Revision 1.11  1995/01/06  16:48:51  rcm
 * added copyright message
 *
 * Revision 1.10  1994/12/23  09:18:31  rcm
 * Added struct packing rules from wchsieh.  Fixed some initializer problems.
 *
 * Revision 1.9  1994/12/20  09:24:05  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.8  1994/11/22  01:54:30  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.7  1994/11/10  03:15:41  rcm
 * Added -nosem option.
 *
 * Revision 1.6  1994/11/03  07:38:41  rcm
 * Added code to output C from the parse tree.
 *
 * Revision 1.5  1994/10/28  18:58:53  rcm
 * Fixed up file headers.
 *
 * Revision 1.4  1994/10/28  18:52:29  rcm
 * Removed ALEWIFE-isms.
 *
 * Revision 1.3  1994/10/25  20:51:24  rcm
 * Added single makefile
 *
 * Revision 1.2  1994/10/25  15:52:13  bradley
 * Added cvs Log and pragma ident to file.
 *
 *
 *  May 27, 1993  MDN Added support to call genir
 *
 *  Created: Tue Apr 27 13:17:36 EDT 1993
 *
 *
 * 
 * Copyright (c) 1994 MIT Laboratory for Computer Science
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE MIT LABORATORY FOR COMPUTER SCIENCE BE LIABLE
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * Except as contained in this notice, the name of the MIT Laboratory for
 * Computer Science shall not be used in advertising or otherwise to
 * promote the sale, use or other dealings in this Software without prior
 * written authorization from the MIT Laboratory for Computer Science.
 *
 *************************************************************************/
#if 0
#pragma ident "main.c,v 1.22 1995/05/05 19:18:28 randall Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "ast.h"

#ifndef NO_POPEN
#ifdef NO_PROTOTYPES
extern FILE *popen(const char *, const char *);
extern int  pclose(FILE *pipe);
#endif
#endif

/* Set to 1 to enable parser debugging.  Also requires YACC flags */
extern int yydebug;

GLOBAL const char * Executable;
GLOBAL const float VersionNumber = 0.6;
GLOBAL const char * const VersionDate = __DATE__;
GLOBAL const char *PhaseName = "???";

#define CPP_FLAG_LIMIT 2048

GLOBAL int WarningLevel = WARNING_LEVEL; /* values 1-5 are legal; 5 == all */
GLOBAL int PrintOpCount = 0;             /* by default, don't print op counts */
GLOBAL List *Program;

GLOBAL extern FILE *yyin;  /* file pointer used by the lexer */
PRIVATE const char *input_file    = NULL;
PRIVATE const char *output_file   = NULL;
PRIVATE const char *stdin_name    = NULL;

PRIVATE const char *default_preproc = DEFAULT_PREPROC;
PRIVATE const char *ansi_preproc = ANSI_PREPROC;
PRIVATE const char *preproc; /* = default_preproc, initialized in main */

PRIVATE char cpp_flags[CPP_FLAG_LIMIT];
PRIVATE int cpp_flags_index = 0;
PRIVATE Bool piped_input = FALSE;

#ifdef NO_POPEN
PRIVATE char tmpname[L_tmpnam];  /* temporary filename */
#endif


/* global flags */
GLOBAL Bool QuietlyIgnore     = FALSE;
GLOBAL Bool DebugLex          = FALSE;
GLOBAL Bool PrintSymTables    = FALSE;
GLOBAL Bool PrintPreproc      = FALSE;
GLOBAL Bool TrackInsertSymbol = FALSE;
GLOBAL Bool PrintAST          = FALSE;
GLOBAL Bool PrintLineOffset   = FALSE;
GLOBAL Bool IgnoreLineDirectives = FALSE;
GLOBAL Bool ANSIOnly          = FALSE;
GLOBAL Bool PrintLiveVars     = FALSE;

GLOBAL Bool Preprocess        = TRUE;
GLOBAL Bool SemanticCheck     = TRUE;
GLOBAL Bool Analyze           = TRUE;
GLOBAL Bool Transform         = TRUE;
GLOBAL Bool GenerateOutput    = FALSE;
GLOBAL Bool FormatReadably    = FALSE;

GLOBAL Bool ZapCode           = FALSE; /* CS:APP */
GLOBAL Bool ZapLongCode       = FALSE; /* CS:APP */

PRIVATE void print_version_info(FILE *out, const char *pre)
{
    fprintf(out, "%sVersion %.02f (%s)\n",
	    pre, VersionNumber, VersionDate);
    exit(0);
}


PRIVATE void print_copyright(FILE *out, const char *pre)
{
    static const char *lines[] = {
      "Copyright (c) 1994 MIT Laboratory for Computer Science\n",
      NULL };
    int i;

    for (i=0; lines[i] != NULL; i++) {
	fputs(pre, out);
	fputs(lines[i], out);
    }
    exit(0);
}


PRIVATE void add_cpp_flag(const char *flag)
{
  /* Quote flag with single quotes, escaping any single quotes that
     appear in flag.  This code only works if system() and popen() 
     use sh as the command shell. */

  const char *src = flag;
  char *dest = &cpp_flags[cpp_flags_index];

  strcpy(dest, " '"); /* starting quote */
  dest+=2;

  for (; *src; ++src) {
    if (*src == '\'') {
      strcpy(dest, "'\\''");
      dest+=4;
    }
    else
      *dest++ = *src;
  }
  strcpy(dest, "'"); /* ending quote */
  dest++;

  cpp_flags_index += dest - &cpp_flags[cpp_flags_index];
}


PRIVATE void usage(Bool print_all_options, int exitcode)
{
    fprintf(stderr, "Usage: %s [options] [file]\n", Executable);

    fprintf(stderr, 
    "\n"
    "Parses <file> as a C program, reporting syntax and type errors, and writes\n"
    "processed C program out to <file>%s.  If <file> is omitted, uses \n"
    "standard input and standard output.\n"
    "\n",
	    OUTPUT_SUFFIX);

    fprintf(stderr, "General Options:\n");
    fprintf(stderr,
	    "\t-help              Print this description\n");
    fprintf(stderr,
	    "\t-options           Print all options\n");
    fprintf(stderr,
	    "\t-copy              Print the copyright information\n");
    fprintf(stderr,
	    "\t-v                 Print version information\n");

      fprintf(stderr, "CS:APP Data Lab Options:\n");
      fprintf(stderr,
	      "\t-e                 Emit operator count for each Data Lab function\n");
      fprintf(stderr,
	      "\t-z                 Zap illegal Data Lab functions\n");
      fprintf(stderr,
	      "\t-Z                 Like -z, but also zaps functions with too many operators\n");

      fprintf(stderr, "Warning Options:\n");
      fprintf(stderr,
	      "\t-ansi              Disable GCC extensions and undefine __GNUC__\n");
      fprintf(stderr,
	      "\t-W<n>              Set warning level; <n> in 1-5. Default=%d\n",
	      WARNING_LEVEL);
      fprintf(stderr,
	      "\t-Wall              Same as -W5\n");
      fprintf(stderr,
	      "\t-il                Ignore line directives (use actual line numbers)\n");
      fprintf(stderr,
	      "\t-offset            Print offset within the line in warnings/errors\n");
      fprintf(stderr,
	      "\t-name <x>          Use stdin with <x> as filename in messages\n");

    if (print_all_options) {
      fprintf(stderr, "Phase Options:\n");
      fprintf(stderr,
	      "\t-nopre             Don't preprocess\n");
      fprintf(stderr,
	      "\t-nosem             Don't semantic-check\n");
      fprintf(stderr,
	      "\t-noanalyze         Don't perform dataflow analysis\n");
      fprintf(stderr,
	      "\t-notrans           Don't transform syntax tree\n");
      fprintf(stderr,
	      "\t-noprint           Don't write C output\n");

      fprintf(stderr, "Output Options:\n");
      fprintf(stderr,
	      "\t-N                 Don't emit line directives\n");
      fprintf(stderr,
	      "\t-o <name>          Write C output to <name>\n");


      
      fprintf(stderr, "Preprocessing Options:\n");
      fprintf(stderr,
	      "\t-P<str>            Set the preprocessor command to <str>\n");
      fprintf(stderr,
	      "\t-pre               Print the preprocessor command and flags\n");
      fprintf(stderr,
	      "\t-I<path>           Specify path to search for include files\n");
      fprintf(stderr,
	      "\t-Dmacro[=value]    Define macro (with optional value)\n");
      fprintf(stderr,
	      "\t-Umacro            Undefine macro\n");
      fprintf(stderr,
	      "\t-H                 Print the name of each header file used\n");
      fprintf(stderr,
	      "\t-undef             Do not predefine nonstandard macros\n");
      fprintf(stderr,
	      "\t-nostdinc          Do not scan standard include files\n");
      fprintf(stderr, "Debugging Options:\n");
      fprintf(stderr,
	      "\t-lex               Show lexical tokens\n");
      fprintf(stderr,
	      "\t-yydebug           Track parser stack and actions\n");
      fprintf(stderr,
	      "\t-insert            Track symbol creation\n");
      fprintf(stderr,
	      "\t-sym               Print out symbol tables after parse\n");
      fprintf(stderr,
	      "\t-ast               Print out syntax tree (after last phase)\n");
      fprintf(stderr,
	      "\t-live              Print live variables as cmts in C output\n");
      fprintf(stderr, "CC Compatibility Options:\n");
      fprintf(stderr,
	      "\t--                 Toggles ignoring of unknown options\n"
              "\t                   (for makefile compatibility with cc)\n"); 
      
      fprintf(stderr, "\n");
    }

  exit(exitcode);
}

PRIVATE void unknown_option(char *option)
{
  if (!QuietlyIgnore) {
    fprintf(stderr, "Unknown option: `%s'\n\n", option);
    usage(FALSE, 1);
  }
}

/* Generate a filename with a new suffix.
   If <filename> ends with <old_suffix>, replace the suffix with <new_suffix>;
   otherwise just append <new_suffix>. */
PRIVATE const char *with_suffix(const char *filename, 
				const char *old_suffix, 
				const char *new_suffix)
{ 
  int root_len, old_len, len;
  char *newfilename;

  /* Look for old_suffix at end of filename */
  root_len = strlen(filename);
  old_len = strlen(old_suffix);
  if (root_len >= old_len && 
      !strcmp(filename + root_len - old_len, old_suffix))
    root_len -= old_len;
  
  /* Compute the length of the create filename */
  len = root_len + strlen(new_suffix) + 1;

  /* allocate the create name */
  if ((newfilename = HeapNewArray(char, len)) == NULL) {
    printf("INTERNAL ERROR: Unable to allocate %d bytes for a filename\n", 
	   len);
    exit(-1);
  }

  strncpy(newfilename, filename, root_len);
  strcat(newfilename, new_suffix);

  return newfilename;
}


/***********************************************************************\
 * Handle command-line arguments
\***********************************************************************/

PRIVATE void handle_options(int argc, char *argv[])
{
  int i;

  for (i=1; i<argc; i++) {
    if (argv[i][0] == '-') {
      switch (argv[i][1]) {
      case '-':
	QuietlyIgnore = !QuietlyIgnore;
	break;
      case 'h':
	usage(FALSE, 0);
	break;
      case 'e':
	PrintOpCount = 1;
	break;
      case 'a':
	if (strcmp(argv[i], "-ansi") == 0) {
	  ANSIOnly = TRUE;
	  /* change the preprocessor command, if the user hasn't
	     already changed it with -P */
	  if (preproc == default_preproc)
	    preproc = ansi_preproc;
	}
	else if (strcmp(argv[i], "-ast") == 0) 
	  PrintAST = TRUE;
	else
	  unknown_option(argv[i]);
	break;

      case 'D':
      case 'U':
      case 'I':
	add_cpp_flag(argv[i]);
	break;
      case 'H':
	if (strcmp(argv[i], "-H") == 0)
	  add_cpp_flag(argv[i]);
	else
	  unknown_option(argv[i]);
	break;
      case 'P':
	preproc = &argv[i][2];
#if 0
/* didn't seem necessary -- rcm */
	fprintf(stderr, "Preprocessor set to `%s'\n", preproc);
#endif
	break;
      case 'N':
	FormatReadably = TRUE;
	break;
      case 'W':
	if (strcmp(argv[i], "-Wall")==0) {
	  WarningLevel = 5;
	} else {
	  int c = atoi(&argv[i][2]);
	  if (c < 1 || c > 5) {
	    unknown_option(argv[i]);
	  } else {
	    WarningLevel = c;
	  }
	}
	break;
      case 'c':
	if (strcmp(argv[i], "-copy") == 0)
	  print_copyright(stderr, "");
	else 
	  unknown_option(argv[i]);
	break;
      case 'i':
	if (strcmp(argv[i], "-insert")==0)
	  TrackInsertSymbol = TRUE;
	else if (strcmp(argv[i], "-imacros") == 0 ||
		 strcmp(argv[i], "-include") == 0) {
	  add_cpp_flag(argv[i++]);
	  add_cpp_flag(argv[i]);
	} else if (strcmp(argv[i], "-il")==0) {
	  IgnoreLineDirectives = TRUE;
	} else unknown_option(argv[i]);
	break;
      case 'l':
	if (strcmp(argv[i], "-lex")==0)
	  DebugLex = TRUE;
	else if (strcmp(argv[i], "-live")==0)
	  PrintLiveVars = TRUE;
	else unknown_option(argv[i]);
	break;
      case 'z':
	ZapCode = 1;
	GenerateOutput = 1;
	break;
      case 'Z':
	ZapLongCode = 1;
	GenerateOutput = 1;
	break;
      case 'n':
	if (strcmp(argv[i], "-name")==0) {
	  i++;
	  if (input_file != NULL) {
	    fprintf(stderr,
		    "Multiple input files defined, using `%s'\n",
		    input_file);
	  } else {
	    stdin_name = argv[i];
	  }
	} else if (strcmp(argv[i], "-nostdinc")==0) {
	  add_cpp_flag(argv[i]);
	} else if (strcmp(argv[i], "-nosem")==0) {
	  SemanticCheck = FALSE;
	} else if (strcmp(argv[i], "-notrans")==0) {
	  Transform = FALSE;
	} else if (strcmp(argv[i], "-noprint")==0) {
	  GenerateOutput = FALSE;
	} else if (strcmp(argv[i], "-nopre")==0) {
	  Preprocess = FALSE;
	} else if (strcmp(argv[i], "-noanalyze") == 0) {
	  Analyze = FALSE;
	} else unknown_option(argv[i]);
	break;
      case 'o':
	if (strcmp(argv[i], "-o")==0) {
	  i++;
	  output_file = argv[i];
	}
	else if (strcmp(argv[i], "-offset")==0)
	  PrintLineOffset = TRUE;
	else if (strcmp(argv[i], "-options")==0) {
	  usage(TRUE, 0);
	  exit(0);
	}
	else unknown_option(argv[i]);
	break;
      case 'p':
	if (strcmp(argv[i], "-pre") == 0)
	  PrintPreproc  = TRUE;
	else
	  unknown_option(argv[i]);
	break;
      case 's':
	if (strcmp(argv[i], "-sym")==0)
	  PrintSymTables = TRUE;
	else unknown_option(argv[i]);
	break;
      case 'u':
	if (strcmp(argv[i], "-undef")==0)
	  add_cpp_flag(argv[i]);
	else unknown_option(argv[i]);
	break;
      case 'v':
	if (strcmp(argv[i], "-v")==0)
	  print_version_info(stderr, "");
	else unknown_option(argv[i]);
	break;
      case 'y':
	if (strcmp(argv[i], "-yydebug") == 0)
	  yydebug = 1;
	else
	  unknown_option(argv[i]);
	break;
      default:
	unknown_option(argv[i]);
      }
    } else {
      if (input_file != NULL) {
	fprintf(stderr, "Multiple input files defined, using `%s'\n",
		argv[i]);
      }
      input_file = argv[i];
    }
  }

  if (GenerateOutput == TRUE && input_file != NULL && output_file == NULL)
    output_file = with_suffix(input_file, INPUT_SUFFIX, OUTPUT_SUFFIX);

}


/***********************************************************************\
 * ANSI C symbol tables
\***********************************************************************/

GLOBAL SymbolTable *Identifiers, *Labels, *Tags, *Externals;

PRIVATE void shadow_var(Node *create, Node *shadowed)
{
    /* the two are equal only for redundant function/extern declarations */
    if (create != shadowed  && WarningLevel == 5) {
	WarningCoord(5, create->coord,
		     "`%s' shadows previous declaration", VAR_NAME(create));
	fprintf(stderr, "\tPrevious declaration: ");
	PRINT_COORD(stderr, shadowed->coord);
	fputc('\n', stderr);
    }
}


PRIVATE void init_symbol_tables(Bool shadow_warnings)
{
    ShadowProc shadow_proc;

    if (shadow_warnings)
      shadow_proc = (ShadowProc) shadow_var;
    else
      shadow_proc = NULL;

    Identifiers = NewSymbolTable("Identifiers", Nested,
				 shadow_proc, (ExitscopeProc) OutOfScope);
    Labels = NewSymbolTable("Labels", Flat,
			    NULL, (ExitscopeProc) EndOfLabelScope);
    Tags = NewSymbolTable("Tags", Nested,
			  shadow_warnings ? (ShadowProc)ShadowTag : (ShadowProc)NULL,
			  NULL);
    Externals = NewSymbolTable("Externals", Flat,
			       NULL, (ExitscopeProc) OutOfScope);
}


/***********************************************************************\
 * Determine input file, preprocess if needed
\***********************************************************************/

PRIVATE FILE *get_preprocessed_input()
{
  FILE *in_file;
  
  if (Preprocess && input_file != NULL) {
    char command[2048];
    
    if (PrintPreproc)
      fprintf(stderr, "Preprocessing: %s %s %s\n", preproc,
	      cpp_flags, input_file);
#ifdef NO_POPEN
    tmpname[0] = 0;
    tmpnam(tmpname);  /* get a temporary filename */
    sprintf(command, "%s %s %s > %s", preproc, cpp_flags,
	    input_file, tmpname);
    /* the following assumes that "system" returns nonzero if
       the command fails, which is not required by ANSI C */
    if (system(command)) {
      fprintf(stderr, "Preprocessing failed.\n");
      remove(tmpname);
      exit(10);
    }
    input_file = tmpname;
    in_file = fopen(input_file, "r");
    if (in_file == NULL) {
      fprintf(stderr,
	      "Unable to read input file \"%s\".\n", input_file);
      if (tmpname[0] != 0) remove(tmpname);
      exit(1);
    }
#else
    sprintf(command, "%s %s %s", preproc, cpp_flags, input_file);
    in_file = popen(command, "r");
    if (in_file == NULL) {
      fprintf(stderr, "Unable to preprocess input file \"%s\".\n",
	      input_file);
      exit(1);
    }
    piped_input = TRUE;
#endif
    SetFile(input_file, 0);
  } else {
    fprintf(stderr, "(Assuming input already preprocessed)\n");

    if (input_file != NULL) {
      in_file = fopen(input_file, "r");
      if (in_file == NULL) {
	fprintf(stderr,
		"Unable to read input file \"%s\".\n", input_file);
	exit(1);
      }
      SetFile(input_file, 0);
    }
    else {
      if (stdin_name == NULL) stdin_name = "stdin";
      in_file = stdin;
      SetFile(stdin_name, 0);
    }
  }
  return(in_file);
}


/***********************************************************************\
 * Main
\***********************************************************************/

GLOBAL int main(int argc, char *argv[])
{
    Bool parsed_ok;

    Executable = argv[0];
#if 0
/* put default cpp flags into preproc  -- rcm */
    /* default cpp flags */
    add_cpp_flag("-D__STDC__");
#endif
    preproc = default_preproc;

    handle_options(argc, argv);

    yyin = get_preprocessed_input();

    InitTypes();
    init_symbol_tables(TRUE);
    InitOperatorTable();

    PhaseName = "Parsing";
    parsed_ok = yyparse();

    if (Level != 0) {
	SyntaxError("unexpected end of file");
    }

    if (PrintSymTables) {
	PrintSymbolTable(stdout, Externals);
    }

#ifndef NDEBUG
    if (Errors == 0) {
	PhaseName = "Verification";
	VerifyParse(Program);
    }
#endif

    PhaseName = "Semantic Check";
    if (Errors == 0 && SemanticCheck)
      Program = SemanticCheckProgram(Program);

    PhaseName = "Analyze";
    if (Errors == 0 && Analyze)
      AnalyzeProgram(Program);

    PhaseName = "Transform";
    if (Errors == 0 && Transform)
      Program = TransformProgram(Program);
    
    PhaseName = "Output";

    if (Errors == 0 && GenerateOutput) {
      if (output_file == NULL) {
	 OutputProgram(stdout, Program);
      }
      else {
	FILE *fp;
	
	if ((fp = fopen(output_file, "w")) == NULL)
	  printf("Unable to open \"%s\" for output file\n", output_file);
	else {
	  OutputProgram(fp, Program);
	  fclose(fp);
	}
      }
    }

    if (Errors > 0) {
      fprintf(stderr, "\nCompilation Failed: %d error%s, %d warning%s\n",
	      Errors, PLURAL(Errors),
	      Warnings, PLURAL(Warnings));
    } else if (Warnings > 0) {
      fprintf(stderr, "\nCompilation Successful (%d warning%s)\n",
		Warnings,
	      PLURAL(Warnings));
    }

    if (PrintAST) {
      PrintList(stdout, Program, -1);
      fprintf(stdout, "\n");
    }

    /* cleanup */
#ifdef NO_POPEN
    if (tmpname[0] != 0) remove(tmpname);
#else
    if (piped_input) pclose(yyin);
#endif

    return(Errors);
}
