#include <iostream>
#include "Node.h"
using namespace tree;

int main() {
    Node* tree= MAKE_TREE();
    printTree(tree, 0);
    return 0;
}