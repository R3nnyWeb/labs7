#include <iostream>
#include "Node.h"
using namespace tree;

int main() {
    Node* root= MAKE_TREE();
    printTree(root, 0);
    int found = FIND(9, root);
    std::cout<<found<<std::endl;
    int notfound = FIND(10, root);
    std::cout<<notfound<<std::endl;
    return 0;
}