//
// Created by R3nny on 15.09.2023.
//
#include "Node.h"
#include <iostream>

using namespace std;
namespace tree {


    Node *MAKE_TREE(data_type data[], int n) {
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
    int FIND_IN_TREE(data_type key, Node *tree){
        if (tree == nullptr) return -1;
        else if (INFO(tree) == key)
            return tree->index;
        else if (key < INFO(tree))
            FIND_IN_TREE(key, LEFT(tree));
        else FIND_IN_TREE(key, RIGHT(tree));
    }
    int FIND(data_type key, data_type data[], int n) {
        Node* tree = MAKE_TREE(data, n);
        return FIND_IN_TREE(key, tree);
    }

    void TLR(Node *tree, int level) {
        if (tree == nullptr) return;
        for (int i = 0; i < level; i++) cout << "=";
        cout << "> " << tree->data << endl;
        TLR(tree->left, level + 1);
        TLR(tree->right, level + 1);
    }

    void LTR(Node *tree, int level) {
        if (tree == nullptr) return;
        LTR(tree->left, level + 1);
        for (int i = 0; i < level; i++) cout << "=";
        cout << "> " << tree->data << endl;
        LTR(tree->right, level + 1);
    }

    void LRT(Node *tree, int level) {
        if (tree == nullptr) return;
        LRT(tree->left, level + 1);
        LRT(tree->right, level + 1);
        for (int i = 0; i < level; i++) cout << "=";
        cout << "> " << tree->data << endl;
    }
}