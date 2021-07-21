/*
 * mem.c
 * Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
 *
 * Distributed under terms of the MIT license.
 */

#include <stdlib.h>
#include <spec.h>

int mem_spec(void) {
    uint8_t test[30];

    memcpy(test, (const uint8_t *)"Hello", 6);
    assert_equal("memcpy", test[0], 'H',"test[0] == 'H'");
    assert_equal("memcpy", test[1], 'e',"test[0] == 'e'");
    assert_equal("memcpy", test[2], 'l',"test[0] == 'l'");
    assert_equal("memcpy", test[3], 'l',"test[0] == 'l'");
    assert_equal("memcpy", test[4], 'o',"test[0] == 'o'");
    assert_equal("memcpy", test[5], '\0',"test[0] == '0'");

    memset(test, 6, 30);
    for (int i = 0; i < 30; i++) {
        assert_equal("memset", test[i], 6, "test == 6");
    }
    assert_nequal("memset", test[30], 6, "test[30] != 6");

    bzero(test, 30);
    for (int i = 0; i < 30; i++) {
        assert_equal("bzero", test[i], 0, "test == 0");
    }
    assert_nequal("bzero", test[30], 0, "test[30] != 0");

    return TRUE;
}
