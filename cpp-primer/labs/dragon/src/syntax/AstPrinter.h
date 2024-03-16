/*!
 * \file AstPrinter.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#ifndef SYNTAX_ASTPRINTER_H
#define SYNTAX_ASTPRINTER_H

#include <string>
#include <cstdarg>
#include <iostream>
#include <fstream>

using namespace std;

/// \brief printer helper class
///
/// with composite pattern and decorate pattern, enable every single class with AstPrinter as a memeber to
/// have capbility to print information into target stream(std/file)
///
class AstPrinter {
    public:
        int indent;     ///< current indent distance
        int step;       ///< increase/decrease step
        char buf[1000]; ///< string buffer
        ostream *out;   ///< outout stream
        ofstream fout;  ///< file stream

        /// \brief constructor
        /// \param void
        /// \return a AstPrinter instance
        AstPrinter(void);

        /// \brief constructor
        /// \param outfile change print target from std to file
        /// \return a AstPrinter instance
        AstPrinter(const char *outfile);

        /// \brief increase indent distance
        /// \param void
        /// \return void
        void incIndent(void);

        /// \brief decrease indent distance
        /// \param void
        /// \return void
        void decIndent(void);

        /// \brief write fmt str to outfile
        /// \param fmt format string
        /// \param ... output string
        /// \return void
        void print(const char *fmt, ...);

        /// \brief write string to outfile
        /// \param str output string
        /// \return void
        void print(string str);
};

#endif /* !SYNTAX_ASTPRINTER_H */
