//
// Created by R3nny on 15.09.2023.
//
#pragma once
namespace tree {
    typedef int data_type;
    struct Node{
        data_type data;
        Node* left;
        Node* right;
        Node(data_type _data): data(_data), left(nullptr), right(nullptr){};
    };
    Node* LEFT(Node*);
    Node* RIGHT(Node*);
    Node* MAKE_TREE();
    Node* INSERT(Node* tree, data_type data);
    void printTree(Node& tree);
}
