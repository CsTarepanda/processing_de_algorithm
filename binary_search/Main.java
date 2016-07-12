import java.util.*;

public class Main{
	public static void main(String[] args){
    int SIZE = 6;
    int[] datas = new int[SIZE];
    int target = new Random().nextInt(SIZE);
    for(int i = 0; i < SIZE; i++) datas[i] = i;

    System.out.println(Arrays.toString(datas));
    System.out.printf("target: %d\n", target);

    int max = datas.length - 1;
    int min = 0;
    int half = (max - min) / 2 + min;
    while(datas[half] != target){
      System.out.println(half);
      if(datas[half] < target){
        min = half + 1;
      }else{
        max = half;
      }

      half = (max - min) / 2 + min;
    }

    System.out.printf("index: %d\n", half);
  }
}
