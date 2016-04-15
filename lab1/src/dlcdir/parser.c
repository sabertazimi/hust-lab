/* A Bison parser, made from ANSI-C.y
   by GNU bison 1.35.  */

#define YYBISON 1  /* Identify Bison output.  */

# define	AUTO	257
# define	DOUBLE	258
# define	INT	259
# define	STRUCT	260
# define	BREAK	261
# define	ELSE	262
# define	LONG	263
# define	SWITCH	264
# define	CASE	265
# define	ENUM	266
# define	REGISTER	267
# define	TYPEDEF	268
# define	CHAR	269
# define	EXTERN	270
# define	RETURN	271
# define	UNION	272
# define	CONST	273
# define	FLOAT	274
# define	SHORT	275
# define	UNSIGNED	276
# define	CONTINUE	277
# define	FOR	278
# define	SIGNED	279
# define	VOID	280
# define	DEFAULT	281
# define	GOTO	282
# define	SIZEOF	283
# define	VOLATILE	284
# define	DO	285
# define	IF	286
# define	STATIC	287
# define	WHILE	288
# define	UPLUS	289
# define	UMINUS	290
# define	INDIR	291
# define	ADDRESS	292
# define	POSTINC	293
# define	POSTDEC	294
# define	PREINC	295
# define	PREDEC	296
# define	BOGUS	297
# define	IDENTIFIER	298
# define	STRINGliteral	299
# define	FLOATINGconstant	300
# define	INTEGERconstant	301
# define	OCTALconstant	302
# define	HEXconstant	303
# define	WIDECHARconstant	304
# define	CHARACTERconstant	305
# define	TYPEDEFname	306
# define	ARROW	307
# define	ICR	308
# define	DECR	309
# define	LS	310
# define	RS	311
# define	LE	312
# define	GE	313
# define	EQ	314
# define	NE	315
# define	ANDAND	316
# define	OROR	317
# define	ELLIPSIS	318
# define	MULTassign	319
# define	DIVassign	320
# define	MODassign	321
# define	PLUSassign	322
# define	MINUSassign	323
# define	LSassign	324
# define	RSassign	325
# define	ANDassign	326
# define	ERassign	327
# define	ORassign	328
# define	INLINE	329
# define	ATTRIBUTE	330

#line 1 "ANSI-C.y"


    /* Copyright (C) 1989,1990 James A. Roskind, All rights reserved.
    This grammar was developed  and  written  by  James  A.  Roskind. 
    Copying  of  this  grammar  description, as a whole, is permitted 
    providing this notice is intact and applicable  in  all  complete 
    copies.   Translations as a whole to other parser generator input 
    languages  (or  grammar  description  languages)   is   permitted 
    provided  that  this  notice is intact and applicable in all such 
    copies,  along  with  a  disclaimer  that  the  contents  are   a 
    translation.   The reproduction of derived text, such as modified 
    versions of this grammar, or the output of parser generators,  is 
    permitted,  provided  the  resulting  work includes the copyright 
    notice "Portions Copyright (c)  1989,  1990  James  A.  Roskind". 
    Derived products, such as compilers, translators, browsers, etc., 
    that  use  this  grammar,  must also provide the notice "Portions 
    Copyright  (c)  1989,  1990  James  A.  Roskind"  in   a   manner 
    appropriate  to  the  utility,  and in keeping with copyright law 
    (e.g.: EITHER displayed when first invoked/executed; OR displayed 
    continuously on display terminal; OR via placement in the  object 
    code  in  form  readable in a printout, with or near the title of 
    the work, or at the end of the file).  No royalties, licenses  or 
    commissions  of  any  kind are required to copy this grammar, its 
    translations, or derivative products, when the copies are made in 
    compliance with this notice. Persons or corporations that do make 
    copies in compliance with this notice may charge  whatever  price 
    is  agreeable  to  a  buyer, for such copies or derivative works. 
    THIS GRAMMAR IS PROVIDED ``AS IS'' AND  WITHOUT  ANY  EXPRESS  OR 
    IMPLIED  WARRANTIES,  INCLUDING,  WITHOUT LIMITATION, THE IMPLIED 
    WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS  FOR  A  PARTICULAR 
    PURPOSE.

    James A. Roskind
    Independent Consultant
    516 Latania Palm Drive
    Indialantic FL, 32903
    (407)729-4348
    jar@ileaf.com
    or ...!uunet!leafusa!jar


    ---end of copyright notice---


This file is a companion file to a C++ grammar description file.

*/

/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  File: ANSI-C.y
 *  ANSI-C.y,v
 * Revision 1.18  1995/05/11  18:53:51  rcm
 * Added gcc extension __attribute__.
 *
 * Revision 1.17  1995/04/21  05:43:54  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.16  1995/04/09  21:30:36  rcm
 * Added Analysis phase to perform all analysis at one place in pipeline.
 * Also added checking for functions without return values and unreachable
 * code.  Added tests of live-variable analysis.
 *
 * Revision 1.15  1995/02/13  01:59:53  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.14  1995/02/10  22:09:37  rcm
 * Allow comma at end of enum
 *
 * Revision 1.13  1995/02/01  23:01:20  rcm
 * Added Text node and #pragma collection
 *
 * Revision 1.12  1995/02/01  21:07:01  rcm
 * New AST constructors convention: MakeFoo makes a foo with unknown coordinates,
 * whereas MakeFooCoord takes an explicit Coord argument.
 *
 * Revision 1.11  1995/02/01  07:36:18  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.10  1995/01/27  01:38:45  rcm
 * Redesigned type qualifiers and storage classes;  introduced "declaration
 * qualifier."
 *
 * Revision 1.9  1995/01/25  21:38:10  rcm
 * Added TypeModifiers to make type modifiers extensible
 *
 * Revision 1.8  1995/01/25  02:16:10  rcm
 * Changed how Prim types are created and merged.
 *
 * Revision 1.7  1995/01/20  03:37:53  rcm
 * Added some GNU extensions (long long, zero-length arrays, cast to union).
 * Moved all scope manipulation out of lexer.
 *
 * Revision 1.6  1994/12/23  09:16:00  rcm
 * Marks global declarations
 *
 * Revision 1.5  1994/12/20  09:23:44  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.4  1994/11/22  01:54:20  rcm
 * No longer folds constant expressions.
 *
 * Revision 1.3  1994/11/10  03:07:26  rcm
 * Line-number behavior changed.  Now keeps coordinates of first terminal
 * in production, rather than end of production.
 *
 * Revision 1.2  1994/10/28  18:51:53  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *************************************************************************/
#pragma ident "ANSI-C.y,v 1.18 1995/05/11 18:53:51 rcm Exp"

/* FILENAME: C.Y */

/*  This  is a grammar file for the dpANSI C language.  This file was 
last modified by J. Roskind on 3/7/90. Version 1.00 */




/* ACKNOWLEDGMENT:

Without the effort expended by the ANSI C standardizing committee,  I 
would  have been lost.  Although the ANSI C standard does not include 
a fully disambiguated syntax description, the committee has at  least 
provided most of the disambiguating rules in narratives.

Several  reviewers  have also recently critiqued this grammar, and/or 
assisted in discussions during it's preparation.  These reviewers are 
certainly not responsible for the errors I have committed  here,  but 
they  are responsible for allowing me to provide fewer errors.  These 
colleagues include: Bruce Blodgett, and Mark Langley. */

/* Added by Eric A. Brewer */

#define _Y_TAB_H_  /* prevents redundant inclusion of y.tab.h */
#include "ast.h"

#ifndef YYDEBUG
int yydebug=0;
#endif

extern int yylex(void);

GLOBAL List *GrabPragmas(List *stmts_or_decls);  /* from c4.l */
PRIVATE void WarnAboutPrecedence(OpType op, Node *node);

PRIVATE void yyerror(const char *msg)
{
    SyntaxError(msg);
}

/* End of create code (EAB) */





#line 211 "ANSI-C.y"
#ifndef YYSTYPE
typedef union {
    Node      *n;
    List      *L;

  /* tq: type qualifiers */
    struct {
        TypeQual   tq;
	Coord      coord;   /* coordinates where type quals began */ 
    } tq;

  /* tok: token coordinates */
    Coord tok;
} yystype;
# define YYSTYPE yystype
# define YYSTYPE_IS_TRIVIAL 1
#endif
#ifndef YYDEBUG
# define YYDEBUG 0
#endif



#define	YYFINAL		647
#define	YYFLAG		-32768
#define	YYNTBASE	101

/* YYTRANSLATE(YYLEX) -- Bison token number corresponding to YYLEX. */
#define YYTRANSLATE(x) ((unsigned)(x) <= 330 ? yytranslate[x] : 250)

/* YYTRANSLATE[YYLEX] -- Bison token number corresponding to YYLEX. */
static const char yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     8,     2,     2,     2,    13,     3,     2,
      15,    16,     4,     5,    22,     6,    17,    14,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    25,    19,
       9,    88,    10,    18,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    23,     2,    24,    12,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    20,    11,    21,     7,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,    26,    27,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    60,    61,    62,    63,    64,    65,    66,    67,    68,
      69,    70,    71,    72,    73,    74,    75,    76,    77,    78,
      79,    80,    81,    82,    83,    84,    85,    86,    87,    89,
      90,    91,    92,    93,    94,    95,    96,    97,    98,    99,
     100
};

#if YYDEBUG
static const short yyprhs[] =
{
       0,     0,     2,     4,     6,     8,    12,    18,    25,    27,
      32,    36,    41,    45,    49,    52,    55,    59,    63,    65,
      69,    71,    74,    77,    80,    83,    88,    90,    92,    94,
      96,    98,   100,   102,   107,   109,   113,   117,   121,   123,
     127,   131,   133,   137,   141,   143,   147,   151,   155,   159,
     161,   165,   169,   171,   175,   177,   181,   183,   187,   189,
     193,   195,   199,   201,   207,   209,   213,   215,   217,   219,
     221,   223,   225,   227,   229,   231,   233,   235,   237,   241,
     243,   244,   246,   249,   252,   255,   258,   259,   260,   267,
     268,   269,   276,   277,   278,   286,   287,   293,   294,   300,
     304,   305,   306,   313,   314,   315,   322,   323,   324,   332,
     333,   339,   340,   346,   350,   352,   354,   356,   359,   362,
     365,   368,   371,   374,   377,   380,   383,   386,   388,   391,
     394,   396,   398,   400,   402,   404,   406,   409,   412,   415,
     417,   420,   423,   425,   428,   431,   433,   436,   438,   441,
     443,   445,   447,   449,   451,   453,   455,   458,   463,   469,
     473,   477,   482,   487,   489,   493,   495,   498,   500,   502,
     505,   509,   513,   518,   520,   522,   524,   526,   529,   532,
     536,   540,   544,   548,   553,   555,   558,   562,   564,   566,
     568,   571,   575,   578,   582,   587,   589,   593,   595,   598,
     602,   607,   611,   616,   618,   622,   624,   626,   628,   631,
     633,   636,   637,   639,   641,   644,   651,   653,   657,   658,
     660,   665,   667,   669,   671,   672,   675,   679,   684,   686,
     688,   692,   694,   698,   700,   702,   706,   710,   714,   716,
     719,   722,   725,   727,   730,   733,   735,   738,   741,   744,
     746,   749,   752,   755,   759,   764,   768,   773,   779,   782,
     786,   791,   793,   795,   797,   800,   803,   806,   809,   813,
     816,   820,   824,   827,   831,   834,   835,   837,   840,   846,
     853,   856,   859,   864,   865,   868,   869,   871,   873,   875,
     877,   879,   881,   883,   886,   887,   892,   897,   901,   905,
     908,   912,   916,   921,   923,   925,   928,   932,   936,   941,
     943,   946,   948,   951,   954,   960,   968,   969,   976,   977,
     984,   985,   994,   995,  1006,  1007,  1018,  1019,  1030,  1031,
    1042,  1043,  1050,  1054,  1057,  1060,  1064,  1068,  1070,  1073,
    1075,  1077,  1078,  1082,  1085,  1086,  1091,  1092,  1097,  1098,
    1103,  1104,  1109,  1110,  1114,  1115,  1120,  1121,  1126,  1127,
    1132,  1133,  1138,  1139,  1144,  1145,  1151,  1152,  1158,  1159,
    1165,  1166,  1172,  1173,  1176,  1178,  1180,  1182,  1184,  1186,
    1188,  1191,  1193,  1195,  1197,  1199,  1201,  1203,  1205,  1207,
    1209,  1211,  1213,  1215,  1217,  1219,  1221,  1223,  1225,  1227
};
static const short yyrhs[] =
{
     224,     0,    67,     0,   244,     0,   245,     0,    15,   121,
      16,     0,    15,   207,   211,   208,    16,     0,    15,   207,
     210,   211,   208,    16,     0,   102,     0,   103,    23,   121,
      24,     0,   103,    15,    16,     0,   103,    15,   104,    16,
       0,   103,    17,    67,     0,   103,    76,    67,     0,   103,
      77,     0,   103,    78,     0,   103,    17,    75,     0,   103,
      76,    75,     0,   119,     0,   104,    22,   119,     0,   103,
       0,    77,   105,     0,    78,   105,     0,   106,   107,     0,
      52,   105,     0,    52,    15,   175,    16,     0,     3,     0,
       4,     0,     5,     0,     6,     0,     7,     0,     8,     0,
     105,     0,    15,   175,    16,   107,     0,   107,     0,   108,
       4,   107,     0,   108,    14,   107,     0,   108,    13,   107,
       0,   108,     0,   109,     5,   108,     0,   109,     6,   108,
       0,   109,     0,   110,    79,   109,     0,   110,    80,   109,
       0,   110,     0,   111,     9,   110,     0,   111,    10,   110,
       0,   111,    81,   110,     0,   111,    82,   110,     0,   111,
       0,   112,    83,   111,     0,   112,    84,   111,     0,   112,
       0,   113,     3,   112,     0,   113,     0,   114,    12,   113,
       0,   114,     0,   115,    11,   114,     0,   115,     0,   116,
      85,   115,     0,   116,     0,   117,    86,   116,     0,   117,
       0,   117,    18,   121,    25,   118,     0,   118,     0,   105,
     120,   119,     0,    88,     0,    89,     0,    90,     0,    91,
       0,    92,     0,    93,     0,    94,     0,    95,     0,    96,
       0,    97,     0,    98,     0,   119,     0,   121,    22,   119,
       0,   118,     0,     0,   121,     0,   125,    19,     0,   134,
      19,     0,   145,    19,     0,   151,    19,     0,     0,     0,
     143,   156,   126,   176,   127,   182,     0,     0,     0,   149,
     156,   128,   176,   129,   182,     0,     0,     0,   125,    22,
     156,   130,   176,   131,   182,     0,     0,   143,     1,   132,
     176,   182,     0,     0,   149,     1,   133,   176,   182,     0,
     125,    22,     1,     0,     0,     0,   147,   167,   135,   176,
     136,   182,     0,     0,     0,   153,   167,   137,   176,   138,
     182,     0,     0,     0,   134,    22,   167,   139,   176,   140,
     182,     0,     0,   147,     1,   141,   176,   182,     0,     0,
     153,     1,   142,   176,   182,     0,   134,    22,     1,     0,
     144,     0,   145,     0,   146,     0,   150,   248,     0,   147,
     249,     0,   144,   148,     0,   144,   249,     0,   151,   248,
       0,   147,   155,     0,   145,   148,     0,   152,   248,     0,
     147,    75,     0,   146,   148,     0,   248,     0,   153,   248,
       0,   147,   148,     0,   246,     0,   248,     0,   150,     0,
     151,     0,   152,     0,   249,     0,   153,   249,     0,   150,
     246,     0,   150,   249,     0,   155,     0,   153,   155,     0,
     151,   246,     0,    75,     0,   153,    75,     0,   152,   246,
       0,   246,     0,   153,   246,     0,   247,     0,   154,   247,
       0,   189,     0,   199,     0,   157,     0,   160,     0,   167,
       0,   171,     0,   158,     0,     4,   157,     0,     4,    15,
     159,    16,     0,     4,   154,    15,   159,    16,     0,     4,
     154,   157,     0,    15,   157,    16,     0,    15,   159,   166,
      16,     0,    15,   157,    16,   166,     0,    75,     0,    15,
     159,    16,     0,    75,     0,    75,   166,     0,   161,     0,
     162,     0,     4,   160,     0,     4,   154,   160,     0,    15,
     161,    16,     0,    15,   161,    16,   166,     0,   164,     0,
     165,     0,   166,     0,     4,     0,     4,   154,     0,     4,
     163,     0,     4,   154,   163,     0,    15,   164,    16,     0,
      15,   165,    16,     0,    15,   166,    16,     0,    15,   164,
      16,   166,     0,   188,     0,    15,    16,     0,    15,   185,
      16,     0,   168,     0,   170,     0,   169,     0,     4,   167,
       0,     4,   154,   167,     0,   170,   166,     0,    15,   168,
      16,     0,    15,   168,    16,   166,     0,    67,     0,    15,
     170,    16,     0,   172,     0,     4,   171,     0,     4,   154,
     171,     0,   170,    15,   173,    16,     0,    15,   171,    16,
       0,    15,   171,    16,   166,     0,    67,     0,   173,    22,
      67,     0,    67,     0,    75,     0,   149,     0,   149,   163,
       0,   153,     0,   153,   163,     0,     0,   177,     0,   178,
       0,   177,   178,     0,   100,    15,    15,   179,    16,    16,
       0,   180,     0,   179,    22,   180,     0,     0,   181,     0,
     181,    15,   121,    16,     0,    67,     0,    75,     0,    42,
       0,     0,    88,   183,     0,    20,   184,    21,     0,    20,
     184,    22,    21,     0,   119,     0,   183,     0,   184,    22,
     183,     0,   186,     0,   186,    22,    87,     0,    87,     0,
     187,     0,   186,    22,   187,     0,   187,    88,   183,     0,
     186,    22,     1,     0,   143,     0,   143,   163,     0,   143,
     167,     0,   143,   160,     0,   147,     0,   147,   163,     0,
     147,   167,     0,   149,     0,   149,   163,     0,   149,   167,
       0,   149,   160,     0,   153,     0,   153,   163,     0,   153,
     167,     0,    23,    24,     0,    23,   122,    24,     0,   188,
      23,   122,    24,     0,   188,    23,    24,     0,   190,    20,
     191,    21,     0,   190,   174,    20,   191,    21,     0,   190,
     174,     0,   190,    20,    21,     0,   190,   174,    20,    21,
       0,    29,     0,    41,     0,   192,     0,   191,   192,     0,
     194,    19,     0,   193,    19,     0,   153,   196,     0,   193,
      22,   196,     0,   149,   195,     0,   194,    22,   195,     0,
     156,   197,   176,     0,   198,   176,     0,   167,   197,   176,
       0,   198,   176,     0,     0,   198,     0,    25,   122,     0,
      35,    20,   200,   202,    21,     0,    35,   174,    20,   200,
     202,    21,     0,    35,   174,     0,   174,   201,     0,   200,
      22,   174,   201,     0,     0,    88,   122,     0,     0,    22,
       0,   204,     0,   206,     0,   212,     0,   213,     0,   215,
       0,   223,     0,     1,    19,     0,     0,    67,    25,   205,
     203,     0,    34,   122,    25,   203,     0,    50,    25,   203,
       0,    75,    25,   203,     0,   207,   208,     0,   207,   210,
     208,     0,   207,   211,   208,     0,   207,   210,   211,   208,
       0,    20,     0,    21,     0,    20,    21,     0,    20,   210,
      21,     0,    20,   211,    21,     0,    20,   210,   211,    21,
       0,   124,     0,   210,   124,     0,   203,     0,   211,   203,
       0,   123,    19,     0,    55,    15,   121,    16,   203,     0,
      55,    15,   121,    16,   203,    31,   203,     0,     0,    33,
     214,    15,   121,    16,   203,     0,     0,    57,   216,    15,
     121,    16,   203,     0,     0,    54,   217,   203,    57,    15,
     121,    16,    19,     0,     0,    47,    15,   123,    19,   123,
      19,   123,    16,   218,   203,     0,     0,    47,    15,     1,
      19,   123,    19,   123,    16,   219,   203,     0,     0,    47,
      15,   123,    19,   123,    19,     1,    16,   220,   203,     0,
       0,    47,    15,   123,    19,     1,    19,   123,    16,   221,
     203,     0,     0,    47,    15,     1,    16,   222,   203,     0,
      51,    67,    19,     0,    46,    19,     0,    30,    19,     0,
      40,   123,    19,     0,    51,    75,    19,     0,   225,     0,
     224,   225,     0,   124,     0,   226,     0,     0,   167,   227,
     209,     0,   167,    66,     0,     0,   143,   167,   228,   209,
       0,     0,   149,   167,   229,   209,     0,     0,   147,   167,
     230,   209,     0,     0,   153,   167,   231,   209,     0,     0,
     171,   232,   209,     0,     0,   143,   171,   233,   209,     0,
       0,   149,   171,   234,   209,     0,     0,   147,   171,   235,
     209,     0,     0,   153,   171,   236,   209,     0,     0,   171,
     242,   237,   209,     0,     0,   143,   171,   242,   238,   209,
       0,     0,   149,   171,   242,   239,   209,     0,     0,   147,
     171,   242,   240,   209,     0,     0,   153,   171,   242,   241,
     209,     0,     0,   243,   210,     0,    69,     0,    70,     0,
      71,     0,    72,     0,    74,     0,    68,     0,   245,    68,
       0,    42,     0,    53,     0,    99,     0,    42,     0,    53,
       0,    37,     0,    39,     0,    56,     0,    26,     0,    36,
       0,    49,     0,    38,     0,    28,     0,    43,     0,    27,
       0,    48,     0,    45,     0,    44,     0,    32,     0
};

