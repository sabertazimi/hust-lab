/*************************************************************************
 *
 *  C-to-C Translator
 *
 *  Adapted from Clean ANSI C Parser
 *  Eric A. Brewer, Michael D. Noakes
 *  
 *  list.c,v
 * Revision 1.8  1995/04/21  05:44:25  rcm
 * Cleaned up data-flow analysis, and separated into two files, dataflow.c
 * and analyze.c.  Fixed void pointer arithmetic bug (void *p; p+=5).
 * Moved CVS Id after comment header of each file.
 *
 * Revision 1.7  1995/04/09  21:30:45  rcm
 * Added Analysis phase to perform all analysis at one place in pipeline.
 * Also added checking for functions without return values and unreachable
 * code.  Added tests of live-variable analysis.
 *
 * Revision 1.6  1995/02/13  02:00:10  rcm
 * Added ASTWALK macro; fixed some small bugs.
 *
 * Revision 1.5  1995/02/01  07:37:30  rcm
 * Renamed list primitives consistently from '...Element' to '...Item'
 *
 * Revision 1.4  1995/01/06  16:48:49  rcm
 * added copyright message
 *
 * Revision 1.3  1994/12/20  09:24:01  rcm
 * Added ASTSWITCH, made other changes to simplify extensions
 *
 * Revision 1.2  1994/10/28  18:52:25  rcm
 * Removed ALEWIFE-isms.
 *
 *
 *  Created: Sat Apr 24 19:25:07 EDT 1993
 *
 *
 *
 * Copyright (c) 1994 MIT Laboratory for Computer Science
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE MIT LABORATORY FOR COMPUTER SCIENCE BE LIABLE
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * Except as contained in this notice, the name of the MIT Laboratory for
 * Computer Science shall not be used in advertising or otherwise to
 * promote the sale, use or other dealings in this Software without prior
 * written authorization from the MIT Laboratory for Computer Science.
 * 
 *************************************************************************/
#if 0
#pragma ident "list.c,v 1.8 1995/04/21 05:44:25 rcm Exp Copyright 1994 Massachusetts Institute of Technology"
#endif

#include "basics.h"

/* node definition of struct List only appears in this file;
   this enforces modularity */

struct liststruct {
    Generic *element;
    struct liststruct *next;
};

GLOBAL Generic *FirstItem(List *list)
{
    assert(list != NULL);
    return(list->element);
}

GLOBAL Generic *LastItem(List *list)
{ ListMarker marker;
  Node *item;

  assert(list != NULL);

  IterateList(&marker, list);
  while (NextOnList(&marker, (GenericREF) &item))
    ;

  return item;
}

GLOBAL List *Rest(List *list)
{ 
  assert(list != NULL);
  return list->next; 
}

GLOBAL List *Last(List *list)
{
  if (list == NULL) return list;

  while (list->next != NULL)
    list = list->next;

  return list;
}

GLOBAL int ListLength(List *list)
{ ListMarker marker;
  Node *item;
  int length;

  IterateList(&marker, list);
  for (length = 0; NextOnList(&marker, (GenericREF) &item); length++)
    ;

  return length;
}

GLOBAL Generic *SetItem(List *list, Generic *element)
{
    assert(list != NULL);
    list->element = element;
    return element;
}

GLOBAL void My213SetItem(List *list, Generic *element)
{
    assert(list != NULL);
    list->element = element;
    list->next = NULL;
}

GLOBAL List *MakeNewList(Generic *item)
{
    List *create = HeapNew(List);
    create->element = item;
    create->next = NULL;
    return(create);
}

GLOBAL List *ConsItem(Generic *item, List *list)
{ List *el = MakeNewList(item);

  el->next = list;
  return el;
}

GLOBAL List *AppendItem(List *list, Generic *item)
{ List *tail = MakeNewList(item);

  if (list == NULL)
    return tail;
  else
    return JoinLists(list, tail);
}

/* fix: this is slow... */
GLOBAL List *JoinLists(List *list1, List *list2)
{
    List *last = Last(list1);

    if (last == NULL) return list2;
    last->next = list2;
    return(list1);
}


GLOBAL List *ListCopy(List *list)
{
  List *new;
  List **plast = &new;
  List *tmp;
  
  while (list) {
    tmp = HeapNew(List);
    tmp->element = list->element;
    *plast = tmp;

    list = list->next;
    plast = &tmp->next;
  }
    
  *plast = NULL;
  return new;
}



GLOBAL List *List2(Generic *x1, Generic *x2)
{
  return ConsItem(x1, MakeNewList(x2));
}

