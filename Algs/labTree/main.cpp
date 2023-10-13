#include <iostream>
#include "Node.h"

using namespace tree;
using namespace std;

int main() {
    int n = 7;
    int data[] = {2, 5, 6, 1, -1, 7, 9};
    Node *tree = MAKE_TREE(data, n);
    int index = FIND(-1, data, n);
    int index2 = FIND(99, data, n);
    cout << index << endl;
    cout << index2 << endl;
    LTR(tree);
    return 0;
}