#endif

#if YYDEBUG
/* YYRLINE[YYN] -- source line where rule number YYN was defined. */
static const short yyrline[] =
{
       0,   342,   352,   355,   356,   357,   362,   366,   372,   374,
     376,   378,   380,   382,   384,   386,   390,   392,   396,   399,
     403,   406,   408,   410,   413,   415,   419,   421,   422,   423,
     424,   425,   428,   430,   434,   436,   438,   440,   444,   446,
     448,   452,   454,   456,   460,   462,   464,   466,   468,   472,
     474,   476,   480,   482,   486,   488,   496,   498,   506,   508,
     512,   514,   522,   524,   531,   533,   539,   541,   543,   545,
     547,   549,   551,   553,   555,   557,   559,   563,   565,   579,
     583,   585,   620,   623,   625,   627,   632,   632,   632,   642,
     642,   642,   651,   651,   651,   663,   663,   673,   673,   683,
     688,   688,   688,   698,   698,   698,   707,   707,   707,   714,
     714,   724,   724,   734,   738,   741,   742,   747,   750,   752,
     754,   760,   763,   765,   771,   774,   776,   782,   784,   787,
     793,   795,   799,   802,   803,   807,   809,   811,   813,   818,
     820,   822,   828,   831,   833,   838,   840,   845,   847,   853,
     855,   859,   861,   862,   863,   872,   874,   877,   880,   883,
     890,   894,   897,   903,   906,   912,   915,   917,   925,   927,
     930,   936,   940,   946,   948,   949,   953,   956,   958,   961,
     967,   971,   974,   977,   983,   985,   986,   990,   992,   996,
     998,  1001,  1007,  1010,  1013,  1019,  1022,  1028,  1034,  1037,
    1043,  1049,  1053,  1068,  1071,  1076,  1078,  1082,  1085,  1087,
    1089,  1096,  1099,  1103,  1106,  1110,  1117,  1120,  1124,  1127,
    1129,  1134,  1136,  1137,  1141,  1143,  1147,  1149,  1150,  1154,
    1157,  1166,  1168,  1171,  1179,  1182,  1186,  1191,  1196,  1199,
    1202,  1205,  1208,  1210,  1212,  1214,  1216,  1219,  1222,  1225,
    1227,  1229,  1234,  1237,  1239,  1243,  1258,  1263,  1268,  1273,
    1279,  1288,  1290,  1294,  1296,  1301,  1303,  1308,  1315,  1320,
    1323,  1329,  1333,  1339,  1343,  1349,  1351,  1355,  1360,  1363,
    1365,  1370,  1373,  1378,  1380,  1383,  1385,  1394,  1396,  1397,
    1398,  1399,  1400,  1402,  1406,  1406,  1412,  1414,  1418,  1422,
    1425,  1427,  1429,  1433,  1435,  1441,  1444,  1446,  1448,  1454,
    1456,  1460,  1462,  1466,  1470,  1473,  1475,  1475,  1480,  1480,
    1485,  1485,  1489,  1489,  1495,  1495,  1499,  1499,  1503,  1503,
    1507,  1507,  1511,  1514,  1516,  1518,  1522,  1532,  1534,  1539,
    1550,  1562,  1562,  1575,  1579,  1579,  1588,  1588,  1600,  1600,
    1611,  1611,  1622,  1622,  1634,  1634,  1645,  1645,  1656,  1656,
    1668,  1668,  1680,  1680,  1692,  1692,  1703,  1703,  1714,  1714,
    1726,  1726,  1742,  1742,  1759,  1761,  1762,  1763,  1764,  1768,
    1770,  1791,  1793,  1794,  1797,  1799,  1802,  1804,  1805,  1806,
    1807,  1810,  1812,  1813,  1814,  1815,  1817,  1818,  1820,  1821
};
#endif


#if (YYDEBUG) || defined YYERROR_VERBOSE

