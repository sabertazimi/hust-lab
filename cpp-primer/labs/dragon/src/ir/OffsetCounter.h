/*!
 * \file OffsetCounter.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#ifndef IR_OFFSET_H
#define IR_OFFSET_H

typedef enum __oskind__ {
    OS_LOCAL = 0,
    OS_PARAM = 1,
    OS_MEMBER = 2
} osKind;

typedef enum __ossize__ {
    POINTER_SIZE = 4,
    WORD_SIZE = 4
} sizeKind;

class OffsetCounter {
    public:
        osKind kind;
        int value;

        // there only exist three offset counter
        static OffsetCounter *LOCAL_COUNTER;
        static OffsetCounter *PARAM_COUNTER;
        static OffsetCounter *MEMBER_COUNTER;

        OffsetCounter(osKind kind);

        virtual void reset(void);
        virtual void set(int offset);
        virtual int next(int value);
};

#endif /* !IR_OFFSET_H */
