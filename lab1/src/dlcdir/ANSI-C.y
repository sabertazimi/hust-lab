%{

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




%}

/* This refined grammar resolves several typedef ambiguities  in  the 
draft  proposed  ANSI  C  standard  syntax  down  to  1  shift/reduce 
conflict, as reported by a YACC process.  Note  that  the  one  shift 
reduce  conflicts  is the traditional if-if-else conflict that is not 
resolved by the grammar.  This ambiguity can  be  removed  using  the 
method  described in the Dragon Book (2nd edition), but this does not 
appear worth the effort.

There was quite a bit of effort made to reduce the conflicts to  this 
level,  and  an  additional effort was made to make the grammar quite 
similar to the C++ grammar being developed in  parallel.   Note  that 
this grammar resolves the following ANSI C ambiguity as follows:

ANSI  C  section  3.5.6,  "If  the [typedef name] is redeclared at an 
inner scope, the type specifiers shall not be omitted  in  the  inner 
declaration".   Supplying type specifiers prevents consideration of T 
as a typedef name in this grammar.  Failure to supply type specifiers 
forced the use of the TYPEDEFname as a type specifier.
              
ANSI C section 3.5.4.3, "In a parameter declaration, a single typedef 
name in parentheses is  taken  to  be  an  abstract  declarator  that 
specifies  a  function  with  a  single  parameter,  not as redundant 
parentheses around the identifier".  This is extended  to  cover  the 
following cases:

typedef float T;
int noo(const (T[5]));
int moo(const (T(int)));
...

Where  again the '(' immediately to the left of 'T' is interpreted as 
being the start of a parameter type list,  and  not  as  a  redundant 
paren around a redeclaration of T.  Hence an equivalent code fragment 
is:

typedef float T;
int noo(const int identifier1 (T identifier2 [5]));
int moo(const int identifier1 (T identifier2 (int identifier3)));
...

*/


%union {
    Node      *n;
    List      *L;

  /* tq: type qualifiers */
    struct {
        TypeQual   tq;
	Coord      coord;   /* coordinates where type quals began */ 
    } tq;

  /* tok: token coordinates */
    Coord tok;
}



/* Define terminal tokens */

%token <tok> '&' '*' '+' '-' '~' '!'
%token <tok> '<' '>' '|' '^' '%' '/' '(' ')' '.' '?' ';'

%token <tok> '{' '}' ',' '[' ']' ':'

/* ANSI keywords, extensions below */
%token <tok> AUTO            DOUBLE          INT             STRUCT
%token <tok> BREAK           ELSE            LONG            SWITCH
%token <tok> CASE            ENUM            REGISTER        TYPEDEF
%token <tok> CHAR            EXTERN          RETURN          UNION
%token <tok> CONST           FLOAT           SHORT           UNSIGNED
%token <tok> CONTINUE        FOR             SIGNED          VOID
%token <tok> DEFAULT         GOTO            SIZEOF          VOLATILE
%token <tok> DO              IF              STATIC          WHILE

/* unary op tokens added by Eric Brewer */

%token <tok> UPLUS UMINUS INDIR ADDRESS POSTINC POSTDEC PREINC PREDEC BOGUS


/* ANSI Grammar suggestions */
%token <n> IDENTIFIER STRINGliteral
%token <n> FLOATINGconstant
%token <n> INTEGERconstant OCTALconstant HEXconstant WIDECHARconstant
%token <n> CHARACTERconstant

/* New Lexical element, whereas ANSI suggested non-terminal */

/* 
   Lexer distinguishes this from an identifier.
   An identifier that is CURRENTLY in scope as a typedef name is provided
   to the parser as a TYPEDEFname
*/
%token <n> TYPEDEFname 

/* Multi-Character operators */
%token <tok>  ARROW            /*    ->                              */
%token <tok>  ICR DECR         /*    ++      --                      */
%token <tok>  LS RS            /*    <<      >>                      */
%token <tok>  LE GE EQ NE      /*    <=      >=      ==      !=      */
%token <tok>  ANDAND OROR      /*    &&      ||                      */
%token <tok>  ELLIPSIS         /*    ...                             */

/* modifying assignment operators */
%token <tok> '='
%token <tok> MULTassign  DIVassign    MODassign   /*   *=      /=      %=      */
%token <tok> PLUSassign  MINUSassign              /*   +=      -=              */
%token <tok> LSassign    RSassign                 /*   <<=     >>=             */
%token <tok> ANDassign   ERassign     ORassign    /*   &=      ^=      |=      */

/* GCC extensions */
%token <tok> INLINE
%token <tok> ATTRIBUTE

%type <tok> lblock rblock

%type <L> translation.unit external.definition 
%type <n> function.definition

%type <n> constant string.literal.list
%type <n> primary.expression postfix.expression unary.expression
%type <n> cast.expression multiplicative.expression additive.expression
%type <n> shift.expression relational.expression equality.expression
%type <n> AND.expression exclusive.OR.expression inclusive.OR.expression
%type <n> logical.AND.expression logical.OR.expression conditional.expression
%type <n> assignment.expression constant.expression expression.opt
%type <L> attributes.opt attributes attribute attribute.list
%type <n> attrib any.word

%type <n> initializer.opt initializer initializer.list
%type <n> bit.field.size.opt bit.field.size enumerator.value.opt

%type <n> statement labeled.statement expression.statement
%type <n> selection.statement iteration.statement jump.statement
%type <n> compound.statement compound.statement.no.new.scope

%type <n> basic.declaration.specifier basic.type.specifier
%type <n> type.name expression type.specifier declaration.specifier
%type <n> typedef.declaration.specifier typedef.type.specifier
%type <n> abstract.declarator unary.abstract.declarator
%type <n> postfixing.abstract.declarator array.abstract.declarator
%type <n> postfix.abstract.declarator old.function.declarator
%type <n> struct.or.union.specifier struct.or.union elaborated.type.name
%type <n> sue.type.specifier sue.declaration.specifier enum.specifier

%type <n> parameter.declaration
%type <n> identifier.declarator parameter.typedef.declarator
%type <n> declarator paren.typedef.declarator
%type <n> clean.typedef.declarator simple.paren.typedef.declarator
%type <n> unary.identifier.declarator paren.identifier.declarator
%type <n> postfix.identifier.declarator clean.postfix.typedef.declarator
%type <n> paren.postfix.typedef.declarator postfix.old.function.declarator
%type <n> struct.identifier.declarator struct.declarator

%type <L> declaration declaration.list declaring.list default.declaring.list
%type <L> argument.expression.list identifier.list statement.list
%type <L> parameter.type.list parameter.list
%type <L> struct.declaration.list struct.declaration struct.declaring.list
%type <L> struct.default.declaring.list enumerator.list
%type <L> old.function.declaration.list

%type <n> unary.operator assignment.operator
%type <n> identifier.or.typedef.name

%type <tq> type.qualifier type.qualifier.list declaration.qualifier.list
%type <tq> declaration.qualifier storage.class
%type <tq> pointer.type.qualifier pointer.type.qualifier.list

%type <n>  basic.type.name

%start prog.start

%%
prog.start: /*P*/
          translation.unit { Program = GrabPragmas($1); }
        ;

/********************************************************************************
*										*
*                                EXPRESSIONS                                    *
*										*
********************************************************************************/

primary.expression:             /* P */ /* 6.3.1 EXTENDED */  
          /* A typedef name cannot be used as a variable.  Fill in type later */
          IDENTIFIER           { $$ = $1; }
        | constant
        | string.literal.list
        | '(' expression ')'    { if ($2->typ == Comma) $2->coord = $1;
                                  $2->parenthesized = TRUE;
                                  $$ = $2; }

          /* GCC-inspired non ANSI-C extension */
        | '(' lblock statement.list rblock ')'
            { if (ANSIOnly)
	         SyntaxError("statement expressions not allowed with -ansi switch");
               $$ = MakeBlockCoord(NULL, NULL, GrabPragmas($3), $1, $4); }
        | '(' lblock declaration.list statement.list rblock ')'
            { if (ANSIOnly)
	         SyntaxError("statement expressions not allowed with -ansi switch");
              $$ = MakeBlockCoord(NULL, $3, GrabPragmas($4), $1, $5); }
        ;