/* YYTNAME[TOKEN_NUM] -- String name of the token TOKEN_NUM. */
static const char *const yytname[] =
{
  "$", "error", "$undefined.", "'&'", "'*'", "'+'", "'-'", "'~'", "'!'", 
  "'<'", "'>'", "'|'", "'^'", "'%'", "'/'", "'('", "')'", "'.'", "'?'", 
  "';'", "'{'", "'}'", "','", "'['", "']'", "':'", "AUTO", "DOUBLE", 
  "INT", "STRUCT", "BREAK", "ELSE", "LONG", "SWITCH", "CASE", "ENUM", 
  "REGISTER", "TYPEDEF", "CHAR", "EXTERN", "RETURN", "UNION", "CONST", 
  "FLOAT", "SHORT", "UNSIGNED", "CONTINUE", "FOR", "SIGNED", "VOID", 
  "DEFAULT", "GOTO", "SIZEOF", "VOLATILE", "DO", "IF", "STATIC", "WHILE", 
  "UPLUS", "UMINUS", "INDIR", "ADDRESS", "POSTINC", "POSTDEC", "PREINC", 
  "PREDEC", "BOGUS", "IDENTIFIER", "STRINGliteral", "FLOATINGconstant", 
  "INTEGERconstant", "OCTALconstant", "HEXconstant", "WIDECHARconstant", 
  "CHARACTERconstant", "TYPEDEFname", "ARROW", "ICR", "DECR", "LS", "RS", 
  "LE", "GE", "EQ", "NE", "ANDAND", "OROR", "ELLIPSIS", "'='", 
  "MULTassign", "DIVassign", "MODassign", "PLUSassign", "MINUSassign", 
  "LSassign", "RSassign", "ANDassign", "ERassign", "ORassign", "INLINE", 
  "ATTRIBUTE", "prog.start", "primary.expression", "postfix.expression", 
  "argument.expression.list", "unary.expression", "unary.operator", 
  "cast.expression", "multiplicative.expression", "additive.expression", 
  "shift.expression", "relational.expression", "equality.expression", 
  "AND.expression", "exclusive.OR.expression", "inclusive.OR.expression", 
  "logical.AND.expression", "logical.OR.expression", 
  "conditional.expression", "assignment.expression", 
  "assignment.operator", "expression", "constant.expression", 
  "expression.opt", "declaration", "declaring.list", "@1", "@2", "@3", 
  "@4", "@5", "@6", "@7", "@8", "default.declaring.list", "@9", "@10", 
  "@11", "@12", "@13", "@14", "@15", "@16", "declaration.specifier", 
  "basic.declaration.specifier", "sue.declaration.specifier", 
  "typedef.declaration.specifier", "declaration.qualifier.list", 
  "declaration.qualifier", "type.specifier", "basic.type.specifier", 
  "sue.type.specifier", "typedef.type.specifier", "type.qualifier.list", 
  "pointer.type.qualifier.list", "elaborated.type.name", "declarator", 
  "paren.typedef.declarator", "paren.postfix.typedef.declarator", 
  "simple.paren.typedef.declarator", "parameter.typedef.declarator", 
  "clean.typedef.declarator", "clean.postfix.typedef.declarator", 
  "abstract.declarator", "unary.abstract.declarator", 
  "postfix.abstract.declarator", "postfixing.abstract.declarator", 
  "identifier.declarator", "unary.identifier.declarator", 
  "postfix.identifier.declarator", "paren.identifier.declarator", 
  "old.function.declarator", "postfix.old.function.declarator", 
  "identifier.list", "identifier.or.typedef.name", "type.name", 
  "attributes.opt", "attributes", "attribute", "attribute.list", "attrib", 
  "any.word", "initializer.opt", "initializer", "initializer.list", 
  "parameter.type.list", "parameter.list", "parameter.declaration", 
  "array.abstract.declarator", "struct.or.union.specifier", 
  "struct.or.union", "struct.declaration.list", "struct.declaration", 
  "struct.default.declaring.list", "struct.declaring.list", 
  "struct.declarator", "struct.identifier.declarator", 
  "bit.field.size.opt", "bit.field.size", "enum.specifier", 
  "enumerator.list", "enumerator.value.opt", "comma.opt", "statement", 
  "labeled.statement", "@17", "compound.statement", "lblock", "rblock", 
  "compound.statement.no.new.scope", "declaration.list", "statement.list", 
  "expression.statement", "selection.statement", "@18", 
  "iteration.statement", "@19", "@20", "@21", "@22", "@23", "@24", "@25", 
  "jump.statement", "translation.unit", "external.definition", 
  "function.definition", "@26", "@27", "@28", "@29", "@30", "@31", "@32", 
  "@33", "@34", "@35", "@36", "@37", "@38", "@39", "@40", 
  "old.function.declaration.list", "@41", "constant", 
  "string.literal.list", "type.qualifier", "pointer.type.qualifier", 
  "storage.class", "basic.type.name", 0
};
#endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives. */
static const short yyr1[] =
{
       0,   101,   102,   102,   102,   102,   102,   102,   103,   103,
     103,   103,   103,   103,   103,   103,   103,   103,   104,   104,
     105,   105,   105,   105,   105,   105,   106,   106,   106,   106,
     106,   106,   107,   107,   108,   108,   108,   108,   109,   109,
     109,   110,   110,   110,   111,   111,   111,   111,   111,   112,
     112,   112,   113,   113,   114,   114,   115,   115,   116,   116,
     117,   117,   118,   118,   119,   119,   120,   120,   120,   120,
     120,   120,   120,   120,   120,   120,   120,   121,   121,   122,
     123,   123,   124,   124,   124,   124,   126,   127,   125,   128,
     129,   125,   130,   131,   125,   132,   125,   133,   125,   125,
     135,   136,   134,   137,   138,   134,   139,   140,   134,   141,
     134,   142,   134,   134,   143,   143,   143,   144,   144,   144,
     144,   145,   145,   145,   146,   146,   146,   147,   147,   147,
     148,   148,   149,   149,   149,   150,   150,   150,   150,   151,
     151,   151,   152,   152,   152,   153,   153,   154,   154,   155,
     155,   156,   156,   156,   156,   157,   157,   157,   157,   157,
     158,   158,   158,   159,   159,   160,   160,   160,   161,   161,
     161,   162,   162,   163,   163,   163,   164,   164,   164,   164,
     165,   165,   165,   165,   166,   166,   166,   167,   167,   168,
     168,   168,   169,   169,   169,   170,   170,   171,   171,   171,
     172,   172,   172,   173,   173,   174,   174,   175,   175,   175,
     175,   176,   176,   177,   177,   178,   179,   179,   180,   180,
     180,   181,   181,   181,   182,   182,   183,   183,   183,   184,
     184,   185,   185,   185,   186,   186,   186,   186,   187,   187,
     187,   187,   187,   187,   187,   187,   187,   187,   187,   187,
     187,   187,   188,   188,   188,   188,   189,   189,   189,   189,
     189,   190,   190,   191,   191,   192,   192,   193,   193,   194,
     194,   195,   195,   196,   196,   197,   197,   198,   199,   199,
     199,   200,   200,   201,   201,   202,   202,   203,   203,   203,
     203,   203,   203,   203,   205,   204,   204,   204,   204,   206,
     206,   206,   206,   207,   208,   209,   209,   209,   209,   210,
     210,   211,   211,   212,   213,   213,   214,   213,   216,   215,
     217,   215,   218,   215,   219,   215,   220,   215,   221,   215,
     222,   215,   223,   223,   223,   223,   223,   224,   224,   225,
     225,   227,   226,   226,   228,   226,   229,   226,   230,   226,
     231,   226,   232,   226,   233,   226,   234,   226,   235,   226,
     236,   226,   237,   226,   238,   226,   239,   226,   240,   226,
     241,   226,   243,   242,   244,   244,   244,   244,   244,   245,
     245,   246,   246,   246,   247,   247,   248,   248,   248,   248,
     248,   249,   249,   249,   249,   249,   249,   249,   249,   249
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN. */
static const short yyr2[] =
{
       0,     1,     1,     1,     1,     3,     5,     6,     1,     4,
       3,     4,     3,     3,     2,     2,     3,     3,     1,     3,
       1,     2,     2,     2,     2,     4,     1,     1,     1,     1,
       1,     1,     1,     4,     1,     3,     3,     3,     1,     3,
       3,     1,     3,     3,     1,     3,     3,     3,     3,     1,
       3,     3,     1,     3,     1,     3,     1,     3,     1,     3,
       1,     3,     1,     5,     1,     3,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     3,     1,
       0,     1,     2,     2,     2,     2,     0,     0,     6,     0,
       0,     6,     0,     0,     7,     0,     5,     0,     5,     3,
       0,     0,     6,     0,     0,     6,     0,     0,     7,     0,
       5,     0,     5,     3,     1,     1,     1,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     1,     2,     2,
       1,     1,     1,     1,     1,     1,     2,     2,     2,     1,
       2,     2,     1,     2,     2,     1,     2,     1,     2,     1,
       1,     1,     1,     1,     1,     1,     2,     4,     5,     3,
       3,     4,     4,     1,     3,     1,     2,     1,     1,     2,
       3,     3,     4,     1,     1,     1,     1,     2,     2,     3,
       3,     3,     3,     4,     1,     2,     3,     1,     1,     1,
       2,     3,     2,     3,     4,     1,     3,     1,     2,     3,
       4,     3,     4,     1,     3,     1,     1,     1,     2,     1,
       2,     0,     1,     1,     2,     6,     1,     3,     0,     1,
       4,     1,     1,     1,     0,     2,     3,     4,     1,     1,
       3,     1,     3,     1,     1,     3,     3,     3,     1,     2,
       2,     2,     1,     2,     2,     1,     2,     2,     2,     1,
       2,     2,     2,     3,     4,     3,     4,     5,     2,     3,
       4,     1,     1,     1,     2,     2,     2,     2,     3,     2,
       3,     3,     2,     3,     2,     0,     1,     2,     5,     6,
       2,     2,     4,     0,     2,     0,     1,     1,     1,     1,
       1,     1,     1,     2,     0,     4,     4,     3,     3,     2,
       3,     3,     4,     1,     1,     2,     3,     3,     4,     1,
       2,     1,     2,     2,     5,     7,     0,     6,     0,     6,
       0,     8,     0,    10,     0,    10,     0,    10,     0,    10,
       0,     6,     3,     2,     2,     3,     3,     1,     2,     1,
       1,     0,     3,     2,     0,     4,     0,     4,     0,     4,
       0,     4,     0,     3,     0,     4,     0,     4,     0,     4,
       0,     4,     0,     4,     0,     5,     0,     5,     0,     5,
       0,     5,     0,     2,     1,     1,     1,     1,     1,     1,
       2,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1
};

/* YYDEFACT[S] -- default rule to reduce with in state S when YYTABLE
   doesn't specify something else to do.  Zero means the default is an
   error. */
static const short yydefact[] =
{
       0,     0,     0,   389,   395,   393,   261,   399,     0,   390,
     386,   392,   387,   262,   381,   394,   398,   397,   396,   391,
     382,   388,   195,   142,   383,   339,     0,     0,     0,   114,
     115,   116,     0,     0,   132,   133,   134,     0,   139,   341,
     187,   189,   188,   372,   197,   149,     0,   150,     1,   337,
     340,   145,   127,   135,   384,   385,     0,   190,   198,   147,
       0,     0,     0,     0,   205,   206,   280,    82,     0,    83,
       0,    95,     0,     0,   165,    86,   151,   155,   152,   167,
     168,   153,   372,   119,   130,   131,   120,    84,   123,   126,
     109,   125,   129,   122,   100,   372,   118,    97,    89,   153,
     372,   137,   117,   138,    85,   141,   121,   144,   124,   111,
     143,   140,   103,   372,   146,   128,   136,   343,     0,     0,
       0,   192,   184,     0,   362,     0,     0,   258,   338,   191,
     199,   148,   193,   196,   201,   283,   285,     0,    99,    92,
     153,   154,   113,     0,     0,   106,   188,   211,     0,     0,
     156,   169,     0,   163,     0,     0,     0,     0,   166,   211,
       0,     0,   364,   211,   211,     0,     0,   368,   211,   211,
       0,     0,   366,   211,   211,     0,     0,   370,     0,   342,
     185,   203,   233,   238,   115,   242,   245,   133,   249,     0,
       0,   231,   234,    26,    27,    28,    29,    30,    31,     0,
     252,     0,     2,   379,   374,   375,   376,   377,   378,     0,
       0,     8,    20,    32,     0,    34,    38,    41,    44,    49,
      52,    54,    56,    58,    60,    62,    79,     0,     3,     4,
       0,   353,     0,   309,     0,     0,     0,     0,   373,   259,
       0,   132,   133,   134,     0,     0,   263,     0,     0,     0,
     194,   202,     0,   281,   286,     0,   285,   211,     0,     0,
     211,     0,   224,   212,   213,     0,     0,   159,   170,     0,
     160,     0,   171,    87,   345,   355,     0,   224,   101,   349,
     359,     0,   224,    90,   347,   357,     0,   224,   104,   351,
     361,     0,     0,   303,   305,     0,   316,     0,    80,     0,
       0,     0,     0,   320,     0,   318,     2,   142,    32,    64,
      77,    81,     0,   311,   287,   288,     0,     0,     0,   289,
     290,   291,   292,   176,     0,   241,   239,   173,   174,   175,
     240,   176,     0,   243,   244,   248,   246,   247,   250,   251,
     200,     0,   186,     0,     0,     0,   207,   209,     0,     0,
       0,    24,     0,    21,    22,     0,     0,     0,     0,    14,
      15,    23,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   253,   380,   255,     0,   363,   100,   103,   310,     0,
     275,   269,   211,   275,   267,   211,   256,   264,   266,     0,
     265,     0,   260,     0,   284,   283,   278,     0,    93,   107,
       0,     0,    96,   214,   157,     0,   164,   162,   161,   172,
     224,   365,   110,   224,   369,    98,   224,   367,   112,   224,
     371,   293,   334,     0,     0,     0,   333,     0,     0,     0,
       0,     0,     0,     0,   294,     0,    66,    67,    68,    69,
      70,    71,    72,    73,    74,    75,    76,     0,     0,   313,
     304,   299,     0,     0,   306,     0,   307,     0,   312,   177,
     178,     0,     0,     0,   177,   204,   237,   232,   235,     0,
     228,   236,     5,   176,     0,   208,   210,     0,     0,     0,
       0,    10,     0,    18,    12,    16,     0,    13,    17,    35,
      37,    36,    39,    40,    42,    43,    45,    46,    47,    48,
      50,    51,    53,    55,    57,    59,     0,    61,   254,   277,
     211,   276,   272,   211,   274,   268,   270,   257,   282,   279,
     224,   224,   218,   225,   158,    88,   102,    91,   105,     0,
       0,   335,     0,     0,   297,   332,   336,     0,     0,     0,
       0,   298,    65,    78,   300,     0,   301,   308,   179,   180,
     181,   182,   229,     0,   177,    33,     0,     0,    25,    11,
       0,     9,     0,   271,   273,    94,   108,   223,   221,   222,
       0,   216,   219,     0,   296,   330,    80,     0,     0,     0,
       0,   295,   302,   183,   226,     0,     0,     6,    19,    63,
       0,   218,     0,     0,     0,     0,     0,     0,     0,   314,
       0,   227,   230,     7,   215,   217,     0,   317,   331,    80,
      80,     0,     0,     0,   319,   220,     0,     0,     0,     0,
       0,   315,   324,   328,   326,   322,   321,     0,     0,     0,
       0,   325,   329,   327,   323,     0,     0,     0
};

static const short yydefgoto[] =
{
     645,   211,   212,   492,   308,   214,   215,   216,   217,   218,
     219,   220,   221,   222,   223,   224,   225,   309,   310,   457,
     311,   227,   312,   233,    26,   159,   420,   169,   426,   257,
     530,   147,   168,    27,   164,   423,   174,   429,   260,   531,
     163,   173,   234,    29,    30,    31,   235,    92,   236,    34,
      35,    36,   237,    56,    38,    75,    76,    77,   155,    78,
      79,    80,   470,   327,   328,   329,    57,    40,    41,    42,
      62,    44,   189,   135,   348,   262,   263,   264,   580,   581,
     582,   412,   481,   563,   190,   191,   192,   122,    45,    46,
     245,   246,   247,   248,   391,   394,   520,   392,    47,   136,
     253,   255,   313,   314,   550,   315,   316,   461,   179,   238,
     318,   319,   320,   433,   321,   443,   441,   640,   637,   639,
     638,   604,   322,    48,    49,    50,   118,   160,   170,   165,
     175,   123,   161,   171,   166,   176,   232,   276,   286,   281,
     291,   124,   125,   228,   229,    51,    59,    52,    53
};

static const short yypact[] =
{
    1609,   564,   151,-32768,-32768,-32768,-32768,-32768,    20,-32768,
  -32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
  -32768,-32768,-32768,-32768,-32768,-32768,    26,    45,   384,  2723,
     661,  1743,  1051,   403,  2723,  1231,  1743,  1104,-32768,   -60,
  -32768,-32768,    76,    -5,-32768,-32768,    58,-32768,  1609,-32768,
  -32768,-32768,-32768,-32768,-32768,-32768,   564,-32768,-32768,-32768,
      11,   453,    13,    30,-32768,-32768,    57,-32768,   507,-32768,
     379,-32768,   679,   561,    97,-32768,-32768,-32768,-32768,-32768,
  -32768,    68,    51,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
  -32768,-32768,-32768,-32768,    91,   107,-32768,-32768,-32768,   112,
     322,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
  -32768,-32768,   136,   143,-32768,-32768,-32768,-32768,   153,  1722,
    2413,-32768,    23,   153,-32768,  2689,  1811,   155,-32768,-32768,
  -32768,-32768,    97,-32768,    97,   111,   184,    30,-32768,-32768,
  -32768,-32768,-32768,  1067,   284,-32768,    97,   108,   561,  1102,
  -32768,-32768,   561,-32768,   237,    97,   244,  1775,-32768,   108,
     153,   153,-32768,   108,   108,   153,   153,-32768,   108,   108,
     153,   153,-32768,   108,   108,   153,   153,-32768,   736,-32768,
  -32768,-32768,-32768,   374,  1743,  1503,   374,  1743,  1556,     9,
     263,   193,   207,-32768,-32768,-32768,-32768,-32768,-32768,  1275,
  -32768,  2602,-32768,-32768,-32768,-32768,-32768,-32768,-32768,  2623,
    2623,-32768,   984,-32768,  2636,-32768,   398,   231,   254,   223,
     282,   297,   296,   301,   232,    -6,-32768,   319,-32768,   253,
    2426,-32768,   153,-32768,   384,  1157,   403,  1210,  2689,-32768,
     638,  2742,   273,   273,  1645,  1840,-32768,   256,   355,  1876,
  -32768,-32768,  2636,-32768,    30,   324,   184,   108,  1067,   470,
     108,   337,   308,   108,-32768,   483,   561,-32768,-32768,   548,
      97,   345,    97,-32768,-32768,-32768,   153,   308,-32768,-32768,
  -32768,   153,   308,-32768,-32768,-32768,   153,   308,-32768,-32768,
  -32768,   153,   365,-32768,-32768,   382,-32768,  2636,  2636,   390,
     401,   427,    61,-32768,   411,-32768,   447,   454,  1243,-32768,
  -32768,   474,   481,-32768,-32768,-32768,   817,   898,  1962,-32768,
  -32768,-32768,-32768,   587,  1344,-32768,-32768,-32768,-32768,-32768,
  -32768,  1061,  1397,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
  -32768,   436,-32768,   629,  2502,    46,   469,  1687,   499,   976,
    1275,-32768,  2523,-32768,-32768,  2544,   176,  2636,   191,-32768,
  -32768,-32768,  2636,  2636,  2636,  2636,  2636,  2636,  2636,  2636,
    2636,  2636,  2636,  2636,  2636,  2636,  2636,  2636,  2636,  2636,
    2636,-32768,-32768,-32768,   496,-32768,-32768,-32768,-32768,  2636,
     515,-32768,   108,   515,-32768,   108,-32768,-32768,-32768,   234,
  -32768,   638,-32768,  1905,-32768,   111,-32768,   523,-32768,-32768,
     534,  2502,-32768,-32768,-32768,   554,-32768,-32768,-32768,-32768,
     308,-32768,-32768,   308,-32768,-32768,   308,-32768,-32768,   308,
  -32768,-32768,-32768,   560,   555,   562,-32768,  2274,  2196,   565,
     566,  2196,  2636,   568,-32768,  2196,-32768,-32768,-32768,-32768,
  -32768,-32768,-32768,-32768,-32768,-32768,-32768,  2636,  2636,-32768,
  -32768,-32768,   817,  2040,-32768,  2118,-32768,   454,-32768,   587,
  -32768,   572,   576,   581,  1061,-32768,-32768,-32768,-32768,  2502,
  -32768,-32768,-32768,  1112,  1450,-32768,-32768,  2636,   976,  2040,
     582,-32768,   170,-32768,-32768,-32768,   120,-32768,-32768,-32768,
  -32768,-32768,   398,   398,   231,   231,   254,   254,   254,   254,
     223,   223,   282,   297,   296,   301,   418,   232,-32768,-32768,
     108,-32768,-32768,   108,-32768,-32768,-32768,-32768,-32768,-32768,
     308,   308,    -9,-32768,-32768,-32768,-32768,-32768,-32768,  2636,
    2196,-32768,   409,   580,-32768,-32768,-32768,   543,   291,  2636,
    2196,-32768,-32768,-32768,-32768,  2040,-32768,-32768,-32768,    97,
  -32768,-32768,-32768,   434,  1112,-32768,  2040,   589,-32768,-32768,
    2636,-32768,  2636,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
     316,-32768,   596,   408,-32768,-32768,  2636,  2295,   597,  2196,
     458,-32768,-32768,-32768,-32768,  2392,   604,-32768,-32768,-32768,
     605,    -9,  2636,  2196,  2196,   606,   607,   608,  2636,   592,
    2196,-32768,-32768,-32768,-32768,-32768,   497,-32768,-32768,  2636,
    2636,  2316,   529,  2196,-32768,-32768,   617,   618,   622,   625,
     628,-32768,-32768,-32768,-32768,-32768,-32768,  2196,  2196,  2196,
    2196,-32768,-32768,-32768,-32768,   659,   669,-32768
};

static const short yypgoto[] =
{
  -32768,-32768,-32768,-32768,   161,-32768,  -194,   116,   180,   224,
     199,   304,   300,   307,   303,   306,-32768,  -112,    37,-32768,
    -185,  -189,  -263,     2,-32768,-32768,-32768,-32768,-32768,-32768,
  -32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
  -32768,-32768,     4,-32768,   -98,-32768,     7,    72,     3,   -54,
     -40,   -10,     5,   -62,   210,   -11,   394,-32768,   -59,   -49,
     137,-32768,  -149,  -308,  -306,   -42,    28,   139,-32768,    36,
      82,-32768,-32768,     1,   338,   -16,-32768,   426,-32768,    89,
  -32768,  -233,  -394,-32768,-32768,-32768,   348,-32768,-32768,-32768,
     444,  -232,-32768,-32768,   294,   293,   309,  -123,-32768,   559,
     302,   445,    12,-32768,-32768,-32768,  -169,  -420,   443,  -167,
    -242,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
  -32768,-32768,-32768,-32768,   651,-32768,-32768,-32768,-32768,-32768,
  -32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
  -32768,   287,-32768,-32768,-32768,   402,   -55,   524,   277
};


#define	YYLAST		2841


static const short yytable[] =
{
     121,   131,    25,    33,    28,    37,   117,    32,   226,    66,
     149,   317,   379,   397,   345,  -352,   471,   533,   472,   121,
     361,   184,    98,   151,   471,   340,   472,   132,    39,   134,
     349,   341,   158,   577,   326,   435,   333,   336,    61,   338,
      63,   384,   554,   556,   422,    67,   230,   127,    68,   425,
      25,    33,    28,    37,   428,    32,    81,   139,   578,   184,
      94,    99,   482,   404,    69,   112,   579,    70,   458,   567,
    -154,  -354,   241,  -154,   463,   465,    39,   137,   126,   187,
     380,   258,    43,    58,   129,   562,   242,    64,  -344,   265,
     250,   119,   251,   269,   131,    65,   140,    64,   145,   120,
     268,    83,    88,    89,   121,    65,   146,   489,   434,    61,
      82,  -348,   157,   271,    95,   100,   243,   187,   226,   113,
     120,   395,   186,   183,   188,    64,   185,  -358,   439,   240,
      43,   244,  -346,    65,   325,   592,   440,   335,   130,  -154,
     226,    60,   458,   273,   571,   241,   596,   277,   278,   462,
     141,  -154,   282,   283,    58,     1,  -350,   287,   288,   242,
     186,   183,   188,  -360,   185,   345,     2,   345,   499,   500,
     501,   397,   496,   178,   543,   249,   471,   129,   472,   146,
     259,   349,   488,   349,    61,   226,   569,   535,    61,   243,
     536,   241,   570,   537,   516,   241,   538,   485,   486,   252,
     519,   612,   346,   131,   347,   242,   254,   415,   261,   242,
     156,   330,    60,   334,   337,   343,   339,   121,    22,   146,
     555,   146,   146,   271,   146,    98,   184,   271,   417,   390,
     419,   130,   369,   370,   184,   243,   365,   366,   143,   243,
     388,   408,    93,   494,   409,   184,   566,   111,   240,   144,
     244,   495,   240,   270,   244,   405,    88,   548,   497,   389,
     272,   469,   140,   386,   140,   387,   498,   521,   140,   474,
     521,   146,   393,   146,   151,   398,   395,   226,   399,   342,
     146,   213,   473,    60,   187,   156,   129,    60,   143,   156,
     473,    60,   187,   565,   146,   344,   241,   575,   576,   144,
     375,    22,    61,   187,   371,   372,    86,   589,   376,    96,
     242,   103,   377,   458,   116,    14,   141,   378,   141,   388,
     558,   382,   141,   605,   607,   558,    20,   186,   183,   188,
     468,   185,   600,   367,   368,   186,   183,   188,   601,   185,
     243,  -154,  -356,   381,  -154,   406,   186,   183,   188,   241,
     185,    22,   410,   346,   583,   347,   626,   627,   629,   146,
     259,   418,   351,   242,   590,   373,   374,   146,   259,   162,
     353,   354,    24,   271,   400,   213,   522,   401,   323,   524,
     142,   480,   167,   143,   431,    71,   184,   172,    72,   324,
     390,   213,   493,   243,   144,    93,   411,   120,   111,    73,
     177,   432,   362,   156,    97,    60,   240,    72,   244,   436,
    -154,   363,   364,   213,   131,   558,   437,   616,    73,   131,
     268,   564,  -154,   622,   603,   585,   442,   393,   586,   140,
     458,    84,    84,    84,    84,   146,   101,   105,   107,   114,
     458,    22,   473,   572,   187,    93,    22,   111,   480,    74,
     544,    22,   438,   547,   111,   594,   595,   551,   213,    74,
     599,   156,    96,    60,   388,   116,   150,   154,   119,   133,
      22,    60,   444,   483,   610,   468,   120,   468,    74,   445,
     458,   502,   503,   141,   484,   157,   133,   186,   183,   188,
     388,   185,   120,   120,   552,   553,   458,   129,   157,   414,
     459,   468,   129,   475,   573,   146,   120,   574,   138,   131,
     146,    72,    96,   625,   116,   487,   480,   593,   103,   458,
     518,   116,    73,   213,   213,   213,   213,   213,   213,   213,
     213,   213,   213,   213,   213,   213,   213,   213,   213,   213,
     389,   213,   154,   267,   529,   630,   154,   504,   505,   532,
     213,   458,   584,    85,    85,    85,    85,   111,   102,   106,
     108,   115,   591,   157,   416,    72,   231,   468,     1,   157,
     534,   120,   510,   511,    22,   539,   152,   120,   468,     2,
     540,   541,    74,   549,   545,   546,    84,    84,   559,   105,
     114,   323,   560,   506,   507,   508,   509,   561,   568,   587,
     588,   609,   324,   274,   275,   597,    54,   598,   279,   280,
     120,   602,   608,   284,   285,   617,   618,    55,   289,   290,
     613,   614,   624,   623,   116,   619,   620,   621,    22,    54,
     476,    22,   480,   632,   633,   631,   153,    84,   634,   114,
      55,   635,    72,   101,   105,   107,   114,   636,   213,   641,
     642,   643,   644,    73,    22,     3,     4,     5,     6,   646,
     154,     7,    74,   389,     8,     9,    10,    11,    12,   647,
      13,    14,    15,    16,    17,   385,   513,    18,    19,   512,
      87,   515,    20,    72,   514,    21,   517,     3,   490,   413,
     615,   478,   525,   403,   148,   526,   256,     9,    10,   128,
      12,   407,   523,    14,    23,    22,     0,   528,    85,    85,
       0,   106,   115,    74,    20,     0,   477,    21,     0,   421,
       0,    54,     0,     0,   424,     0,     0,     0,    24,   427,
       0,     0,    55,   213,   430,     0,     0,   292,     0,   193,
     194,   195,   196,   197,   198,     0,    22,     0,     0,   114,
       0,   199,     0,     0,    74,   -80,   293,   294,     0,    85,
      24,   115,     3,     4,     5,     6,   295,     0,     7,   296,
     297,     8,     9,    10,    11,    12,   298,    13,    14,    15,
      16,    17,   299,   300,    18,    19,   301,   302,   201,    20,
     303,   304,    21,   305,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   306,   203,   204,   205,   206,   207,     0,
     208,   307,     0,   209,   210,     0,     0,     0,   292,     0,
     193,   194,   195,   196,   197,   198,     0,     0,     0,     0,
       0,     0,   199,     0,     0,    24,   -80,   293,   460,     0,
       0,     0,     0,     3,     4,     5,     6,   295,     0,     7,
     296,   297,     8,     9,    10,    11,    12,   298,    13,    14,
      15,    16,    17,   299,   300,    18,    19,   301,   302,   201,
      20,   303,   304,    21,   305,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   306,   203,   204,   205,   206,   207,
       0,   208,   307,     0,   209,   210,     0,     0,     0,   292,
       0,   193,   194,   195,   196,   197,   198,     0,     0,     0,
       0,     0,     0,   199,     0,     0,    24,   -80,   293,   464,
       0,     0,     0,     0,     3,     4,     5,     6,   295,     0,
       7,   296,   297,     8,     9,    10,    11,    12,   298,    13,
      14,    15,    16,    17,   299,   300,    18,    19,   301,   302,
     201,    20,   303,   304,    21,   305,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   306,   203,   204,   205,   206,
     207,     0,   208,   307,     0,   209,   210,   292,     0,   193,
     194,   195,   196,   197,   198,     0,     0,     0,     0,     0,
       0,   199,     0,     0,     0,   -80,   293,    24,     0,   355,
       0,   356,     3,     4,     5,     6,   295,   357,     7,   296,
     297,     8,     9,    10,    11,    12,   298,    13,    14,    15,
      16,    17,   299,   300,    18,    19,   301,   302,   201,    20,
     303,   304,    21,   305,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   306,   203,   204,   205,   206,   207,     0,
     208,   307,    90,   209,   210,     1,     0,     0,     0,     0,
     358,   359,   360,     0,     0,   331,     2,     0,     0,     0,
       0,   143,     0,     0,     0,    24,   332,     3,     4,     5,
       6,     0,   144,     7,   120,     0,     8,     9,    10,    11,
      12,     0,    13,    14,    15,    16,    17,     0,     0,    18,
      19,     0,     0,    54,    20,   109,    72,    21,     1,    54,
       0,     0,     0,     0,    55,     0,   483,   266,    22,     2,
      55,     0,     0,     0,     0,     0,    91,   484,    22,     0,
       3,     4,     5,     6,    22,   120,     7,     0,     0,     8,
       9,    10,    11,    12,    54,    13,    14,    15,    16,    17,
      24,     0,    18,    19,    54,    55,     0,    20,    90,     0,
      21,   143,     0,     0,     0,    55,     0,     0,     0,    22,
       0,    22,   144,     0,     0,     0,     0,    74,     0,   110,
       0,     0,     0,     3,     4,     5,     6,     0,     0,     7,
       0,     0,     8,     9,    10,    11,    12,     0,    13,    14,
      15,    16,    17,    24,     0,    18,    19,     0,     0,     0,
      20,   109,     0,    21,   143,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    22,   144,     0,     0,     0,     0,
       0,     0,    91,     0,     0,     0,     3,     4,     5,     6,
       0,     0,     7,     0,     0,     8,     9,    10,    11,    12,
     104,    13,    14,    15,    16,    17,    24,     3,    18,    19,
       0,     0,     0,    20,     0,     0,    21,     9,    10,     0,
      12,     0,     0,    14,     0,     0,     0,    22,   193,   194,
     195,   196,   197,   198,    20,   110,     0,    21,     0,     0,
     199,     0,     0,     0,     0,   293,     0,     0,     0,     0,
       0,     0,     4,     5,     6,     0,     0,     7,     0,    24,
       8,     0,     0,    11,     0,     0,    13,    14,    15,    16,
      17,     0,     0,    18,    19,     0,     0,   201,    20,     0,
      24,   446,   447,   448,   449,   450,   451,   452,   453,   454,
     455,   456,   202,   203,   204,   205,   206,   207,   323,   208,
      23,     0,   209,   210,     0,     0,     0,     0,     0,   324,
     180,     0,     0,     0,     0,     0,     0,   120,     0,     0,
       3,     4,     5,     6,    24,     0,     7,     0,     0,     8,
       9,    10,    11,    12,     0,    13,    14,    15,    16,    17,
       0,     0,    18,    19,     0,     0,     0,    20,     0,     0,
      21,   331,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    22,   332,   180,     0,     0,     0,     0,     0,    23,
     120,     0,     0,     3,     4,     5,     6,     0,     0,     7,
       0,   182,     8,     9,    10,    11,    12,     0,    13,    14,
      15,    16,    17,    24,     0,    18,    19,     0,     0,     0,
      20,     0,     0,    21,   483,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    22,   484,   180,     0,     0,     0,
       0,     0,    23,   120,     0,     0,     3,     4,     5,     6,
       0,     0,     7,     0,   182,     8,     9,    10,    11,    12,
       0,    13,    14,    15,    16,    17,    24,     0,    18,    19,
       0,     0,     0,    20,     0,     0,    21,   331,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   332,     0,
       0,     0,     0,     0,     0,    23,   120,     0,     0,     3,
       4,     5,     6,     0,     0,     7,     0,   182,     8,     9,
      10,    11,    12,     0,    13,    14,    15,    16,    17,    24,
       0,    18,    19,     0,     0,     0,    20,     0,     0,    21,
     331,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      22,   332,     0,     0,     0,     0,     0,     0,    91,   120,
       0,     0,     3,     4,     5,     6,     0,     0,     7,     0,
       0,     8,     9,    10,    11,    12,     0,    13,    14,    15,
      16,    17,    24,     0,    18,    19,     0,     0,     0,    20,
       0,     0,    21,     1,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    22,     2,     0,     0,     0,     0,     0,
       0,   110,     0,     0,     0,     3,     4,     5,     6,     0,
       0,     7,     0,     0,     8,     9,    10,    11,    12,   143,
      13,    14,    15,    16,    17,    24,     0,    18,    19,     0,
     144,     0,    20,     0,     0,    21,     0,     0,     0,     0,
     389,     0,     4,     5,     6,     0,    22,     7,     0,     0,
       8,     0,     0,    11,    23,     0,    13,    14,    15,    16,
      17,   483,     0,    18,    19,     0,     0,     0,    20,     0,
       0,     0,   484,     0,     0,     0,     0,     0,    24,     0,
     120,     0,    22,     0,     4,     5,     6,     0,     0,     7,
     110,     0,     8,     0,     0,    11,     0,     0,    13,    14,
      15,    16,    17,     0,     0,    18,    19,     0,   180,     0,
      20,     0,     0,     0,    24,     0,     0,     0,     3,     4,
       5,     6,     0,     0,     7,     0,     0,     8,     9,    10,
      11,    12,   110,    13,    14,    15,    16,    17,     0,     3,
      18,    19,     0,     0,     0,    20,     0,     0,    21,     9,
      10,     0,    12,     0,     0,    14,    24,     0,     0,   181,
       0,   180,     0,     0,     0,     0,    20,    23,     0,    21,
       0,     3,     4,     5,     6,     0,     0,     7,     0,   182,
       8,     9,    10,    11,    12,     0,    13,    14,    15,    16,
      17,    24,     0,    18,    19,     0,     0,     0,    20,     0,
       0,    21,   239,     0,     0,     0,     0,     0,     4,     5,
       6,     0,    24,     7,     0,     0,     8,     0,     0,    11,
      23,     0,    13,    14,    15,    16,    17,     0,     0,    18,
      19,   396,   182,     0,    20,     0,     0,     4,     5,     6,
       0,     0,     7,     0,    24,     8,     0,     0,    11,     0,
       0,    13,    14,    15,    16,    17,    23,     0,    18,    19,
       0,     0,     0,    20,     0,     0,     0,   402,     0,     0,
       0,     0,     0,     4,     5,     6,     0,     0,     7,     0,
      24,     8,     0,     0,    11,    23,     0,    13,    14,    15,
      16,    17,     0,     0,    18,    19,   527,     0,     0,    20,
       0,     0,     4,     5,     6,     0,     0,     7,     0,    24,
       8,     0,     0,    11,     0,     0,    13,    14,    15,    16,
      17,    23,     0,    18,    19,     0,     0,     0,    20,     0,
       0,     0,     0,   292,     0,   193,   194,   195,   196,   197,
     198,     0,     0,     0,     0,    24,     0,   199,     0,     0,
      23,   -80,   293,   466,     0,     0,     0,     0,     0,     0,
       0,     0,   295,     0,     0,   296,   297,     0,     0,     0,
       0,     0,   298,     0,    24,     0,     0,     0,   299,   300,
       0,     0,   301,   302,   201,     0,   303,   304,     0,   305,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   306,
     203,   204,   205,   206,   207,     0,   208,   467,     0,   209,
     210,   292,     0,   193,   194,   195,   196,   197,   198,     0,
       0,     0,     0,     0,     0,   199,     0,     0,     0,   -80,
     293,   460,     0,     0,     0,     0,     0,     0,     0,     0,
     295,     0,     0,   296,   297,     0,     0,     0,     0,     0,
     298,     0,     0,     0,     0,     0,   299,   300,     0,     0,
     301,   302,   201,     0,   303,   304,     0,   305,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   306,   203,   204,
     205,   206,   207,     0,   208,   467,     0,   209,   210,   292,
       0,   193,   194,   195,   196,   197,   198,     0,     0,     0,
       0,     0,     0,   199,     0,     0,     0,   -80,   293,   557,
       0,     0,     0,     0,     0,     0,     0,     0,   295,     0,
       0,   296,   297,     0,     0,     0,     0,     0,   298,     0,
       0,     0,     0,     0,   299,   300,     0,     0,   301,   302,
     201,     0,   303,   304,     0,   305,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   306,   203,   204,   205,   206,
     207,     0,   208,   467,     0,   209,   210,   292,     0,   193,
     194,   195,   196,   197,   198,     0,     0,     0,     0,     0,
       0,   199,     0,     0,     0,   -80,   293,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   295,     0,     0,   296,
     297,     0,     0,     0,     0,     0,   298,     0,     0,     0,
       0,     0,   299,   300,     0,     0,   301,   302,   201,     0,
     303,   304,     0,   305,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   306,   203,   204,   205,   206,   207,     0,
     208,   467,     0,   209,   210,   542,     0,   193,   194,   195,
     196,   197,   198,     0,     0,     0,     0,     0,     0,   199,
       0,     0,     0,   -80,     0,     0,   606,     0,   193,   194,
     195,   196,   197,   198,     0,     0,     0,     0,     0,     0,
     199,     0,     0,     0,   -80,     0,     0,   628,     0,   193,
     194,   195,   196,   197,   198,     0,   201,     0,     0,     0,
       0,   199,   -80,     0,     0,     0,     0,     0,     0,     0,
       0,   202,   203,   204,   205,   206,   207,   201,   208,     0,
       0,   209,   210,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   202,   203,   204,   205,   206,   207,   201,   208,
       0,     0,   209,   210,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   202,   203,   204,   205,   206,   207,     0,
     208,     0,     0,   209,   210,   193,   194,   195,   196,   197,
     198,     0,     0,     0,     0,     0,     0,   199,     0,     0,
       0,     0,   479,   611,     0,     0,   193,   194,   195,   196,
     197,   198,     0,     0,     0,     0,     0,     0,   199,   193,
     194,   195,   196,   197,   198,     0,     0,   200,     0,     0,
       0,   199,     0,     0,   201,     0,     0,     0,     0,     0,
     383,     0,     0,     0,     0,     0,     0,     0,     0,   202,
     203,   204,   205,   206,   207,   201,   208,     0,     0,   209,
     210,     0,     0,     0,     0,     0,     0,     0,   201,     0,
     202,   203,   204,   205,   206,   207,     0,   208,     0,     0,
     209,   210,     0,   202,   203,   204,   205,   206,   207,     0,
     208,     0,     0,   209,   210,   193,   194,   195,   196,   197,
     198,     0,     0,     0,     0,     0,     0,   199,     0,     0,
       0,     0,   479,     0,     0,     0,   193,   194,   195,   196,
     197,   198,     0,     0,     0,     0,     0,     0,   199,     0,
       0,     0,     0,   293,     0,     0,     0,   193,   194,   195,
     196,   197,   198,     0,   201,     0,     0,     0,     0,   199,
     491,     0,     0,     0,     0,     0,     0,     0,     0,   202,
     203,   204,   205,   206,   207,   201,   208,     0,     0,   209,
     210,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     202,   203,   204,   205,   206,   207,   201,   208,     0,     0,
     209,   210,     0,     0,     0,   193,   194,   195,   196,   197,
     198,   202,   203,   204,   205,   206,   207,   350,   208,     0,
       0,   209,   210,     0,     0,     0,   193,   194,   195,   196,
     197,   198,     0,     0,     0,     0,     0,     0,   352,   193,
     194,   195,   196,   197,   198,     0,     0,     0,     0,     0,
       0,   199,     0,     0,   201,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   202,
     203,   204,   205,   206,   207,   201,   208,     0,     0,   209,
     210,     0,     0,     0,     0,     0,     0,     0,   201,     0,
     202,   203,   204,   205,   206,   207,     0,   208,     0,     0,
     209,   210,     0,   202,   203,   204,   205,   206,   207,     0,
     208,     0,     0,   209,   210,     3,     4,     5,     6,     0,
       0,     7,     0,     0,     8,     9,    10,    11,    12,     0,
      13,    14,    15,    16,    17,     0,     0,    18,    19,     0,
       0,     0,    20,     0,     0,    21,     0,     0,     0,     3,
       4,     5,     0,     0,     0,     7,     0,     0,     0,     9,
      10,    11,    12,     0,    23,    14,    15,    16,    17,     4,
       5,    18,    19,     0,     7,     0,    20,     0,     0,    21,
      11,     0,     0,     0,    14,    15,    16,    17,    24,     0,
      18,    19,     0,     0,     0,    20,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    24,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    24
};

static const short yycheck[] =
{
      42,    56,     0,     0,     0,     0,    66,     0,   120,     8,
      72,   178,    18,   245,   199,    20,   324,   411,   324,    61,
     214,   119,    33,    72,   332,    16,   332,    16,     0,    16,
     199,    22,    74,    42,   183,   298,   185,   186,     2,   188,
      20,   230,   462,   463,   277,    19,    23,    46,    22,   282,
      48,    48,    48,    48,   287,    48,    28,    68,    67,   157,
      32,    33,    16,   252,    19,    37,    75,    22,    22,   489,
      19,    20,   126,    22,   316,   317,    48,    20,    20,   119,
      86,   143,     0,     1,    56,   479,   126,    67,    20,   148,
     132,    15,   134,   152,   149,    75,    68,    67,    70,    23,
     149,    29,    30,    31,   146,    75,    70,   349,   297,    73,
      28,    20,    15,   155,    32,    33,   126,   157,   230,    37,
      23,   244,   119,   119,   119,    67,   119,    20,    67,   126,
      48,   126,    20,    75,   183,   555,    75,   186,    56,    88,
     252,     2,    22,   159,    24,   199,   566,   163,   164,   316,
      68,   100,   168,   169,    72,     4,    20,   173,   174,   199,
     157,   157,   157,    20,   157,   350,    15,   352,   362,   363,
     364,   403,   357,    20,   437,    20,   484,   149,   484,   143,
     144,   350,   349,   352,   148,   297,    16,   420,   152,   199,
     423,   245,    22,   426,   379,   249,   429,   346,   347,    88,
     389,   595,   199,   258,   199,   245,    22,   266,   100,   249,
      73,   183,    73,   185,   186,    22,   188,   259,    67,   183,
     462,   185,   186,   265,   188,   236,   324,   269,   270,   240,
     272,   149,     9,    10,   332,   245,     5,     6,     4,   249,
     238,   257,    32,    67,   260,   343,   488,    37,   245,    15,
     245,    75,   249,    16,   249,   254,   184,   442,    67,    25,
      16,   323,   234,   235,   236,   237,    75,   390,   240,   331,
     393,   235,   244,   237,   323,    19,   399,   389,    22,    16,
     244,   120,   324,   144,   324,   148,   258,   148,     4,   152,
     332,   152,   332,   487,   258,    88,   350,   530,   531,    15,
       3,    67,   266,   343,    81,    82,    29,    16,    12,    32,
     350,    34,    11,    22,    37,    42,   234,    85,   236,   317,
     469,    68,   240,   586,   587,   474,    53,   324,   324,   324,
     318,   324,    16,    79,    80,   332,   332,   332,    22,   332,
     350,    19,    20,    24,    22,    21,   343,   343,   343,   403,
     343,    67,    15,   350,   539,   350,   619,   620,   621,   323,
     324,    16,   201,   403,   549,    83,    84,   331,   332,    82,
     209,   210,    99,   415,    19,   214,   392,    22,     4,   395,
       1,   344,    95,     4,    19,     1,   484,   100,     4,    15,
     401,   230,   355,   403,    15,   185,    88,    23,   188,    15,
     113,    19,     4,   266,     1,   266,   403,     4,   403,    19,
      88,    13,    14,   252,   469,   564,    15,   602,    15,   474,
     469,   483,   100,   608,    16,    16,    15,   399,    19,   401,
      22,    29,    30,    31,    32,   399,    34,    35,    36,    37,
      22,    67,   484,    25,   484,   235,    67,   237,   411,    75,
     438,    67,    25,   441,   244,    21,    22,   445,   297,    75,
     572,   324,   185,   324,   462,   188,    72,    73,    15,    16,
      67,   332,    25,     4,    16,   463,    23,   465,    75,    25,
      22,   365,   366,   401,    15,    15,    16,   484,   484,   484,
     488,   484,    23,    23,   457,   458,    22,   469,    15,    16,
      19,   489,   474,    67,   520,   469,    23,   523,     1,   564,
     474,     4,   235,    16,   237,    16,   479,   559,   241,    22,
      24,   244,    15,   362,   363,   364,   365,   366,   367,   368,
     369,   370,   371,   372,   373,   374,   375,   376,   377,   378,
      25,   380,   148,   149,    21,    16,   152,   367,   368,    15,
     389,    22,   540,    29,    30,    31,    32,   347,    34,    35,
      36,    37,   550,    15,    16,     4,   123,   555,     4,    15,
      16,    23,   373,   374,    67,    15,    15,    23,   566,    15,
      25,    19,    75,    15,    19,    19,   184,   185,    16,   187,
     188,     4,    16,   369,   370,   371,   372,    16,    16,    19,
      57,   589,    15,   160,   161,    16,    42,   570,   165,   166,
      23,    15,    15,   170,   171,   603,   604,    53,   175,   176,
      16,    16,   610,    31,   347,    19,    19,    19,    67,    42,
       1,    67,   595,    16,    16,   623,    75,   235,    16,   237,
      53,    16,     4,   241,   242,   243,   244,    19,   487,   637,
     638,   639,   640,    15,    67,    26,    27,    28,    29,     0,
     266,    32,    75,    25,    35,    36,    37,    38,    39,     0,
      41,    42,    43,    44,    45,   232,   376,    48,    49,   375,
      19,   378,    53,     4,   377,    56,   380,    26,   350,   263,
     601,   343,   399,   249,    15,   401,   137,    36,    37,    48,
      39,   256,   393,    42,    75,    67,    -1,   405,   184,   185,
      -1,   187,   188,    75,    53,    -1,    87,    56,    -1,   276,
      -1,    42,    -1,    -1,   281,    -1,    -1,    -1,    99,   286,
      -1,    -1,    53,   572,   291,    -1,    -1,     1,    -1,     3,
       4,     5,     6,     7,     8,    -1,    67,    -1,    -1,   347,
      -1,    15,    -1,    -1,    75,    19,    20,    21,    -1,   235,
      99,   237,    26,    27,    28,    29,    30,    -1,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    67,    68,    69,    70,    71,    72,    -1,
      74,    75,    -1,    77,    78,    -1,    -1,    -1,     1,    -1,
       3,     4,     5,     6,     7,     8,    -1,    -1,    -1,    -1,
      -1,    -1,    15,    -1,    -1,    99,    19,    20,    21,    -1,
      -1,    -1,    -1,    26,    27,    28,    29,    30,    -1,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    67,    68,    69,    70,    71,    72,
      -1,    74,    75,    -1,    77,    78,    -1,    -1,    -1,     1,
      -1,     3,     4,     5,     6,     7,     8,    -1,    -1,    -1,
      -1,    -1,    -1,    15,    -1,    -1,    99,    19,    20,    21,
      -1,    -1,    -1,    -1,    26,    27,    28,    29,    30,    -1,
      32,    33,    34,    35,    36,    37,    38,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    67,    68,    69,    70,    71,
      72,    -1,    74,    75,    -1,    77,    78,     1,    -1,     3,
       4,     5,     6,     7,     8,    -1,    -1,    -1,    -1,    -1,
      -1,    15,    -1,    -1,    -1,    19,    20,    99,    -1,    15,
      -1,    17,    26,    27,    28,    29,    30,    23,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    67,    68,    69,    70,    71,    72,    -1,
      74,    75,     1,    77,    78,     4,    -1,    -1,    -1,    -1,
      76,    77,    78,    -1,    -1,     4,    15,    -1,    -1,    -1,
      -1,     4,    -1,    -1,    -1,    99,    15,    26,    27,    28,
      29,    -1,    15,    32,    23,    -1,    35,    36,    37,    38,
      39,    -1,    41,    42,    43,    44,    45,    -1,    -1,    48,
      49,    -1,    -1,    42,    53,     1,     4,    56,     4,    42,
      -1,    -1,    -1,    -1,    53,    -1,     4,    15,    67,    15,
      53,    -1,    -1,    -1,    -1,    -1,    75,    15,    67,    -1,
      26,    27,    28,    29,    67,    23,    32,    -1,    -1,    35,
      36,    37,    38,    39,    42,    41,    42,    43,    44,    45,
      99,    -1,    48,    49,    42,    53,    -1,    53,     1,    -1,
      56,     4,    -1,    -1,    -1,    53,    -1,    -1,    -1,    67,
      -1,    67,    15,    -1,    -1,    -1,    -1,    75,    -1,    75,
      -1,    -1,    -1,    26,    27,    28,    29,    -1,    -1,    32,
      -1,    -1,    35,    36,    37,    38,    39,    -1,    41,    42,
      43,    44,    45,    99,    -1,    48,    49,    -1,    -1,    -1,
      53,     1,    -1,    56,     4,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    67,    15,    -1,    -1,    -1,    -1,
      -1,    -1,    75,    -1,    -1,    -1,    26,    27,    28,    29,
      -1,    -1,    32,    -1,    -1,    35,    36,    37,    38,    39,
      19,    41,    42,    43,    44,    45,    99,    26,    48,    49,
      -1,    -1,    -1,    53,    -1,    -1,    56,    36,    37,    -1,
      39,    -1,    -1,    42,    -1,    -1,    -1,    67,     3,     4,
       5,     6,     7,     8,    53,    75,    -1,    56,    -1,    -1,
      15,    -1,    -1,    -1,    -1,    20,    -1,    -1,    -1,    -1,
      -1,    -1,    27,    28,    29,    -1,    -1,    32,    -1,    99,
      35,    -1,    -1,    38,    -1,    -1,    41,    42,    43,    44,
      45,    -1,    -1,    48,    49,    -1,    -1,    52,    53,    -1,
      99,    88,    89,    90,    91,    92,    93,    94,    95,    96,
      97,    98,    67,    68,    69,    70,    71,    72,     4,    74,
      75,    -1,    77,    78,    -1,    -1,    -1,    -1,    -1,    15,
      16,    -1,    -1,    -1,    -1,    -1,    -1,    23,    -1,    -1,
      26,    27,    28,    29,    99,    -1,    32,    -1,    -1,    35,
      36,    37,    38,    39,    -1,    41,    42,    43,    44,    45,
      -1,    -1,    48,    49,    -1,    -1,    -1,    53,    -1,    -1,
      56,     4,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    67,    15,    16,    -1,    -1,    -1,    -1,    -1,    75,
      23,    -1,    -1,    26,    27,    28,    29,    -1,    -1,    32,
      -1,    87,    35,    36,    37,    38,    39,    -1,    41,    42,
      43,    44,    45,    99,    -1,    48,    49,    -1,    -1,    -1,
      53,    -1,    -1,    56,     4,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    67,    15,    16,    -1,    -1,    -1,
      -1,    -1,    75,    23,    -1,    -1,    26,    27,    28,    29,
      -1,    -1,    32,    -1,    87,    35,    36,    37,    38,    39,
      -1,    41,    42,    43,    44,    45,    99,    -1,    48,    49,
      -1,    -1,    -1,    53,    -1,    -1,    56,     4,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    15,    -1,
      -1,    -1,    -1,    -1,    -1,    75,    23,    -1,    -1,    26,
      27,    28,    29,    -1,    -1,    32,    -1,    87,    35,    36,
      37,    38,    39,    -1,    41,    42,    43,    44,    45,    99,
      -1,    48,    49,    -1,    -1,    -1,    53,    -1,    -1,    56,
       4,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      67,    15,    -1,    -1,    -1,    -1,    -1,    -1,    75,    23,
      -1,    -1,    26,    27,    28,    29,    -1,    -1,    32,    -1,
      -1,    35,    36,    37,    38,    39,    -1,    41,    42,    43,
      44,    45,    99,    -1,    48,    49,    -1,    -1,    -1,    53,
      -1,    -1,    56,     4,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    67,    15,    -1,    -1,    -1,    -1,    -1,
      -1,    75,    -1,    -1,    -1,    26,    27,    28,    29,    -1,
      -1,    32,    -1,    -1,    35,    36,    37,    38,    39,     4,
      41,    42,    43,    44,    45,    99,    -1,    48,    49,    -1,
      15,    -1,    53,    -1,    -1,    56,    -1,    -1,    -1,    -1,
      25,    -1,    27,    28,    29,    -1,    67,    32,    -1,    -1,
      35,    -1,    -1,    38,    75,    -1,    41,    42,    43,    44,
      45,     4,    -1,    48,    49,    -1,    -1,    -1,    53,    -1,
      -1,    -1,    15,    -1,    -1,    -1,    -1,    -1,    99,    -1,
      23,    -1,    67,    -1,    27,    28,    29,    -1,    -1,    32,
      75,    -1,    35,    -1,    -1,    38,    -1,    -1,    41,    42,
      43,    44,    45,    -1,    -1,    48,    49,    -1,    16,    -1,
      53,    -1,    -1,    -1,    99,    -1,    -1,    -1,    26,    27,
      28,    29,    -1,    -1,    32,    -1,    -1,    35,    36,    37,
      38,    39,    75,    41,    42,    43,    44,    45,    -1,    26,
      48,    49,    -1,    -1,    -1,    53,    -1,    -1,    56,    36,
      37,    -1,    39,    -1,    -1,    42,    99,    -1,    -1,    67,
      -1,    16,    -1,    -1,    -1,    -1,    53,    75,    -1,    56,
      -1,    26,    27,    28,    29,    -1,    -1,    32,    -1,    87,
      35,    36,    37,    38,    39,    -1,    41,    42,    43,    44,
      45,    99,    -1,    48,    49,    -1,    -1,    -1,    53,    -1,
      -1,    56,    21,    -1,    -1,    -1,    -1,    -1,    27,    28,
      29,    -1,    99,    32,    -1,    -1,    35,    -1,    -1,    38,
      75,    -1,    41,    42,    43,    44,    45,    -1,    -1,    48,
      49,    21,    87,    -1,    53,    -1,    -1,    27,    28,    29,
      -1,    -1,    32,    -1,    99,    35,    -1,    -1,    38,    -1,
      -1,    41,    42,    43,    44,    45,    75,    -1,    48,    49,
      -1,    -1,    -1,    53,    -1,    -1,    -1,    21,    -1,    -1,
      -1,    -1,    -1,    27,    28,    29,    -1,    -1,    32,    -1,
      99,    35,    -1,    -1,    38,    75,    -1,    41,    42,    43,
      44,    45,    -1,    -1,    48,    49,    21,    -1,    -1,    53,
      -1,    -1,    27,    28,    29,    -1,    -1,    32,    -1,    99,
      35,    -1,    -1,    38,    -1,    -1,    41,    42,    43,    44,
      45,    75,    -1,    48,    49,    -1,    -1,    -1,    53,    -1,
      -1,    -1,    -1,     1,    -1,     3,     4,     5,     6,     7,
       8,    -1,    -1,    -1,    -1,    99,    -1,    15,    -1,    -1,
      75,    19,    20,    21,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    30,    -1,    -1,    33,    34,    -1,    -1,    -1,
      -1,    -1,    40,    -1,    99,    -1,    -1,    -1,    46,    47,
      -1,    -1,    50,    51,    52,    -1,    54,    55,    -1,    57,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    67,
      68,    69,    70,    71,    72,    -1,    74,    75,    -1,    77,
      78,     1,    -1,     3,     4,     5,     6,     7,     8,    -1,
      -1,    -1,    -1,    -1,    -1,    15,    -1,    -1,    -1,    19,
      20,    21,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      30,    -1,    -1,    33,    34,    -1,    -1,    -1,    -1,    -1,
      40,    -1,    -1,    -1,    -1,    -1,    46,    47,    -1,    -1,
      50,    51,    52,    -1,    54,    55,    -1,    57,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    67,    68,    69,
      70,    71,    72,    -1,    74,    75,    -1,    77,    78,     1,
      -1,     3,     4,     5,     6,     7,     8,    -1,    -1,    -1,
      -1,    -1,    -1,    15,    -1,    -1,    -1,    19,    20,    21,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    30,    -1,
      -1,    33,    34,    -1,    -1,    -1,    -1,    -1,    40,    -1,
      -1,    -1,    -1,    -1,    46,    47,    -1,    -1,    50,    51,
      52,    -1,    54,    55,    -1,    57,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    67,    68,    69,    70,    71,
      72,    -1,    74,    75,    -1,    77,    78,     1,    -1,     3,
       4,     5,     6,     7,     8,    -1,    -1,    -1,    -1,    -1,
      -1,    15,    -1,    -1,    -1,    19,    20,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    30,    -1,    -1,    33,
      34,    -1,    -1,    -1,    -1,    -1,    40,    -1,    -1,    -1,
      -1,    -1,    46,    47,    -1,    -1,    50,    51,    52,    -1,
      54,    55,    -1,    57,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    67,    68,    69,    70,    71,    72,    -1,
      74,    75,    -1,    77,    78,     1,    -1,     3,     4,     5,
       6,     7,     8,    -1,    -1,    -1,    -1,    -1,    -1,    15,
      -1,    -1,    -1,    19,    -1,    -1,     1,    -1,     3,     4,
       5,     6,     7,     8,    -1,    -1,    -1,    -1,    -1,    -1,
      15,    -1,    -1,    -1,    19,    -1,    -1,     1,    -1,     3,
       4,     5,     6,     7,     8,    -1,    52,    -1,    -1,    -1,
      -1,    15,    16,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    67,    68,    69,    70,    71,    72,    52,    74,    -1,
      -1,    77,    78,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    67,    68,    69,    70,    71,    72,    52,    74,
      -1,    -1,    77,    78,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    67,    68,    69,    70,    71,    72,    -1,
      74,    -1,    -1,    77,    78,     3,     4,     5,     6,     7,
       8,    -1,    -1,    -1,    -1,    -1,    -1,    15,    -1,    -1,
      -1,    -1,    20,    21,    -1,    -1,     3,     4,     5,     6,
       7,     8,    -1,    -1,    -1,    -1,    -1,    -1,    15,     3,
       4,     5,     6,     7,     8,    -1,    -1,    24,    -1,    -1,
      -1,    15,    -1,    -1,    52,    -1,    -1,    -1,    -1,    -1,
      24,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    67,
      68,    69,    70,    71,    72,    52,    74,    -1,    -1,    77,
      78,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    52,    -1,
      67,    68,    69,    70,    71,    72,    -1,    74,    -1,    -1,
      77,    78,    -1,    67,    68,    69,    70,    71,    72,    -1,
      74,    -1,    -1,    77,    78,     3,     4,     5,     6,     7,
       8,    -1,    -1,    -1,    -1,    -1,    -1,    15,    -1,    -1,
      -1,    -1,    20,    -1,    -1,    -1,     3,     4,     5,     6,
       7,     8,    -1,    -1,    -1,    -1,    -1,    -1,    15,    -1,
      -1,    -1,    -1,    20,    -1,    -1,    -1,     3,     4,     5,
       6,     7,     8,    -1,    52,    -1,    -1,    -1,    -1,    15,
      16,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    67,
      68,    69,    70,    71,    72,    52,    74,    -1,    -1,    77,
      78,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      67,    68,    69,    70,    71,    72,    52,    74,    -1,    -1,
      77,    78,    -1,    -1,    -1,     3,     4,     5,     6,     7,
       8,    67,    68,    69,    70,    71,    72,    15,    74,    -1,
      -1,    77,    78,    -1,    -1,    -1,     3,     4,     5,     6,
       7,     8,    -1,    -1,    -1,    -1,    -1,    -1,    15,     3,
       4,     5,     6,     7,     8,    -1,    -1,    -1,    -1,    -1,
      -1,    15,    -1,    -1,    52,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    67,
      68,    69,    70,    71,    72,    52,    74,    -1,    -1,    77,
      78,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    52,    -1,
      67,    68,    69,    70,    71,    72,    -1,    74,    -1,    -1,
      77,    78,    -1,    67,    68,    69,    70,    71,    72,    -1,
      74,    -1,    -1,    77,    78,    26,    27,    28,    29,    -1,
      -1,    32,    -1,    -1,    35,    36,    37,    38,    39,    -1,
      41,    42,    43,    44,    45,    -1,    -1,    48,    49,    -1,
      -1,    -1,    53,    -1,    -1,    56,    -1,    -1,    -1,    26,
      27,    28,    -1,    -1,    -1,    32,    -1,    -1,    -1,    36,
      37,    38,    39,    -1,    75,    42,    43,    44,    45,    27,
      28,    48,    49,    -1,    32,    -1,    53,    -1,    -1,    56,
      38,    -1,    -1,    -1,    42,    43,    44,    45,    99,    -1,
      48,    49,    -1,    -1,    -1,    53,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    99,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    99
};
/* -*-C-*-  Note some compilers choke on comments on `#line' lines.  */
#line 3 "/usr/share/bison/bison.simple"

/* Skeleton output parser for bison,

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002 Free Software
   Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/* As a special exception, when this file is copied by Bison into a
   Bison output file, you may use that output file without restriction.
   This special exception was added by the Free Software Foundation
   in version 1.24 of Bison.  */

/* This is the parser code that is written into each bison parser when
   the %semantic_parser declaration is not specified in the grammar.
   It was written by Richard Stallman by simplifying the hairy parser
   used when %semantic_parser is specified.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

#if ! defined (yyoverflow) || defined (YYERROR_VERBOSE)

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# if YYSTACK_USE_ALLOCA
#  define YYSTACK_ALLOC alloca
# else
#  ifndef YYSTACK_USE_ALLOCA
#   if defined (alloca) || defined (_ALLOCA_H)
#    define YYSTACK_ALLOC alloca
#   else
#    ifdef __GNUC__
#     define YYSTACK_ALLOC __builtin_alloca
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning. */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
# else
#  if defined (__STDC__) || defined (__cplusplus)
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   define YYSIZE_T size_t
#  endif
#  define YYSTACK_ALLOC malloc
#  define YYSTACK_FREE free
# endif
#endif /* ! defined (yyoverflow) || defined (YYERROR_VERBOSE) */


#if (! defined (yyoverflow) \
     && (! defined (__cplusplus) \
	 || (YYLTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  short yyss;
  YYSTYPE yyvs;
# if YYLSP_NEEDED
  YYLTYPE yyls;
# endif
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAX (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# if YYLSP_NEEDED
#  define YYSTACK_BYTES(N) \
     ((N) * (sizeof (short) + sizeof (YYSTYPE) + sizeof (YYLTYPE))	\
      + 2 * YYSTACK_GAP_MAX)
# else
#  define YYSTACK_BYTES(N) \
     ((N) * (sizeof (short) + sizeof (YYSTYPE))				\
      + YYSTACK_GAP_MAX)
# endif

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  register YYSIZE_T yyi;		\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (0)
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAX;	\
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (0)

#endif


#if ! defined (YYSIZE_T) && defined (__SIZE_TYPE__)
# define YYSIZE_T __SIZE_TYPE__
#endif
#if ! defined (YYSIZE_T) && defined (size_t)
# define YYSIZE_T size_t
#endif
#if ! defined (YYSIZE_T)
# if defined (__STDC__) || defined (__cplusplus)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# endif
#endif
#if ! defined (YYSIZE_T)
# define YYSIZE_T unsigned int
#endif

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		-2
#define YYEOF		0
#define YYACCEPT	goto yyacceptlab
#define YYABORT 	goto yyabortlab
#define YYERROR		goto yyerrlab1
/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */
#define YYFAIL		goto yyerrlab
#define YYRECOVERING()  (!!yyerrstatus)
#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yychar1 = YYTRANSLATE (yychar);				\
      YYPOPSTACK;						\
      goto yybackup;						\
    }								\
  else								\
    { 								\
      yyerror ("syntax error: cannot back up");			\
      YYERROR;							\
    }								\
while (0)

#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Compute the default location (before the actions
   are run).

   When YYLLOC_DEFAULT is run, CURRENT is set the location of the
   first token.  By default, to implement support for ranges, extend
   its range to the last symbol.  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)       	\
   Current.last_line   = Rhs[N].last_line;	\
   Current.last_column = Rhs[N].last_column;
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#if YYPURE
# if YYLSP_NEEDED
#  ifdef YYLEX_PARAM
#   define YYLEX		yylex (&yylval, &yylloc, YYLEX_PARAM)
#  else
#   define YYLEX		yylex (&yylval, &yylloc)
#  endif
# else /* !YYLSP_NEEDED */
#  ifdef YYLEX_PARAM
#   define YYLEX		yylex (&yylval, YYLEX_PARAM)
#  else
#   define YYLEX		yylex (&yylval)
#  endif
# endif /* !YYLSP_NEEDED */
#else /* !YYPURE */
# define YYLEX			yylex ()
#endif /* !YYPURE */


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (0)
/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
#endif /* !YYDEBUG */

/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   SIZE_MAX < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#if YYMAXDEPTH == 0
# undef YYMAXDEPTH
#endif

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif

#ifdef YYERROR_VERBOSE

# ifndef yystrlen
#  if defined (__GLIBC__) && defined (_STRING_H)
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
#   if defined (__STDC__) || defined (__cplusplus)
yystrlen (const char *yystr)
#   else
yystrlen (yystr)
     const char *yystr;
#   endif
{
  register const char *yys = yystr;

  while (*yys++ != '\0')
    continue;

  return yys - yystr - 1;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined (__GLIBC__) && defined (_STRING_H) && defined (_GNU_SOURCE)
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
#   if defined (__STDC__) || defined (__cplusplus)
yystpcpy (char *yydest, const char *yysrc)
#   else
yystpcpy (yydest, yysrc)
     char *yydest;
     const char *yysrc;
#   endif
{
  register char *yyd = yydest;
  register const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif
#endif

#line 315 "/usr/share/bison/bison.simple"


/* The user can define YYPARSE_PARAM as the name of an argument to be passed
   into yyparse.  The argument should have type void *.
   It should actually point to an object.
   Grammar actions can access the variable by casting it
   to the proper pointer type.  */

#ifdef YYPARSE_PARAM
# if defined (__STDC__) || defined (__cplusplus)
#  define YYPARSE_PARAM_ARG void *YYPARSE_PARAM
#  define YYPARSE_PARAM_DECL
# else
#  define YYPARSE_PARAM_ARG YYPARSE_PARAM
#  define YYPARSE_PARAM_DECL void *YYPARSE_PARAM;
# endif
#else /* !YYPARSE_PARAM */
# define YYPARSE_PARAM_ARG
# define YYPARSE_PARAM_DECL
#endif /* !YYPARSE_PARAM */

/* Prevent warning if -Wstrict-prototypes.  */
#ifdef __GNUC__
# ifdef YYPARSE_PARAM
int yyparse (void *);
# else
int yyparse (void);
# endif
#endif

/* YY_DECL_VARIABLES -- depending whether we use a pure parser,
   variables are global, or local to YYPARSE.  */

#define YY_DECL_NON_LSP_VARIABLES			\
/* The lookahead symbol.  */				\
int yychar;						\
							\
/* The semantic value of the lookahead symbol. */	\
YYSTYPE yylval;						\
							\
/* Number of parse errors so far.  */			\
int yynerrs;

#if YYLSP_NEEDED
# define YY_DECL_VARIABLES			\
YY_DECL_NON_LSP_VARIABLES			\
						\
/* Location data for the lookahead symbol.  */	\
YYLTYPE yylloc;
#else
# define YY_DECL_VARIABLES			\
YY_DECL_NON_LSP_VARIABLES
#endif


/* If nonreentrant, generate the variables here. */

#if !YYPURE
YY_DECL_VARIABLES
#endif  /* !YYPURE */

int
yyparse (YYPARSE_PARAM_ARG)
     YYPARSE_PARAM_DECL
{
  /* If reentrant, generate the variables here. */
#if YYPURE
  YY_DECL_VARIABLES
#endif  /* !YYPURE */

  register int yystate;
  register int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Lookahead token as an internal (translated) token number.  */
  int yychar1 = 0;

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack. */
  short	yyssa[YYINITDEPTH];
  short *yyss = yyssa;
  register short *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  register YYSTYPE *yyvsp;

#if YYLSP_NEEDED
  /* The location stack.  */
  YYLTYPE yylsa[YYINITDEPTH];
  YYLTYPE *yyls = yylsa;
  YYLTYPE *yylsp;
#endif

#if YYLSP_NEEDED
# define YYPOPSTACK   (yyvsp--, yyssp--, yylsp--)
#else
# define YYPOPSTACK   (yyvsp--, yyssp--)
#endif

  YYSIZE_T yystacksize = YYINITDEPTH;


  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
#if YYLSP_NEEDED
  YYLTYPE yyloc;
#endif

  /* When reducing, the number of symbols on the RHS of the reduced
     rule. */
  int yylen;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;
#if YYLSP_NEEDED
  yylsp = yyls;
#endif
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed. so pushing a state here evens the stacks.
     */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyssp >= yyss + yystacksize - 1)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack. Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	short *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  */
# if YYLSP_NEEDED
	YYLTYPE *yyls1 = yyls;
	/* This used to be a conditional around just the two extra args,
	   but that might be undefined if yyoverflow is a macro.  */
	yyoverflow ("parser stack overflow",
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yyls1, yysize * sizeof (*yylsp),
		    &yystacksize);
	yyls = yyls1;
# else
	yyoverflow ("parser stack overflow",
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);
# endif
	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyoverflowlab;
# else
      /* Extend the stack our own way.  */
      if (yystacksize >= YYMAXDEPTH)
	goto yyoverflowlab;
      yystacksize *= 2;
      if (yystacksize > YYMAXDEPTH)
	yystacksize = YYMAXDEPTH;

      {
	short *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyoverflowlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);
# if YYLSP_NEEDED
	YYSTACK_RELOCATE (yyls);
# endif
# undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
#if YYLSP_NEEDED
      yylsp = yyls + yysize - 1;
#endif

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyssp >= yyss + yystacksize - 1)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:

/* Do appropriate processing given the current state.  */
/* Read a lookahead token if we need one and don't already have one.  */
/* yyresume: */

  /* First try to decide what to do without reference to lookahead token.  */

  yyn = yypact[yystate];
  if (yyn == YYFLAG)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* yychar is either YYEMPTY or YYEOF
     or a valid token in external form.  */

  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  /* Convert token to internal form (in yychar1) for indexing tables with */

  if (yychar <= 0)		/* This means end of input. */
    {
      yychar1 = 0;
      yychar = YYEOF;		/* Don't call YYLEX any more */

      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yychar1 = YYTRANSLATE (yychar);

#if YYDEBUG
     /* We have to keep this `#if YYDEBUG', since we use variables
	which are defined only if `YYDEBUG' is set.  */
      if (yydebug)
	{
	  YYFPRINTF (stderr, "Next token is %d (%s",
		     yychar, yytname[yychar1]);
	  /* Give the individual parser a way to print the precise
	     meaning of a token, for further debugging info.  */
# ifdef YYPRINT
	  YYPRINT (stderr, yychar, yylval);
# endif
	  YYFPRINTF (stderr, ")\n");
	}
#endif
    }

  yyn += yychar1;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != yychar1)
    goto yydefault;

  yyn = yytable[yyn];

  /* yyn is what to do for this token type in this state.
     Negative => reduce, -yyn is rule number.
     Positive => shift, yyn is new state.
       New state is final state => don't bother to shift,
       just return success.
     0, or most negative number => error.  */

  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrlab;

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Shift the lookahead token.  */
  YYDPRINTF ((stderr, "Shifting token %d (%s), ",
	      yychar, yytname[yychar1]));

  /* Discard the token being shifted unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  *++yyvsp = yylval;
#if YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  yystate = yyn;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to the semantic value of
     the lookahead token.  This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

#if YYLSP_NEEDED
  /* Similarly for the default location.  Let the user run additional
     commands if for instance locations are ranges.  */
  yyloc = yylsp[1-yylen];
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
#endif

#if YYDEBUG
  /* We have to keep this `#if YYDEBUG', since we use variables which
     are defined only if `YYDEBUG' is set.  */
  if (yydebug)
    {
      int yyi;

      YYFPRINTF (stderr, "Reducing via rule %d (line %d), ",
		 yyn, yyrline[yyn]);

      /* Print the symbols being reduced, and their result.  */
      for (yyi = yyprhs[yyn]; yyrhs[yyi] > 0; yyi++)
	YYFPRINTF (stderr, "%s ", yytname[yyrhs[yyi]]);
      YYFPRINTF (stderr, " -> %s\n", yytname[yyr1[yyn]]);
    }
#endif

  switch (yyn) {

case 1:
#line 343 "ANSI-C.y"
{ Program = GrabPragmas(yyvsp[0].L); }
    break;
case 2:
#line 354 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; }
    break;
case 5:
#line 357 "ANSI-C.y"
{ if (yyvsp[-1].n->typ == Comma) yyvsp[-1].n->coord = yyvsp[-2].tok;
                                  yyvsp[-1].n->parenthesized = TRUE;
                                  yyval.n = yyvsp[-1].n; }
    break;
case 6:
#line 363 "ANSI-C.y"
{ if (ANSIOnly)
	         SyntaxError("statement expressions not allowed with -ansi switch");
               yyval.n = MakeBlockCoord(NULL, NULL, GrabPragmas(yyvsp[-2].L), yyvsp[-4].tok, yyvsp[-1].tok); }
    break;
case 7:
#line 367 "ANSI-C.y"
{ if (ANSIOnly)
	         SyntaxError("statement expressions not allowed with -ansi switch");
              yyval.n = MakeBlockCoord(NULL, yyvsp[-3].L, GrabPragmas(yyvsp[-2].L), yyvsp[-5].tok, yyvsp[-1].tok); }
    break;
case 9:
#line 375 "ANSI-C.y"
{ yyval.n = ExtendArray(yyvsp[-3].n, yyvsp[-1].n, yyvsp[-2].tok); arrayop();}
    break;
case 10:
#line 377 "ANSI-C.y"
{ yyval.n = MakeCallCoord(yyvsp[-2].n, NULL, yyvsp[-1].tok); funccall(yyvsp[-2].n);}
    break;
case 11:
#line 379 "ANSI-C.y"
{ yyval.n = MakeCallCoord(yyvsp[-3].n, yyvsp[-1].L, yyvsp[-2].tok); funccall(yyvsp[-3].n);}
    break;
case 12:
#line 381 "ANSI-C.y"
{ yyval.n = MakeBinopCoord('.', yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop('.');}
    break;
case 13:
#line 383 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(ARROW, yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop(ARROW);}
    break;
case 14:
#line 385 "ANSI-C.y"
{ yyval.n = MakeUnaryCoord(POSTINC, yyvsp[-1].n, yyvsp[0].tok); checkop(POSTINC);}
    break;
case 15:
#line 387 "ANSI-C.y"
{ yyval.n = MakeUnaryCoord(POSTDEC, yyvsp[-1].n, yyvsp[0].tok); checkop(POSTDEC);}
    break;
case 16:
#line 391 "ANSI-C.y"
{ yyval.n = MakeBinopCoord('.', yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop('.');}
    break;
case 17:
#line 393 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(ARROW, yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop(ARROW);}
    break;
case 18:
#line 398 "ANSI-C.y"
{ yyval.L = MakeNewList(yyvsp[0].n); }
    break;
case 19:
#line 400 "ANSI-C.y"
{ yyval.L = AppendItem(yyvsp[-2].L, yyvsp[0].n); }
    break;
case 20:
#line 405 "ANSI-C.y"
{ yyval.n = LookupPostfixExpression(yyvsp[0].n); }
    break;
case 21:
#line 407 "ANSI-C.y"
{ yyval.n = MakeUnaryCoord(PREINC, yyvsp[0].n, yyvsp[-1].tok); }
    break;
case 22:
#line 409 "ANSI-C.y"
{ yyval.n = MakeUnaryCoord(PREDEC, yyvsp[0].n, yyvsp[-1].tok); }
    break;
case 23:
#line 411 "ANSI-C.y"
{ yyvsp[-1].n->u.unary.expr = yyvsp[0].n;
              yyval.n = yyvsp[-1].n; }
    break;
case 24:
#line 414 "ANSI-C.y"
{ yyval.n = MakeUnaryCoord(SIZEOF, yyvsp[0].n, yyvsp[-1].tok); checkstmt("sizeof");}
    break;
case 25:
#line 416 "ANSI-C.y"
{ yyval.n = MakeUnaryCoord(SIZEOF, yyvsp[-1].n, yyvsp[-3].tok); checkstmt("sizeof");}
    break;
case 26:
#line 420 "ANSI-C.y"
{ yyval.n = MakeUnaryCoord('&', NULL, yyvsp[0].tok); checkop('&');}
    break;
case 27:
#line 421 "ANSI-C.y"
{ yyval.n = MakeUnaryCoord('*', NULL, yyvsp[0].tok); checkop('*');}
    break;
case 28:
#line 422 "ANSI-C.y"
{ yyval.n = MakeUnaryCoord('+', NULL, yyvsp[0].tok); checkop('+');}
    break;
case 29:
#line 423 "ANSI-C.y"
{ yyval.n = MakeUnaryCoord('-', NULL, yyvsp[0].tok); checkop('-');}
    break;
case 30:
#line 424 "ANSI-C.y"
{ yyval.n = MakeUnaryCoord('~', NULL, yyvsp[0].tok); checkop('~');}
    break;
case 31:
#line 425 "ANSI-C.y"
{ yyval.n = MakeUnaryCoord('!', NULL, yyvsp[0].tok); checkop('!');}
    break;
case 33:
#line 430 "ANSI-C.y"
{ 
	  yyval.n = MakeCastCoord(yyvsp[-2].n, yyvsp[0].n, yyvsp[-3].tok); castwarning(); }
    break;
case 35:
#line 437 "ANSI-C.y"
{ yyval.n = MakeBinopCoord('*', yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop('*');}
    break;
case 36:
#line 439 "ANSI-C.y"
{ yyval.n = MakeBinopCoord('/', yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop('/');}
    break;
case 37:
#line 441 "ANSI-C.y"
{ yyval.n = MakeBinopCoord('%', yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop('%');}
    break;
case 39:
#line 447 "ANSI-C.y"
{ yyval.n = MakeBinopCoord('+', yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop('+');}
    break;
case 40:
#line 449 "ANSI-C.y"
{ yyval.n = MakeBinopCoord('-', yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop('-');}
    break;
case 42:
#line 455 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(LS, yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop(LS);}
    break;
case 43:
#line 457 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(RS, yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop(RS);}
    break;
case 45:
#line 463 "ANSI-C.y"
{ yyval.n = MakeBinopCoord('<', yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop('<');}
    break;
case 46:
#line 465 "ANSI-C.y"
{ yyval.n = MakeBinopCoord('>', yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop('>');}
    break;
case 47:
#line 467 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(LE, yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop(LE);}
    break;
case 48:
#line 469 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(GE, yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop(GE);}
    break;
case 50:
#line 475 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(EQ, yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop(EQ);}
    break;
case 51:
#line 477 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(NE, yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop(NE);}
    break;
case 53:
#line 483 "ANSI-C.y"
{ yyval.n = MakeBinopCoord('&', yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop('&');}
    break;
case 55:
#line 489 "ANSI-C.y"
{ 
	      checkop('^');
              WarnAboutPrecedence('^', yyvsp[-2].n);
              WarnAboutPrecedence('^', yyvsp[0].n);
	      yyval.n = MakeBinopCoord('^', yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); }
    break;
case 57:
#line 499 "ANSI-C.y"
{ 
	      checkop('|');
	      WarnAboutPrecedence('|', yyvsp[-2].n);
              WarnAboutPrecedence('|', yyvsp[0].n);
              yyval.n = MakeBinopCoord('|', yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); }
    break;
case 59:
#line 509 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(ANDAND, yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); checkop(ANDAND);}
    break;
case 61:
#line 515 "ANSI-C.y"
{ 
	      checkop(OROR);
	      WarnAboutPrecedence(OROR, yyvsp[-2].n);
              WarnAboutPrecedence(OROR, yyvsp[0].n);
              yyval.n = MakeBinopCoord(OROR, yyvsp[-2].n, yyvsp[0].n, yyvsp[-1].tok); }
    break;
case 63:
#line 525 "ANSI-C.y"
{ 
	      yyval.n = MakeTernaryCoord(yyvsp[-4].n, yyvsp[-2].n, yyvsp[0].n, yyvsp[-3].tok, yyvsp[-1].tok); 
	      checkstmt("ternary if");
	    }
    break;
case 65:
#line 534 "ANSI-C.y"
{ yyvsp[-1].n->u.binop.left = yyvsp[-2].n;
              yyvsp[-1].n->u.binop.right = yyvsp[0].n;
              yyval.n = yyvsp[-1].n; }
    break;
case 66:
#line 540 "ANSI-C.y"
{ yyval.n = MakeBinopCoord('=', NULL, NULL, yyvsp[0].tok); }
    break;
case 67:
#line 541 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(MULTassign, NULL, NULL, yyvsp[0].tok); 
	checkop('*');}
    break;
case 68:
#line 543 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(DIVassign, NULL, NULL, yyvsp[0].tok); 
	checkop('/');}
    break;
case 69:
#line 545 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(MODassign, NULL, NULL, yyvsp[0].tok); 
	checkop('%');}
    break;
case 70:
#line 547 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(PLUSassign, NULL, NULL, yyvsp[0].tok); 
	checkop('+');}
    break;
case 71:
#line 549 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(MINUSassign, NULL, NULL, yyvsp[0].tok); 
	checkop('-');}
    break;
case 72:
#line 551 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(LSassign, NULL, NULL, yyvsp[0].tok);    
	checkop(LS);}
    break;
case 73:
#line 553 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(RSassign, NULL, NULL, yyvsp[0].tok);    
	checkop(RS);}
    break;
case 74:
#line 555 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(ANDassign, NULL, NULL, yyvsp[0].tok);   
	checkop('&');}
    break;
case 75:
#line 557 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(ERassign, NULL, NULL, yyvsp[0].tok);    
	checkop('^');}
    break;
case 76:
#line 559 "ANSI-C.y"
{ yyval.n = MakeBinopCoord(ORassign, NULL, NULL, yyvsp[0].tok);    
	checkop('|');}
    break;
case 78:
#line 566 "ANSI-C.y"
{  
              if (yyvsp[-2].n->typ == Comma) 
                {
		  AppendItem(yyvsp[-2].n->u.comma.exprs, yyvsp[0].n);
		  yyval.n = yyvsp[-2].n;
		}
              else
                {
		  yyval.n = MakeCommaCoord(AppendItem(MakeNewList(yyvsp[-2].n), yyvsp[0].n), yyvsp[-2].n->coord);
		}
	    }
    break;
case 79:
#line 580 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; }
    break;
case 80:
#line 584 "ANSI-C.y"
{ yyval.n = (Node *) NULL; }
    break;
case 81:
#line 585 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; }
    break;
case 82:
#line 622 "ANSI-C.y"
{ yyval.L = yyvsp[-1].L; }
    break;
case 83:
#line 624 "ANSI-C.y"
{ yyval.L = yyvsp[-1].L; }
    break;
case 84:
#line 626 "ANSI-C.y"
{ yyval.L = MakeNewList(ForceNewSU(yyvsp[-1].n, yyvsp[0].tok)); }
    break;
case 85:
#line 628 "ANSI-C.y"
{ yyval.L = MakeNewList(ForceNewSU(yyvsp[-1].n, yyvsp[0].tok)); }
    break;
case 86:
#line 634 "ANSI-C.y"
{ 
	      SetDeclType(yyvsp[0].n, yyvsp[-1].n, Redecl);
	    }
    break;
case 87:
#line 637 "ANSI-C.y"
{ SetDeclAttribs(yyvsp[-2].n, yyvsp[0].L); }
    break;
case 88:
#line 639 "ANSI-C.y"
{ 
              yyval.L = MakeNewList(SetDeclInit(yyvsp[-4].n, yyvsp[0].n)); 
            }
    break;
case 89:
#line 643 "ANSI-C.y"
{ 
              SetDeclType(yyvsp[0].n, yyvsp[-1].n, Redecl);
            }
    break;
case 90:
#line 646 "ANSI-C.y"
{ SetDeclAttribs(yyvsp[-2].n, yyvsp[0].L); }
    break;
case 91:
#line 648 "ANSI-C.y"
{ 
              yyval.L = MakeNewList(SetDeclInit(yyvsp[-4].n, yyvsp[0].n)); 
	    }
    break;
case 92:
#line 652 "ANSI-C.y"
{ 
	      yyval.L = AppendDecl(yyvsp[-2].L, yyvsp[0].n, Redecl);
	    }
    break;
case 93:
#line 655 "ANSI-C.y"
{ SetDeclAttribs(yyvsp[-2].n, yyvsp[0].L); }
    break;
case 94:
#line 657 "ANSI-C.y"
{ 
              SetDeclInit(yyvsp[-4].n, yyvsp[0].n); 
            }
    break;
case 95:
#line 665 "ANSI-C.y"
{ 
              SyntaxError("declaration without a variable"); 
            }
    break;
case 96:
#line 670 "ANSI-C.y"
{ 
              yyval.L = NULL; /* empty list */ 
            }
    break;
case 97:
#line 675 "ANSI-C.y"
{ 
              SyntaxError("declaration without a variable"); 
            }
    break;
case 98:
#line 680 "ANSI-C.y"
{ 
              yyval.L = NULL; /* empty list */ 
            }
    break;
case 100:
#line 690 "ANSI-C.y"
{ 
              SetDeclType(yyvsp[0].n, MakeDefaultPrimType(yyvsp[-1].tq.tq, yyvsp[-1].tq.coord), NoRedecl);
            }
    break;
case 101:
#line 693 "ANSI-C.y"
{ SetDeclAttribs(yyvsp[-2].n, yyvsp[0].L); }
    break;
case 102:
#line 695 "ANSI-C.y"
{ 
              yyval.L = MakeNewList(SetDeclInit(yyvsp[-4].n, yyvsp[0].n)); 
            }
    break;
case 103:
#line 699 "ANSI-C.y"
{ 
              SetDeclType(yyvsp[0].n, MakeDefaultPrimType(yyvsp[-1].tq.tq, yyvsp[-1].tq.coord), NoRedecl);
            }
    break;
case 104:
#line 702 "ANSI-C.y"
{ SetDeclAttribs(yyvsp[-2].n, yyvsp[0].L); }
    break;
case 105:
#line 704 "ANSI-C.y"
{ 
              yyval.L = MakeNewList(SetDeclInit(yyvsp[-4].n, yyvsp[0].n)); 
	    }
    break;
case 106:
#line 708 "ANSI-C.y"
{ yyval.L = AppendDecl(yyvsp[-2].L, yyvsp[0].n, NoRedecl); }
    break;
case 107:
#line 709 "ANSI-C.y"
{ SetDeclAttribs(yyvsp[-2].n, yyvsp[0].L); }
    break;
case 108:
#line 711 "ANSI-C.y"
{ SetDeclInit(yyvsp[-4].n, yyvsp[0].n); }
    break;
case 109:
#line 716 "ANSI-C.y"
{ 
              SyntaxError("declaration without a variable"); 
	    }
    break;
case 110:
#line 721 "ANSI-C.y"
{ 
              yyval.L = NULL; /* empty list */ 
	    }
    break;
case 111:
#line 726 "ANSI-C.y"
{ 
              SyntaxError("declaration without a variable"); 
	    }
    break;
case 112:
#line 731 "ANSI-C.y"
{ 
              yyval.L = NULL; /* empty list */ 
            }
    break;
case 114:
#line 740 "ANSI-C.y"
{ yyval.n = FinishPrimType(yyvsp[0].n); }
    break;
case 117:
#line 749 "ANSI-C.y"
{ yyval.n = TypeQualifyNode(yyvsp[-1].n, yyvsp[0].tq.tq); }
    break;
case 118:
#line 751 "ANSI-C.y"
{ yyval.n = TypeQualifyNode(yyvsp[0].n, yyvsp[-1].tq.tq); yyval.n->coord = yyvsp[-1].tq.coord; }
    break;
case 119:
#line 753 "ANSI-C.y"
{ yyval.n = TypeQualifyNode(yyvsp[-1].n, yyvsp[0].tq.tq); }
    break;
case 120:
#line 755 "ANSI-C.y"
{ yyval.n = MergePrimTypes(yyvsp[-1].n, yyvsp[0].n); }
    break;
case 121:
#line 762 "ANSI-C.y"
{ yyval.n = TypeQualifyNode(yyvsp[-1].n, yyvsp[0].tq.tq); }
    break;
case 122:
#line 764 "ANSI-C.y"
{ yyval.n = TypeQualifyNode(yyvsp[0].n, yyvsp[-1].tq.tq); yyval.n->coord = yyvsp[-1].tq.coord; }
    break;
case 123:
#line 766 "ANSI-C.y"
{ yyval.n = TypeQualifyNode(yyvsp[-1].n, yyvsp[0].tq.tq); }
    break;
case 124:
#line 773 "ANSI-C.y"
{ yyval.n = TypeQualifyNode(yyvsp[-1].n, yyvsp[0].tq.tq); }
    break;
case 125:
#line 775 "ANSI-C.y"
{ yyval.n = ConvertIdToTdef(yyvsp[0].n, yyvsp[-1].tq.tq, GetTypedefType(yyvsp[0].n)); yyval.n->coord = yyvsp[-1].tq.coord; }
    break;
case 126:
#line 777 "ANSI-C.y"
{ yyval.n = TypeQualifyNode(yyvsp[-1].n, yyvsp[0].tq.tq); }
    break;
case 128:
#line 785 "ANSI-C.y"
{ yyval.tq.tq = MergeTypeQuals(yyvsp[-1].tq.tq, yyvsp[0].tq.tq, yyvsp[0].tq.coord);
              yyval.tq.coord = yyvsp[-1].tq.coord; }
    break;
case 129:
#line 788 "ANSI-C.y"
{ yyval.tq.tq = MergeTypeQuals(yyvsp[-1].tq.tq, yyvsp[0].tq.tq, yyvsp[0].tq.coord);
              yyval.tq.coord = yyvsp[-1].tq.coord; }
    break;
case 132:
#line 801 "ANSI-C.y"
{ yyval.n = FinishPrimType(yyvsp[0].n); }
    break;
case 136:
#line 810 "ANSI-C.y"
{ yyval.n = TypeQualifyNode(yyvsp[0].n, yyvsp[-1].tq.tq); yyval.n->coord = yyvsp[-1].tq.coord; }
    break;
case 137:
#line 812 "ANSI-C.y"
{ yyval.n = TypeQualifyNode(yyvsp[-1].n, yyvsp[0].tq.tq); }
    break;
case 138:
#line 814 "ANSI-C.y"
{ yyval.n = MergePrimTypes(yyvsp[-1].n, yyvsp[0].n); }
    break;
case 140:
#line 821 "ANSI-C.y"
{ yyval.n = TypeQualifyNode(yyvsp[0].n, yyvsp[-1].tq.tq); yyval.n->coord = yyvsp[-1].tq.coord; }
    break;
case 141:
#line 823 "ANSI-C.y"
{ yyval.n = TypeQualifyNode(yyvsp[-1].n, yyvsp[0].tq.tq); }
    break;
case 142:
#line 830 "ANSI-C.y"
{ yyval.n = ConvertIdToTdef(yyvsp[0].n, EMPTY_TQ, GetTypedefType(yyvsp[0].n)); }
    break;
case 143:
#line 832 "ANSI-C.y"
{ yyval.n = ConvertIdToTdef(yyvsp[0].n, yyvsp[-1].tq.tq, GetTypedefType(yyvsp[0].n)); yyval.n->coord = yyvsp[-1].tq.coord; }
    break;
case 144:
#line 834 "ANSI-C.y"
{ yyval.n = TypeQualifyNode(yyvsp[-1].n, yyvsp[0].tq.tq); }
    break;
case 146:
#line 841 "ANSI-C.y"
{ yyval.tq.tq = MergeTypeQuals(yyvsp[-1].tq.tq, yyvsp[0].tq.tq, yyvsp[0].tq.coord);
              yyval.tq.coord = yyvsp[-1].tq.coord; }
    break;
case 148:
#line 848 "ANSI-C.y"
{ yyval.tq.tq = MergeTypeQuals(yyvsp[-1].tq.tq, yyvsp[0].tq.tq, yyvsp[0].tq.coord);
              yyval.tq.coord = yyvsp[-1].tq.coord; }
    break;
case 154:
#line 864 "ANSI-C.y"
{
	      Warning(2, "function prototype parameters must have types");
              yyval.n = AddDefaultParameterTypes(yyvsp[0].n);
            }
    break;
case 156:
#line 875 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[0].n, MakePtrCoord(EMPTY_TQ, NULL, yyvsp[-1].tok), Redecl);
               }
    break;
case 157:
#line 878 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[-1].n, MakePtrCoord(EMPTY_TQ, NULL, yyvsp[-3].tok), Redecl); 
               }
    break;
case 158:
#line 881 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[-1].n, MakePtrCoord(   yyvsp[-3].tq.tq,    NULL, yyvsp[-4].tok), Redecl);
               }
    break;
