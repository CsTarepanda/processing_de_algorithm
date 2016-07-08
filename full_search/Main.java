import java.util.*;

public class Main{
	public static void main(String[] args){
    int SIZE = 6;
    int RANGE = 1 << SIZE;
    List<Integer> list = new ArrayList<Integer>();
    for(int i = 0; i < RANGE; i++){
      int sum = 0;
      int count = 0;
      for(int j = i; j > 0; j >>= 1){
        if((j & 1) == 1) sum += count;
        count++;
      }
      list.add(sum);
    }

    System.out.println(list);
	}
}
