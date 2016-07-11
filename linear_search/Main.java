import java.util.*;

public class Main{
	public static void main(String[] args){
    int SIZE = 6;
    int[] datas = new int[SIZE];
    int target = new Random().nextInt(SIZE);
    for(int i = 0; i < SIZE; i++) datas[i] = i;

    System.out.println(Arrays.toString(datas));
    System.out.printf("target: %d\n", target);

    int index = 0;
    for(int i = 0; i < datas.length; i++){
      System.out.println(i);
      if(datas[i] == target){
        index = i;
        break;
      }
    }

    System.out.printf("index: %d\n", index);
  }
}
