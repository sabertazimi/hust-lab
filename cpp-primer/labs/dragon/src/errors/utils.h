/*!
 * \file utils.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#ifndef ERRORS_UTILS_H
#define ERRORS_UTILS_H

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include "location.h"
#include "errors/srcbuf.h"

/// \brief print error information
/// \param loc location information
/// \param fmt format string
/// \param ... more string to output
/// \return void
void dragon_report(yyltype *loc, const char *fmt, ...);

/// \brief simple logger function
/// \param fmt format string
/// \param ... more string to output
/// \return void
void dragon_log(const char *fmt, ...);

#endif /* !ERRORS_UTILS_H */
