//
// Created by R3nny on 15.09.2023.
//
#include "Node.h"

namespace tree {
    Node *MAKE_TREE() {
        data_type data[] = {2, 5, 6, 1, 6, 7, 2};
        int n = 7;
        Node root = Node(data[0]);

        for (int i = 1; i < n; i++) {
            Node *current = &root;
            data_type currentData = data[i];
            while (current != nullptr) {
                if (currentData < root.data)
                    current = LEFT(current);
                else current = RIGHT(current);
            }

        }
    }
}