case 159:
#line 884 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[0].n, MakePtrCoord(   yyvsp[-1].tq.tq,    NULL, yyvsp[-2].tok), Redecl); 
               }
    break;
case 160:
#line 892 "ANSI-C.y"
{ yyval.n = yyvsp[-1].n;  
              }
    break;
case 161:
#line 895 "ANSI-C.y"
{ yyval.n = ModifyDeclType(yyvsp[-2].n, yyvsp[-1].n); 
               }
    break;
case 162:
#line 898 "ANSI-C.y"
{ yyval.n = ModifyDeclType(yyvsp[-2].n, yyvsp[0].n); 
               }
    break;
case 163:
#line 905 "ANSI-C.y"
{ yyval.n = ConvertIdToDecl(yyvsp[0].n, EMPTY_TQ, NULL, NULL, NULL); }
    break;
case 164:
#line 907 "ANSI-C.y"
{ yyval.n = yyvsp[-1].n;  
               }
    break;
case 165:
#line 914 "ANSI-C.y"
{ yyval.n = ConvertIdToDecl(yyvsp[0].n, EMPTY_TQ, NULL, NULL, NULL); }
    break;
case 166:
#line 916 "ANSI-C.y"
{ yyval.n = ConvertIdToDecl(yyvsp[-1].n, EMPTY_TQ, yyvsp[0].n, NULL, NULL);   }
    break;
