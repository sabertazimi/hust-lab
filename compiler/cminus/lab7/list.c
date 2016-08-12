#include <stdlib.h>
#include "list.h"

List_t List_new (void *data, List_t tail)
{
  List_t p = malloc (sizeof (*p));
  p->data = data;
  p->next = tail;
  return p;
}
