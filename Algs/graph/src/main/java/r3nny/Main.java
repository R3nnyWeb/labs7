package r3nny;

import java.util.Arrays;
import java.util.LinkedList;



class Queue {
    int size;
    int top = 0;
    int arr[];

    public Queue(int size) {
        this.size = size;
        arr = new int[size];
    }

    public void add(int value) {
        arr[top] = value;
        top++;
    }


    public boolean isEmpty() {
        return top == 0;
    }

    public int poll() {
        return arr[top--];
    }
}

class Node {
    int num;
    Node next;

    Node(int num) {
        this.num = num;
        this.next = null;
    }

    @Override
    public String toString() {
        return num + "->" + next;
    }
}


public class Main {

    public static Node fillHead(int... heads) {
        Node head = new Node(heads[0]);
        Node cur = head;
        for (int i = 1; i < heads.length; i++) {
            cur.next = new Node(heads[i]);
            cur = cur.next;
        }
        return head;
    }


    public static void DFS(Node[] heads) {
        boolean[] visited = new boolean[heads.length];
        for (int i = 0; i < heads.length ; i++) {
            DFSrecursive(i, heads, visited);
        }

    }

    public static void DFSrecursive(int i, Node[] heads, boolean[] visited) {
        if(!visited[i]) {
            visited[i] = true;
            System.out.println(i);
            Node cur = heads[i];
            while (cur != null) {
                if (!visited[cur.num]) {
                    DFSrecursive(cur.num, heads, visited);
                }
                cur = cur.next;
            }
        }
    }

    public static void BFS(Node[] heads) {
        boolean[] visited = new boolean[heads.length];
        for (int i = 0; i < heads.length; i++) {
            if (!visited[i]) {
                Queue queue = new Queue(heads.length);
                queue.add(i);
                visited[i] = true;
                while (!queue.isEmpty()) {
                    int cur = queue.poll();
                    System.out.println(cur);
                    Node curNode = heads[cur];
                    while (curNode != null) {
                        if (!visited[curNode.num]) {
                            visited[curNode.num] = true;
                            queue.add(curNode.num);
                        }
                        curNode = curNode.next;
                    }
                }
            }

        }

    }

    public static void main(String[] args) {
        Node[] heads = new Node[7];

        heads[0] = fillHead(1, 2);
        heads[1] = fillHead(0, 2, 4);
        heads[2] = fillHead(0, 1, 3);
        heads[3] = fillHead(2, 4);
        heads[4] = fillHead(3, 1);
        heads[5] = fillHead(6);
        heads[6] = fillHead(5);

        DFS(heads);
     //   BFS(heads);

              /*  head[0] = new Node(1);
        head[0].next = new Node(2);
        head[1] = new Node(0);
        head[1].next = new Node(2);
        head[1].next.next = new Node(4);
        head[2] = new Node(0);
        head[2].next = new Node(1);
        head[2].next.next = new Node(3);
        head[3] = new Node(2);
        head[3].next = new Node(4);
        head[4] = new Node(1);
        head[4].next = new Node(3);*/
        for (int i = 0; i < heads.length; i++) {
            System.out.println(i + ": " + heads[i]);
        }
    }
}