postfix.expression:             /* P */ /* 6.3.2 CLARIFICATION */
          primary.expression
        | postfix.expression '[' expression ']'
            { $$ = ExtendArray($1, $3, $2); arrayop();}
        | postfix.expression '(' ')'
            { $$ = MakeCallCoord($1, NULL, $2); funccall($1);}
        | postfix.expression '(' argument.expression.list ')'
            { $$ = MakeCallCoord($1, $3, $2); funccall($1);}
        | postfix.expression '.' IDENTIFIER
            { $$ = MakeBinopCoord('.', $1, $3, $2); checkop('.');}
        | postfix.expression ARROW IDENTIFIER
            { $$ = MakeBinopCoord(ARROW, $1, $3, $2); checkop(ARROW);}
        | postfix.expression ICR
            { $$ = MakeUnaryCoord(POSTINC, $1, $2); checkop(POSTINC);}
        | postfix.expression DECR
            { $$ = MakeUnaryCoord(POSTDEC, $1, $2); checkop(POSTDEC);}

          /* EXTENSION: TYPEDEFname can be used to name a struct/union field */
        | postfix.expression '.'   TYPEDEFname
            { $$ = MakeBinopCoord('.', $1, $3, $2); checkop('.');}
        | postfix.expression ARROW TYPEDEFname
            { $$ = MakeBinopCoord(ARROW, $1, $3, $2); checkop(ARROW);}
        ;

argument.expression.list:       /* P */ /* 6.3.2 */
          assignment.expression
            { $$ = MakeNewList($1); }
        | argument.expression.list ',' assignment.expression
            { $$ = AppendItem($1, $3); }
        ;

unary.expression:               /* P */ /* 6.3.3 */
          postfix.expression
            { $$ = LookupPostfixExpression($1); }
        | ICR unary.expression
            { $$ = MakeUnaryCoord(PREINC, $2, $1); }
        | DECR unary.expression
            { $$ = MakeUnaryCoord(PREDEC, $2, $1); }
        | unary.operator cast.expression
            { $1->u.unary.expr = $2;
              $$ = $1; }
        | SIZEOF unary.expression
            { $$ = MakeUnaryCoord(SIZEOF, $2, $1); checkstmt("sizeof");}
        | SIZEOF '(' type.name ')'
            { $$ = MakeUnaryCoord(SIZEOF, $3, $1); checkstmt("sizeof");}
        ;

unary.operator:                 /* P */ /* 6.3.3 */
          '&'     { $$ = MakeUnaryCoord('&', NULL, $1); checkop('&');}
        | '*'     { $$ = MakeUnaryCoord('*', NULL, $1); checkop('*');}
        | '+'     { $$ = MakeUnaryCoord('+', NULL, $1); checkop('+');}
        | '-'     { $$ = MakeUnaryCoord('-', NULL, $1); checkop('-');}
        | '~'     { $$ = MakeUnaryCoord('~', NULL, $1); checkop('~');}
        | '!'     { $$ = MakeUnaryCoord('!', NULL, $1); checkop('!');}
        ;

cast.expression:                /* P */ /* 6.3.4 */
          unary.expression
        | '(' type.name ')' cast.expression  { 
	  $$ = MakeCastCoord($2, $4, $1); castwarning(); }
        ;

multiplicative.expression:      /* P */ /* 6.3.5 */
          cast.expression
        | multiplicative.expression '*' cast.expression
            { $$ = MakeBinopCoord('*', $1, $3, $2); checkop('*');}
        | multiplicative.expression '/' cast.expression
            { $$ = MakeBinopCoord('/', $1, $3, $2); checkop('/');}
        | multiplicative.expression '%' cast.expression
            { $$ = MakeBinopCoord('%', $1, $3, $2); checkop('%');}
        ;

additive.expression:            /* P */ /* 6.3.6 */
          multiplicative.expression
        | additive.expression '+' multiplicative.expression
            { $$ = MakeBinopCoord('+', $1, $3, $2); checkop('+');}
        | additive.expression '-' multiplicative.expression
            { $$ = MakeBinopCoord('-', $1, $3, $2); checkop('-');}
        ;

shift.expression:               /* P */ /* 6.3.7 */
          additive.expression
        | shift.expression LS additive.expression
            { $$ = MakeBinopCoord(LS, $1, $3, $2); checkop(LS);}
        | shift.expression RS additive.expression
            { $$ = MakeBinopCoord(RS, $1, $3, $2); checkop(RS);}
        ;

relational.expression:          /* P */ /* 6.3.8 */
          shift.expression
        | relational.expression '<' shift.expression
            { $$ = MakeBinopCoord('<', $1, $3, $2); checkop('<');}
        | relational.expression '>' shift.expression
            { $$ = MakeBinopCoord('>', $1, $3, $2); checkop('>');}
        | relational.expression LE shift.expression
            { $$ = MakeBinopCoord(LE, $1, $3, $2); checkop(LE);}
        | relational.expression GE shift.expression
            { $$ = MakeBinopCoord(GE, $1, $3, $2); checkop(GE);}
        ;

equality.expression:            /* P */ /* 6.3.9 */
          relational.expression
        | equality.expression EQ relational.expression
            { $$ = MakeBinopCoord(EQ, $1, $3, $2); checkop(EQ);}
        | equality.expression NE relational.expression
            { $$ = MakeBinopCoord(NE, $1, $3, $2); checkop(NE);}
        ;

AND.expression:                 /* P */ /* 6.3.10 */
          equality.expression
        | AND.expression '&' equality.expression
            { $$ = MakeBinopCoord('&', $1, $3, $2); checkop('&');}
        ;

exclusive.OR.expression:        /* P */ /* 6.3.11 */
          AND.expression
        | exclusive.OR.expression '^' AND.expression
            { 
	      checkop('^');
              WarnAboutPrecedence('^', $1);
              WarnAboutPrecedence('^', $3);
	      $$ = MakeBinopCoord('^', $1, $3, $2); }
        ;

inclusive.OR.expression:        /* P */ /* 6.3.12 */
          exclusive.OR.expression
        | inclusive.OR.expression '|' exclusive.OR.expression
            { 
	      checkop('|');
	      WarnAboutPrecedence('|', $1);
              WarnAboutPrecedence('|', $3);
              $$ = MakeBinopCoord('|', $1, $3, $2); }
        ;

logical.AND.expression:         /* P */ /* 6.3.13 */
          inclusive.OR.expression
        | logical.AND.expression ANDAND inclusive.OR.expression
            { $$ = MakeBinopCoord(ANDAND, $1, $3, $2); checkop(ANDAND);}
        ;

logical.OR.expression:          /* P */ /* 6.3.14 */
          logical.AND.expression
        | logical.OR.expression OROR logical.AND.expression
            { 
	      checkop(OROR);
	      WarnAboutPrecedence(OROR, $1);
              WarnAboutPrecedence(OROR, $3);
              $$ = MakeBinopCoord(OROR, $1, $3, $2); }
        ;

conditional.expression:         /* P */ /* 6.3.15 */
          logical.OR.expression
        | logical.OR.expression '?' expression ':' conditional.expression
            { 
	      $$ = MakeTernaryCoord($1, $3, $5, $2, $4); 
	      checkstmt("ternary if");
	    }
        ;

assignment.expression:          /* P */ /* 6.3.16 */
          conditional.expression
        | unary.expression assignment.operator assignment.expression
            { $2->u.binop.left = $1;
              $2->u.binop.right = $3;
              $$ = $2; }
        ;

