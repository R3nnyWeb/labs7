import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;
import java.util.Scanner;

public class Main {
    public static void swap(int[] array, int i, int j) {
        int temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }


    public static void selectSort(int[] array) {
        int min;
        for (int i = 0; i < array.length - 1; i++) {
            min = i;
            for (int j = i + 1; j < array.length; j++) {
                if (array[j] < array[min])
                    min = j;
            }
            swap(array, i, min);
        }
    }

    public static void insertionSort(int[] array) {
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
    }

    public static void mergeSort(int[] array) {
        mergeSortRecursive(array);
    }

    public static void mergeSortRecursive(int[] array) {
        if (array.length > 1) {
            int mid = array.length / 2;
            int[] left = Arrays.copyOfRange(array, 0, mid);
            int[] right = Arrays.copyOfRange(array, mid + 1, array.length);
            mergeSortRecursive(left);
            mergeSortRecursive(right);
            merge(left, right, array);
        }
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
        System.out.print(res.toNanos() / 10e6 / count + "\t");
        System.gc();

        start = Instant.now();
        for (int i = 0; i < count; i++) {
            insertionSort(Arrays.copyOf(arr, n));
        }
        end = Instant.now();
        res = Duration.between(start, end);
        System.out.print(res.toNanos() / 10e6 / count + "\t");
        System.gc();

        start = Instant.now();
        for (int i = 0; i < count; i++) {
            mergeSort(Arrays.copyOf(arr, n));
        }
        end = Instant.now();
        res = Duration.between(start, end);
        System.out.print(res.toNanos() / 10e6 / count + "\t");
        System.gc();
        System.out.println();
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.println("Введите минимальный размер массива: ");
        int minSize = sc.nextInt();
        System.out.println("Введите максимальный размер массива: ");
        int maxSize = sc.nextInt();
        System.out.println("Введите шаг изменения размера массива: ");
        int step = sc.nextInt();
        System.out.println("Введите количеств измерений для сортировки: ");
        int count = sc.nextInt();

        int[] arr = ArrayCreator.createArray(maxSize, -100000, 100000);
        for (int i = minSize; i <= maxSize; i += step) {
            System.out.println("Размер = " + i);
            printSortTimes(arr, i, count);
        }

    }

}