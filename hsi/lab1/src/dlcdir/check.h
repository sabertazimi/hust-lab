/* various constants */
#define MAXFUNCS 256
#define MAXOPS 128
#define MAXSTR 128


/* Field "whatsok" constructed by OR'ing together mask of allowed features */
/* Function calls OK */
#define CALLS_OK 0x1
/* Big constants OK */
#define BIGCONST_OK 0x2
/* Control instructions OK */
#define CONTROL_OK 0x4
/* Nonstandard integer data types */
#define OTHERINT_OK 0x8

/* holds the list of legal functions and operators (defined in legallist.c) */
struct legallist {
    char name[MAXSTR]; /* legal function name */
    int whatsok;       /* are function calls allowed in this function? */
    int maxops;        /* max operators for this function */
    int ops[MAXOPS];   /* null-terminated list of legal operators for this function */
};