assignment.operator:            /* P */ /* 6.3.16 */
          '='             { $$ = MakeBinopCoord('=', NULL, NULL, $1); }
        | MULTassign      { $$ = MakeBinopCoord(MULTassign, NULL, NULL, $1); 
	checkop('*');}
        | DIVassign       { $$ = MakeBinopCoord(DIVassign, NULL, NULL, $1); 
	checkop('/');}
        | MODassign       { $$ = MakeBinopCoord(MODassign, NULL, NULL, $1); 
	checkop('%');}  
        | PLUSassign      { $$ = MakeBinopCoord(PLUSassign, NULL, NULL, $1); 
	checkop('+');}
        | MINUSassign     { $$ = MakeBinopCoord(MINUSassign, NULL, NULL, $1); 
	checkop('-');}
        | LSassign        { $$ = MakeBinopCoord(LSassign, NULL, NULL, $1);    
	checkop(LS);}
        | RSassign        { $$ = MakeBinopCoord(RSassign, NULL, NULL, $1);    
	checkop(RS);}
        | ANDassign       { $$ = MakeBinopCoord(ANDassign, NULL, NULL, $1);   
	checkop('&');}
        | ERassign        { $$ = MakeBinopCoord(ERassign, NULL, NULL, $1);    
	checkop('^');}
        | ORassign        { $$ = MakeBinopCoord(ORassign, NULL, NULL, $1);    
	checkop('|');}
        ;

expression:                     /* P */ /* 6.3.17 */
          assignment.expression
        | expression ',' assignment.expression
            {  
              if ($1->typ == Comma) 
                {
		  AppendItem($1->u.comma.exprs, $3);
		  $$ = $1;
		}
              else
                {
		  $$ = MakeCommaCoord(AppendItem(MakeNewList($1), $3), $1->coord);
		}
	    }
        ;

constant.expression:            /* P */ /* 6.4   */
          conditional.expression { $$ = $1; }
        ;

expression.opt:                 /* P */ /* For convenience */
          /* Nothing */   { $$ = (Node *) NULL; }
        | expression      { $$ = $1; }
        ;

/********************************************************************************
*										*
*                               DECLARATIONS					*
*										*
*    The following is different from the ANSI C specified grammar.  The changes *
* were made to disambiguate typedef's presence in declaration.specifiers        *
* (vs. in the declarator for redefinition) to allow struct/union/enum tag       *
* declarations without declarators, and to better reflect the parsing of        *
* declarations (declarators must be combined with declaration.specifiers ASAP   *
* so that they are visible in scope).					        *
*										*
* Example of typedef use as either a declaration.specifier or a declarator:	*
*										*
*   typedef int T;								*
*   struct S { T T; }; / * redefinition of T as member name * /			*
*										*
* Example of legal and illegal statements detected by this grammar:		*
*										*
*   int;              / * syntax error: vacuous declaration      * /		*
*   struct S;         / * no error: tag is defined or elaborated * /		*
*										*
* Example of result of proper declaration binding:				*
*										*
*   /* Declare "a" with a type in the name space BEFORE parsing initializer * / *
*   int a = sizeof(a);								*
*										*
*   /* Declare "b" with a type before parsing "c" * /				*
*   int b, c[sizeof(b)];							*
*										*
********************************************************************************/

/*                        */    /* ? */ /* ?.?.? */
declaration: /*P*/
          declaring.list ';'
            { $$ = $1; }
        | default.declaring.list ';'
            { $$ = $1; }
        | sue.declaration.specifier ';'
            { $$ = MakeNewList(ForceNewSU($1, $2)); }
        | sue.type.specifier ';'
            { $$ = MakeNewList(ForceNewSU($1, $2)); }
        ;

/*                        */    /* ? */ /* ?.?.? */
declaring.list: /*P*/
          declaration.specifier declarator
            { 
	      SetDeclType($2, $1, Redecl);
	    }
          attributes.opt { SetDeclAttribs($2, $4); }
          initializer.opt
            { 
              $$ = MakeNewList(SetDeclInit($2, $6)); 
            }
        | type.specifier declarator 
            { 
              SetDeclType($2, $1, Redecl);
            }
          attributes.opt { SetDeclAttribs($2, $4); }
          initializer.opt
            { 
              $$ = MakeNewList(SetDeclInit($2, $6)); 
	    }
        | declaring.list ',' declarator
            { 
	      $$ = AppendDecl($1, $3, Redecl);
	    }
          attributes.opt { SetDeclAttribs($3, $5); }
          initializer.opt
            { 
              SetDeclInit($3, $7); 
            }


        /******** ERROR PRODUCTIONS ********/
        | /* error production: catch missing identifier */
          declaration.specifier error
            { 
              SyntaxError("declaration without a variable"); 
            }
          attributes.opt
          initializer.opt
            { 
              $$ = NULL; /* empty list */ 
            }
        | /* error production: catch missing identifier */
          type.specifier error
            { 
              SyntaxError("declaration without a variable"); 
            }
          attributes.opt
          initializer.opt
            { 
              $$ = NULL; /* empty list */ 
            }
        | declaring.list ',' error
        ;

/*                        */    /* ? */ /* ?.?.? */
/* Note that if a typedef were redeclared, then a decl-spec must be supplied */
default.declaring.list:  /*P*/ /* Can't  redeclare typedef names */
          declaration.qualifier.list identifier.declarator
            { 
              SetDeclType($2, MakeDefaultPrimType($1.tq, $1.coord), NoRedecl);
            }
          attributes.opt { SetDeclAttribs($2, $4); }
	  initializer.opt
            { 
              $$ = MakeNewList(SetDeclInit($2, $6)); 
            }
        | type.qualifier.list identifier.declarator
            { 
              SetDeclType($2, MakeDefaultPrimType($1.tq, $1.coord), NoRedecl);
            }
          attributes.opt { SetDeclAttribs($2, $4); }
	  initializer.opt
            { 
              $$ = MakeNewList(SetDeclInit($2, $6)); 
	    }
        | default.declaring.list ',' identifier.declarator
            { $$ = AppendDecl($1, $3, NoRedecl); }
          attributes.opt { SetDeclAttribs($3, $5); }
	  initializer.opt
            { SetDeclInit($3, $7); }

        /********  ERROR PRODUCTIONS ********/
        | /* error production: catch missing identifier */
          declaration.qualifier.list error
            { 
              SyntaxError("declaration without a variable"); 
	    }
          attributes.opt
          initializer.opt
            { 
              $$ = NULL; /* empty list */ 
	    }
        | /* error production: catch missing identifier */
          type.qualifier.list error
            { 
              SyntaxError("declaration without a variable"); 
	    }
          attributes.opt
          initializer.opt
            { 
              $$ = NULL; /* empty list */ 
            }
        | default.declaring.list ',' error
        ;

/*                        */    /* ? */ /* ?.?.? */
declaration.specifier: /*P*/
          basic.declaration.specifier        /* Arithmetic or void */
            { $$ = FinishPrimType($1); }
        | sue.declaration.specifier          /* struct/union/enum  */
        | typedef.declaration.specifier      /* typedef            */
        ;

/*                        */    /* ? */ /* ?.?.? */
/* StorageClass + Arithmetic or void */
basic.declaration.specifier:  /*P*/
          basic.type.specifier storage.class
            { $$ = TypeQualifyNode($1, $2.tq); } 
        | declaration.qualifier.list basic.type.name
            { $$ = TypeQualifyNode($2, $1.tq); $$->coord = $1.coord; }
        | basic.declaration.specifier declaration.qualifier
            { $$ = TypeQualifyNode($1, $2.tq); }
        | basic.declaration.specifier basic.type.name
            { $$ = MergePrimTypes($1, $2); }
        ;

/*                        */    /* ? */ /* ?.?.? */
/* StorageClass + struct/union/enum */
sue.declaration.specifier: /*P*/   
          sue.type.specifier storage.class
            { $$ = TypeQualifyNode($1, $2.tq); }
        | declaration.qualifier.list elaborated.type.name
            { $$ = TypeQualifyNode($2, $1.tq); $$->coord = $1.coord; }
        | sue.declaration.specifier declaration.qualifier
            { $$ = TypeQualifyNode($1, $2.tq); }
        ;