case 169:
#line 928 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[0].n, MakePtrCoord(EMPTY_TQ, NULL, yyvsp[-1].tok), Redecl); 
               }
    break;
case 170:
#line 931 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[0].n, MakePtrCoord(yyvsp[-1].tq.tq, NULL, yyvsp[-2].tok), Redecl); 
               }
    break;
case 171:
#line 938 "ANSI-C.y"
{ yyval.n = yyvsp[-1].n; 
               }
    break;
case 172:
#line 941 "ANSI-C.y"
{ yyval.n = ModifyDeclType(yyvsp[-2].n, yyvsp[0].n); 
               }
    break;
case 176:
#line 955 "ANSI-C.y"
{ yyval.n = MakePtrCoord(EMPTY_TQ, NULL, yyvsp[0].tok); }
    break;
case 177:
#line 957 "ANSI-C.y"
{ yyval.n = MakePtrCoord(yyvsp[0].tq.tq, NULL, yyvsp[-1].tok); }
    break;
case 178:
#line 959 "ANSI-C.y"
{ yyval.n = SetBaseType(yyvsp[0].n, MakePtrCoord(EMPTY_TQ, NULL, yyvsp[-1].tok)); 
               }
    break;
case 179:
#line 962 "ANSI-C.y"
{ yyval.n = SetBaseType(yyvsp[0].n, MakePtrCoord(yyvsp[-1].tq.tq, NULL, yyvsp[-2].tok)); 
               }
    break;
