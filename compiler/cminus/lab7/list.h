#ifndef LIST_H
#define LIST_H

typedef struct List_t *List_t;
struct List_t
{
  void *data;
  List_t next;
};

List_t List_new (void *data, List_t tail);


#endif
