%{
    /* Copyright (C) 1989,1990 James A. Roskind, All rights reserved. 
    This lexer description was written by James A.  Roskind.  Copying 
    of  this  file, as a whole, is permitted providing this notice is 
    intact  and  applicable   in   all   complete   copies.    Direct 
    translations  as a whole to other lexer generator input languages 
    (or lexical description languages)  is  permitted  provided  that 
    this  notice  is  intact and applicable in all such copies, along 
    with a disclaimer that  the  contents  are  a  translation.   The 
    reproduction  of derived files or text, such as modified versions 
    of this file, or the output of scanner generators, is  permitted, 
    provided   the  resulting  work  includes  the  copyright  notice 
    "Portions Copyright (c) 1989, 1990 James  A.   Roskind".  Derived 
    products  must  also  provide  the notice "Portions Copyright (c) 
    1989, 1990 James A.  Roskind" in  a  manner  appropriate  to  the 
    utility,   and  in  keeping  with  copyright  law  (e.g.:  EITHER 
    displayed when first invoked/executed; OR displayed  continuously 
    on  display terminal; OR via placement in the object code in form 
    readable in a printout, with or near the title of the work, or at 
    the end of the file).  No royalties, licenses or  commissions  of 
    any  kind  are  required  to copy this file, its translations, or 
    derivative products, when the copies are made in compliance  with 
    this  notice.  Persons  or  corporations  that  do make copies in 
    compliance  with  this  notice  may  charge  whatever  price   is 
    agreeable  to  a buyer, for such copies or derivative works. THIS 
    FILE IS PROVIDED ``AS IS'' AND WITHOUT  ANY  EXPRESS  OR  IMPLIED 
    WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES 
    OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

    James A. Roskind
    Independent Consultant
    516 Latania Palm Drive
    Indialantic FL, 32903
    (407)729-4348
    jar@ileaf.com
    or ...!uunet!leafusa!jar

    ---end of copyright notice---


COMMENTS-

My  goal  is  to  see  software  developers adopt my C++ grammar as a 
standard until such time as a better  standard  is  accessible.   The 
only  way  to  get it to become a standard, is to be sure that people 
know that derivations are based on a specific work.   The  intent  of 
releasing  this Flex input file is to facilitate experimentation with 
my C++ grammar. The intent  of  the  copyright  notice  is  to  allow 
arbitrary  commercial and non-commercial use of this file, as long as 
reference is given to my standardization effort.   Without  reference 
to  a specific standard, many alternative grammars would develop.  By 
referring to the standard, the C++ grammar is given publicity,  which 
should  lead  to further use in compatible products and systems.  The 
benefits  of  such  a  standard  to  commercial  products  (browsers, 
beautifiers,  translators,  compilers,  ...) should be obvious to the 
developers, in that other compatible products will  emerge,  and  the 
value  of  all  conforming  products  will rise.  Most developers are 
aware of the value of acquiring  a  fairly  complete  grammar  for  a 
language,  and  the  copyright  notice (and the resulting affiliation 
with my work) should not be too high a price to pay.  By copyrighting 
my work, I have some minor control over what this standard is, and  I 
can  (hopefully)  keep it from degrading without my approval.  I will 
consistently attempt to provide upgraded grammars that are  compliant 
with  the  current  art, and the ANSI C++ Committee recommendation in 
particular.  A  developer  is  never  prevented  from  modifying  the 
grammar or this file to improve it in whatever way is seen fit. There 
is  also  no  restriction on the sale of copies, or derivative works, 
providing the request in the copyright notice are satisfied.

If you are not "copying" my work, but  are  rather  only  abstracting 
some of my work, an acknowledgment with references to such a standard 
would  be  appreciated.  Specifically, agreements with my grammar and 
its resolution of otherwise ambiguous constructs, should be noted.

Simply put: "make whatever use you would like of the grammar and this 
file, but include the ``portions Copyright ...'' as  a  reference  to 
this standard."


*/

/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  File: 
 *  c4.l,v
 * Revision 1.21  1995/05/11  18:54:14  rcm
 * Added gcc extension __attribute__.
 *
 * Revision 1.20  1995/05/05  19:18:26  randall
 * Added #include reconstruction.
 *
 * Revision 1.19  1995/04/21  05:44:08  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.18  1995/03/23  15:30:59  rcm
 * Dataflow analysis; removed IsCompatible; replaced SUN4 compile-time symbol
 * with more specific symbols; minor bug fixes.
 *
 * Revision 1.17  1995/03/01  16:23:11  rcm
 * Various type-checking bug fixes; added T_REDUNDANT_EXTERNAL_DECL.
 *
 * Revision 1.16  1995/02/13  02:00:04  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.15  1995/02/10  22:10:20  rcm
 * Now supports #ident.  Also interprets tabs when computing token offsets.
 *
 * Revision 1.14  1995/02/07  21:24:40  rcm
 * Adapted to older versions of flex.
 *
 * Revision 1.13  1995/02/06  21:41:24  rcm
 * Alpha release v0.60
 *
 * Revision 1.12  1995/02/01  23:01:24  rcm
 * Added Text node and #pragma collection
 *
 * Revision 1.11  1995/02/01  21:07:10  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.10  1995/02/01  00:29:39  rcm
 * c4.l is now compatible with Sun4 lex; added #pragma lang C.
 *
 * Revision 1.9  1995/01/25  02:16:14  rcm
 * Changed how Prim types are created and merged.
 *
 * Revision 1.8  1995/01/20  03:38:01  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.7  1995/01/11  17:17:00  rcm
 * Added detection of unknown escape codes in string constants.
 *
 * Revision 1.6  1994/12/20  09:23:53  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.5  1994/11/22  01:54:26  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.4  1994/11/10  03:08:33  rcm
 * Tokens now have full coordinates (file, line, offset).  Added GetCoord().
 *
 * Revision 1.3  1994/11/03  07:30:35  rcm
 * Now strips #pragma directives.
 *
 * Revision 1.2  1994/10/28  18:52:11  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *************************************************************************/
#pragma ident "c4.l,v 1.21 1995/05/11 18:54:14 rcm Exp"

/* Last modified 3/7/90, Version 1.00 */


/* This file is a dramatically cut down version  of  the  FLEX  input 
file  used in my ANSI C Preprocessor.  The executable version of my C 
preprocessor is available on many platforms (shareware), but this  is 
the  only source extract that is currently being distributed.  If you 
need  a  full  ANSI  C  preprocessor,   with   extensive   diagnostic 
capabilities  and  customization facilities, please contact me at the 
addresses given above.  Current platforms  include  IBMPC  (DOS/OS2), 
Sun  (SPARC  and  Motorola),  and  IBM R/6000.  ... end of commercial 
announcement.

This file is being distributed to facilitate experimentation and  use 
of my C and C++ grammar.


Comment  removal  must be done during the lexing, as context (such as 
enclosure in string literals) must be observed.   For  this  cut-down 
lexer,  we  will assume that comments have been removed (don't assume 
this if you are writing a compiler or browser!).   The  justification 
for   this   assumption   is   a   view   that   we   are  processing 
post-preprocessed source, and hence comment removal was taken care of 
during that phase. Note that in real life, comments CANNOT always  be 
removed  prior  to  lexing,  as  the  sequence of characters '/' '*' may 
appear within a string literal, and hence NOT indicate the start of a 
comment.

For each IDENTIFIER like string that  is  found,  there  are  several 
distinct interpretations that can be applied:

1)  The  preprocessor  may  interpret  the string as a "keyword" in a 
directive (eg: "pragma" or "include", "defined").

2) The parser may interpret the string as a keyword. (eg: "int").

3) Both parser and preprocessor may interpret the string as a keyword 
(eg: "if").

Since this file is based on source that actually  lexically  analyses 
text  for both preprocessing and parsing, macro definitions were used 
throughout.  The macro definitions supplied here have been customized 
to a C++ parse only, and all  preprocessor  keywords  are  passed  as 
IDENTIFIER  or  TYPEDEFname.  Also, since there is no symbol table to 
interrogate to decide whether a string is  a  TYPEDEFname,  I  simply 
assume  that  any identifier beginning with an upper case letter is a 
TYPEDEFname.  This hack should  allow  you  to  check  out  how  code 
segments  are  parsed using my grammar.  Unfortunately, if you really 
want to parse major league code, you have to write  a  symbol  table, 
and maintain appropriate scoping information.  :-), sorry...

*/


/* Included code before lex code */
/*************** Includes and Defines *****************************/



/**************************************************************************\
*  New code added by Eric A. Brewer
\**************************************************************************/

#include <ctype.h>
#include "ast.h"


PRIVATE inline void GetCoord(Coord *pcoord);
PRIVATE Node *char_constant(const char *);
PRIVATE Node *int_constant(const char *, Bool decimal, Bool octal);
PRIVATE Node *wide_char_const(const char *);
PRIVATE Node *float_constant(const char *s);
PRIVATE char *convert_escape_sequences(char *string);
PRIVATE void print_token(int token);
PRIVATE Bool HasSuffix(const char *filename, const char *suffix);
PRIVATE Bool HasIncludedSuffix(const char *filename);
PRIVATE void parse_line_directive(char *s);
PRIVATE void save_pragma_directive(char *s);
PRIVATE void EnterC(void);
PRIVATE void ExitC(void);

#define DEBUGLEX

#ifdef DEBUGLEX
#define RETURN_TOKEN(x) return(print_token(x), x)
#else
#define RETURN_TOKEN(x) return(x)
#endif

#define TAB_WIDTH  8

static char *line_start;

#undef YY_INPUT
#define YY_INPUT(buf, result, max_size) \
    if (fgets(buf, max_size, yyin)==0) { result=0; } \
    else { line_start = (char *)buf; result = strlen(buf); }

#undef yywrap

/**************************************************************************\
*  End of New code
\**************************************************************************/


#if 0
/* y.tab.h now included by ast.h -- rcm */
#include "y.tab.h" /* YACC generated definitions based on C++ parser input*/
#endif


#define WHITE_RETURN(x)  /* do nothing,  */

#define PA_KEYWORD_RETURN(x) \
    RETURN_VAL(x)

/* PreProcessor and C keyword */
#define PPPA_KEYWORD_RETURN(x) \
    RETURN_VAL(x)

#define PP_KEYWORD_RETURN(x) \
   { GetCoord(&yylval.tok);\
     yylval.n = MakeIdCoord(UniqueString(yytext), yylval.tok);\
     if (IsAType(yylval.n->u.id.text)) \
       RETURN_TOKEN(TYPEDEFname); else RETURN_TOKEN(IDENTIFIER); }

/* PreProcess and Parser operator */
#define PPOP_RETURN(x) \
    RETURN_VAL((int)*yytext)

/* error: CPP ONLY operator;  Do nothing */
#define NAMED_PPOP_RETURN(x)

/* a single character operator */
#define ASCIIOP_RETURN(x)  RETURN_VAL((int)*yytext)

/* a multichar operator, with a name */
#define NAMEDOP_RETURN(x)  RETURN_VAL(x)             

#define RETURN_VAL(x) \
  {GetCoord(&yylval.tok); \
   RETURN_TOKEN(x);}


%}

