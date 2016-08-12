#ifndef FA_H
#define FA_H

typedef struct Node_t *Node_t;
typedef struct Nfa_t *Nfa_t;
typedef struct Nfa_t *Dfa_t;
typedef struct Edge_t *Edge_t;

struct Nfa_t
{
  int start;     // start node of an NFA
  int accept;    // accept node of an NFA
  Node_t nodes;  // a list of all nodes
};

struct Node_t
{
  int num;
  int visited;
  int closure;
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

Nfa_t Nfa_new ();
void Nfa_addEdge(Nfa_t nfa, int from, int to, int c);
void Nfa_print (Nfa_t nfa);
Dfa_t Dfa_new ();
void Dfa_addEdge(Dfa_t dfa, int from, int to, int c);
void Dfa_print (Dfa_t dfa);

#endif
