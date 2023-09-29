#include <iostream>
#include "Node.h"
using namespace tree;
using namespace std;
int main() {
    Node* root= MAKE_TREE();
    cout << "TLR"<<endl;
    TLR(root, 0);
    cout << "=====================" << endl;
    cout << "LRT" << endl;
    LRT(root, 0);
    cout << "=====================" << endl;
    cout << "LTR"<<endl;
    LTR(root, 0);
    Node* found = FIND(9, root);
    cout<<found<<endl;
    Node* notfound = FIND(10, root);
    cout<<notfound<<endl;
    int wait;
    std::cin >> wait;
    return 0;
}