%s C


identifier ([a-zA-Z_][0-9a-zA-Z_]*)

exponent_part ([eE][-+]?[0-9]+)
fractional_constant ([0-9]*"."[0-9]+)|([0-9]+".")
floating_constant ((({fractional_constant}{exponent_part}?)|([0-9]+{exponent_part}))[FfLl]?)

integer_suffix_opt ([uU]?[lL]?[lL]?)|([lL][uU][lL]?)|([lL][lL][uU])
decimal_constant ("0"{integer_suffix_opt}|[1-9][0-9]*{integer_suffix_opt})
octal_constant ("0"[0-7]*{integer_suffix_opt})
hex_constant ("0"[xX][0-9a-fA-F]+{integer_suffix_opt})

simple_escape ([abfnrtv'"?\\])
octal_escape  ([0-7][^'\n]*)
hex_escape ("x"[^'\n]*)
bad_escape ([\\][^abfnrtv'"?\\x0-7\n ])

escape_sequence ([\\]({simple_escape}|{octal_escape}|{hex_escape}))
c_char ([^'\\\n]|{escape_sequence})
s_char ([^"\\\n]|{escape_sequence})

any_white ([ \011\013\014\015])
hwhite ([ \011])

%%

<INITIAL,C>{any_white}+     {  WHITE_RETURN(' ');  }

<INITIAL,C>"\n"             {  Line++; WHITE_RETURN(' ');  }

<INITIAL,C>auto                {PA_KEYWORD_RETURN(AUTO);}
<INITIAL,C>break               {PA_KEYWORD_RETURN(BREAK);}
<INITIAL,C>case                {PA_KEYWORD_RETURN(CASE);}
<INITIAL,C>char                {PA_KEYWORD_RETURN(CHAR);}
<INITIAL,C>const               {PA_KEYWORD_RETURN(CONST);}
<INITIAL,C>continue            {PA_KEYWORD_RETURN(CONTINUE);}
<INITIAL,C>default             {PA_KEYWORD_RETURN(DEFAULT);}
<INITIAL,C>define              {PP_KEYWORD_RETURN(DEFINE);}
<INITIAL,C>defined             {PP_KEYWORD_RETURN(OPDEFINED);}
<INITIAL,C>do                  {PA_KEYWORD_RETURN(DO);}
<INITIAL,C>double              {PA_KEYWORD_RETURN(DOUBLE);}
<INITIAL,C>elif                {PP_KEYWORD_RETURN(ELIF);}
<INITIAL,C>else                {PPPA_KEYWORD_RETURN(ELSE);}
<INITIAL,C>endif               {PP_KEYWORD_RETURN(ENDIF);}
<INITIAL,C>enum                {PA_KEYWORD_RETURN(ENUM);}
<INITIAL,C>error               {PP_KEYWORD_RETURN(ERROR);}
<INITIAL,C>extern              {PA_KEYWORD_RETURN(EXTERN);}
<INITIAL,C>float               {PA_KEYWORD_RETURN(FLOAT);}
<INITIAL,C>for                 {PA_KEYWORD_RETURN(FOR);}
<INITIAL,C>goto                {PA_KEYWORD_RETURN(GOTO);}
<INITIAL,C>if                  {PPPA_KEYWORD_RETURN(IF);}
<INITIAL,C>ifdef               {PP_KEYWORD_RETURN(IFDEF);}
<INITIAL,C>ifndef              {PP_KEYWORD_RETURN(IFNDEF);}
<INITIAL,C>include             {PP_KEYWORD_RETURN(INCLUDE); }
<INITIAL,C>int                 {PA_KEYWORD_RETURN(INT);}
<INITIAL,C>line                {PP_KEYWORD_RETURN(LINE);}
<INITIAL,C>long                {PA_KEYWORD_RETURN(LONG);}
<INITIAL,C>pragma              {PP_KEYWORD_RETURN(PRAGMA);}
<INITIAL,C>register            {PA_KEYWORD_RETURN(REGISTER);}
<INITIAL,C>return              {PA_KEYWORD_RETURN(RETURN);}
<INITIAL,C>short               {PA_KEYWORD_RETURN(SHORT);}
<INITIAL,C>signed              {PA_KEYWORD_RETURN(SIGNED);}
<INITIAL,C>sizeof              {PA_KEYWORD_RETURN(SIZEOF);}
<INITIAL,C>static              {PA_KEYWORD_RETURN(STATIC);}
<INITIAL,C>struct              {PA_KEYWORD_RETURN(STRUCT);}
<INITIAL,C>switch              {PA_KEYWORD_RETURN(SWITCH);}
<INITIAL,C>typedef             {PA_KEYWORD_RETURN(TYPEDEF);}
<INITIAL,C>undef               {PP_KEYWORD_RETURN(UNDEF);}
<INITIAL,C>union               {PA_KEYWORD_RETURN(UNION);}
<INITIAL,C>unsigned            {PA_KEYWORD_RETURN(UNSIGNED);}
<INITIAL,C>void                {PA_KEYWORD_RETURN(VOID);}
<INITIAL,C>volatile            {PA_KEYWORD_RETURN(VOLATILE);}
<INITIAL,C>while               {PA_KEYWORD_RETURN(WHILE);}

<INITIAL,C>inline   |
<INITIAL,C>__inline__   {PA_KEYWORD_RETURN(INLINE); }
<INITIAL,C>__attribute__   {PA_KEYWORD_RETURN(ATTRIBUTE); }


<INITIAL,C>{identifier} { GetCoord(&yylval.tok);  
                          yylval.n = MakeIdCoord(UniqueString(yytext), 
                                                 yylval.tok);
                          if (IsAType(yylval.n->u.id.text))
                            RETURN_TOKEN(TYPEDEFname);
                          else RETURN_TOKEN(IDENTIFIER); }




<INITIAL,C>{decimal_constant}  { yylval.n = int_constant(yytext, TRUE, FALSE);
                      RETURN_TOKEN(INTEGERconstant);}
<INITIAL,C>{octal_constant}    { yylval.n = int_constant(yytext, FALSE, TRUE);
                      RETURN_TOKEN(OCTALconstant);}
<INITIAL,C>{hex_constant}      { yylval.n = int_constant(yytext, FALSE, FALSE);
                      RETURN_TOKEN(HEXconstant);}

<INITIAL,C>{floating_constant}[^.] { yyless(yyleng-1);
                          yylval.n = float_constant(yytext);
                          RETURN_TOKEN(FLOATINGconstant);}


<INITIAL,C>[']{c_char}+[']     { yylval.n = char_constant(yytext);
                      RETURN_TOKEN(CHARACTERconstant); }

<INITIAL,C>[']{c_char}*[\n]    { SyntaxError("Unmatched '");
                      yylval.n = char_constant("'X'");
		      Line++;
		      RETURN_TOKEN(CHARACTERconstant); }


<INITIAL,C>['][^\\\n'][^'\n]+[']           |
<INITIAL,C>['][']                          |
<INITIAL,C>[']{bad_escape}[^'\n]*[']    { /* bad char constant */
                      yylval.n = char_constant("'X'");
                      SyntaxError(
                        "invalid char constant %s, treating as 'X'",
                        yytext);
                      RETURN_TOKEN(CHARACTERconstant);
                    }


<INITIAL,C>"L"[']{c_char}+[']  { yylval.n = wide_char_const(yytext);
                          RETURN_TOKEN(WIDECHARconstant);
                        }


<INITIAL,C>["]{s_char}*["]     { int length = strlen(yytext);
                      char *text = UniqueString(yytext);  /* save original */
                      yytext[length-1] = 0;  /* remove trailing double quote */
		      GetCoord(&yylval.tok);
                      /* remove leading double quote */
                      yylval.n = MakeStringTextCoord(
                        text,
			UniqueString(convert_escape_sequences(&yytext[1])),
					    yylval.tok);
                      RETURN_TOKEN(STRINGliteral);}

<INITIAL,C>"L"["]{s_char}*["]  { int length = strlen(yytext);
                      char *text = UniqueString(yytext);  /* save original */
                      yytext[length-1] = 0;  /* remove trailing double quote */
		      GetCoord(&yylval.tok);
                      /* remove leading double quote */
                      yylval.n = MakeStringTextCoord(
                        text,
			UniqueString(convert_escape_sequences(&yytext[1])),
					    yylval.tok);
                      RETURN_TOKEN(STRINGliteral);}

<INITIAL,C>["]{s_char}*{bad_escape}{s_char}*["]    { /* bad string constant */
    /* (unterminated string constants are caught by preprocessor) */
                      SyntaxError(
                        "string contains invalid escape code",
                        yytext);
		      GetCoord(&yylval.tok);
                      yylval.n = MakeStringTextCoord(UniqueString("\"\""),
                                            UniqueString(""),
                                            yylval.tok);
                      RETURN_TOKEN(STRINGliteral);
                    }


<INITIAL,C>"("                  {PPOP_RETURN(LP);}
<INITIAL,C>")"                  {PPOP_RETURN(RP);}
<INITIAL,C>","                  {PPOP_RETURN(COMMA);}

<INITIAL,C>^{hwhite}*"#"{hwhite}*[0-9].*"\n" |
<INITIAL,C>^{hwhite}*"#"{hwhite}*line.*"\n" {
                     parse_line_directive(yytext); }

<INITIAL,C>^{hwhite}*"#"{hwhite}*pragma{hwhite}+lang{hwhite}+"+"[Cc]{hwhite}*"\n" { EnterC(); Line++; }

<INITIAL,C>^{hwhite}*"#"{hwhite}*pragma{hwhite}+lang{hwhite}+"-"[Cc]{hwhite}*"\n" { ExitC(); Line++; }

<INITIAL,C>^{hwhite}*"#"{hwhite}*(pragma|ident).*"\n" { 
                     save_pragma_directive(yytext);
                     Line++; }

<INITIAL,C>"#"                  {NAMED_PPOP_RETURN('#') ;} 
<INITIAL,C>"##"                 {NAMED_PPOP_RETURN(POUNDPOUND);}

<INITIAL,C>"{"                  {ASCIIOP_RETURN(LC);}
<INITIAL,C>"}"                  {ASCIIOP_RETURN(RC);}

<INITIAL,C>"["                  {ASCIIOP_RETURN(LB);}
<INITIAL,C>"]"                  {ASCIIOP_RETURN(RB);}
<INITIAL,C>"."                  {ASCIIOP_RETURN(DOT);}
<INITIAL,C>"&"                  {ASCIIOP_RETURN(AND);}
<INITIAL,C>"*"                  {ASCIIOP_RETURN(STAR);}
<INITIAL,C>"+"                  {ASCIIOP_RETURN(PLUS);}
<INITIAL,C>"-"                  {ASCIIOP_RETURN(MINUS);}
<INITIAL,C>"~"                  {ASCIIOP_RETURN(NEGATE);}
<INITIAL,C>"!"                  {ASCIIOP_RETURN(NOT);}
<INITIAL,C>"/"                  {ASCIIOP_RETURN(DIV);}
<INITIAL,C>"%"                  {ASCIIOP_RETURN(MOD);}
<INITIAL,C>"<"                  {ASCIIOP_RETURN(LT);}
<INITIAL,C>">"                  {ASCIIOP_RETURN(GT);}
<INITIAL,C>"^"                  {ASCIIOP_RETURN(XOR);}
<INITIAL,C>"|"                  {ASCIIOP_RETURN(PIPE);}
<INITIAL,C>"?"                  {ASCIIOP_RETURN(QUESTION);}
<INITIAL,C>":"                  {ASCIIOP_RETURN(COLON);}
<INITIAL,C>";"                  {ASCIIOP_RETURN(SEMICOLON);}
<INITIAL,C>"="                  {ASCIIOP_RETURN(ASSIGN);}

<INITIAL,C>"->"                 {NAMEDOP_RETURN(ARROW);}
<INITIAL,C>"++"                 {NAMEDOP_RETURN(ICR);}
<INITIAL,C>"--"                 {NAMEDOP_RETURN(DECR);}
<INITIAL,C>"<<"                 {NAMEDOP_RETURN(LS);}
<INITIAL,C>">>"                 {NAMEDOP_RETURN(RS);}
<INITIAL,C>"<="                 {NAMEDOP_RETURN(LE);}
<INITIAL,C>">="                 {NAMEDOP_RETURN(GE);}
<INITIAL,C>"=="                 {NAMEDOP_RETURN(EQ);}
<INITIAL,C>"!="                 {NAMEDOP_RETURN(NE);}
<INITIAL,C>"&&"                 {NAMEDOP_RETURN(ANDAND);}
<INITIAL,C>"||"                 {NAMEDOP_RETURN(OROR);}
<INITIAL,C>"*="                 {NAMEDOP_RETURN(MULTassign);}
<INITIAL,C>"/="                 {NAMEDOP_RETURN(DIVassign);}
<INITIAL,C>"%="                 {NAMEDOP_RETURN(MODassign);}
<INITIAL,C>"+="                 {NAMEDOP_RETURN(PLUSassign);}
<INITIAL,C>"-="                 {NAMEDOP_RETURN(MINUSassign);}
<INITIAL,C>"<<="                {NAMEDOP_RETURN(LSassign);}
<INITIAL,C>">>="                {NAMEDOP_RETURN(RSassign);}
<INITIAL,C>"&="                 {NAMEDOP_RETURN(ANDassign);}
<INITIAL,C>"^="                 {NAMEDOP_RETURN(ERassign);}
<INITIAL,C>"|="                 {NAMEDOP_RETURN(ORassign);}
<INITIAL,C>"..."                {NAMEDOP_RETURN(ELLIPSIS);}


<INITIAL,C>.                    { char tmp[20];
		       CharToText(tmp, *yytext);
                       SyntaxError("Unexpected character: %s", tmp); }



%%


/*  I won't bother to provide any error recovery. I won't even handle 
unknown characters */

/*******************************************************************/

GLOBAL extern Bool DebugLex;

PRIVATE inline void GetCoord(Coord *pcoord)
{
  char *s;
  int offset;

  pcoord->file = CurrentFile;
  pcoord->line = Line;
  pcoord->includedp = CurrentIncludedp;

  offset = 0;
  for (s = line_start; s < yytext; ++s) {
    if (*s == '\t')
      offset = ((offset / TAB_WIDTH) + 1) * TAB_WIDTH;
    else ++offset;
  }
  pcoord->offset = offset;
}

PRIVATE void print_token(int token)
{
    if (DebugLex)
      fprintf(stderr, "Lexer: \"%s\", token=%d\n", yytext, token);
}

PRIVATE int hex_digit(char in)
{
    if (in >= '0' && in <= '9') return(in - '0');
    if (in >= 'a' && in <= 'f') return(in - 'a' + 10);
    if (in >= 'A' && in <= 'F') return(in - 'A' + 10);
    return -1;
}

PRIVATE int octal_digit(char in)
{
    if (in >= '0' && in <= '7') return(in - '0');
    return -1;
}

PRIVATE int parse_char_constant(const char *s, int *actual_read)
{
    assert(s[0] == '\\');
    *actual_read = 2;

    switch (s[1]) {
      case 'n': return '\n';
      case 't': return '\t';
      case 'v': return '\v';
      case 'b': return '\b';
      case 'r': return '\r';
      case 'f': return '\f';
      case 'a': return '\a';
      case '\\': return '\\';
      case '?': return '\?';
      case '\'': return '\'';
      case '\"': return '\"';
      case 'x': {
	  int val=0, tmp, i;

	  for (i=2; (tmp = hex_digit(s[i])) >= 0; i++) {
	      val = 16 * val + tmp;
	  }
	  *actual_read = i;
	  if (i==2) {
	      SyntaxError("expecting hex digits after \\x");
	      return(-1);
	  }
	  if (val > TARGET_MAX_UCHAR) {
	      SyntaxError("explicit hex character (\\x) out of range");
	      return(-1);
	  }
	  return(val);
	  break;
      }
      default:
	if (octal_digit(s[1]) >= 0) {  /* octal constant */
	    int val=0, tmp, i;
	    
	    for (i=1; (tmp = octal_digit(s[i])) >= 0  && i<4; i++) {
		val = 8 * val + tmp;
	    }
	    if (val > TARGET_MAX_UCHAR) {
		SyntaxError("explicit octal character out of range");
		return(-1);
	    }
	    *actual_read = i;
	    return(val);
	} else {
	    SyntaxError("unknown special character \"\\%c\"", s[1]);
	    return(-1);
	}
    }
    /* unreachable */
}

PRIVATE Node *char_constant(const char *s)
{
    int read, value;
    Node *n;

    assert(s[0] == '\'');
    if (s[1] == '\\') {
	value = parse_char_constant(&s[1], &read);
	if (value < 0) value = 'X';
	
	if (s[1+read] != '\'')
	  Warning(1,
		  "ignoring extra characters at end of char constant %s", s);
    } else {
	value = s[1];
	if (s[2] != '\'')
	  Warning(1,
		  "ignoring extra characters at end of char constant %s", s);
    }
    
    GetCoord(&yylval.tok);
    n = MakeConstSintTextCoord(UniqueString(s), value, yylval.tok);
    return(n);
}


PRIVATE Node *wide_char_const(const char *s)
{
    assert(s[0]=='L' && s[1]== '\'');
    return(char_constant(&s[1]));
}


PRIVATE char *convert_escape_sequences(char *string)
{
    char *read, *write;
    int actual_read, val;

    write = read = string;

    while (*read != 0) {
	if (*read == '\\') {
	    val = parse_char_constant(read, &actual_read);
	    if (val < 0) {
		*write++ = 'X';
	    } else {
		*write++ = (char) val;
	    }
	    read += actual_read;
	} else {
	    *write++ = *read++;
	}
    }
    *write = 0;
    return(string);
}

#ifdef NO_STRTOUL
unsigned long strtoul(const char *c,char **p,int base) {
  return strtol(c,p,base);
}
#endif


PRIVATE Node *int_constant(const char *s, Bool decimal, Bool octal)
{
    Node *c;
    char ch; const char *p;
    Bool is_unsigned;
    int longness;  /* 0 == not, 1==long, 2==long long */
    TARGET_ULONG value;

    longness = 0;
    is_unsigned = !decimal;

    p = &s[strlen(s) - 1];  /* address of last char in string */
    while (!isxdigit(*p)) {
	ch = toupper(*p);
	if (ch == 'U') {
	    is_unsigned = TRUE;
	} else if (ch == 'L') {
	    ++longness;
	}
	p--;
    }

    GetCoord(&yylval.tok);

    /* the following breaks if TARGET_ULONG is 'long long' */
    value = (TARGET_ULONG) strtoul(s, NULL, 0);

    if (longness==0 && !is_unsigned && value <= TARGET_MAX_INT) 
      c = MakeConstSintTextCoord(UniqueString(s), (TARGET_INT) value, yylval.tok);
    else if (longness==0 && value <= TARGET_MAX_UINT) 
      c = MakeConstUintTextCoord(UniqueString(s), (TARGET_UINT) value, yylval.tok);
    else if (longness==1 && !is_unsigned && value <= TARGET_MAX_LONG) 
      c = MakeConstSlongTextCoord(UniqueString(s), (TARGET_LONG) value, yylval.tok);
    else if (longness==1) {
      if (value > TARGET_MAX_ULONG) {
	SyntaxError("Constant `%s' is out of range", s);
      }
      c = MakeConstUlongTextCoord(UniqueString(s), (TARGET_ULONG) value, yylval.tok);
    }
    else {
      assert(longness==2);
      if (ANSIOnly)
        SyntaxErrorCoord(yylval.tok, "long long constants not allowed with -ansi switch"); 

      /* store constant value as unsigned long, but cast it to
         appropriate long long type */
      c = MakeImplicitCastCoord(
              is_unsigned ? PrimUlonglong : PrimSlonglong,
	      MakeConstUlongTextCoord(UniqueString(s), 
                                      (TARGET_ULONG) value, yylval.tok),
              yylval.tok);
    }
    return(c);
}


PRIVATE Node *float_constant(const char *s)
{
    Node *c;
    char ch; const char *p;
    Bool is_long = FALSE, is_float = FALSE;
    double value;


    p = &s[strlen(s) - 1];  /* address of last char in string */
    while (!isdigit(*p)) {
	ch = toupper(*p);
	if (ch == 'F') {
	    is_float = TRUE;
	} else if (ch == 'L') {
	    is_long = TRUE;
	}
	p--;
    }

    GetCoord(&yylval.tok);

    value = atof(s);

    if (is_float) 
      c = MakeConstFloatTextCoord(UniqueString(s), (float) value, yylval.tok);
    else if (is_long)
      /* we don't directly represent long double constants -- store it
         as a double constant implicitly cast to long double */
      c = MakeImplicitCastCoord(
              PrimLongdouble,
	      MakeConstDoubleTextCoord(UniqueString(s), 
                                       value, yylval.tok),
              yylval.tok);
    else
      c = MakeConstDoubleTextCoord(UniqueString(s), value, yylval.tok);

    return(c);
}

PRIVATE Bool HasSuffix(const char *filename, const char *suffix)
{
  int root_len = strlen(filename);
  int suffix_len = strlen(suffix);

  return (root_len >= suffix_len && 
          !strcmp(filename + root_len - suffix_len, suffix));
}
PRIVATE Bool HasIncludedSuffix(const char *name)
{
  return(HasSuffix(name,".h"));
}

GLOBAL char *Filename;
GLOBAL char *FileNames[MAX_FILES] = {"unknown"};
GLOBAL Bool FileIncludedp[MAX_FILES] = {FALSE};
GLOBAL Bool CurrentIncludedp = FALSE;
GLOBAL unsigned int CurrentFile = 0;
GLOBAL unsigned int known_files = 1;

GLOBAL void SetFile(const char *name, int line)
{
    int i;
    char *uniq = UniqueString(name);

    for (i=0; i<known_files; i++) {
	if (uniq == FileNames[i]) break;
    }
    if (i == known_files) {
	if (known_files == MAX_FILES) {
	    Warning(1, "Internal Error!");
	    fprintf(stderr, "too many distinct filenames");
	    i = CurrentFile;  /* keep using current file number */
	} else {
	    FileNames[i] = uniq;
	    known_files++;
	}
    }

    if (line == 1 && i > 1) {
        /* starting new included file.  This file is included if its
           parent was included or if it has an included suffix. */
        FileIncludedp[i] = CurrentIncludedp | HasIncludedSuffix(name);
        if (CurrentIncludedp && !HasIncludedSuffix(name)) {
            /* non-includable file included from includable file.  Issue
               a warning. */
	    Warning(1, "Non-includable file %s included from includable"
                       " file %s.", name, FileNames[CurrentFile]);
        }
    }

    CurrentFile = i;
    Filename = FileNames[i];
    CurrentIncludedp = FileIncludedp[i];
}

PRIVATE List *pragmas = NULL;

/*
   Parse a traditional or ANSI-C line number specification.

   ANSI-C:   # line <n> \n
             # line <n> "<filename>" \n
   K&R       # <n> "<filename>" \n
*/
PRIVATE void parse_line_directive(char *s)
{ char *p;
  int val;

  /* Read until a '#' sign */
  for (p = s; *p != '\n' && *p != '#'; p++);
  assert(*p != '\n');

  /* Read spaces and tabs */
  for (p = p + 1; *p != '\n' && (*p == ' ' || *p == '\t'); p++);
  assert(*p != '\n');

  /* Swallow "line" and any trailing whitespace */
  if (strncmp(p, "line", 4) == 0) {
    p = p + 4;

    /* There must be whitespace */
    assert(*p == ' ' || *p == '\t');

    for (     ; *p != '\n' && (*p == ' ' || *p == '\t'); p++);
    assert(*p != '\n');
  }

  /* Read an integer from the string */
  if (isdigit(*p))
    for (val = 0; *p && isdigit(*p); p++)
      val = val * 10 + (*p - '0');
  else {
    SyntaxError("#line error: expecting line number");
    Line++;
    return;
  }

  /* Skip whitespace */
  for (     ; *p != '\n' && (*p == ' ' || *p == '\t'); p++);

  /* Should be pointing at a '"' to start the filename or end of line */
  if (*p != '\n' && *p != '\"') {
    SyntaxError("#line error: expecting a filename string");
    Line++;
    return;
  }
  else if (*p == '\"') {
    char fname[MAX_FILENAME + 1];
    int  f; 

    for (f = 0, p++; *p != '\n' && *p != '\"' && f < MAX_FILENAME; p++, f++)
      fname[f] = *p;
    fname[f] = '\0';

    if (*p != '"') {
      SyntaxError("#line error: Filename string missing close `\"'");
      Line++;
      return;
    }
    else if (f == MAX_FILENAME)
      Warning(1, "#line error: filename truncated to %d characters",
	      MAX_FILENAME);

    if (!IgnoreLineDirectives &&
        !CurrentIncludedp &&
        HasIncludedSuffix(fname)) {
      /* SetFile will change file mode to included.  Generate an include
         that includes this new file. */
      Coord coord;
      char line[MAX_FILENAME + 13];
      
      GetCoord(&coord);
      sprintf(line,"#include \"%s\"\n", fname);
      pragmas = AppendItem(pragmas,
                           MakeTextCoord(UniqueString(line), TRUE, coord));
    }

    if (!IgnoreLineDirectives) SetFile(fname, val);
  }

  if (IgnoreLineDirectives)
    Line++;
  else
    Line = val;
}



/*
   Save pragma directive for later collection into source tree.
*/
PRIVATE void save_pragma_directive(char *s)
{
   Coord coord;

   if(CurrentIncludedp)
      return;

   GetCoord(&coord);
   pragmas = AppendItem(pragmas,
			MakeTextCoord(UniqueString(s), TRUE, coord));
}

/* GrabPragmas is called by the parser at appropriate points
   to gather pragmas into the source tree */
GLOBAL List *GrabPragmas(List *stmts_or_decls)
{
   stmts_or_decls = JoinLists(stmts_or_decls, pragmas);
   pragmas = NULL;
   return stmts_or_decls;
}

int yywrap()
{
   return 1;
}

PRIVATE void EnterC()
{
   BEGIN(C);
}

PRIVATE void ExitC()
{
   BEGIN(INITIAL);
}
