/*!
 * \file AstPrinter.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include "syntax/AstPrinter.h"

using namespace std;

AstPrinter::AstPrinter(void) {
    indent = 0;
    step = 4;
    out = &cout;
}

AstPrinter::AstPrinter(const char *outfile) {
    indent = 0;
    step = 4;
    fout.open(outfile);
    out = &fout;
}

void AstPrinter::incIndent(void) {
    indent += step;
}

void AstPrinter::decIndent(void) {
    indent -= step;
}

void AstPrinter::print(const char *fmt, ...) {
    for (int i = 0; i < indent; i++) {
        *out << " ";
    }

    // output
    va_list args;
    va_start(args, fmt);
    vsnprintf(buf, 1000, fmt, args);
    va_end(args);
    *out << buf << endl;
}

void AstPrinter::print(string str) {
    for (int i = 0; i < indent; i++) {
        *out << " ";
    }

    *out << str << endl;
}
