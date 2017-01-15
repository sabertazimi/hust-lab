/*!
 * \file spec.h
 * \brief header files for program testing
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016-09-30
 */

#ifndef SPEC_H
#define SPEC_H

#include <iostream>

using namespace std;

/// \brief ASSERTion macro
/// \param func name string of target function to test
/// \param cond assertion true condition
/// \param info information string to print when assertion failed
/// \return 1 stands for assertion passed, 0 stands for assertion failed
#define ASSERT(func, cond, info)                                                \
    do {                                                                        \
        if (!(cond)) {                                                          \
            cerr<<"[failed] - function <"<<(func)<<"> test: "<<(info);          \
            cerr<<" in file <"<<(__FILE__)<<">, line <"<<(__LINE__)<<"> !\n";   \
            return 0;                                                           \
        } else {                                                                \
            cout<<"[passed] - function <"<<(func)<<"> test.\n";                 \
        }                                                                       \
    } while (0)

/// \brief test function for postk
/// \return test passed(1) or failed(0)
int postk_spec(void);

/// \brief test function for oostk
/// \return test passed(1) or failed(0)
int oostk_spec(void);

/// \brief test function for stack
/// \return test passed(1) or failed(0)
int stack_spec(void);

/// \brief test function for que2s
/// \return test passed(1) or failed(0)
int que2s_spec(void);

/// \brief test function for queis
/// \return test passed(1) or failed(0)
int queis_spec(void);

#endif /* !SPEC_H */
