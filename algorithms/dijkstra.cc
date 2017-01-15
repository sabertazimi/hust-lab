/*!
 * \file dijkstra.cc
 * \brief Hust Algorithm Lab
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include <cstdlib>
#include <climits>
#include <iostream>
#include <vector>
#include <set>

#define LOCAL
// #undef LOCAL

#ifdef LOCAL
#include <fstream>
#endif

using namespace std;

class Node {
public:
    int dist;
    int parent;

    Node(int dist = -1, int parent = -1) {
        this->dist = dist;
        this->parent = parent;
    }
};

/// \brief implementation of dijkstra algorithm
///
/// start node: No.0
///
/// \param nodes nodes array
/// \param edges map matrix
/// \return void
void dijkstra(vector<Node *> &nodes, int **edges) {
    int n = nodes.size();
    set<int> S;
    S.insert(0);

    while ((int)S.size() < n) {
        int minDist = INT_MAX;
        int minNode = 0;

        // find node closest to S set
        for (int i = 0; i < n; i++) {
            // node i is not in S set
            if (S.find(i) == S.end() && nodes[i]->dist != -1 && minDist > nodes[i]->dist) {
                minDist = nodes[i]->dist;
                minNode = i;
            }
        }

        // insert minNode into S set
        S.insert(minNode);

        for (int i = 0; i < n; i++) {
            // relax: update distance between nodes not in S set to S set after inserting minNode
            // constraint: node not in S set; edges[minNode][i] != infinite
            // update condition: nodes[i]->dist == infinite; nodes[i]->dist > nodes[minNode]->dist + edges[minNode][i]
            if (S.find(i) == S.end() && edges[minNode][i] != -1 &&
                    (nodes[i]->dist > nodes[minNode]->dist + edges[minNode][i]
                    || nodes[i]->dist == -1)) {
                nodes[i]->dist = nodes[minNode]->dist + edges[minNode][i];
                nodes[i]->parent = minNode;
            }
        }
    }
}

void createGraph(vector<Node *> &nodes, int **edges, int n, int m) {
    // initialize map matrix, set distance of every edge to -1(infinite)
    for (int j = 0; j < n; j++) {
        edges[j] = (int *)malloc(sizeof(int) * n);

        for (int k = 0; k < n; k++) {
            edges[j][k] = -1;
        }
    }

    // get map matrix from input
    for (int j = 0; j < m; j++) {
        int s, t, d;
        cin >> s >> t >> d;
        edges[s][t] = d;
    }

    // set distance of self node to 0
    for (int j = 0; j < n; j++) {
        edges[j][j] = 0;
    }

    // initialize dist and parent information of nodes, by map matrix
    for (int j = 0; j < n; j++) {
        if (edges[0][j] != -1) {
            nodes[j] = new Node(edges[0][j], 0);
        } else {
            nodes[j] = new Node(-1, -1);
        }
    }
}

void outputPaths(vector<Node *> &nodes, int **edges, int n) {
    cout << "map: " << endl;
    for (int j = 0; j < n; j++) {
        for (int k = 0; k < n; k++) {
            if (edges[j][k] != -1) {
                cout << edges[j][k] << "\t";
            } else {
                cout << "x\t";
            }
        }
        cout << endl;
    }

    cout << "shortest paths:" << endl;
    for (int j = 1; j < n; j++) {
        // put path into path vector
        int parent = j;
        vector<int> path;
        while (parent != 0) {
            path.insert(path.begin(), parent);
            parent = nodes[parent]->parent;
        }

        // print shortest path
        cout << "0 - " << j << ": 0";
        for (int k = 0; k < (int)path.size(); k++) {
            cout << "-" << path[k];
        }
        cout << "\t" << nodes[j]->dist << endl;
    }
}

int main(void) {
#ifdef LOCAL
    freopen("input.dat", "r", stdin);
#endif

    int n;  ///< number of nodes
    int m;  ///< number of edges

    while (cin >> n >> m) {
        vector<Node *> nodes(n);
        int **edges = (int **)malloc(sizeof(int *) * n);

        // create nodes vector and map matrix by data from input
        createGraph(nodes, edges, n, m);

        // invoke dijkstra algorithm
        dijkstra(nodes, edges);

        // print shortest paths
        outputPaths(nodes, edges, n);
        cout << endl;

        // free heap memory
        for (int j = 0; j < n; j++) {
            delete nodes[j];
        }

        // free heap memory;
        for (int j = 0; j < n; j++) {
            delete edges[j];
        }
        delete edges;
    }

    return 0;
}
