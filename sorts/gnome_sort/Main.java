import java.util.*;

public class Main{
	public static void main(String[] args){
    final int SIZE = 6;
    List<Integer> datas = new ArrayList<Integer>(){{
      for(int i = 0; i < SIZE; i++) add(i);
      Collections.shuffle(this);
    }};

    System.out.println(datas);

    for(int i = 0; i < datas.size(); i++){
      if(i == 0) continue;
      int a = datas.get(i - 1);
      int b = datas.get(i);
      if(a > b) {
        datas.set(i - 1, b);
        datas.set(i, a);
        i -= 2;
      }
    }

    System.out.println(datas);
  }
}
