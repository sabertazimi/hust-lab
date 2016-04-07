/* 
 * makecookie.c - generates and prints cookie
 */
#include <stdio.h>
#include <stdlib.h>
#include "gencookie.h"

int main(int argc, char *argv[])
{
    int i;
    for (i = 1; i < argc; i++) {
		unsigned c = gencookie(argv[i]);
		printf("0x%x\n", c);
    }
    return 0;
}
