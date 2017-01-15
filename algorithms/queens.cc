/*!
 * \file queens.cc
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#include <iostream>
#include <cmath>

using namespace std;

class Queen {
    private:
        int n;              ///< n Queens' problem
        int *cols;          ///< store column number of each row queen
        bool existSolution; ///< existence of solution for n queen's problem

        /// \brief bounding function
        /// \param depth row number of current queen
        /// \param col try to place queen[depth] to col column
        /// \return success or failure of placing
        bool place(int depth, int col) {
            // same line or diagonal
            for (int i = 1; i < depth; i++) {
                if (cols[i] == cols[depth] || abs(i - depth) == abs(cols[i] - col)) {
                    return false;
                }
            }

            // success of placing
            return true;
        }

        /// \brief solution function
        /// \return void
        void solution(void) {
            int depth = 1;  ///< number of current queen to place

            while (depth > 0) {
                cols[depth]++;

                if (depth > n) {
                    existSolution = true;
                    return ;
                } else {
                    // search place
                    while (cols[depth] <= n && !place(depth, cols[depth])) {
                        cols[depth]++;
                    }

                    if (cols[depth] <= n) {
                        // success
                        // place next queen
                        depth++;
                    } else {
                        // failure
                        // backtracking
                        cols[depth] = 0;
                        depth--;
                    }
                }
            }
        }

    public:
        Queen(int nn) {
            n = nn;
            existSolution = false;
            cols = new int[n+1];

            for (int i = 0; i < n + 1; i++) {
                cols[i] = 0;
            }
        }
        
        ~Queen(void) {
            n = 0;
            existSolution = false;
            delete []cols;
        }

        /// \brief get existence of solution for n queens' problem
        /// \return existence of solution
        bool getSolution(void) {
            existSolution = false;
            solution();
            return existSolution;
        }

        /// \brief print solution(array) for n queens' problem
        /// \return void
        void printSolution(void) {
            cout << n << " queens' problem: " << endl;
            cout << (existSolution ? "true - " : "false - ");

            for (int i = 1; i <= n;i++) {
                cout << cols[i] << " ";
            }

            cout << endl;
        }
};

int main(void) {
    int n;
    cin >> n;

    for (int i = 1; i <= n; i++) {
        Queen q(i);
        q.getSolution();
        q.printSolution();
    }

    return 0;
}