case 180:
#line 969 "ANSI-C.y"
{ yyval.n = yyvsp[-1].n; 
               }
    break;
case 181:
#line 972 "ANSI-C.y"
{ yyval.n = yyvsp[-1].n; 
               }
    break;
case 182:
#line 975 "ANSI-C.y"
{ yyval.n = yyvsp[-1].n; 
               }
    break;
case 183:
#line 978 "ANSI-C.y"
{ yyval.n = SetBaseType(yyvsp[-2].n, yyvsp[0].n); 
               }
    break;
case 184:
#line 984 "ANSI-C.y"
{ yyval.n = yyvsp[0].n;                   }
    break;
case 185:
#line 985 "ANSI-C.y"
{ yyval.n = MakeFdclCoord(EMPTY_TQ, NULL, NULL, yyvsp[-1].tok); }
    break;
case 186:
#line 986 "ANSI-C.y"
{ yyval.n = MakeFdclCoord(EMPTY_TQ, yyvsp[-1].L, NULL, yyvsp[-2].tok); }
    break;
case 190:
#line 999 "ANSI-C.y"
{ yyval.n = ModifyDeclType(yyvsp[0].n, MakePtrCoord(EMPTY_TQ, NULL, yyvsp[-1].tok)); 
               }
    break;
case 191:
#line 1002 "ANSI-C.y"
{ yyval.n = ModifyDeclType(yyvsp[0].n, MakePtrCoord(   yyvsp[-1].tq.tq,    NULL, yyvsp[-2].tok)); 
               }
    break;
