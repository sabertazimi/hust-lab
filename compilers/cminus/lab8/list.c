#include <stdlib.h>
#include "list.h"

List_t List_new (void *data, List_t tail)
{
  List_t p = malloc (sizeof (*p));
  p->data = data;
  p->next = tail;
  return p;
}

List_t List_rev (List_t l)
{
  List_t p = 0;
  while (l){
    p = List_new (l->data, p);
    l = l->next;
  }
  return p;
}

