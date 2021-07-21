/*
 * string.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include <stdlib.h>
#include <spec.h>

int string_spec(void) {
    char test[30];

    assert_equal("strcmp", strcmp("Hello", "Hello W"), -1, "Hello < Hello W");
    assert_equal("strcmp", strcmp("Hello", "Hello "), -1, "Hello < Hello ");
    assert_equal("strcmp", strcmp("Hello", "Helloo"), -1, "Hello < Helloo");
    assert_equal("strcmp", strcmp("Hello", "Hello"), 0, "Hello == Hello");
    assert_equal("strcmp", strcmp("Hello\n", "Hello\n"), 0, "Hello == Hello");
    assert_equal("strcmp", strcmp("Hellooo", "Helloo"), 1, "Hellooo > Helloo");
    assert_equal("strcmp", strcmp("a", "b"), -1, "a < b");
    assert_equal("strcmp", strcmp("", "a"), -1, "epsilon < a");
    assert_equal("strcmp", strcmp("", ""), 0, "epsilon == epsilon");
    assert_equal("strcmp", strcmp("b", ""), 1, "b > epsilon");

    strcpy(test, "Hello");
    assert_equal("strcpy", test[0], 'H', "H");
    assert_equal("strcpy", test[1], 'e', "e");
    assert_equal("strcpy", test[2], 'l', "l");
    assert_equal("strcpy", test[3], 'l', "l");
    assert_equal("strcpy", test[4], 'o', "o");
    assert_equal("strcpy", test[5], '\0', "epsilon");
    assert_equal("strlen", strlen(test), 5, "Hello's length: 5");

    strcat(test, " World!");
    assert_equal("strcat", test[0], 'H', "H");
    assert_equal("strcat", test[1], 'e', "e");
    assert_equal("strcat", test[2], 'l', "l");
    assert_equal("strcat", test[3], 'l', "l");
    assert_equal("strcat", test[4], 'o', "o");
    assert_equal("strcat", test[5], ' ', "space");
    assert_equal("strcat", test[6], 'W', "W");
    assert_equal("strcat", test[7], 'o', "o");
    assert_equal("strcat", test[8], 'r', "r");
    assert_equal("strcat", test[9], 'l', "l");
    assert_equal("strcat", test[10], 'd', "d");
    assert_equal("strcat", test[11], '!', "!");
    assert_equal("strcat", test[12], '\0', "epsilon");
    assert_equal("strlen", strlen(test), 12, "Hello World!'s length: 12");
    strcat(test, "\0");
    assert_equal("strcat", test[0], 'H', "H");
    assert_equal("strcat", test[1], 'e', "e");
    assert_equal("strcat", test[2], 'l', "l");
    assert_equal("strcat", test[3], 'l', "l");
    assert_equal("strcat", test[4], 'o', "o");
    assert_equal("strcat", test[5], ' ', "space");
    assert_equal("strcat", test[6], 'W', "W");
    assert_equal("strcat", test[7], 'o', "o");
    assert_equal("strcat", test[8], 'r', "r");
    assert_equal("strcat", test[9], 'l', "l");
    assert_equal("strcat", test[10], 'd', "d");
    assert_equal("strcat", test[11], '!', "!");
    assert_equal("strcat", test[12], '\0', "epsilon");
    assert_equal("strlen", strlen(test), 12, "Hello World!'s length: 12");

    assert_equal("strlen", strlen("\0"), 0, "epsilon's length: 0");
    assert_equal("strlen", strlen("sabertazimi"), 11, "sabertazimi's length: 11");

    return TRUE;
}