GLOBAL List *List3(Generic *x1, Generic *x2, Generic *x3)
{
  return ConsItem(x1, ConsItem(x2, MakeNewList(x3)));
}

GLOBAL List *List4(Generic *x1, Generic *x2, Generic *x3, Generic *x4)
{
  return ConsItem(x1, ConsItem(x2, ConsItem(x3, MakeNewList(x4))));
}

GLOBAL List *List5(Generic *x1, Generic *x2, Generic *x3, Generic *x4, Generic *x5)
{
  return ConsItem(x1, ConsItem(x2, ConsItem(x3, ConsItem(x4, MakeNewList(x5)))));
}


GLOBAL void IterateList(ListMarker *marker, List *list)
{
    marker->first   = list;  /* useful for when I switch to circular lists */
    marker->current = NULL;
    marker->tail = NULL;
}

GLOBAL Bool NextOnList(ListMarker *marker, GenericREF handle)
{
  if (marker == NULL) 
    return FALSE;
  else if (marker->current == NULL)
    if (marker->first == NULL)
      return FALSE;
    else {
      marker->current = marker->first;
    }
  else if (marker->current->next) {
    marker->current = marker->current->next;
  }
  else if (marker->tail) {
    /* reconnect temporary split caused by NextChunkOnList */
    marker->current->next = marker->tail;
    marker->tail = NULL;

    marker->current = marker->current->next;
  }
  else return FALSE;

  *handle = marker->current->element;
  return TRUE;
}

/* Requires that previous NextOnList(marker) returned true. */
GLOBAL void SetCurrentOnList(ListMarker *marker, Generic *handle)
{
  assert(marker && marker->current);
  marker->current->element = handle;
}

/* Terminate the current list after the point and return the tail.
   Requires that previous NextOnList(marker) returned true. */
GLOBAL List *SplitList(ListMarker *marker)
{ List *tail;

  assert(marker && marker->current);
  tail = (marker->current)->next;
  (marker->current)->next = NULL;
  return tail;
}

/* Insert sublist before the point. Returns beginning of whole list
   being iterated. */
GLOBAL List *InsertList(ListMarker *marker, List *sublist)
{ 
  if (!marker->current) {
    /* point is before beginning of list */
    marker->current = Last(sublist);
    marker->first = JoinLists(sublist, marker->first);
  }
  else {
    List *prev;

    for (prev = marker->first; 
	 prev != NULL && prev->next != marker->current;
	 prev = prev->next)
      ;
    if (prev == NULL) 
      marker->first = JoinLists(sublist, marker->first);
    else prev->next = JoinLists(sublist, prev->next);
  }

  return marker->first;
}

/* Inserts sublist after point (so sublist will be iterated in subsequent
   calls to NextOnList).  Returns whole list being iterated. */
GLOBAL List *SpliceList(ListMarker *marker, List *sublist)
{
  if (!marker->current) {
    /* point is before beginning of list */
    marker->first = JoinLists(sublist, marker->first);
  }
  else {
    marker->current->next = JoinLists(sublist, marker->current->next);
  }

  return marker->first;
}

/* FindItem returns sublist whose head is item, or NULL if item not
   found in list. */
GLOBAL List *FindItem(List *list, Generic *item)
{
  while (list) {
    if (item == list->element)
      return list;
    list = list->next;
  }
  return NULL;
}

/* RemoveItem mutates list to remove first item matching <item>.  Does nothing
   if <item> not found. */
GLOBAL List *RemoveItem(List *list, Generic *item)
{
  List *prev = NULL;
  List *curr = list;

  while (curr) {
    if (item == curr->element) {
      if (prev) 
	prev->next = curr->next;
      else 
	list = curr->next;
      break;
    }
    prev = curr;
    curr = curr->next;
  }
  return list;
}

/* Splits off at most <chunksize> elements starting at point into a temporarily
   NULL-terminated list.  (Subsequent NextOnList or NextChunkOnList call will
   re-connect the separated list.)  If fewer than chunksize elements remain
   to be iterated, will return all of them. */
GLOBAL List *NextChunkOnList(ListMarker *m, int chunksize)
{
  Generic *trash;
  List *chunk_begin = m->current ? m->current->next : m->first;
  int i;

  if (chunksize == 0)
    return NULL;

  i = 0;
  while (i < chunksize && NextOnList(m, &trash))
    ++i;

  /* Terminate list after point */
  if (m->current) {
    m->tail = (m->current)->next;
    (m->current)->next = NULL;    
  }

  assert(ListLength(chunk_begin) <= chunksize);
  return chunk_begin;
}
