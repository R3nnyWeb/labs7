//
// Created by R3nny on 15.09.2023.
//
#pragma once
namespace tree {
    typedef int data_type;
    struct Tree{
        data_type data;
        Tree* left;
        Tree* right;
        Tree(data_type _data): data(_data), left(nullptr), right(nullptr){}
    }
}
