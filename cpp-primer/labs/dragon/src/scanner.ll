%{

    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "location.h"
    #include "errors/errors.h"
    #include "libs/List.h"
    #include "syntax/Tree.h"
    #include "parser.hh"

    /// \brief informations of locations
    int current_line;
    int current_column;

    #define YY_USER_INIT                                    \
        yy_push_state(SRCBUF);                              \
        current_line = current_column = 1;                  \
        yylloc.first_line = yylloc.first_column = 1;        \
        srcbuf_init();
    #define YY_USER_ACTION                                  \
        yylloc.first_line = yylloc.last_line = yylineno;    \
        yylloc.first_column = current_column;               \
        yylloc.last_column = current_column + yyleng - 1;   \
        current_column += yyleng;

    #ifdef __cplusplus
        extern "C" {
    #endif

    /// \brief return 1 making parse only get done 1 time
    int yywrap(void);

    #ifdef __cplusplus
        }
    #endif

    /// \brief skip block comment
    void dragon_comment(void);

    // #define LEX_DEBUG

    /// \macro DRAGON_DEBUG
    /// \brief print debug info for lexical analysis
    #ifdef LEX_DEBUG
        #undef DRAGON_DEBUG
        #define DRAGON_DEBUG(type, value) do { dragon_debug(type, value); } while (0)
    #else
        #undef DRAGON_DEBUG
        #define DRAGON_DEBUG(type, value) do { } while (0)
    #endif

    /// \brief debug output function
    void dragon_debug(const char *type, const char *value);
%}

digit   [0-9]
letter  [a-zA-Z]
hexical [a-fA-F0-9]

%option yylineno
%option stack

%option noyy_top_state

/* lexer state for set up source code buffer */
%x SRCBUF

%%

<SRCBUF>.* {
    srcbuf_append(yytext);
    current_column = 1;
    yy_pop_state();
    yyless(0);
}

<SRCBUF><<EOF>> {
    srcbuf_append("\n");
    // exit SRCBUF lex state
    yy_pop_state();

    // transfer to END token
    return END;
}

<*>\n  {
    // increase current line
    current_line += 1;
    // reset column counter
    current_column = 1;

    if (YYSTATE == SRCBUF) {
        srcbuf_append("\n");
    } else {
        yy_push_state(SRCBUF);
    }

}

" " { }
\t  { }

