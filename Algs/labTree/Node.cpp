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
            return FIND_IN_TREE(key, LEFT(tree));
        else return FIND_IN_TREE(key, RIGHT(tree));
    }

    int FIND(data_type key, data_type data[], int n) {
        Node* tree = MAKE_TREE(data, n);
        return FIND_IN_TREE(key, tree);
    }

    void TLR(Node *tree) {
        if (tree == nullptr) return;
        cout << tree->data << " ";
        TLR(tree->left);
        TLR(tree->right);
    }

    void LTR(Node *tree) {
        if (tree == nullptr) return;
        LTR(tree->left);
        cout << tree->data << " ";
        LTR(tree->right);
    }

    void LRT(Node *tree) {
        if (tree == nullptr) return;
        LRT(tree->left);
        LRT(tree->right);
        cout << tree->data << " ";
    }
}