/*                        */    /* ? */ /* ?.?.? */
/* Storage Class + typedef types */
typedef.declaration.specifier:  /*P*/      
          typedef.type.specifier storage.class
            { $$ = TypeQualifyNode($1, $2.tq); }
        | declaration.qualifier.list TYPEDEFname
            { $$ = ConvertIdToTdef($2, $1.tq, GetTypedefType($2)); $$->coord = $1.coord; }
        | typedef.declaration.specifier declaration.qualifier
            { $$ = TypeQualifyNode($1, $2.tq); }
        ;

/*                        */    /* ? */ /* ?.?.? */
/* Type qualifier AND storage class */
declaration.qualifier.list:  /*P*/
          storage.class
        | type.qualifier.list storage.class
            { $$.tq = MergeTypeQuals($1.tq, $2.tq, $2.coord);
              $$.coord = $1.coord; }
        | declaration.qualifier.list declaration.qualifier
            { $$.tq = MergeTypeQuals($1.tq, $2.tq, $2.coord);
              $$.coord = $1.coord; }
        ;

/*                        */    /* ? */ /* ?.?.? */
declaration.qualifier: /*P*/
          type.qualifier
        | storage.class
        ;

/*                        */    /* ? */ /* ?.?.? */
type.specifier: /*P*/
          basic.type.specifier               /* Arithmetic or void */
            { $$ = FinishPrimType($1); }
        | sue.type.specifier                 /* Struct/Union/Enum  */
        | typedef.type.specifier             /* Typedef            */
        ;

/*                        */    /* ? */ /* ?.?.? */
basic.type.specifier: /*P*/
          basic.type.name            /* Arithmetic or void */
        | type.qualifier.list basic.type.name
            { $$ = TypeQualifyNode($2, $1.tq); $$->coord = $1.coord; }
        | basic.type.specifier type.qualifier
            { $$ = TypeQualifyNode($1, $2.tq); }
        | basic.type.specifier basic.type.name
            { $$ = MergePrimTypes($1, $2); }
        ;

/*                        */    /* ? */ /* ?.?.? */
sue.type.specifier: /*P*/
          elaborated.type.name              /* struct/union/enum */
        | type.qualifier.list elaborated.type.name
            { $$ = TypeQualifyNode($2, $1.tq); $$->coord = $1.coord; }
        | sue.type.specifier type.qualifier
            { $$ = TypeQualifyNode($1, $2.tq); }
        ;

/*                        */    /* ? */ /* ?.?.? */
/* typedef types */
typedef.type.specifier:  /*P*/             
          TYPEDEFname
            { $$ = ConvertIdToTdef($1, EMPTY_TQ, GetTypedefType($1)); }
        | type.qualifier.list TYPEDEFname
            { $$ = ConvertIdToTdef($2, $1.tq, GetTypedefType($2)); $$->coord = $1.coord; }
        | typedef.type.specifier type.qualifier
            { $$ = TypeQualifyNode($1, $2.tq); }
        ;

/*                        */    /* ? */ /* ?.?.? */
type.qualifier.list: /*P*/
          type.qualifier
        | type.qualifier.list type.qualifier
            { $$.tq = MergeTypeQuals($1.tq, $2.tq, $2.coord);
              $$.coord = $1.coord; }
        ;

pointer.type.qualifier.list:
          pointer.type.qualifier
        | pointer.type.qualifier.list pointer.type.qualifier
            { $$.tq = MergeTypeQuals($1.tq, $2.tq, $2.coord);
              $$.coord = $1.coord; }
        ;

/*                        */    /* ? */ /* ?.?.? */
elaborated.type.name: /*P*/
          struct.or.union.specifier
        | enum.specifier
        ;

/*                        */    /* ? */ /* ?.?.? */
declarator: /*P*/
          paren.typedef.declarator       /* would be ambiguous as parameter */
        | parameter.typedef.declarator   /* not ambiguous as param          */
        | identifier.declarator
        | old.function.declarator
            {
	      Warning(2, "function prototype parameters must have types");
              $$ = AddDefaultParameterTypes($1);
            }
        ;

/*                        */    /* ? */ /* ?.?.? */
/* Redundant '(' placed immediately to the left of the TYPEDEFname  */
paren.typedef.declarator: /*P*/
          paren.postfix.typedef.declarator
        | '*' paren.typedef.declarator
            { $$ = SetDeclType($2, MakePtrCoord(EMPTY_TQ, NULL, $1), Redecl);
               }
        | '*' '(' simple.paren.typedef.declarator ')' 
            { $$ = SetDeclType($3, MakePtrCoord(EMPTY_TQ, NULL, $1), Redecl); 
               }
        | '*' pointer.type.qualifier.list '(' simple.paren.typedef.declarator ')' 
            { $$ = SetDeclType($4, MakePtrCoord(   $2.tq,    NULL, $1), Redecl);
               }
        | '*' pointer.type.qualifier.list paren.typedef.declarator
            { $$ = SetDeclType($3, MakePtrCoord(   $2.tq,    NULL, $1), Redecl); 
               }
        ;
        
/*                        */    /* ? */ /* ?.?.? */
/* Redundant '(' to left of TYPEDEFname */
paren.postfix.typedef.declarator: /*P*/ 
          '(' paren.typedef.declarator ')'
            { $$ = $2;  
              }
        | '(' simple.paren.typedef.declarator postfixing.abstract.declarator ')'
            { $$ = ModifyDeclType($2, $3); 
               }
        | '(' paren.typedef.declarator ')' postfixing.abstract.declarator
            { $$ = ModifyDeclType($2, $4); 
               }
        ;

/*                        */    /* ? */ /* ?.?.? */
simple.paren.typedef.declarator: /*P*/
          TYPEDEFname
            { $$ = ConvertIdToDecl($1, EMPTY_TQ, NULL, NULL, NULL); }
        | '(' simple.paren.typedef.declarator ')'
            { $$ = $2;  
               }
        ;

/*                        */    /* ? */ /* ?.?.? */
parameter.typedef.declarator: /*P*/
          TYPEDEFname 
            { $$ = ConvertIdToDecl($1, EMPTY_TQ, NULL, NULL, NULL); }
        | TYPEDEFname postfixing.abstract.declarator
            { $$ = ConvertIdToDecl($1, EMPTY_TQ, $2, NULL, NULL);   }
        | clean.typedef.declarator
        ;

/*
   The  following have at least one '*'. There is no (redundant) 
   '(' between the '*' and the TYPEDEFname. 
*/
/*                        */    /* ? */ /* ?.?.? */
clean.typedef.declarator: /*P*/
          clean.postfix.typedef.declarator
        | '*' parameter.typedef.declarator
            { $$ = SetDeclType($2, MakePtrCoord(EMPTY_TQ, NULL, $1), Redecl); 
               }
        | '*' pointer.type.qualifier.list parameter.typedef.declarator  
            { $$ = SetDeclType($3, MakePtrCoord($2.tq, NULL, $1), Redecl); 
               }
        ;

/*                        */    /* ? */ /* ?.?.? */
clean.postfix.typedef.declarator: /*P*/
          '(' clean.typedef.declarator ')'
            { $$ = $2; 
               }
        | '(' clean.typedef.declarator ')' postfixing.abstract.declarator
            { $$ = ModifyDeclType($2, $4); 
               }
        ;

/*                        */    /* ? */ /* ?.?.? */
abstract.declarator: /*P*/
          unary.abstract.declarator
        | postfix.abstract.declarator
        | postfixing.abstract.declarator
        ;

/*                        */    /* ? */ /* ?.?.? */
unary.abstract.declarator: /*P*/
          '*' 
            { $$ = MakePtrCoord(EMPTY_TQ, NULL, $1); }
        | '*' pointer.type.qualifier.list 
            { $$ = MakePtrCoord($2.tq, NULL, $1); }
        | '*' abstract.declarator
            { $$ = SetBaseType($2, MakePtrCoord(EMPTY_TQ, NULL, $1)); 
               }
        | '*' pointer.type.qualifier.list abstract.declarator
            { $$ = SetBaseType($3, MakePtrCoord($2.tq, NULL, $1)); 
               }
        ;

