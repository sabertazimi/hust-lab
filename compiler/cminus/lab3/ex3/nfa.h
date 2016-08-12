#ifndef NFA_H
#define NFA_H

typedef struct Node_t *Node_t;
typedef struct Nfa_t *Nfa_t;
struct Nfa_t
{
  int start;     // start node of an NFA
  int accept;    // accept node of an NFA
  Node_t nodes;  // a list of all nodes
};

Nfa_t Nfa_new ();
void Nfa_addEdge(Nfa_t nfa, int from, int to, int c);
void Nfa_print (Nfa_t nfa);

#endif
