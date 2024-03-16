/*!
 * \file List.h
 * \brief
 *
 * \author sabertazimi, <sabertazimi@gmail.com>
 * \version 1.0
 * \date 2016
 * \license MIT
 */

#ifndef LIBS_LIST_H
#define LIBS_LIST_H

#include <iostream>
#include <deque>

using namespace std;

/// \brief list data structure for modules
///
/// this template get used for almost every module of dragon compiler
///
template <class Element>
class List {
    public:
        deque <Element> elems;      ///< deque container

        /// \brief create a new empty list
        /// \return a List<T> instance
        List(void) {
        }

        /// \brief number of elements
        /// \return size of list
        int size(void) {
            return elems.size();
        }

        /// \breif get element at index
        /// \param index index
        /// \return List[index]
        Element operator[](int index) {
            if (index < 0 || index >= size()) {
                cerr << "Subscript out of range" << endl;
                return 0;
            } else {
                return elems[index];
            }
        }

        /// \brief insert element at index
        /// \param elem element to insert
        /// \param index index
        /// \return void
        void insertAt(const Element &elem, int index) {
            if (index < 0 || index >= size()) {
                cerr << "Subscript out of range" << endl;
            } else {
                elems.insert(elems.begin() + index, elem);
            }
        }

        /// \brief remove element at index
        /// \param index index
        /// \return void
        void removeAt(int index) {
            if (index < 0 || index >= size()) {
                cerr << "Subscript out of range" << endl;
            } else {
                elems.erase(elems.begin() + index);
            }
        }

        /// \brief append element at the tail of list
        /// \param elem element to append
        /// \return void
        void append(const Element &elem) {
            elems.push_back(elem);
        }

        /// \brief pop element at index size()-1
        /// \return element poped
        Element pop(void) {
            Element tmp = (*this)[this->elems.size()-1];
            elems.erase(elems.begin() + this->size() - 1);
            return tmp;
        }
};

#endif				/* !LIBS_LIST_H */
