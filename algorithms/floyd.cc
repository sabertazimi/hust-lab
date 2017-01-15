/*!
 * \file router.cc
 * \brief No.4
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include <iostream>
#include <string>
#include <cstring>

#define LOCAL
// #undef LOCAL

#ifdef LOCAL
#include <fstream>
#endif

#define NODE_MAX 1000

using namespace std;

int n, m;   ///< n points, m edges

int edge[NODE_MAX][NODE_MAX];
int path[NODE_MAX][NODE_MAX];

void print(void) {
    cout << "edge: " << endl;

    for (int i = 0; i < n; i++) {
        for (int j = i+1; j < n; j++) {
            if (i != j) {
                cout << i << "->" << j << ": " << edge[i][j] << endl;
            }
        }
    }

    cout << "path: " << endl;

    for (int i = 0; i < n; i++) {
        for (int j = i+1; j < n; j++) {
            int start = i, end = j;
            while (start != end){
                cout << start << "->";
                start = path[start][end];
            }
            cout << end << endl;

        }
    }
}

int main(void) {
#ifdef LOCAL
    freopen("input.dat", "r", stdin);
#endif

    while (cin >> n >> m) {

        // initialization
        memset(edge, -1, sizeof(edge));
        memset(path, 0, sizeof(path));

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                edge[i][j] = -1;
                path[i][j] = j;
            }
        }

        for (int i = 0; i < n; i++) {
            edge[i][i] = 0;
        }

        for (int i = 0; i < m; i++) {
            int x, y, v;
            cin >> x >> y >> v;
            edge[x][y] = v;
            edge[y][x] = v;
        }

        for (int k = 0; k < n; k++) {
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    if (edge[i][k] == -1 || edge[k][j] == -1) {
                        continue;
                    }

                    if (edge[i][j] == -1 || edge[i][k] + edge[k][j] < edge[i][j]) {
                        edge[i][j] = edge[i][k] + edge[k][j];
                        path[i][j] = path[i][k];
                    }
                }
            }
        }

        print();
    }

    return 0;
}
