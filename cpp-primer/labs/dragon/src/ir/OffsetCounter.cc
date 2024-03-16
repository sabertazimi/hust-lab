/*!
 * \file OffsetCounter.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "OffsetCounter.h"

///< initial value for different scope
const static int initValue[] = {
    -2 * WORD_SIZE,     ///< stack frame down
    2 * WORD_SIZE,      ///< stack frame up
    POINTER_SIZE        ///< this pointer, pointing to virtaul function table of class
};

///< offset increase drection
const static int direction[] = {
    -1,                 ///< stack frame
    1,
    1
};

OffsetCounter *OffsetCounter::LOCAL_COUNTER = new OffsetCounter(OS_LOCAL);
OffsetCounter *OffsetCounter::PARAM_COUNTER = new OffsetCounter(OS_PARAM);
OffsetCounter *OffsetCounter::MEMBER_COUNTER = new OffsetCounter(OS_MEMBER);

OffsetCounter::OffsetCounter(osKind kind) {
    this->kind = kind;
    reset();
}

void OffsetCounter::reset(void) {
    value = initValue[kind];
}

void OffsetCounter::set(int offset) {
    value = offset;
}

int OffsetCounter::next(int value) {
    int ret = this->value;
    this->value += direction[kind] * value;
    return ret;
}

