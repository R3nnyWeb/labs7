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
    void ADD_LEFT(Node*, data_type data);
    void ADD_RIGHT(Node* , data_type data);
    Node* MAKE_TREE();
}
