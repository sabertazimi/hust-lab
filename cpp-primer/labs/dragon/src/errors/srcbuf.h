/*!
 * \file srcbuf.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#ifndef ERRORS_SRCBUF_H
#define ERRORS_SRCBUF_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vector>

/// \brief create vector<char *> for srcbuf
/// \return void
void srcbuf_init(void);

/// \brief send new source code to buffer
/// \param src a new line of source code
/// \return void
void srcbuf_append(const char * src);

/// \brief get source code, with specific line number
/// \param num_line target line number
/// \return source code line
const char * srbuf_get(int num_line);

/// \brief get length of buffer
/// \return length of buffer
int srcbuf_length(void);

/// \brief print source code in buffer, with specific line number
/// \param num_line target line number
/// \return void
void srcbuf_print(int num_line);

#endif /* !ERRORS_SRCBUF_H */
