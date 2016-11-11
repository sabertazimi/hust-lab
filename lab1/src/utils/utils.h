/*!
 * \file utils.h
 * \brief header file for utils.c
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#ifndef UTILS_H
#define UTILS_H

#undef DEBUG
#define DEBUG   ///< macro for enable/disable debug functions
// #undef DEBUG

typedef char *string;   ///< alias for char *

/// \brief a simple log function
/// \param fmt format string
/// \param ... output string
/// \return void
void logger(const char *fmt, ...);

/// \brief LOG: a simple marco encapsulating logger function
/// \param fmt format string
/// \param ... output string
/// \return void
#ifdef DEBUG
#define LOG(fmt, ...) do { logger(fmt,##__VA_ARGS__); } while (0)
#else
#define LOG(fmt, ...) do { ; } while (0)
#endif

#endif /* !UTILS_H */
