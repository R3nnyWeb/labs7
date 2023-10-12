//
// Created by R3nny on 15.09.2023.
//
#pragma once
namespace tree {
    typedef int data_type;
    struct Node{
        data_type data;
        int index;
        Node* left;
        Node* right;
        Node(data_type _data, int _index): data(_data),index(_index), left(nullptr), right(nullptr){};
    };
    Node* LEFT(Node* node);
    Node* RIGHT(Node* node);
    data_type INFO(Node* node);
    int FIND(data_type key, data_type data[], int n);
    Node* MAKE_TREE(data_type data[], int n);
    Node* INSERT(Node* tree, data_type data, int index);
    void TLR(Node* tree, int level);
    void LTR(Node* tree, int level);
    void LRT(Node* tree, int level);
}
