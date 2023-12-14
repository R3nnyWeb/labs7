import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;
import java.util.Random;
import java.util.Scanner;

public class Main {

    public static void swap(int[] array, int i, int j) {
        int temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }


    public static int[] selectSort(int[] array) {
        int min;
        for (int i = 0; i < array.length - 1; i++) {
            min = i;
            for (int j = i + 1; j < array.length; j++) {
                if (array[j] < array[min])
                    min = j;
            }
            swap(array, i, min);
        }
        return array;
    }

    public static int[] insertionSort(int[] array) {
        for (int i = 1; i < array.length; i++) {
            if (array[i - 1] > array[i]) {
                int key = array[i];
                int j = i - 1;
                while (j >= 0 && array[j] > key) {
                    array[j + 1] = array[j];
                    j--;
                }
                array[j + 1] = key;
            }
        }
        return array;
    }


    public static void mergeSort(int[] array) {
        if (array.length > 1) {
            int mid = array.length / 2;
            int[] left = copy(array, 0, mid);
            int[] right = copy(array, mid, array.length);
            mergeSort(left);
            mergeSort(right);
            merge(left, right, array);
        }
    }

    public static int[] copy(int[] array, int from, int to) {
        int[] copy = new int[to - from];
        for (int i = from; i < to; i++) {
            copy[i - from] = array[i];
        }
        return copy;
    }

    private static void merge(int[] left, int[] right, int[] array) {
        int leftI = 0;
        int rightI = 0;
        int arrI = 0;
        while (leftI < left.length && rightI < right.length) {
            if (left[leftI] < right[rightI])
                array[arrI++] = left[leftI++];
            else
                array[arrI++] = right[rightI++];
        }
        while (leftI < left.length)
            array[arrI++] = left[leftI++];

        while (rightI < right.length)
            array[arrI++] = right[rightI++];

    }

    private static void printSortTimes(int[] arr, int n, int count) {
        Instant start = Instant.now();
        for (int i = 0; i < count; i++) {
            selectSort(Arrays.copyOf(arr, n));
        }
        Instant end = Instant.now();
        Duration res = Duration.between(start, end);
        System.out.print(res.toNanos() / 10e3 / count + "\t");
        System.gc();

        start = Instant.now();
        for (int i = 0; i < count; i++) {
            insertionSort(Arrays.copyOf(arr, n));
        }
        end = Instant.now();
        res = Duration.between(start, end);
        System.out.print(res.toNanos() / 10e3 / count + "\t");
        System.gc();

        start = Instant.now();
        for (int i = 0; i < count; i++) {
            mergeSort(Arrays.copyOf(arr, n));
        }
        end = Instant.now();
        res = Duration.between(start, end);
        System.out.print(res.toNanos() / 10e3 / count + "\t");
        System.gc();
        System.out.println();
    }

    public static int[] createArray(int size, int min, int max) {
        int[] array = new int[size];
        Random rand = new Random();
        for (int i = 0; i < size; i++) {
            array[i] = rand.nextInt(min, max + 1);
        }
        return array;
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        if(sc.nextInt() == 1){
            System.out.println("Введите размер исходного массива: ");
            int size = sc.nextInt();
            System.out.println("Введите массив: ");
            int[] array = new int[size];
            for (int i = 0; i < size; i++) {
                array[i] = sc.nextInt();
            }
            System.out.println("Исходный массив:");
            for (int i = 0; i < size; i++) {
                System.out.print(array[i] + " ");
            }
            System.out.println();
            System.out.println("Отсортированный массив: ");
            mergeSort(array);
            for (int i = 0; i < size; i++) {
                System.out.print(array[i] + " ");
            }
            System.out.println();
        } else {
            System.out.println("Анализ:");

            System.out.println("Введите минимальный размер массива: ");
            int minSize = sc.nextInt();
            System.out.println("Введите максимальный размер массива: ");
            int maxSize = sc.nextInt();
            System.out.println("Введите шаг изменения размера массива: ");
            int step = sc.nextInt();
            System.out.println("Введите количеств измерений для сортировки: ");
            int count = sc.nextInt();

            int[] arr = createArray(maxSize, -100000, 100000);
            for (int i = minSize; i <= maxSize; i += step) {
                System.out.println("Размер = " + i);
                printSortTimes(arr, i, count);
            }
            sc.close();
        }

    }
}
