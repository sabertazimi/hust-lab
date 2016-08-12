#include <assert.h>
#include <stdio.h>
#include "new.h"
#include "re.h"
#include "todo.h"

#define EPS (-1)
#define NODES_MAXNUM 20

Re_t Re_Eps_new ()
{
  Re_Eps_t p;
  NEW(p);
  p->kind = RE_KIND_EPS;
  return (Re_t)p;
}

Re_t Re_Char_new (int c)
{
  Re_Char_t p;
  NEW(p);
  p->kind = RE_KIND_CHAR;
  p->c = c;
  return (Re_t)p;
}

Re_t Re_Concat_new (Re_t left, Re_t right)
{
  Re_Concat_t p;
  NEW(p);
  p->kind = RE_KIND_CONCAT;
  p->left = left;
  p->right = right;
  return (Re_t)p;
}

Re_t Re_Alt_new (Re_t left, Re_t right)
{
  Re_Alt_t p;
  NEW(p);
  p->kind = RE_KIND_ALT;
  p->left = left;
  p->right = right;
  return (Re_t)p;
}

Re_t Re_Closure_new (Re_t exp)
{
  Re_Closure_t p;
  NEW(p);
  p->kind = RE_KIND_CLOSURE;
  p->exp = exp;
  return (Re_t)p;
}

void Re_print (Re_t e)
{
  assert (e);
  switch (e->kind){
  case RE_KIND_EPS:
    printf ("\\eps");
    break;
  case RE_KIND_CHAR:{
    Re_Char_t p = (Re_Char_t)e;
    printf ("%d", p->c);
    break;
  }
  case RE_KIND_ALT:{
    Re_Alt_t p = (Re_Alt_t)e;
    printf ("(");
    Re_print (p->left);
    printf (") | (");
    Re_print (p->right);
    printf (")");
    break;
  }
  case RE_KIND_CONCAT:{
    Re_Concat_t p = (Re_Concat_t)e;
    printf ("(");
    Re_print (p->left);
    printf (")(");
    Re_print (p->right);
    printf (")");
    break;
  }
  case RE_KIND_CLOSURE:{
    Re_Closure_t p = (Re_Closure_t)e;
    printf ("(");
    Re_print (p->exp);
    printf (")*");
    break;
  }
  default:
    break;
  }
  return;
}

static int counter = 1;
static int nextNum ()
{
  return counter++;
}

static Nfa_t Re_thompsonDoit (Nfa_t nfa,Re_t e)
{
  assert (e);
  switch (e->kind){
  case RE_KIND_EPS:{
    int from = nextNum();
    int to = nextNum();
    Nfa_addEdge (nfa, from, to, EPS);
    nfa->start = from;
    nfa->accept = to;
    break;
  }
  case RE_KIND_CHAR:{
    Re_Char_t p = (Re_Char_t)e;
    int from = nextNum();
    int to = nextNum();
    Nfa_addEdge (nfa, from, to, p->c);
    nfa->start = from;
    nfa->accept = to;
    break;
  }
  case RE_KIND_ALT:{
    Re_Alt_t p = (Re_Alt_t)e;

    int from = nextNum();

    Re_thompsonDoit(nfa, p->left);
    int oldStart = nfa->start;
    int oldAccept = nfa->accept;

    Re_thompsonDoit(nfa, p->right);

    int to = nextNum();

    Nfa_addEdge(nfa, from, oldStart, EPS);
    Nfa_addEdge(nfa, from, nfa->start, EPS);
    Nfa_addEdge(nfa, oldAccept, to, EPS);
    Nfa_addEdge(nfa, nfa->accept, to, EPS);

    nfa->start = from;
    nfa->accept = to;
    break;
  }
  case RE_KIND_CONCAT:{
    Re_Concat_t p = (Re_Concat_t)e;
    Re_thompsonDoit (nfa, p->left);
    int oldStart = nfa->start;
    int oldAccept = nfa->accept;
    Re_thompsonDoit (nfa, p->right);
    Nfa_addEdge(nfa, oldAccept, nfa->start,
                EPS);
    nfa->start = oldStart;
    break;
  }
  case RE_KIND_CLOSURE:{
    Re_Closure_t p = (Re_Closure_t)e;

    int from = nextNum();

    Re_thompsonDoit(nfa, p->exp);

    int to = nextNum();

    Nfa_addEdge(nfa, nfa->accept, nfa->start, EPS);
    Nfa_addEdge(nfa, from, nfa->start, EPS);
    Nfa_addEdge(nfa, nfa->accept, to, EPS);
    Nfa_addEdge(nfa, from, to, EPS);

    nfa->start = from;
    nfa->accept = to;
    break;
  }
  default:
    break;
  }
  return nfa;
}

Nfa_t Re_thompson (Re_t e)
{
  Nfa_t nfa = Nfa_new ();
  counter = 1;
  Re_thompsonDoit (nfa, e);
  return nfa;
}

/*
 * Transfer NFA to DFA
 *
 */

static void dfs(Nfa_t nfa, int num, int closure) {
    Node_t node = nfa->nodes;

    while (node) {
        if (num == node->num) {
            node->closure = closure;
            node->visited = 1;
            Edge_t edge = node->edges;

            while (edge) {
                if (edge->to->visited == 0 && edge->c == EPS) {
                    dfs(nfa, edge->to->num, node->closure);
                }

                node = node->next;
            }
        }

        node = node->next;
    }
}

static int closure(Nfa_t nfa, int num) {
    int closure = nextNum();
    dfs(nfa, num, closure);
    return closure;
}

static int nfa_visited(Nfa_t nfa) {
    Node_t node = nfa->nodes;

    while (node) {
        if (node->closure == 0) {
            return 0;
        }
        node = node->next;
    }

    return 1;
}

Dfa_t Nfa_Dfa(Nfa_t nfa) {
    counter = 1;
    Node_t node;
    Edge_t edge;
    Dfa_t dfa = Dfa_new();
    int closure = closure(nfa, nfa->start);
    dfa->start = closure;

    while (!nfa_visited) {
        for (int i = 0; i < 255; i++) {
            node = nfa->nodes;
            while (node) {
                if (node->num == closure) {
                    edge = node->edge;
                    while (edge) {
                        if (edge->c == i) {
                            closure = closure(nfa, edge->to->num);
                            break;
                        }
                        edge = edge->next;
                    }
                }
                node = node->next;
            }
        }
    }
}
