#include "ast.h"  
#include "check.h"

/* 
 * legallist.c - Null-terminated list of programming rules for the 
 *    standard set of Data Lab functions. If you want to add new 
 *    functions, this is the only dlc file in this directory that you 
 *    need to modify.
 *
 *    See y.tab.h for the names of the multi-character operators such
 *    as LS (left shift) and RS (right shift)
 */

#if 0  
/* Here is the definition and meaning of each entry (see check.h) */
struct legallist {
    char name[MAXSTR]; /* legal function name */
    int whatsok;       /* Mask indicating what language features are allowed */
    int maxops;        /* max operators for this function */
    int ops[MAXOPS];   /* null-terminated list of legal operators for this function.  '$' is wildcard */
};
#endif 

struct legallist legallist[MAXFUNCS] = {
    {{"absVal"}, 0, 10, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"addOK"}, 0, 20, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"allEvenBits"}, 0, 12, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"allOddBits"}, 0, 12, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"anyEvenBit"}, 0, 12, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"anyOddBit"}, 0, 12, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"bang"}, 0, 12, {'~', '&', '^', '|', '+', LS, RS, 0}},
    {{"bitAnd"}, 0, 8, {'~', '|', 0}},
    {{"bitCount"}, 0, 40, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"bitMask"}, 0, 16, {'!', '~', '&', '^', '|', '+', LS, RS, 0}},
    {{"bitNor"}, 0, 8, {'~', '&', 0}},
    {{"bitOr"}, 0, 8, {'~', '&', 0}},
    {{"bitParity"}, 0, 20, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"bitXor"}, 0, 14, {'~', '&', 0}},
    {{"byteSwap"}, 0, 25, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"conditional"}, 0, 16, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"copyLSB"}, 0, 5, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"divpwr2"}, 0, 15, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"evenBits"}, 0, 8, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"ezThreeFourths"}, 0, 12, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"fitsBits"}, 0, 15, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"fitsShort"}, 0, 8, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"float_abs"}, (BIGCONST_OK|CONTROL_OK|OTHERINT_OK), 10, {'$', 0}},
    {{"float_f2i"}, (BIGCONST_OK|CONTROL_OK|OTHERINT_OK), 30, {'$', 0}},
    {{"float_half"}, (BIGCONST_OK|CONTROL_OK|OTHERINT_OK), 30, {'$', 0}},
    {{"float_i2f"}, (BIGCONST_OK|CONTROL_OK|OTHERINT_OK), 30, {'$', 0}},
    {{"float_neg"}, (BIGCONST_OK|CONTROL_OK|OTHERINT_OK), 10, {'$', 0}},
    {{"float_twice"}, (BIGCONST_OK|CONTROL_OK|OTHERINT_OK), 30, {'$', 0}},
    {{"getByte"}, 0, 6, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"greatestBitPos"}, 0, 70, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"howManyBits"}, 0, 90, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"ilog2"}, 0, 90, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"implication"}, 0, 5, {'~', '!', '^', '|', 0}},
    {{"isAsciiDigit"}, 0, 15, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"isEqual"}, 0, 5, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"isGreater"}, 0, 24, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"isLess"}, 0, 24, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"isLessOrEqual"}, 0, 24, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"isNegative"}, 0, 6, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"isNonNegative"}, 0, 6, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"isNonZero"}, 0, 10, {'~', '&', '^', '|', '+', LS, RS, 0}},
    {{"isNotEqual"}, 0, 6, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"isPositive"}, 0, 8, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"isPower2"}, 0, 20, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"isTmax"}, 0, 10, {'~', '&', '!', '^', '|', '+', 0}},
    {{"isTmin"}, 0, 10, {'~', '&', '!', '^', '|', '+', 0}},
    {{"isZero"}, 0, 2, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"leastBitPos"}, 0, 6, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"leftBitCount"}, 0, 50, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"logicalNeg"}, 0, 12, {'~', '&', '^', '|', '+', LS, RS, 0}},
    {{"logicalShift"}, 0, 20, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"minusOne"}, 0, 2, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"multFiveEighths"}, 0, 12, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"negate"}, 0, 5, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"oddBits"}, 0, 8, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"rempwr2"}, 0, 20, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"replaceByte"}, 0, 10, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"reverseBytes"}, 0, 25, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"rotateLeft"}, 0, 25, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"rotateRight"}, 0, 25, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"satAdd"}, 0, 30, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"satMul2"}, 0, 20, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"satMul3"}, 0, 25, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"sign"}, 0, 10, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"sm2tc"}, 0, 15, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"subOK"}, 0, 20, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"tc2sm"}, 0, 15, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"thirdBits"}, 0, 8, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"tmax"}, 0, 4, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"tmin"}, 0, 4, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"trueFiveEighths"}, 0, 25, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"trueThreeFourths"}, 0, 20, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{"upperBits"}, 0, 10, {'~', '&', '!', '^', '|', '+', LS, RS, 0}},
    {{0} , 0, 0, {0}} /* end of list */
};

