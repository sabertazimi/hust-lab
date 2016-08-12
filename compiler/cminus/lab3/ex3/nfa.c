#include <assert.h>
#include <stdio.h>
#include "nfa.h"
#include "new.h"

typedef struct Edge_t *Edge_t;
struct Node_t
{
  int num;
  int visited;
  Edge_t edges;
  Node_t next;
};

struct Edge_t
{
  int c;
  Node_t from;
  Node_t to;
  Edge_t next;
};



// list head insert
static Node_t Node_new (int num, Node_t n)
{
  Node_t p;
  NEW(p);
  p->num = num;
  p->visited = 0;
  p->edges = 0;
  p->next = n;
  return p;
}

static Edge_t Edge_new (Node_t from
                        , Node_t to
                        , int c
                        , Edge_t edge)
{
  Edge_t p;
  NEW(p);
  p->c = c;
  p->from = from;
  p->to = to;
  p->next = edge;
  return p;
}

Nfa_t Nfa_new ()
{
  Nfa_t p;
  NEW(p);
  p->start = -1;
  p->accept = -1;
  p->nodes = 0;
  return p;
}

// lookup a node "num" in the nfa and return
// it; if that
// node does not exist, create a fresh one
// and return it.
Node_t Nfa_lookupOrInsert (Nfa_t nfa, int num)
{
  assert (nfa);
  Node_t nodes = nfa->nodes;
  while (nodes){
    if (nodes->num == num)
      return nodes;
    nodes = nodes->next;
  }
  Node_t p = Node_new (num, nfa->nodes);
  nfa->nodes = p;
  return p;
}

void Nfa_addEdge(Nfa_t nfa, int from, int to, int c)
{
  Node_t f = Nfa_lookupOrInsert (nfa, from);
  Node_t t = Nfa_lookupOrInsert (nfa, to);
  f->edges = Edge_new (f, t, c, f->edges);
  return;
}

void Nfa_print (Nfa_t nfa)
{
  assert (nfa);
  Node_t nodes = nfa->nodes;
  assert (nodes);
  while (nodes){
    Edge_t edges = nodes->edges;
    while (edges){
      printf ("%d ----(%d)----> %d\n"
              , edges->from->num
              , edges->c
              , edges->to->num);
      edges = edges->next;
    }
    nodes = nodes->next;
  }
  return;
}
