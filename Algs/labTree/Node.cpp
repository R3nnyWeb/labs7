//
// Created by R3nny on 15.09.2023.
//
#include "Node.h"
#include <iostream>

using namespace std;
namespace tree {


    Node *MAKE_TREE() {
        data_type data[] = {2, 5, 6, 1, -1, 7, 9};

        int n = 7;
        Node *root = new Node(data[0], 0);

        for (int i = 1; i < n; i++) {
            INSERT(root, data[i], i);
        }
        return root;
    }

    Node *INSERT(Node *tree, data_type data, int index) {
        if (tree == nullptr) {
            return new Node(data, index);
        } else if (data < tree->data) {
            tree->left = INSERT(tree->left, data, index);
        } else if (data > tree->data) {
            tree->right = INSERT(tree->right, data, index);
        } else throw "Repeat keys";
        return tree;
    }


    Node *LEFT(Node *node) {
        return node->left;
    }

    Node *RIGHT(Node *node) {
        return node->right;
    }

    data_type INFO(Node *node) {
        return node->data;
    }

    data_type FIND(data_type key, Node *tree) {
        if (tree == nullptr) return -1;
        else if (INFO(tree) == key)
            return tree->index;
        else if (key < INFO(tree))
            FIND(key, LEFT(tree));
        else FIND(key, RIGHT(tree));
    }

    void printTree(Node *tree, int level) {
        if (tree == nullptr) return;
        for (int i = 0; i < level; i++) cout << "=";
        cout << "> " << tree->data << endl;
        printTree(tree->left, level + 1);
        printTree(tree->right, level + 1);
    }
}