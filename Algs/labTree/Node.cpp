//
// Created by R3nny on 15.09.2023.
//
#include "Node.h"

namespace tree {
    void INSERT(const data_type *data, Node &root, int i);

    Node *MAKE_TREE() {
        data_type data[] = {2, 5, 6, 1, -1, 7, 2};
        int n = 7;
        Node root = Node(data[0]);

        for (int i = 1; i < n; i++) {
            INSERT(&root, data[i]);
        }
    }

    Node* INSERT(Node *tree, data_type data) {
        if (tree == nullptr) {
            return new Node(data);
        } else if (data < tree->data) {
            tree->left = INSERT(tree->left, data);
        } else if (data > tree->data) {
            tree->right = INSERT(tree->right, data);
        } else throw "Repeat keys";
        return tree;
    }
}