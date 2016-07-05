import java.util.ArrayList;
import java.util.Scanner;
public class Main{
	public static void main(String[] args){
    int RANGE = new Scanner(System.in).nextInt();
    int[] map = new int[RANGE];
    ArrayList<Integer> primes = new ArrayList<>();
    for(int i = 0; i < map.length; i++) map[i] = i + 1;
    map[0] = -1;
    int sqrt_num = (int)Math.sqrt(RANGE) + 1;

    for(int i: map){
      if(i != -1){
        if(i > sqrt_num){
          primes.add(i);
          continue;
        }
        primes.add(i);
        for(int j = i - 1; j < map.length; j += i) map[j] = -1;
      }
    }

    System.out.println(primes);
	}
}