/*                        */    /* ? */ /* ?.?.? */
postfix.abstract.declarator: /*P*/
          '(' unary.abstract.declarator ')'
            { $$ = $2; 
               }
        | '(' postfix.abstract.declarator ')'
            { $$ = $2; 
               }
        | '(' postfixing.abstract.declarator ')'
            { $$ = $2; 
               }
        | '(' unary.abstract.declarator ')' postfixing.abstract.declarator
            { $$ = SetBaseType($2, $4); 
               }
        ;

/*                        */    /* ? */ /* ?.?.? */
postfixing.abstract.declarator: /*P*/
          array.abstract.declarator     { $$ = $1;                   }
        | '(' ')'                       { $$ = MakeFdclCoord(EMPTY_TQ, NULL, NULL, $1); }
        | '(' parameter.type.list ')'   { $$ = MakeFdclCoord(EMPTY_TQ, $2, NULL, $1); }
        ;

/*                        */    /* ? */ /* ?.?.? */
identifier.declarator: /*P*/
          unary.identifier.declarator
        | paren.identifier.declarator
        ;

/*                        */    /* ? */ /* ?.?.? */
unary.identifier.declarator: /*P293*/
          postfix.identifier.declarator
        | '*' identifier.declarator
            { $$ = ModifyDeclType($2, MakePtrCoord(EMPTY_TQ, NULL, $1)); 
               }
        | '*' pointer.type.qualifier.list identifier.declarator
            { $$ = ModifyDeclType($3, MakePtrCoord(   $2.tq,    NULL, $1)); 
               }
        ;
        
/*                        */    /* ? */ /* ?.?.? */
postfix.identifier.declarator: /*P296*/
          paren.identifier.declarator postfixing.abstract.declarator
            { $$ = ModifyDeclType($1, $2); }
        | '(' unary.identifier.declarator ')'
            { $$ = $2; 
               }
        | '(' unary.identifier.declarator ')' postfixing.abstract.declarator
            { $$ = ModifyDeclType($2, $4); 
               }
        ;

/*                        */    /* ? */ /* ?.?.? */
paren.identifier.declarator: /*P299*/
          IDENTIFIER
            { $$ = ConvertIdToDecl($1, EMPTY_TQ, NULL, NULL, NULL); }
        | '(' paren.identifier.declarator ')'
            { $$ = $2; 
               }
        ;

/*                        */    /* ? */ /* ?.?.? */
old.function.declarator: /*P301*/
          postfix.old.function.declarator
            { 
/*              OldStyleFunctionDefinition = TRUE; */
              $$ = $1; 
            }
        | '*' old.function.declarator
            { $$ = SetDeclType($2, MakePtrCoord(EMPTY_TQ, NULL, $1), SU); 
               }
        | '*' pointer.type.qualifier.list old.function.declarator
            { $$ = SetDeclType($3, MakePtrCoord($2.tq, NULL, $1), SU); 
               }
        ;

/*                        */    /* ? */ /* ?.?.? */
postfix.old.function.declarator: /*P*/
          paren.identifier.declarator '(' identifier.list ')'  
            { 
	      $$ = ModifyDeclType($1, MakeFdclCoord(EMPTY_TQ, $3, NULL, $2)); 
	    }

        | '(' old.function.declarator ')'
            { 
	      $$ = $2; 
	    }
        | '(' old.function.declarator ')' postfixing.abstract.declarator
            { 
	      $$ = ModifyDeclType($2, $4); 
	    }
        ;

/* 
    ANSI C section 3.7.1 states  

      "An identifier declared as a typedef name shall not be redeclared 
       as a parameter".  

    Hence the following is based only on IDENTIFIERs 
*/
/*                        */    /* ? */ /* ?.?.? */
identifier.list: /*P*/ /* only used by postfix.old.function.declarator */
          IDENTIFIER
            { $$ = MakeNewList($1); }
        | identifier.list ',' IDENTIFIER
            { $$ = AppendItem($1, $3); }
        ;

/*                        */    /* ? */ /* ?.?.? */
identifier.or.typedef.name: /*P*/
          IDENTIFIER
        | TYPEDEFname
        ;

/*                        */    /* ? */ /* ?.?.? */
type.name: /*P*/
          type.specifier
            { $$ = FinishType($1); }
        | type.specifier abstract.declarator
            { $$ = FinishType(SetBaseType($2, $1)); }
        | type.qualifier.list /* DEFAULT_INT */
            { $$ = MakeDefaultPrimType($1.tq, $1.coord); }
        | type.qualifier.list /* DEFAULT_INT */ abstract.declarator
	    { $$ = SetBaseType($2, MakeDefaultPrimType($1.tq, $1.coord)); }
        ;


/* Productions for __attribute__ adapted from the original in gcc 2.6.3. */

attributes.opt:
      /* empty */
  		{ $$ = NULL; }
	| attributes
		{ $$ = $1; }
	;

attributes:
      attribute
		{ $$ = $1; }
	| attributes attribute
		{ $$ = JoinLists ($1, $2); }
	;

attribute:
      ATTRIBUTE '(' '(' attribute.list ')' ')'
		{ if (ANSIOnly)
	            SyntaxError("__attribute__ not allowed with -ansi switch");
                  $$ = $4; }
	;

attribute.list:
      attrib
		{ $$ = MakeNewList($1); }
	| attribute.list ',' attrib
		{ $$ = AppendItem($1, $3); }
	;
 
attrib:
    /* empty */
		{ $$ = NULL; }
	| any.word
		{ $$ = ConvertIdToAttrib($1, NULL); }
	| any.word '(' expression ')'
		{ $$ = ConvertIdToAttrib($1, $3); }
	;


any.word:
	  IDENTIFIER
	| TYPEDEFname
	| CONST { $$ = MakeIdCoord(UniqueString("const"), $1); }
	;

/*                        */    /* ? */ /* ?.?.? */
initializer.opt: /*P*/
          /* nothing */                  { $$ = NULL; }
        | '=' initializer                { $$ = $2; }
        ;

/*                        */    /* ? */ /* ?.?.? */
initializer: /*P*/
          '{' initializer.list '}'       { $$ = $2; $$->coord = $1; }
        | '{' initializer.list ',' '}'   { $$ = $2; $$->coord = $1; }
        | assignment.expression          { $$ = $1; }
        ;

/*                        */    /* ? */ /* ?.?.? */
initializer.list: /*P*/
          initializer
            { $$ = MakeInitializerCoord(MakeNewList($1), $1->coord); }
        | initializer.list ',' initializer
            { 
              assert($1->typ == Initializer);
              AppendItem($1->u.initializer.exprs, $3);
              $$ = $1; 
            }
        ;

/*                        */    /* ? */ /* ?.?.? */
parameter.type.list: /*P*/
          parameter.list
        | parameter.list ',' ELLIPSIS   { $$ = AppendItem($1, EllipsisNode); }

        /******** ERROR PRODUCTIONS (EAB) ********/
        | ELLIPSIS
            { Node *n = MakePrimCoord(EMPTY_TQ, Void, $1);
	      SyntaxErrorCoord(n->coord, "First argument cannot be `...'");
              $$ = MakeNewList(n);
            }
        ;

/*                        */    /* ? */ /* ?.?.? */
parameter.list: /*P*/
          parameter.declaration
            { $$ = MakeNewList($1); }
        | parameter.list ',' parameter.declaration
            { $$ = AppendItem($1, $3); }

        /******** ERROR PRODUCTIONS (EAB) ********/
        | parameter.declaration '=' initializer
            { 
	      SyntaxErrorCoord($1->coord, "formals cannot have initializers");
              $$ = MakeNewList($1); 
            }
        | parameter.list ',' error
            { $$ = $1; }
        ;