case 192:
#line 1009 "ANSI-C.y"
{ yyval.n = ModifyDeclType(yyvsp[-1].n, yyvsp[0].n); }
    break;
case 193:
#line 1011 "ANSI-C.y"
{ yyval.n = yyvsp[-1].n; 
               }
    break;
case 194:
#line 1014 "ANSI-C.y"
{ yyval.n = ModifyDeclType(yyvsp[-2].n, yyvsp[0].n); 
               }
    break;
case 195:
#line 1021 "ANSI-C.y"
{ yyval.n = ConvertIdToDecl(yyvsp[0].n, EMPTY_TQ, NULL, NULL, NULL); }
    break;
case 196:
#line 1023 "ANSI-C.y"
{ yyval.n = yyvsp[-1].n; 
               }
    break;
case 197:
#line 1030 "ANSI-C.y"
{ 
/*              OldStyleFunctionDefinition = TRUE; */
              yyval.n = yyvsp[0].n; 
            }
    break;
case 198:
#line 1035 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[0].n, MakePtrCoord(EMPTY_TQ, NULL, yyvsp[-1].tok), SU); 
               }
    break;
case 199:
#line 1038 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[0].n, MakePtrCoord(yyvsp[-1].tq.tq, NULL, yyvsp[-2].tok), SU); 
               }
    break;
case 200:
#line 1045 "ANSI-C.y"
{ 
	      yyval.n = ModifyDeclType(yyvsp[-3].n, MakeFdclCoord(EMPTY_TQ, yyvsp[-1].L, NULL, yyvsp[-2].tok)); 
	    }
    break;
case 201:
#line 1050 "ANSI-C.y"
{ 
	      yyval.n = yyvsp[-1].n; 
	    }
    break;
case 202:
#line 1054 "ANSI-C.y"
{ 
	      yyval.n = ModifyDeclType(yyvsp[-2].n, yyvsp[0].n); 
	    }
    break;
case 203:
#line 1070 "ANSI-C.y"
{ yyval.L = MakeNewList(yyvsp[0].n); }
    break;
case 204:
#line 1072 "ANSI-C.y"
{ yyval.L = AppendItem(yyvsp[-2].L, yyvsp[0].n); }
    break;
case 207:
#line 1084 "ANSI-C.y"
{ yyval.n = FinishType(yyvsp[0].n); }
    break;
case 208:
#line 1086 "ANSI-C.y"
{ yyval.n = FinishType(SetBaseType(yyvsp[0].n, yyvsp[-1].n)); }
    break;
case 209:
#line 1088 "ANSI-C.y"
{ yyval.n = MakeDefaultPrimType(yyvsp[0].tq.tq, yyvsp[0].tq.coord); }
    break;
case 210:
#line 1090 "ANSI-C.y"
{ yyval.n = SetBaseType(yyvsp[0].n, MakeDefaultPrimType(yyvsp[-1].tq.tq, yyvsp[-1].tq.coord)); }
    break;
case 211:
#line 1098 "ANSI-C.y"
{ yyval.L = NULL; }
    break;
case 212:
#line 1100 "ANSI-C.y"
{ yyval.L = yyvsp[0].L; }
    break;
case 213:
#line 1105 "ANSI-C.y"
{ yyval.L = yyvsp[0].L; }
    break;
case 214:
#line 1107 "ANSI-C.y"
{ yyval.L = JoinLists (yyvsp[-1].L, yyvsp[0].L); }
    break;
case 215:
#line 1112 "ANSI-C.y"
{ if (ANSIOnly)
	            SyntaxError("__attribute__ not allowed with -ansi switch");
                  yyval.L = yyvsp[-2].L; }
    break;
case 216:
#line 1119 "ANSI-C.y"
{ yyval.L = MakeNewList(yyvsp[0].n); }
    break;
case 217:
#line 1121 "ANSI-C.y"
{ yyval.L = AppendItem(yyvsp[-2].L, yyvsp[0].n); }
    break;
case 218:
#line 1126 "ANSI-C.y"
{ yyval.n = NULL; }
    break;
case 219:
#line 1128 "ANSI-C.y"
{ yyval.n = ConvertIdToAttrib(yyvsp[0].n, NULL); }
    break;
case 220:
#line 1130 "ANSI-C.y"
{ yyval.n = ConvertIdToAttrib(yyvsp[-3].n, yyvsp[-1].n); }
    break;
case 223:
#line 1137 "ANSI-C.y"
{ yyval.n = MakeIdCoord(UniqueString("const"), yyvsp[0].tok); }
    break;
case 224:
#line 1142 "ANSI-C.y"
{ yyval.n = NULL; }
    break;
case 225:
#line 1143 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; }
    break;
case 226:
#line 1148 "ANSI-C.y"
{ yyval.n = yyvsp[-1].n; yyval.n->coord = yyvsp[-2].tok; }
    break;
case 227:
#line 1149 "ANSI-C.y"
{ yyval.n = yyvsp[-2].n; yyval.n->coord = yyvsp[-3].tok; }
    break;
case 228:
#line 1150 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; }
    break;
case 229:
#line 1156 "ANSI-C.y"
{ yyval.n = MakeInitializerCoord(MakeNewList(yyvsp[0].n), yyvsp[0].n->coord); }
    break;
case 230:
#line 1158 "ANSI-C.y"
{ 
              assert(yyvsp[-2].n->typ == Initializer);
              AppendItem(yyvsp[-2].n->u.initializer.exprs, yyvsp[0].n);
              yyval.n = yyvsp[-2].n; 
            }
    break;
case 232:
#line 1168 "ANSI-C.y"
{ yyval.L = AppendItem(yyvsp[-2].L, EllipsisNode); }
    break;
case 233:
#line 1172 "ANSI-C.y"
{ Node *n = MakePrimCoord(EMPTY_TQ, Void, yyvsp[0].tok);
	      SyntaxErrorCoord(n->coord, "First argument cannot be `...'");
              yyval.L = MakeNewList(n);
            }
    break;
case 234:
#line 1181 "ANSI-C.y"
{ yyval.L = MakeNewList(yyvsp[0].n); }
    break;
case 235:
#line 1183 "ANSI-C.y"
{ yyval.L = AppendItem(yyvsp[-2].L, yyvsp[0].n); }
    break;
case 236:
#line 1187 "ANSI-C.y"
{ 
	      SyntaxErrorCoord(yyvsp[-2].n->coord, "formals cannot have initializers");
              yyval.L = MakeNewList(yyvsp[-2].n); 
            }
    break;
case 237:
#line 1192 "ANSI-C.y"
{ yyval.L = yyvsp[-2].L; }
    break;
case 238:
#line 1198 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; }
    break;
case 239:
#line 1200 "ANSI-C.y"
{ yyval.n = SetBaseType(yyvsp[0].n, yyvsp[-1].n); 
            }
    break;
case 240:
#line 1203 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[0].n, yyvsp[-1].n, Formal); 
            }
    break;
case 241:
#line 1206 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[0].n, yyvsp[-1].n, Formal); 
            }
    break;
case 242:
#line 1209 "ANSI-C.y"
{ yyval.n = MakeDefaultPrimType(yyvsp[0].tq.tq, yyvsp[0].tq.coord); }
    break;
case 243:
#line 1211 "ANSI-C.y"
{ yyval.n = SetBaseType(yyvsp[0].n, MakeDefaultPrimType(yyvsp[-1].tq.tq, yyvsp[-1].tq.coord)); }
    break;
case 244:
#line 1213 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[0].n, MakeDefaultPrimType(yyvsp[-1].tq.tq, yyvsp[-1].tq.coord), Formal); }
    break;
case 245:
#line 1215 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; }
    break;
case 246:
#line 1217 "ANSI-C.y"
{ yyval.n = SetBaseType(yyvsp[0].n, yyvsp[-1].n); 
            }
    break;
case 247:
#line 1220 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[0].n, yyvsp[-1].n, Formal); 
            }
    break;
case 248:
#line 1223 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[0].n, yyvsp[-1].n, Formal); 
            }
    break;
case 249:
#line 1226 "ANSI-C.y"
{ yyval.n = MakeDefaultPrimType(yyvsp[0].tq.tq, yyvsp[0].tq.coord); }
    break;
case 250:
#line 1228 "ANSI-C.y"
{ yyval.n = SetBaseType(yyvsp[0].n, MakeDefaultPrimType(yyvsp[-1].tq.tq, yyvsp[-1].tq.coord)); }
    break;
case 251:
#line 1230 "ANSI-C.y"
{ yyval.n = SetDeclType(yyvsp[0].n, MakeDefaultPrimType(yyvsp[-1].tq.tq, yyvsp[-1].tq.coord), Formal); }
    break;
case 252:
#line 1236 "ANSI-C.y"
{ yyval.n = MakeAdclCoord(EMPTY_TQ, NULL, NULL, yyvsp[-1].tok); arrayop();}
    break;
case 253:
#line 1238 "ANSI-C.y"
{ yyval.n = MakeAdclCoord(EMPTY_TQ, NULL, yyvsp[-1].n, yyvsp[-2].tok); arrayop();}
    break;
case 254:
#line 1240 "ANSI-C.y"
{ yyval.n = SetBaseType(yyvsp[-3].n, MakeAdclCoord(EMPTY_TQ, NULL, yyvsp[-1].n, yyvsp[-2].tok)); arrayop();}
    break;
case 255:
#line 1245 "ANSI-C.y"
{ 
              SyntaxError("array declaration with illegal empty dimension");
              yyval.n = SetBaseType(yyvsp[-2].n, MakeAdclCoord(EMPTY_TQ, NULL, SintOne, yyvsp[-1].tok)); 
            }
    break;
case 256:
#line 1260 "ANSI-C.y"
{ 
              yyval.n = SetSUdclNameFields(yyvsp[-3].n, NULL, yyvsp[-1].L, yyvsp[-2].tok, yyvsp[0].tok);
            }
    break;
case 257:
#line 1265 "ANSI-C.y"
{ 
              yyval.n = SetSUdclNameFields(yyvsp[-4].n, yyvsp[-3].n, yyvsp[-1].L, yyvsp[-2].tok, yyvsp[0].tok);
	    }
    break;
case 258:
#line 1269 "ANSI-C.y"
{ 
              yyval.n = SetSUdclName(yyvsp[-1].n, yyvsp[0].n, yyvsp[-1].n->coord);
	    }
    break;
case 259:
#line 1274 "ANSI-C.y"
{ 
              if (ANSIOnly)
                 Warning(1, "empty structure declaration");
              yyval.n = SetSUdclNameFields(yyvsp[-2].n, NULL, NULL, yyvsp[-1].tok, yyvsp[0].tok); 
	    }
    break;
case 260:
#line 1280 "ANSI-C.y"
{ 
              if (ANSIOnly)
                 Warning(1, "empty structure declaration");
              yyval.n = SetSUdclNameFields(yyvsp[-3].n, yyvsp[-2].n, NULL, yyvsp[-1].tok, yyvsp[0].tok); 
	    }
    break;
case 261:
#line 1289 "ANSI-C.y"
{ yyval.n = MakeSdclCoord(EMPTY_TQ, NULL, yyvsp[0].tok); }
    break;
case 262:
#line 1290 "ANSI-C.y"
{ yyval.n = MakeUdclCoord(EMPTY_TQ, NULL, yyvsp[0].tok); }
    break;
case 264:
#line 1297 "ANSI-C.y"
{ yyval.L = JoinLists(yyvsp[-1].L, yyvsp[0].L); }
    break;
case 267:
#line 1310 "ANSI-C.y"
{ 
	      yyval.L = MakeNewList(SetDeclType(yyvsp[0].n,
					    MakeDefaultPrimType(yyvsp[-1].tq.tq, yyvsp[-1].tq.coord),
					    SU)); 
	    }
    break;
case 268:
#line 1316 "ANSI-C.y"
{ yyval.L = AppendDecl(yyvsp[-2].L, yyvsp[0].n, SU); }
    break;
case 269:
#line 1322 "ANSI-C.y"
{ yyval.L = MakeNewList(SetDeclType(yyvsp[0].n, yyvsp[-1].n, SU)); }
    break;
case 270:
#line 1324 "ANSI-C.y"
{ yyval.L = AppendDecl(yyvsp[-2].L, yyvsp[0].n, SU); }
    break;
case 271:
#line 1331 "ANSI-C.y"
{ SetDeclAttribs(yyvsp[-2].n, yyvsp[0].L);
              yyval.n = SetDeclBitSize(yyvsp[-2].n, yyvsp[-1].n); }
    break;
case 272:
#line 1334 "ANSI-C.y"
{ yyval.n = MakeDeclCoord(NULL, EMPTY_TQ, NULL, NULL, yyvsp[-1].n, yyvsp[-1].n->coord);
              SetDeclAttribs(yyval.n, yyvsp[0].L); }
    break;
case 273:
#line 1341 "ANSI-C.y"
{ yyval.n = SetDeclBitSize(yyvsp[-2].n, yyvsp[-1].n);
              SetDeclAttribs(yyvsp[-2].n, yyvsp[0].L); }
    break;
case 274:
#line 1344 "ANSI-C.y"
{ yyval.n = MakeDeclCoord(NULL, EMPTY_TQ, NULL, NULL, yyvsp[-1].n, yyvsp[-1].n->coord);
              SetDeclAttribs(yyval.n, yyvsp[0].L); }
    break;
case 275:
#line 1350 "ANSI-C.y"
{ yyval.n = NULL; }
    break;
case 277:
#line 1356 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; }
    break;
case 278:
#line 1362 "ANSI-C.y"
{ yyval.n = BuildEnum(NULL, yyvsp[-2].L, yyvsp[-4].tok, yyvsp[-3].tok, yyvsp[0].tok); }
    break;
case 279:
#line 1364 "ANSI-C.y"
{ yyval.n = BuildEnum(yyvsp[-4].n, yyvsp[-2].L, yyvsp[-5].tok, yyvsp[-3].tok, yyvsp[0].tok);   }
    break;
case 280:
#line 1366 "ANSI-C.y"
{ yyval.n = BuildEnum(yyvsp[0].n, NULL, yyvsp[-1].tok, yyvsp[0].n->coord, yyvsp[0].n->coord); }
    break;
case 281:
#line 1372 "ANSI-C.y"
{ yyval.L = MakeNewList(BuildEnumConst(yyvsp[-1].n, yyvsp[0].n)); }
    break;
case 282:
#line 1374 "ANSI-C.y"
{ yyval.L = AppendItem(yyvsp[-3].L, BuildEnumConst(yyvsp[-1].n, yyvsp[0].n)); }
    break;
case 283:
#line 1379 "ANSI-C.y"
{ yyval.n = NULL; }
    break;
case 284:
#line 1380 "ANSI-C.y"
{ yyval.n = yyvsp[0].n;   }
    break;
case 285:
#line 1384 "ANSI-C.y"
{ }
    break;
case 286:
#line 1385 "ANSI-C.y"
{ }
    break;
case 293:
#line 1403 "ANSI-C.y"
{  yyval.n = NULL; }
    break;
case 294:
#line 1408 "ANSI-C.y"
{ yyval.n = BuildLabel(yyvsp[-1].n, NULL); }
    break;
case 295:
#line 1410 "ANSI-C.y"
{ yyval.n->u.label.stmt = yyvsp[0].n; }
    break;
case 296:
#line 1413 "ANSI-C.y"
{ yyval.n = AddContainee(MakeCaseCoord(yyvsp[-2].n, yyvsp[0].n, NULL, yyvsp[-3].tok)); }
    break;
case 297:
#line 1415 "ANSI-C.y"
{ yyval.n = AddContainee(MakeDefaultCoord(yyvsp[0].n, NULL, yyvsp[-2].tok)); }
    break;
case 298:
#line 1419 "ANSI-C.y"
{ yyval.n = BuildLabel(yyvsp[-2].n, yyvsp[0].n); }
    break;
case 299:
#line 1424 "ANSI-C.y"
{ yyval.n = MakeBlockCoord(PrimVoid, NULL, NULL, yyvsp[-1].tok, yyvsp[0].tok); }
    break;
case 300:
#line 1426 "ANSI-C.y"
{ yyval.n = MakeBlockCoord(PrimVoid, GrabPragmas(yyvsp[-1].L), NULL, yyvsp[-2].tok, yyvsp[0].tok); }
    break;
case 301:
#line 1428 "ANSI-C.y"
{ yyval.n = MakeBlockCoord(PrimVoid, NULL, GrabPragmas(yyvsp[-1].L), yyvsp[-2].tok, yyvsp[0].tok); }
    break;
case 302:
#line 1430 "ANSI-C.y"
{ yyval.n = MakeBlockCoord(PrimVoid, yyvsp[-2].L, GrabPragmas(yyvsp[-1].L), yyvsp[-3].tok, yyvsp[0].tok); }
    break;
case 303:
#line 1433 "ANSI-C.y"
{ EnterScope(); }
    break;
case 304:
#line 1435 "ANSI-C.y"
{ ExitScope(); }
    break;
case 305:
#line 1443 "ANSI-C.y"
{ yyval.n = MakeBlockCoord(PrimVoid, NULL, NULL, yyvsp[-1].tok, yyvsp[0].tok);disable_check();}
    break;
case 306:
#line 1445 "ANSI-C.y"
{ yyval.n = MakeBlockCoord(PrimVoid, GrabPragmas(yyvsp[-1].L), NULL, yyvsp[-2].tok, yyvsp[0].tok); disable_check();}
    break;
case 307:
#line 1447 "ANSI-C.y"
{ yyval.n = MakeBlockCoord(PrimVoid, NULL, GrabPragmas(yyvsp[-1].L), yyvsp[-2].tok, yyvsp[0].tok); disable_check();}
    break;
case 308:
#line 1449 "ANSI-C.y"
{ yyval.n = MakeBlockCoord(PrimVoid, yyvsp[-2].L, GrabPragmas(yyvsp[-1].L), yyvsp[-3].tok, yyvsp[0].tok); disable_check();}
    break;
case 309:
#line 1455 "ANSI-C.y"
{ yyval.L = GrabPragmas(yyvsp[0].L); }
    break;
case 310:
#line 1456 "ANSI-C.y"
{ yyval.L = JoinLists(GrabPragmas(yyvsp[-1].L),
                                                         yyvsp[0].L); }
    break;
case 311:
#line 1461 "ANSI-C.y"
{ yyval.L = GrabPragmas(MakeNewList(yyvsp[0].n)); }
    break;
case 312:
#line 1462 "ANSI-C.y"
{ yyval.L = AppendItem(GrabPragmas(yyvsp[-1].L), 
                                                        yyvsp[0].n); }
    break;
case 314:
#line 1472 "ANSI-C.y"
{ yyval.n = MakeIfCoord(yyvsp[-2].n, yyvsp[0].n, yyvsp[-4].tok); checkstmt("if");}
    break;
case 315:
#line 1474 "ANSI-C.y"
{ yyval.n = MakeIfElseCoord(yyvsp[-4].n, yyvsp[-2].n, yyvsp[0].n, yyvsp[-6].tok, yyvsp[-1].tok); checkstmt("if");}
    break;
case 316:
#line 1475 "ANSI-C.y"
{ PushContainer(Switch); }
    break;
case 317:
#line 1476 "ANSI-C.y"
{ yyval.n = PopContainer(MakeSwitchCoord(yyvsp[-2].n, yyvsp[0].n, NULL, yyvsp[-5].tok)); 
	    checkstmt("switch");}
    break;
case 318:
#line 1482 "ANSI-C.y"
{ PushContainer(While);}
    break;
