import java.util.*;
public class Main{
	public static void main(String[] args){
    Integer[] data = (Integer[])Arrays.asList(1, 10, 15, 23, 100).toArray();
    int target = 230;
    int count = 0;
    List<Integer> result = new ArrayList<Integer>();

    Arrays.sort(data, Comparator.reverseOrder());
    for(int i: data){
      while(i != 0 && count + i <= target){
        count += i;
        result.add(i);
      }
    }
    System.out.println(result);
	}
}
