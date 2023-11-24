package r3nny;


import java.util.Arrays;

class Queue {
    int size;
    int top = 0;
    int[] arr;

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
        if (heads.length == 0) return null;
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
        for (int i = 0; i < heads.length; i++) {
            DFSrecursive(i, heads, visited);
        }

    }

    public static void DFSrecursive(int i, Node[] heads, boolean[] visited) {
        if (!visited[i]) {
            visited[i] = true;
            System.out.print(i + ", ");
            Node cur = heads[i];
            while (cur != null) {
                if (!visited[cur.num]) {
                    DFSrecursive(cur.num, heads, visited);
                }
                cur = cur.next;
            }
        }
    }

    //Компонента связанности при помощи DFS
    public static int[] linkingByDFS(Node[] heads) {
        boolean[] visited = new boolean[heads.length];
        int[] comp = new int[heads.length];
        int num = 0;
        for (int i = 0; i < heads.length; i++) {
            if (!visited[i]) {
                num++;
                DFSrecursiveLinking(i, heads, visited, comp, num);
            }
        }
        return comp;
    }
    //Модифицированная DFS для компоненты связанности

    public static void DFSrecursiveLinking(int i, Node[] heads, boolean[] visited, int[] comp, int num) {
        visited[i] = true;
        System.out.print(i + ", ");
        comp[i] = num;
        Node cur = heads[i];
        while (cur != null) {
            if (!visited[cur.num]) {
                DFSrecursiveLinking(cur.num, heads, visited, comp, num);
            }
            cur = cur.next;
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
                    System.out.print(cur + ", ");
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

    //Топологическая без обнаружения контура
    public static int[] topologicalSort(Node[] heads) {
        boolean[] visited = new boolean[heads.length];
        int[] labels = new int[heads.length];
        int num = heads.length;
        for (int i = 0; i < heads.length; i++) {
            if (!visited[i]) {
                num = DFStopologicalSort(i, heads, visited, labels, num);
            }
        }
        return labels;
    }

    private static int DFStopologicalSort(int i, Node[] heads, boolean[] visited, int[] labels, int num) {
        visited[i] = true;
        Node cur = heads[i];
        while (cur != null) {
            if (!visited[cur.num]) {
                num = DFStopologicalSort(cur.num, heads, visited, labels, num);
            }
            cur = cur.next;
        }
        num--;
        labels[i] = num;
        System.out.print(i + ", ");
        return num;
    }

        public static int[] topologicalModifiedSort(Node[] heads) {
        boolean[] visited = new boolean[heads.length];
        int[] labels = new int[heads.length];
        int num = heads.length;
        for (int i = 0; i < heads.length; i++) {
            if (!visited[i]) {
                num = DFStopologicalModifiedSort(i, heads, visited, labels, num);
            }
        }
        return labels;
    }

    private static int DFStopologicalModifiedSort(int i, Node[] heads, boolean[] visited, int[] labels, int num) {
        visited[i] = true;
        Node cur = heads[i];
        while (cur != null) {
            if (!visited[cur.num]) {
                num = DFStopologicalModifiedSort(cur.num, heads, visited, labels, num);
            } else {
                if(labels[cur.num] == 0) {
                    throw new RuntimeException("Контур через вершины: " + cur.num + " и " + i);
                }
            }
            cur = cur.next;
        }
        num--;
        labels[i] = num;
        System.out.print(i + ", ");
        return num;
    }

    public static void printGraph(Node[] heads) {
        for (int i = 0; i < heads.length; i++) {
            System.out.println(i + ": " + heads[i]);
        }
    }

    public static void main(String[] args) {
        Node[] notOriented = new Node[7];

        notOriented[0] = fillHead(1, 2);
        notOriented[1] = fillHead(0, 2, 4);
        notOriented[2] = fillHead(0, 1, 3);
        notOriented[3] = fillHead(2, 4);
        notOriented[4] = fillHead(3, 1);
        notOriented[5] = fillHead(6);
        notOriented[6] = fillHead(5);

        printGraph(notOriented);

        System.out.println("DFS: ");
        DFS(notOriented);
        System.out.println("\nBFS:");
        BFS(notOriented);

        System.out.println("\nКомпонента связанности: ");
        System.out.println(Arrays.toString(linkingByDFS(notOriented)));

        Node[] oriented = new Node[6];
        oriented[0] = fillHead(1, 5);
        oriented[1] = fillHead(2);
        oriented[2] = fillHead();
        oriented[3] = fillHead(2);
        oriented[4] = fillHead(0, 3, 5);
        oriented[5] = fillHead(1, 2, 3);

        System.out.println("Ориентированный: ");
        printGraph(oriented);
        System.out.println("Топологическая");
        System.out.println(Arrays.toString(topologicalSort(oriented)));

        Node[] withContur = new Node[4];
        oriented[0] = fillHead(1);
        oriented[1] = fillHead(2);
        oriented[2] = fillHead(3);
        oriented[3] = fillHead(0);
        System.out.println("Топологическая модифицированная");
        System.out.println(Arrays.toString(topologicalModifiedSort(oriented)));
    }
}