"/*"   {
    dragon_comment();
}
"//"[^\n]* {
    /* Skip comment line */
}
"bool" {
    DRAGON_DEBUG("keyword", "BOOL");
    return BOOL;
}
"class" {
    DRAGON_DEBUG("keyword", "CLASS");
    return CLASS;
}
"else" {
    DRAGON_DEBUG("keyword", "ELSE");
    return ELSE;
}
"extends" {
    DRAGON_DEBUG("keyword", "EXTENDS");
    return EXTENDS;
}
"for" {
    DRAGON_DEBUG("keyword", "FOR");
    return FOR;
}
"if" {
    DRAGON_DEBUG("keyword", "IF");
    return IF;
}
"int" {
    DRAGON_DEBUG("keyword", "INT");
    return INT;
}
"new" {
    DRAGON_DEBUG("keyword", "NEW");
    return NEW;
}
"null" {
    DRAGON_DEBUG("keyword", "NULL");
    return NIL;
}
"return" {
    DRAGON_DEBUG("keyword", "RETURN");
    return RETURN;
}
"string" {
    DRAGON_DEBUG("keyword", "STRING");
    return STRING;
}
"this" {
    DRAGON_DEBUG("keyword", "THIS");
    return THIS;
}
"void" {
    DRAGON_DEBUG("keyword", "VOID");
    return VOID;
}
"while" {
    DRAGON_DEBUG("keyword", "WHILE");
    return WHILE;
}
"true"  {
    DRAGON_DEBUG("keyword", "CONSTANT_BOOL");
    yylval.num_val = 1;
    return CONSTANT_BOOL;
}
"false" {
    DRAGON_DEBUG("keyword", "CONSTANT_BOOL");
    yylval.num_val = 0;
    return CONSTANT_BOOL;
}
"Print" {
    DRAGON_DEBUG("keyword", "PRINT");
    return PRINT;
}
"ReadInt" {
    DRAGON_DEBUG("keyword", "READINTEGER");
    return READINTEGER;
}
"ReadLine" {
    DRAGON_DEBUG("keyword", "READLINE");
    return READLINE;
}
({letter}|_)({letter}|{digit}|_)* {
    char *str = strdup(yytext);
    yylval.str_val = str;
    DRAGON_DEBUG("identifier", yylval.str_val);
    return IDENTIFIER;
}
(0|[1-9]{digit}*) {
    DRAGON_DEBUG("constant", "CONSTANT_DEC");
    yylval.num_val = atoi(yytext);
    return CONSTANT_INT;
}
0[xX]{hexical}+ {
    DRAGON_DEBUG("constant", "CONSTANT_HEX");
    yylval.num_val = strtol(yytext, NULL, 16);
    return CONSTANT_INT;
}
\"(\\.|[^\\"\n])*\"	{
    DRAGON_DEBUG("constant", "CONSTANT_STRING");
    char *str = strdup(yytext + 1);
    memset(str + strlen(yytext) - 2, '\0', 1);
    yylval.str_val = str;
    DRAGON_DEBUG("string", yylval.str_val);
    return CONSTANT_STRING;
}
"&&"	{
    DRAGON_DEBUG("operator", yytext);
    return(OP_AND);
}
"||"	{
    DRAGON_DEBUG("operator", yytext);
    return(OP_OR);
}
"<="	{
    DRAGON_DEBUG("operator", yytext);
    return(OP_LE);
}
">="	{
    DRAGON_DEBUG("operator", yytext);
    return(OP_GE);
}
"=>"    {
    DRAGON_DEBUG("operator", yytext);
    return(OP_ARROW);
}
"=="	{
    DRAGON_DEBUG("operator", yytext);
    return(OP_EQ);
}
"!="	{
    DRAGON_DEBUG("operator", yytext);
    return(OP_NE);
}
";"		{
    DRAGON_DEBUG("separator", yytext);
    return(';');
}
"{"		{
    DRAGON_DEBUG("separator", yytext);
    return('{');
}
"}"		{
    DRAGON_DEBUG("separator", yytext);
    return('}');
}
"["		{
    DRAGON_DEBUG("separator", yytext);
    return('[');
}
"]"		{
    DRAGON_DEBUG("separator", yytext);
    return(']');
}
"("		{
    DRAGON_DEBUG("separator", yytext);
    return('(');
}
")"		{
    DRAGON_DEBUG("separator", yytext);
    return(')');
}
"="		{
    DRAGON_DEBUG("operator", yytext);
    return('=');
}
","		{
    DRAGON_DEBUG("separator", yytext);
    return(',');
}
"."		{
    DRAGON_DEBUG("operator", yytext);
    return('.');
}
"!"		{
    DRAGON_DEBUG("operator", yytext);
    return('!');
}
"+"		{
    DRAGON_DEBUG("operator", yytext);
    return('+');
}
"-"		{
    DRAGON_DEBUG("operator", yytext);
    return('-');
}
"*"		{
    DRAGON_DEBUG("operator", yytext);
    return('*');
}
"/"		{
    DRAGON_DEBUG("operator", yytext);
    return('/');
}
"%"		{
    DRAGON_DEBUG("operator", yytext);
    return('%');
}
"<"		{
    DRAGON_DEBUG("operator", yytext);
    return('<');
}
">"		{
    DRAGON_DEBUG("operator", yytext);
    return('>');
}

. {
    dragon_report(&yylloc, "lexical error near %s", yytext);
    fprintf(stderr, "*** please fix lexical error first!\n");
    exit(0);
}

%%

int yywrap(void) {
    return 1;
}

void dragon_comment(void) {
    char ch = '\0',
         prev = '\0';

    while ((ch = yyinput()) != '\0' && ch != EOF) {
        if (ch == '\n') {
            srcbuf_append("\n");
        }

        if (prev == '*' && ch == '/') {
            return;
        } else {
            prev = ch;
        }
    }

    dragon_report(&yylloc, "unterminated block comment near %s", yytext);
    fprintf(stderr, "*** please fix lexical error first!\n");
    exit(0);
}

void dragon_debug(const char *type, const char *value) {
    fprintf(stdout, "line %4d, column %-4d-%4d: ", yylloc.first_line, yylloc.first_column, yylloc.last_column);
    fprintf(stdout, "(%s, %s)\n", type, value);
}


