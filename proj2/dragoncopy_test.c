/*!
 * \file dragoncopy_test.c
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2017
 * \license MIT
 */

#include <unistd.h>

int main(void) {
    syscall(546, "dragoncopy.c", "dragoncopy.cc");
    return 0;
}

