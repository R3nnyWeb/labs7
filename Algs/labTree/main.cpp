#include <iostream>
#include "Node.h"

using namespace tree;
using namespace std;

int main() {
    int n = 7;
    int data[] = {2, 5, 7, 1, -1, 9, 6};
    int found = FIND(6, data, n);
    int notFound = FIND(99, data, n);
    cout << found << endl;
    cout << notFound << endl;

    Node *tree = MAKE_TREE(data, n);
    LRT(tree);
    return 0;
}