case 319:
#line 1484 "ANSI-C.y"
{ yyval.n = PopContainer(MakeWhileCoord(yyvsp[-2].n, yyvsp[0].n, yyvsp[-5].tok)); checkstmt("while");}
    break;
case 320:
#line 1486 "ANSI-C.y"
{ PushContainer(Do);}
    break;
case 321:
#line 1488 "ANSI-C.y"
{ yyval.n = PopContainer(MakeDoCoord(yyvsp[-5].n, yyvsp[-2].n, yyvsp[-7].tok, yyvsp[-4].tok)); checkstmt("do");}
    break;
case 322:
#line 1490 "ANSI-C.y"
{ PushContainer(For);}
    break;
case 323:
#line 1492 "ANSI-C.y"
{ yyval.n = PopContainer(MakeForCoord(yyvsp[-7].n, yyvsp[-5].n, yyvsp[-3].n, yyvsp[0].n, yyvsp[-9].tok)); checkstmt("for");}
    break;
case 324:
#line 1496 "ANSI-C.y"
{ PushContainer(For);}
    break;
case 325:
#line 1498 "ANSI-C.y"
{ yyval.n = PopContainer(MakeForCoord(NULL, yyvsp[-5].n, yyvsp[-3].n, yyvsp[0].n, yyvsp[-9].tok)); }
    break;
case 326:
#line 1500 "ANSI-C.y"
{ PushContainer(For);}
    break;
case 327:
#line 1502 "ANSI-C.y"
{ yyval.n = PopContainer(MakeForCoord(yyvsp[-7].n, yyvsp[-5].n, NULL, yyvsp[0].n, yyvsp[-9].tok)); }
    break;
case 328:
#line 1504 "ANSI-C.y"
{ PushContainer(For);}
    break;
case 329:
#line 1506 "ANSI-C.y"
{ yyval.n = PopContainer(MakeForCoord(yyvsp[-7].n, NULL, yyvsp[-3].n, yyvsp[0].n, yyvsp[-9].tok)); }
    break;
case 330:
#line 1507 "ANSI-C.y"
{ PushContainer(For);}
    break;
case 331:
#line 1508 "ANSI-C.y"
{ yyval.n = PopContainer(MakeForCoord(NULL, SintZero, NULL, yyvsp[0].n, yyvsp[-5].tok)); }
    break;
case 332:
#line 1513 "ANSI-C.y"
{ yyval.n = ResolveGoto(yyvsp[-1].n, yyvsp[-2].tok); checkstmt("goto");}
    break;
case 333:
#line 1515 "ANSI-C.y"
{ yyval.n = AddContainee(MakeContinueCoord(NULL, yyvsp[-1].tok)); checkstmt("continue");}
    break;
case 334:
#line 1517 "ANSI-C.y"
{ yyval.n = AddContainee(MakeBreakCoord(NULL, yyvsp[-1].tok)); checkstmt("break");}
    break;
case 335:
#line 1519 "ANSI-C.y"
{ yyval.n = AddReturn(MakeReturnCoord(yyvsp[-1].n, yyvsp[-2].tok)); }
    break;
case 336:
#line 1523 "ANSI-C.y"
{ yyval.n = ResolveGoto(yyvsp[-1].n, yyvsp[-2].tok); }
    break;
case 338:
#line 1535 "ANSI-C.y"
{ yyval.L = JoinLists(GrabPragmas(yyvsp[-1].L), yyvsp[0].L); }
    break;
case 339:
#line 1541 "ANSI-C.y"
{
              if (yydebug)
                {
                  printf("external.definition # declaration\n");
                  PrintNode(stdout, FirstItem(yyvsp[0].L), 0); 
                  printf("\n\n\n");
		}
              yyval.L = yyvsp[0].L;
            }
    break;
case 340:
#line 1551 "ANSI-C.y"
{ 
              if (yydebug)
                {
                  printf("external.definition # function.definition\n");
                  PrintNode(stdout, yyvsp[0].n, 0); 
                  printf("\n\n\n");
                }
              yyval.L = MakeNewList(yyvsp[0].n); 
            }
    break;
case 341:
#line 1564 "ANSI-C.y"
{ 
	      Node *decl;
	      decl = SetDeclType(yyvsp[0].n,
				       MakeDefaultPrimType(EMPTY_TQ, 
							   yyvsp[0].n->coord),
				       Redecl);
	      newfunc(decl);
              yyvsp[0].n = DefineProc(FALSE, decl);
            }
    break;
case 342:
#line 1574 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-2].n, yyvsp[0].n); }
    break;
case 344:
#line 1580 "ANSI-C.y"
{ 
	      Node *decl;
	      decl = SetDeclType(yyvsp[0].n, yyvsp[-1].n, Redecl);
	      newfunc(decl);
	      yyvsp[0].n = DefineProc(FALSE, decl); 
	    }
    break;
case 345:
#line 1587 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-2].n, yyvsp[0].n); }
    break;
case 346:
#line 1589 "ANSI-C.y"
{ 
	      Node *decl;
	      decl = SetDeclType(yyvsp[0].n, yyvsp[-1].n, Redecl);
	      newfunc(decl);
	      yyvsp[0].n = DefineProc(FALSE, decl); 
	    }
    break;
case 347:
#line 1596 "ANSI-C.y"
{ 
	      endfunc(yyvsp[0].n);
	      yyval.n = SetProcBody(yyvsp[-2].n, yyvsp[0].n); 
	    }
    break;
case 348:
#line 1601 "ANSI-C.y"
{ 
	      Node *decl;
	      decl = SetDeclType(yyvsp[0].n,
				       MakeDefaultPrimType(yyvsp[-1].tq.tq, yyvsp[-1].tq.coord),
				       Redecl);
	      newfunc(decl);
              yyvsp[0].n = DefineProc(FALSE, decl);
            }
    break;
case 349:
#line 1610 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-2].n, yyvsp[0].n); }
    break;
case 350:
#line 1612 "ANSI-C.y"
{ 
	      Node *decl;
	      decl = SetDeclType(yyvsp[0].n,
				       MakeDefaultPrimType(yyvsp[-1].tq.tq, yyvsp[-1].tq.coord),
				       Redecl);
	      newfunc(decl);
              yyvsp[0].n = DefineProc(FALSE, decl);
            }
    break;
case 351:
#line 1621 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-2].n, yyvsp[0].n); }
    break;
case 352:
#line 1623 "ANSI-C.y"
{ 
	      Node *decl;
	      decl = SetDeclType(yyvsp[0].n,
				       MakeDefaultPrimType(EMPTY_TQ, 
							   yyvsp[0].n->coord),
				       Redecl);
	      newfunc(decl);
              yyvsp[0].n = DefineProc(TRUE, decl);
            }
    break;
case 353:
#line 1633 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-2].n, yyvsp[0].n); }
    break;
case 354:
#line 1635 "ANSI-C.y"
{
	       Node *decl;
	       decl = SetDeclType(yyvsp[0].n, yyvsp[-1].n, Redecl);  
	       newfunc(decl);

               AddParameterTypes(decl, NULL);
               yyvsp[0].n = DefineProc(TRUE, decl);
            }
    break;
case 355:
#line 1644 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-2].n, yyvsp[0].n); }
    break;
case 356:
#line 1646 "ANSI-C.y"
{
	      Node *decl;
	      decl = SetDeclType(yyvsp[0].n, yyvsp[-1].n, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, NULL);
              yyvsp[0].n = DefineProc(TRUE, decl);
            }
    break;
case 357:
#line 1655 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-2].n, yyvsp[0].n); }
    break;
case 358:
#line 1657 "ANSI-C.y"
{
	      Node *type, *decl;
	      type == MakeDefaultPrimType(yyvsp[-1].tq.tq, yyvsp[-1].tq.coord);
              decl = SetDeclType(yyvsp[0].n, type, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, NULL);
              yyvsp[0].n = DefineProc(TRUE, decl);
            }
    break;
case 359:
#line 1667 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-2].n, yyvsp[0].n); }
    break;
case 360:
#line 1669 "ANSI-C.y"
{
	      Node *type, *decl;
	      type = MakeDefaultPrimType(yyvsp[-1].tq.tq, yyvsp[-1].tq.coord);
	      decl = SetDeclType(yyvsp[0].n, type, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, NULL);
              yyvsp[0].n = DefineProc(TRUE, decl);
            }
    break;
case 361:
#line 1679 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-2].n, yyvsp[0].n); }
    break;
case 362:
#line 1681 "ANSI-C.y"
{
	      Node *type, *decl;
	      type = MakeDefaultPrimType(EMPTY_TQ, yyvsp[-1].n->coord);
	      decl = SetDeclType(yyvsp[-1].n, type, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, yyvsp[0].L);
              yyvsp[-1].n = DefineProc(TRUE, decl);
            }
    break;
case 363:
#line 1691 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-3].n, yyvsp[0].n); }
    break;
case 364:
#line 1693 "ANSI-C.y"
{
	      Node *decl;
	      decl = SetDeclType(yyvsp[-1].n, yyvsp[-2].n, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, yyvsp[0].L);
              yyvsp[-1].n = DefineProc(TRUE, decl);
            }
    break;
case 365:
#line 1702 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-3].n, yyvsp[0].n); }
    break;
case 366:
#line 1704 "ANSI-C.y"
{
	      Node *decl;
	      decl = SetDeclType(yyvsp[-1].n, yyvsp[-2].n, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, yyvsp[0].L);
              yyvsp[-1].n = DefineProc(TRUE, decl);
            }
    break;
case 367:
#line 1713 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-3].n, yyvsp[0].n); }
    break;
case 368:
#line 1715 "ANSI-C.y"
{
	      Node *type, *decl;
	      type = MakeDefaultPrimType(yyvsp[-2].tq.tq, yyvsp[-2].tq.coord);
	      decl = SetDeclType(yyvsp[-1].n, type, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, yyvsp[0].L);
              yyvsp[-1].n = DefineProc(TRUE, decl);
            }
    break;
case 369:
#line 1725 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-3].n, yyvsp[0].n); }
    break;
case 370:
#line 1727 "ANSI-C.y"
{
	      Node *type, *decl;
	      type = MakeDefaultPrimType(yyvsp[-2].tq.tq, yyvsp[-2].tq.coord);
	      decl = SetDeclType(yyvsp[-1].n, type, Redecl);
	      newfunc(decl);
   

              AddParameterTypes(decl, yyvsp[0].L);
              yyvsp[-1].n = DefineProc(TRUE, decl);
            }
    break;
case 371:
#line 1738 "ANSI-C.y"
{ yyval.n = SetProcBody(yyvsp[-3].n, yyvsp[0].n); }
    break;
case 372:
#line 1743 "ANSI-C.y"
{ OldStyleFunctionDefinition = TRUE; }
    break;
case 373:
#line 1745 "ANSI-C.y"
{ OldStyleFunctionDefinition = FALSE; 
               yyval.L = yyvsp[0].L; }
    break;
case 374:
#line 1760 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; checkconst(yyvsp[0].n);}
    break;
case 375:
#line 1761 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; checkconst(yyvsp[0].n);}
    break;
case 376:
#line 1762 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; checkconst(yyvsp[0].n);}
    break;
case 377:
#line 1763 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; checkconst(yyvsp[0].n);}
    break;
case 378:
#line 1764 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; checkconst(yyvsp[0].n);}
    break;
case 379:
#line 1769 "ANSI-C.y"
{ yyval.n = yyvsp[0].n; }
    break;
case 380:
#line 1771 "ANSI-C.y"
{ const char *first_text  = yyvsp[-1].n->u.Const.text;
              const char *second_text = yyvsp[0].n->u.Const.text;
              int   length = strlen(first_text) + strlen(second_text) + 1;
              char *buffer = HeapNewArray(char, length);
              char *new_text, *new_val;
	
              /* since text (which includes quotes and escape codes)
		 is always longer than value, it's safe to use buffer
		 to concat both */
              strcpy(buffer, NodeConstantStringValue(yyvsp[-1].n));
	      strcat(buffer, NodeConstantStringValue(yyvsp[0].n));
              new_val = UniqueString(buffer);

              strcpy(buffer, first_text);
	      strcat(buffer, second_text);
              new_text = buffer;
              yyval.n = MakeStringTextCoord(new_text, new_val, yyvsp[-1].n->coord);
	     }
    break;
case 381:
#line 1792 "ANSI-C.y"
{ yyval.tq.tq = T_CONST;    yyval.tq.coord = yyvsp[0].tok; }
    break;
case 382:
#line 1793 "ANSI-C.y"
{ yyval.tq.tq = T_VOLATILE; yyval.tq.coord = yyvsp[0].tok; }
    break;
case 383:
#line 1794 "ANSI-C.y"
{ yyval.tq.tq = T_INLINE;   yyval.tq.coord = yyvsp[0].tok; }
    break;
case 384:
#line 1798 "ANSI-C.y"
{ yyval.tq.tq = T_CONST;    yyval.tq.coord = yyvsp[0].tok; }
    break;
case 385:
#line 1799 "ANSI-C.y"
{ yyval.tq.tq = T_VOLATILE; yyval.tq.coord = yyvsp[0].tok; }
    break;
case 386:
#line 1803 "ANSI-C.y"
{ yyval.tq.tq = T_TYPEDEF;  yyval.tq.coord = yyvsp[0].tok; }
    break;
case 387:
#line 1804 "ANSI-C.y"
{ yyval.tq.tq = T_EXTERN;   yyval.tq.coord = yyvsp[0].tok; }
    break;
case 388:
#line 1805 "ANSI-C.y"
{ yyval.tq.tq = T_STATIC;   yyval.tq.coord = yyvsp[0].tok; }
    break;
case 389:
#line 1806 "ANSI-C.y"
{ yyval.tq.tq = T_AUTO;     yyval.tq.coord = yyvsp[0].tok; }
    break;
case 390:
#line 1807 "ANSI-C.y"
{ yyval.tq.tq = T_REGISTER; yyval.tq.coord = yyvsp[0].tok; }
    break;
case 391:
#line 1811 "ANSI-C.y"
{ yyval.n = StartPrimType(Void, yyvsp[0].tok);    }
    break;
case 392:
#line 1812 "ANSI-C.y"
{ yyval.n = StartPrimType(Char, yyvsp[0].tok);  checktype(Char, "char");   }
    break;
case 393:
#line 1813 "ANSI-C.y"
{ yyval.n = StartPrimType(Int_ParseOnly, yyvsp[0].tok);     }
    break;
case 394:
#line 1814 "ANSI-C.y"
{ yyval.n = StartPrimType(Float, yyvsp[0].tok); checktype(Float, "float");  }
    break;
case 395:
#line 1815 "ANSI-C.y"
{ yyval.n = StartPrimType(Double, yyvsp[0].tok);  checktype(Double, "double"); }
    break;
case 396:
#line 1817 "ANSI-C.y"
{ yyval.n = StartPrimType(Signed, yyvsp[0].tok);   }
    break;
case 397:
#line 1818 "ANSI-C.y"
{ yyval.n = StartPrimType(Unsigned, yyvsp[0].tok); checktype(Unsigned, "unsigned"); }
    break;
case 398:
#line 1820 "ANSI-C.y"
{ yyval.n = StartPrimType(Short, yyvsp[0].tok);  checktype(Short, "short"); }
    break;
case 399:
#line 1821 "ANSI-C.y"
{ yyval.n = StartPrimType(Long, yyvsp[0].tok); }
    break;
}

#line 705 "/usr/share/bison/bison.simple"


  yyvsp -= yylen;
  yyssp -= yylen;
#if YYLSP_NEEDED
  yylsp -= yylen;
#endif

#if YYDEBUG
  if (yydebug)
    {
      short *yyssp1 = yyss - 1;
      YYFPRINTF (stderr, "state stack now");
      while (yyssp1 != yyssp)
	YYFPRINTF (stderr, " %d", *++yyssp1);
      YYFPRINTF (stderr, "\n");
    }
#endif

  *++yyvsp = yyval;
#if YYLSP_NEEDED
  *++yylsp = yyloc;
#endif

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTBASE] + *yyssp;
  if (yystate >= 0 && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTBASE];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;

#ifdef YYERROR_VERBOSE
      yyn = yypact[yystate];

      if (yyn > YYFLAG && yyn < YYLAST)
	{
	  YYSIZE_T yysize = 0;
	  char *yymsg;
	  int yyx, yycount;

	  yycount = 0;
	  /* Start YYX at -YYN if negative to avoid negative indexes in
	     YYCHECK.  */
	  for (yyx = yyn < 0 ? -yyn : 0;
	       yyx < (int) (sizeof (yytname) / sizeof (char *)); yyx++)
	    if (yycheck[yyx + yyn] == yyx)
	      yysize += yystrlen (yytname[yyx]) + 15, yycount++;
	  yysize += yystrlen ("parse error, unexpected ") + 1;
	  yysize += yystrlen (yytname[YYTRANSLATE (yychar)]);
	  yymsg = (char *) YYSTACK_ALLOC (yysize);
	  if (yymsg != 0)
	    {
	      char *yyp = yystpcpy (yymsg, "parse error, unexpected ");
	      yyp = yystpcpy (yyp, yytname[YYTRANSLATE (yychar)]);

	      if (yycount < 5)
		{
		  yycount = 0;
		  for (yyx = yyn < 0 ? -yyn : 0;
		       yyx < (int) (sizeof (yytname) / sizeof (char *));
		       yyx++)
		    if (yycheck[yyx + yyn] == yyx)
		      {
			const char *yyq = ! yycount ? ", expecting " : " or ";
			yyp = yystpcpy (yyp, yyq);
			yyp = yystpcpy (yyp, yytname[yyx]);
			yycount++;
		      }
		}
	      yyerror (yymsg);
	      YYSTACK_FREE (yymsg);
	    }
	  else
	    yyerror ("parse error; also virtual memory exhausted");
	}
      else
#endif /* defined (YYERROR_VERBOSE) */
	yyerror ("parse error");
    }
  goto yyerrlab1;


/*--------------------------------------------------.
| yyerrlab1 -- error raised explicitly by an action |
`--------------------------------------------------*/
yyerrlab1:
  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      /* return failure if at end of input */
      if (yychar == YYEOF)
	YYABORT;
      YYDPRINTF ((stderr, "Discarding token %d (%s).\n",
		  yychar, yytname[yychar1]));
      yychar = YYEMPTY;
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */

  yyerrstatus = 3;		/* Each real token shifted decrements this */

  goto yyerrhandle;


/*-------------------------------------------------------------------.
| yyerrdefault -- current state does not do anything special for the |
| error token.                                                       |
`-------------------------------------------------------------------*/
yyerrdefault:
#if 0
  /* This is wrong; only states that explicitly want error tokens
     should shift them.  */

  /* If its default is to accept any token, ok.  Otherwise pop it.  */
  yyn = yydefact[yystate];
  if (yyn)
    goto yydefault;
#endif


/*---------------------------------------------------------------.
| yyerrpop -- pop the current state because it cannot handle the |
| error token                                                    |
`---------------------------------------------------------------*/
yyerrpop:
  if (yyssp == yyss)
    YYABORT;
  yyvsp--;
  yystate = *--yyssp;
#if YYLSP_NEEDED
  yylsp--;
#endif

#if YYDEBUG
  if (yydebug)
    {
      short *yyssp1 = yyss - 1;
      YYFPRINTF (stderr, "Error: state stack now");
      while (yyssp1 != yyssp)
	YYFPRINTF (stderr, " %d", *++yyssp1);
      YYFPRINTF (stderr, "\n");
    }
#endif

/*--------------.
| yyerrhandle.  |
`--------------*/
yyerrhandle:
  yyn = yypact[yystate];
  if (yyn == YYFLAG)
    goto yyerrdefault;

  yyn += YYTERROR;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != YYTERROR)
    goto yyerrdefault;

  yyn = yytable[yyn];
  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrpop;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrpop;

  if (yyn == YYFINAL)
    YYACCEPT;

  YYDPRINTF ((stderr, "Shifting error token, "));

  *++yyvsp = yylval;
#if YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

/*---------------------------------------------.
| yyoverflowab -- parser overflow comes here.  |
`---------------------------------------------*/
yyoverflowlab:
  yyerror ("parser stack overflow");
  yyresult = 2;
  /* Fall through.  */

yyreturn:
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
  return yyresult;
}
#line 1824 "ANSI-C.y"

/* ----end of grammar----*/


PRIVATE void WarnAboutPrecedence(OpType op, Node *node)
{
  if (node->typ == Binop && !node->parenthesized) {
    OpType subop = node->u.binop.op;

    if (op == OROR && subop == ANDAND)
      WarningCoord(4, node->coord, "suggest parentheses around && in operand of ||");
    else if ((op == '|' || op == '^') && 
	     (subop == '+' || subop == '-' || subop == '&' || subop == '^') &&
	     op != subop)
      WarningCoord(4, node->coord, "suggest parentheses around arithmetic in operand of %c", op);
  }
}