/*                        */    /* ? */ /* ?.?.? */
parameter.declaration: /*P*/
          declaration.specifier
            { $$ = $1; }
        | declaration.specifier abstract.declarator
            { $$ = SetBaseType($2, $1); 
            }
        | declaration.specifier identifier.declarator
            { $$ = SetDeclType($2, $1, Formal); 
            }
        | declaration.specifier parameter.typedef.declarator
            { $$ = SetDeclType($2, $1, Formal); 
            }
        | declaration.qualifier.list /* DEFAULT_INT */ 
            { $$ = MakeDefaultPrimType($1.tq, $1.coord); }
        | declaration.qualifier.list /* DEFAULT_INT */ abstract.declarator
            { $$ = SetBaseType($2, MakeDefaultPrimType($1.tq, $1.coord)); }
        | declaration.qualifier.list /* DEFAULT_INT */ identifier.declarator
            { $$ = SetDeclType($2, MakeDefaultPrimType($1.tq, $1.coord), Formal); }
        | type.specifier
            { $$ = $1; }
        | type.specifier abstract.declarator
            { $$ = SetBaseType($2, $1); 
            }
        | type.specifier identifier.declarator
            { $$ = SetDeclType($2, $1, Formal); 
            }
        | type.specifier parameter.typedef.declarator
            { $$ = SetDeclType($2, $1, Formal); 
            }
        | type.qualifier.list /* DEFAULT_INT */ 
            { $$ = MakeDefaultPrimType($1.tq, $1.coord); }
        | type.qualifier.list /* DEFAULT_INT */ abstract.declarator
            { $$ = SetBaseType($2, MakeDefaultPrimType($1.tq, $1.coord)); }
        | type.qualifier.list /* DEFAULT_INT */ identifier.declarator
            { $$ = SetDeclType($2, MakeDefaultPrimType($1.tq, $1.coord), Formal); }
        ;

/*                        */    /* ? */ /* ?.?.? */
array.abstract.declarator: /*P*/
          '[' ']'
            { $$ = MakeAdclCoord(EMPTY_TQ, NULL, NULL, $1); arrayop();}
        | '[' constant.expression ']'
            { $$ = MakeAdclCoord(EMPTY_TQ, NULL, $2, $1); arrayop();}
        | array.abstract.declarator '[' constant.expression ']'
            { $$ = SetBaseType($1, MakeAdclCoord(EMPTY_TQ, NULL, $3, $2)); arrayop();}

        /******** ERROR PRODUCTIONS ********/
        | /* error production: catch empty dimension that isn't first */
          array.abstract.declarator '[' ']'
            { 
              SyntaxError("array declaration with illegal empty dimension");
              $$ = SetBaseType($1, MakeAdclCoord(EMPTY_TQ, NULL, SintOne, $2)); 
            }
        ;

/********************************************************************************
*										*
*                      STRUCTURES, UNION, and ENUMERATORS			*
*										*
********************************************************************************/

/*                        */    /* ? */ /* ?.?.? */
struct.or.union.specifier: /*P*/
          struct.or.union '{' struct.declaration.list '}'
            { 
              $$ = SetSUdclNameFields($1, NULL, $3, $2, $4);
            }
        | struct.or.union identifier.or.typedef.name
          '{' struct.declaration.list '}'
            { 
              $$ = SetSUdclNameFields($1, $2, $4, $3, $5);
	    }
        | struct.or.union identifier.or.typedef.name
            { 
              $$ = SetSUdclName($1, $2, $1->coord);
	    }
        /* EAB: create rules for empty structure declarations */
        | struct.or.union '{' '}'
            { 
              if (ANSIOnly)
                 Warning(1, "empty structure declaration");
              $$ = SetSUdclNameFields($1, NULL, NULL, $2, $3); 
	    }
        | struct.or.union identifier.or.typedef.name '{' '}'
            { 
              if (ANSIOnly)
                 Warning(1, "empty structure declaration");
              $$ = SetSUdclNameFields($1, $2, NULL, $3, $4); 
	    }
        ;

/*                        */    /* ? */ /* ?.?.? */
struct.or.union: /*P*/ 
          STRUCT   { $$ = MakeSdclCoord(EMPTY_TQ, NULL, $1); }
        | UNION    { $$ = MakeUdclCoord(EMPTY_TQ, NULL, $1); }
        ;

/*                        */    /* ? */ /* ?.?.? */
struct.declaration.list: /*P*/
          struct.declaration
        | struct.declaration.list struct.declaration
            { $$ = JoinLists($1, $2); }
        ;

/*                        */    /* ? */ /* ?.?.? */
struct.declaration: /*P*/
          struct.declaring.list ';'
        | struct.default.declaring.list ';'
        ;

/* doesn't redeclare typedef */
/*                        */    /* ? */ /* ?.?.? */
struct.default.declaring.list: /*P*/        
          type.qualifier.list struct.identifier.declarator
            { 
	      $$ = MakeNewList(SetDeclType($2,
					    MakeDefaultPrimType($1.tq, $1.coord),
					    SU)); 
	    }
        | struct.default.declaring.list ',' struct.identifier.declarator
            { $$ = AppendDecl($1, $3, SU); }
        ;

/*                        */    /* ? */ /* ?.?.? */
struct.declaring.list:  /*P*/       
          type.specifier struct.declarator
            { $$ = MakeNewList(SetDeclType($2, $1, SU)); }
        | struct.declaring.list ',' struct.declarator
            { $$ = AppendDecl($1, $3, SU); }
        ;


/*                        */    /* ? */ /* ?.?.? */
struct.declarator: /*P*/
          declarator bit.field.size.opt attributes.opt
            { SetDeclAttribs($1, $3);
              $$ = SetDeclBitSize($1, $2); }
        | bit.field.size attributes.opt
            { $$ = MakeDeclCoord(NULL, EMPTY_TQ, NULL, NULL, $1, $1->coord);
              SetDeclAttribs($$, $2); }
        ;

/*                        */    /* ? */ /* ?.?.? */
struct.identifier.declarator: /*P*/
          identifier.declarator bit.field.size.opt attributes.opt
            { $$ = SetDeclBitSize($1, $2);
              SetDeclAttribs($1, $3); }
        | bit.field.size attributes.opt
            { $$ = MakeDeclCoord(NULL, EMPTY_TQ, NULL, NULL, $1, $1->coord);
              SetDeclAttribs($$, $2); }
        ;

/*                        */    /* ? */ /* ?.?.? */
bit.field.size.opt: /*P*/
          /* nothing */   { $$ = NULL; }
        | bit.field.size
        ;

/*                        */    /* ? */ /* ?.?.? */
bit.field.size: /*P*/
          ':' constant.expression { $$ = $2; }
        ;

/*                        */    /* ? */ /* ?.?.? */
enum.specifier: /*P*/
          ENUM '{' enumerator.list comma.opt '}'
            { $$ = BuildEnum(NULL, $3, $1, $2, $5); }
        | ENUM identifier.or.typedef.name '{' enumerator.list comma.opt '}'
            { $$ = BuildEnum($2, $4, $1, $3, $6);   }
        | ENUM identifier.or.typedef.name
            { $$ = BuildEnum($2, NULL, $1, $2->coord, $2->coord); }
        ;

/*                        */    /* ? */ /* ?.?.? */
enumerator.list: /*P*/
          identifier.or.typedef.name enumerator.value.opt
            { $$ = MakeNewList(BuildEnumConst($1, $2)); }
        | enumerator.list ',' identifier.or.typedef.name enumerator.value.opt
            { $$ = AppendItem($1, BuildEnumConst($3, $4)); }
        ;

/*                        */    /* ? */ /* ?.?.? */
enumerator.value.opt: /*P*/
          /* Nothing */               { $$ = NULL; }
        | '=' constant.expression     { $$ = $2;   }
        ;

comma.opt: /* not strictly ANSI */
          /* Nothing */    { }
        | ','              { }
        ;

