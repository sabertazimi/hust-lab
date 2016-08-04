#include <iostream>
#include <cstring>

#ifndef DEBUG
#define DEBUG
#endif

#ifdef DEBUG
#undef DEBUG
#endif

#define ID_MAXLEN       30
#define TOKEN_ARRLEN    100
#define FILE_MAXSIZE    10000

#define SETOKEN(_type, _string, _column, _line) {   \
    tokens[tokens_index].type = (_type);            \
    tokens[tokens_index].line = (_line);            \
    tokens[tokens_index].column = (_column);        \
    strcpy(tokens[tokens_index].string, (_string)); \
    column += strlen(_string)+1;                    \
    buf += strlen(_string)+1;                       \
    tokens_index++;                                 \
}

using namespace std;

enum {
    IDENTIFIER,
    IF
};

typedef struct token {
    int type;
    char string[ID_MAXLEN];
    int column;
    int line;
} Token;

static Token tokens[TOKEN_ARRLEN];
static uint32_t tokens_index = 0;

static uint32_t parse_line(char *buf, int line);
static uint32_t parse_file(FILE *fp);

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("<Usage> ./exec <file name>\n");
    }

    FILE *fp = fopen(argv[1], "r");

    if (!fp) {
        printf("Read error.\n");
        exit(0);
    }

    parse_file(fp);
    tokens_index--;

    for (uint32_t i = 0; i <= tokens_index; i++) {
        if (tokens[i].type == IF) {
            printf("IF\t");
            printf("(%d, %d)\n", tokens[i].line, tokens[i].column);
        } else {
            printf("ID(%s)\t", tokens[i].string);
            printf("(%d, %d)\n", tokens[i].line, tokens[i].column);
        }
    }

    fclose(fp);
    return 0;
}

static uint32_t parse_line(char *buf, int line) {
    int column = 0;
    int pos = 0;

    while (*buf != '\n' && *buf != '\0') {
        pos = 0;

        // remove space
        while (isspace(*buf)) {
            buf++;
            column++;
        }

        // 'if' token
        if (buf[0] == 'i' && buf[1] =='f' && !isalnum(buf[2])) {

#ifdef DEBUG
            printf("buf[2]: %c\n", buf[2]);
#endif

            SETOKEN(IF, "IF", column, line);

#ifdef DEBUG
            printf("column :%d\n", column);
#endif

        } else {
            while (!isspace(*(buf+pos))) {
                pos++;
            }

            *(buf+pos) = '\0';
            SETOKEN(IDENTIFIER, buf, column, line);
        }
    }

    return 1;
}

static uint32_t parse_file(FILE *fp) {
    char *buf = (char *)malloc(sizeof(char) * FILE_MAXSIZE);
    int line = 0;

    while (fgets(buf, FILE_MAXSIZE, fp)) {
        parse_line(buf, line);
        line++;
    }

    free(buf);

    return 1;
}

