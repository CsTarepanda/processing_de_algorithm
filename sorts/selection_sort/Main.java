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
      int min = datas.get(i);
      int target = i;
      for(int j = i + 1; j < datas.size(); j++){
        int d = datas.get(j);
        if(min > d){
          min = d;
          target = j;
        }
      }
      datas.add(i, datas.remove(target));
    }

    System.out.println(datas);
  }
}