/********************************************************************************
*										*
*                                  STATEMENTS					*
*										*
********************************************************************************/

statement:                      /* P */ /* 6.6   */
          labeled.statement
        | compound.statement
        | expression.statement
        | selection.statement
        | iteration.statement
        | jump.statement
          /******** ERROR PRODUCTIONS ********/
        | error ';'
           {  $$ = NULL; }
        ;

labeled.statement:              /* P */ /* 6.6.1 */
          IDENTIFIER ':'             
           { $$ = BuildLabel($1, NULL); }
          statement
           { $$->u.label.stmt = $4; }

        | CASE constant.expression ':' statement
            { $$ = AddContainee(MakeCaseCoord($2, $4, NULL, $1)); }
        | DEFAULT ':' statement
            { $$ = AddContainee(MakeDefaultCoord($3, NULL, $1)); }

          /* Required extension to 6.6.1 */
        | TYPEDEFname ':' statement
            { $$ = BuildLabel($1, $3); }
        ;

compound.statement:             /* P */ /* 6.6.2 */
          lblock rblock
            { $$ = MakeBlockCoord(PrimVoid, NULL, NULL, $1, $2); }
        | lblock declaration.list rblock
            { $$ = MakeBlockCoord(PrimVoid, GrabPragmas($2), NULL, $1, $3); }
        | lblock statement.list rblock
            { $$ = MakeBlockCoord(PrimVoid, NULL, GrabPragmas($2), $1, $3); }
        | lblock declaration.list statement.list rblock
            { $$ = MakeBlockCoord(PrimVoid, $2, GrabPragmas($3), $1, $4); }
        ;

lblock: '{'  { EnterScope(); }
        ;
rblock: '}'  { ExitScope(); }
        ;

/* compound.statement.no.new.scope is used by function.definition,
   since the new scope is begun with formal argument declarations,
   not with the opening '{' */
compound.statement.no.new.scope:             /* P */ /* 6.6.2 */
          '{' '}'
            { $$ = MakeBlockCoord(PrimVoid, NULL, NULL, $1, $2);disable_check();} 
        | '{' declaration.list '}'
            { $$ = MakeBlockCoord(PrimVoid, GrabPragmas($2), NULL, $1, $3); disable_check();}
        | '{' statement.list '}'
            { $$ = MakeBlockCoord(PrimVoid, NULL, GrabPragmas($2), $1, $3); disable_check();}
        | '{' declaration.list statement.list '}'
            { $$ = MakeBlockCoord(PrimVoid, $2, GrabPragmas($3), $1, $4); disable_check();}
        ;



declaration.list:               /* P */ /* 6.6.2 */
          declaration                   { $$ = GrabPragmas($1); }
        | declaration.list declaration  { $$ = JoinLists(GrabPragmas($1),
                                                         $2); }
        ;

statement.list:                 /* P */ /* 6.6.2 */
          statement                   { $$ = GrabPragmas(MakeNewList($1)); }
        | statement.list statement    { $$ = AppendItem(GrabPragmas($1), 
                                                        $2); }
        ;

expression.statement:           /* P */ /* 6.6.3 */
          expression.opt ';'
        ;

selection.statement:            /* P */ /* 6.6.4 */
          IF '(' expression ')' statement
            { $$ = MakeIfCoord($3, $5, $1); checkstmt("if");}
        | IF '(' expression ')' statement ELSE statement
            { $$ = MakeIfElseCoord($3, $5, $7, $1, $6); checkstmt("if");}
        | SWITCH { PushContainer(Switch); } '(' expression ')' statement
            { $$ = PopContainer(MakeSwitchCoord($4, $6, NULL, $1)); 
	    checkstmt("switch");}
        ;

iteration.statement:            /* P */ /* 6.6.5 */
          WHILE 
            { PushContainer(While);} 
          '(' expression ')' statement
            { $$ = PopContainer(MakeWhileCoord($4, $6, $1)); checkstmt("while");}
        | DO 
            { PushContainer(Do);} 
          statement WHILE '(' expression ')' ';'
            { $$ = PopContainer(MakeDoCoord($3, $6, $1, $4)); checkstmt("do");}
        | FOR '(' expression.opt ';' expression.opt ';' expression.opt ')'  
            { PushContainer(For);} 
          statement
            { $$ = PopContainer(MakeForCoord($3, $5, $7, $10, $1)); checkstmt("for");}

        /******** ERROR PRODUCTIONS (EAB) ********/
        | FOR '(' error ';' expression.opt ';' expression.opt ')'  
            { PushContainer(For);} 
          statement
            { $$ = PopContainer(MakeForCoord(NULL, $5, $7, $10, $1)); }
        | FOR '(' expression.opt ';' expression.opt ';' error ')'  
            { PushContainer(For);} 
          statement
            { $$ = PopContainer(MakeForCoord($3, $5, NULL, $10, $1)); }
        | FOR '(' expression.opt ';' error ';' expression.opt ')'  
            { PushContainer(For);} 
          statement
            { $$ = PopContainer(MakeForCoord($3, NULL, $7, $10, $1)); }
        | FOR '(' error ')' { PushContainer(For);} statement
            { $$ = PopContainer(MakeForCoord(NULL, SintZero, NULL, $6, $1)); }
        ;

jump.statement:                 /* P */ /* 6.6.6 */
          GOTO IDENTIFIER ';'
            { $$ = ResolveGoto($2, $1); checkstmt("goto");}
        | CONTINUE ';'
            { $$ = AddContainee(MakeContinueCoord(NULL, $1)); checkstmt("continue");}
        | BREAK ';'
            { $$ = AddContainee(MakeBreakCoord(NULL, $1)); checkstmt("break");}
        | RETURN expression.opt ';'
            { $$ = AddReturn(MakeReturnCoord($2, $1)); }	      

        /* Required extension/clarification to 6.6.6 */
        | GOTO TYPEDEFname ';'
            { $$ = ResolveGoto($2, $1); }
        ;

/********************************************************************************
*										*
*                            EXTERNAL DEFINITIONS                               *
*										*
********************************************************************************/

translation.unit:               /* P */ /* 6.7   */
          external.definition
        | translation.unit external.definition   
                  { $$ = JoinLists(GrabPragmas($1), $2); }

        ;

external.definition:            /* P */ /* 6.7   */
          declaration
            {
              if (yydebug)
                {
                  printf("external.definition # declaration\n");
                  PrintNode(stdout, FirstItem($1), 0); 
                  printf("\n\n\n");
		}
              $$ = $1;
            }
        | function.definition  
            { 
              if (yydebug)
                {
                  printf("external.definition # function.definition\n");
                  PrintNode(stdout, $1, 0); 
                  printf("\n\n\n");
                }
              $$ = MakeNewList($1); 
            }
        ;

