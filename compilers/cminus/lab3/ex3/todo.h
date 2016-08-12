#ifndef TODO_H
#define TODO_H

#define TODO()                                          \
  do{                                                   \
    printf ("\nAdd your code here: file \"%s\", line %d\n", \
            __FILE__, __LINE__);                        \
    exit (0);                                           \
  }                                                     \
  while(0)

#endif
