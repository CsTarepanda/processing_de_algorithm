import java.util.*;

public class Main{
	public static void main(String[] args){
    final int SIZE = 6;
    List<Integer> datas = new ArrayList<Integer>(){{
      for(int i = 0; i < SIZE; i++) add(i);
      Collections.shuffle(this);
    }};

    System.out.println(datas);

    for(int i = 1; i < datas.size(); i++){
        int j = i - 1;
        for(; j > -1; j--) if(datas.get(i) > datas.get(j)) break;
        datas.add(j + 1, datas.remove(i));
    }

    System.out.println(datas);
  }
}