function.definition:            /* P */ /* BASED ON 6.7.1 */
          identifier.declarator
            { 
	      Node *decl;
	      decl = SetDeclType($1,
				       MakeDefaultPrimType(EMPTY_TQ, 
							   $1->coord),
				       Redecl);
	      newfunc(decl);
              $1 = DefineProc(FALSE, decl);
            }
          compound.statement.no.new.scope
            { $$ = SetProcBody($1, $3); }
        | identifier.declarator BOGUS
            /* this rule is never used, it exists solely to force the parser to
	       read the '{' token for the previous rule, thus starting a create
	       scope in the correct place */
        | declaration.specifier      identifier.declarator
            { 
	      Node *decl;
	      decl = SetDeclType($2, $1, Redecl);
	      newfunc(decl);
	      $2 = DefineProc(FALSE, decl); 
	    }
          compound.statement.no.new.scope
            { $$ = SetProcBody($2, $4); }
        | type.specifier             identifier.declarator
            { 
	      Node *decl;
	      decl = SetDeclType($2, $1, Redecl);
	      newfunc(decl);
	      $2 = DefineProc(FALSE, decl); 
	    }
          compound.statement.no.new.scope
            { 
	      endfunc($4);
	      $$ = SetProcBody($2, $4); 
	    }
        | declaration.qualifier.list identifier.declarator
            { 
	      Node *decl;
	      decl = SetDeclType($2,
				       MakeDefaultPrimType($1.tq, $1.coord),
				       Redecl);
	      newfunc(decl);
              $2 = DefineProc(FALSE, decl);
            } 
          compound.statement.no.new.scope
            { $$ = SetProcBody($2, $4); }
        | type.qualifier.list        identifier.declarator
            { 
	      Node *decl;
	      decl = SetDeclType($2,
				       MakeDefaultPrimType($1.tq, $1.coord),
				       Redecl);
	      newfunc(decl);
              $2 = DefineProc(FALSE, decl);
            } 
          compound.statement.no.new.scope
            { $$ = SetProcBody($2, $4); }
        | old.function.declarator
            { 
	      Node *decl;
	      decl = SetDeclType($1,
				       MakeDefaultPrimType(EMPTY_TQ, 
							   $1->coord),
				       Redecl);
	      newfunc(decl);
              $1 = DefineProc(TRUE, decl);
            } 
          compound.statement.no.new.scope
            { $$ = SetProcBody($1, $3); }
        | declaration.specifier old.function.declarator 
             {
	       Node *decl;
	       decl = SetDeclType($2, $1, Redecl);  
	       newfunc(decl);

               AddParameterTypes(decl, NULL);
               $2 = DefineProc(TRUE, decl);
            }
          compound.statement.no.new.scope
            { $$ = SetProcBody($2, $4); }
        | type.specifier old.function.declarator
            {
	      Node *decl;
	      decl = SetDeclType($2, $1, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, NULL);
              $2 = DefineProc(TRUE, decl);
            }
          compound.statement.no.new.scope
            { $$ = SetProcBody($2, $4); }
        | declaration.qualifier.list old.function.declarator
            {
	      Node *type, *decl;
	      type == MakeDefaultPrimType($1.tq, $1.coord);
              decl = SetDeclType($2, type, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, NULL);
              $2 = DefineProc(TRUE, decl);
            } 
          compound.statement.no.new.scope
            { $$ = SetProcBody($2, $4); }
        | type.qualifier.list        old.function.declarator
            {
	      Node *type, *decl;
	      type = MakeDefaultPrimType($1.tq, $1.coord);
	      decl = SetDeclType($2, type, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, NULL);
              $2 = DefineProc(TRUE, decl);
            } 
          compound.statement.no.new.scope
            { $$ = SetProcBody($2, $4); }
        | old.function.declarator old.function.declaration.list
            {
	      Node *type, *decl;
	      type = MakeDefaultPrimType(EMPTY_TQ, $1->coord);
	      decl = SetDeclType($1, type, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, $2);
              $1 = DefineProc(TRUE, decl);
            } 
          compound.statement.no.new.scope
            { $$ = SetProcBody($1, $4); }
        | declaration.specifier old.function.declarator old.function.declaration.list
            {
	      Node *decl;
	      decl = SetDeclType($2, $1, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, $3);
              $2 = DefineProc(TRUE, decl);
            } 
          compound.statement.no.new.scope
            { $$ = SetProcBody($2, $5); }
        | type.specifier old.function.declarator old.function.declaration.list
            {
	      Node *decl;
	      decl = SetDeclType($2, $1, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, $3);
              $2 = DefineProc(TRUE, decl);
            } 
          compound.statement.no.new.scope
            { $$ = SetProcBody($2, $5); }
        | declaration.qualifier.list old.function.declarator old.function.declaration.list
            {
	      Node *type, *decl;
	      type = MakeDefaultPrimType($1.tq, $1.coord);
	      decl = SetDeclType($2, type, Redecl);
	      newfunc(decl);

              AddParameterTypes(decl, $3);
              $2 = DefineProc(TRUE, decl);
            } 
          compound.statement.no.new.scope
            { $$ = SetProcBody($2, $5); }
        | type.qualifier.list old.function.declarator old.function.declaration.list
            {
	      Node *type, *decl;
	      type = MakeDefaultPrimType($1.tq, $1.coord);
	      decl = SetDeclType($2, type, Redecl);
	      newfunc(decl);
   

              AddParameterTypes(decl, $3);
              $2 = DefineProc(TRUE, decl);
            } 
          compound.statement.no.new.scope
            { $$ = SetProcBody($2, $5); }
        ;


old.function.declaration.list:
             { OldStyleFunctionDefinition = TRUE; }
             declaration.list
             { OldStyleFunctionDefinition = FALSE; 
               $$ = $2; }
        ;

/********************************************************************************
*										*
*                          CONSTANTS and LITERALS                               *
*										*
********************************************************************************/

/* 
  CONSTANTS.  Note ENUMERATIONconstant is treated like a variable with a type
  of "enumeration constant" (elsewhere)
*/
constant: /*P*/
          FLOATINGconstant      { $$ = $1; checkconst($1);}
        | INTEGERconstant       { $$ = $1; checkconst($1);}
        | OCTALconstant         { $$ = $1; checkconst($1);}
        | HEXconstant           { $$ = $1; checkconst($1);}
        | CHARACTERconstant     { $$ = $1; checkconst($1);}
        ;

/* STRING LITERALS */
string.literal.list: /*P*/
          STRINGliteral         { $$ = $1; }
        | string.literal.list STRINGliteral
            { const char *first_text  = $1->u.Const.text;
              const char *second_text = $2->u.Const.text;
              int   length = strlen(first_text) + strlen(second_text) + 1;
              char *buffer = HeapNewArray(char, length);
              char *new_text, *new_val;
	
              /* since text (which includes quotes and escape codes)
		 is always longer than value, it's safe to use buffer
		 to concat both */
              strcpy(buffer, NodeConstantStringValue($1));
	      strcat(buffer, NodeConstantStringValue($2));
              new_val = UniqueString(buffer);

              strcpy(buffer, first_text);
	      strcat(buffer, second_text);
              new_text = buffer;
              $$ = MakeStringTextCoord(new_text, new_val, $1->coord);
	     }
        ;

type.qualifier: /*P*/
          CONST     { $$.tq = T_CONST;    $$.coord = $1; } 
        | VOLATILE  { $$.tq = T_VOLATILE; $$.coord = $1; }
        | INLINE    { $$.tq = T_INLINE;   $$.coord = $1; }
        ;

pointer.type.qualifier: /*P*/
          CONST     { $$.tq = T_CONST;    $$.coord = $1; } 
        | VOLATILE  { $$.tq = T_VOLATILE; $$.coord = $1; }
        ;

storage.class: /*P*/
          TYPEDEF   { $$.tq = T_TYPEDEF;  $$.coord = $1; } 
        | EXTERN    { $$.tq = T_EXTERN;   $$.coord = $1; } 
        | STATIC    { $$.tq = T_STATIC;   $$.coord = $1; } 
        | AUTO      { $$.tq = T_AUTO;     $$.coord = $1; } 
        | REGISTER  { $$.tq = T_REGISTER; $$.coord = $1; } 
        ;

basic.type.name: /*P*/
          VOID      { $$ = StartPrimType(Void, $1);    } 
        | CHAR      { $$ = StartPrimType(Char, $1);  checktype(Char, "char");   } 
        | INT       { $$ = StartPrimType(Int_ParseOnly, $1);     } 
        | FLOAT     { $$ = StartPrimType(Float, $1); checktype(Float, "float");  } 
        | DOUBLE    { $$ = StartPrimType(Double, $1);  checktype(Double, "double"); } 

        | SIGNED    { $$ = StartPrimType(Signed, $1);   } 
        | UNSIGNED  { $$ = StartPrimType(Unsigned, $1); checktype(Unsigned, "unsigned"); } 

        | SHORT     { $$ = StartPrimType(Short, $1);  checktype(Short, "short"); } 
        | LONG      { $$ = StartPrimType(Long, $1); }
        ;

%%
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


