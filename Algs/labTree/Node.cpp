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
        Node *root = new Node(data[0]);

        for (int i = 1; i < n; i++) {
            INSERT(root, data[i]);
        }
        return root;
    }

    Node *INSERT(Node *tree, data_type data) {
        if (tree == nullptr) {
            return new Node(data);
        } else if (data < tree->data) {
            tree->left = INSERT(tree->left, data);
        } else if (data > tree->data) {
            tree->right = INSERT(tree->right, data);
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

    Node *FIND(data_type key, Node *tree) {
        if (tree == nullptr) return nullptr;
        else if (INFO(tree) == key)
            return tree;
        else if (key < INFO(tree))
            FIND(key, LEFT(tree));
        else FIND(key, RIGHT(tree));
    }

    void TLR(Node *tree, int level) {
        if (tree == nullptr) return;
        for (int i = 0; i < level; i++) cout << "=";
        cout << "> " << tree->data << endl;
        TLR(tree->left, level + 1);
        TLR(tree->right, level + 1);
    }
    void LTR(Node* tree, int level) {
        if (tree == nullptr) return;
        LTR(tree->left, level + 1);
        for (int i = 0; i < level; i++) cout << "=";
        cout << "> " << tree->data << endl;
        LTR(tree->right, level + 1);
    }
    void LRT(Node* tree, int level) {
        if (tree == nullptr) return;
        LRT(tree->left, level + 1);
        LRT(tree->right, level + 1);
        for (int i = 0; i < level; i++) cout << "=";
        cout << "> " << tree->data << endl;
    }
}