import java.util.Random;

public class ArrayCreator
{
    public static int[] createArray(int size){
        return createArray(size, 0, 10);
    }
    public static int[] createArray(int size, int min, int max){

        int[] array = new int[size];
        Random rand = new Random();
        for (int i = 0; i <size ; i++) {
            array[i] = rand.nextInt(min,max+1);
        }
        return array;
    }

    public static int[] createArrASC(int size) {
        int[] array = new int[size];
        for (int i = 0; i <size ; i++) {
            array[i] = i;
        }
        return array;
    }
    public static int[] createArrayDESC(int size) {
        int[] array = new int[size];
        for (int i = 0; i <size ; i++) {
            array[i] = i;
        }
        return array;
    }
}