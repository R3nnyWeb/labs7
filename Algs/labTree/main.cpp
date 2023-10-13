#include <iostream>
#include "Node.h"

using namespace tree;
using namespace std;

int main() {
    int n = 7;
    int data[] = {2, 5, 6, 1, -1, 7, 9};
    int found = FIND(-1, data, n);
    int notFound = FIND(99, data, n);
    cout << found << endl;
    cout << notFound << endl;

    Node *tree = MAKE_TREE(data, n);
    LTR(tree);
    return 0;
}