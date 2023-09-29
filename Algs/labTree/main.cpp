#include <iostream>
#include "Node.h"
using namespace tree;

int main() {
    Node* root= MAKE_TREE();
    printTree(root, 0);
    Node* found = FIND(9, root);
    std::cout<<found<<std::endl;
    Node* notfound = FIND(10, root);
    std::cout<<notfound<<std::endl;
    return 0;
}