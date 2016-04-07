#ifndef BISON_Y_TAB_H
# define BISON_Y_TAB_H

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


extern YYSTYPE yylval;

#endif /* not BISON_Y_TAB_H */
