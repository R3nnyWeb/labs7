package r3nny;

import java.util.LinkedList;
import java.util.List;

public class Main2 {
    public static void main(String[] args) {
        List<Integer>[] head = new LinkedList[6];
        head[0] = new LinkedList<Integer>();
        head[0].add(1);
        head[0].add(2);
        head[0].add(3);

        for (int i = 0; i < head.length ; i++) {
            System.out.println(head[i]);
        };
    }
}
