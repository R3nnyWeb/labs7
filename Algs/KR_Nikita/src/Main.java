import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;
import java.util.function.Consumer;

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

    public static double measureTimeMillis(Consumer<int[]> method, int[] array) {
        Instant start = Instant.now();
        method.accept(Arrays.copyOf(array, array.length));
        Instant end = Instant.now();
        Duration res = Duration.between(start, end);
        return (double) res.toNanos() / 1000000.0;
    }

    private static void printSortTimes(int[] arr, int n) {
        double sum = 0;
        for (int i = 0; i < 100; i++) {
            sum += measureTimeMillis(Main::selectSort, Arrays.copyOf(arr, n));
        }
        System.out.print(sum / 100 + "\t");
        System.gc();
        sum = 0;
        for (int i = 0; i < 100; i++) {
            sum += measureTimeMillis(Main::insertionSort, Arrays.copyOf(arr, n));
        }
        System.out.print(sum / 100 + "\t");
        System.gc();
        sum = 0;
        for (int i = 0; i < 100; i++) {
            sum += measureTimeMillis(Main::mergeSort, Arrays.copyOf(arr, n));
        }
        System.out.print(sum / 100 + "\t");
        System.gc();
        System.out.println();
    }

    public static void main(String[] args) {
        int[] arr = ArrayCreator.createArray(35000, -100000, 100000);
        for (int i = 5000; i <= 35000; i += 1000) {
            System.out.println("Размер = " + i);
            printSortTimes(arr, i);
        }

    }

}