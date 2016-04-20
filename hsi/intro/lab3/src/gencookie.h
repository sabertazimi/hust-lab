
/* Generate "cookie" from a string, i.e., a number that
   is not likely to match one generated for a different string.

   We require cookies to have properties that make it possible to
   receive them embedded in strings.  In particular, none of the bytes
   of a cookie can match the ASCII code for '\n'.
*/

unsigned gencookie(char *s);



