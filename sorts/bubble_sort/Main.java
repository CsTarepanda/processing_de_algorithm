import java.util.*;

public class Main{
	public static void main(String[] args){
    final int SIZE = 6;
    List<Integer> datas = new ArrayList<Integer>(){{
      for(int i = 0; i < SIZE; i++) add(i);
      Collections.shuffle(this);
    }};

    System.out.println(datas);

    boolean changed = false;
    while(true){
      for(int i = 1; i < datas.size(); i++){
        int pre = datas.get(i - 1);
        int target = datas.get(i);
        if(pre > target){
          changed = true;
          datas.set(i - 1, target);
          datas.set(i, pre);
        }
      }
      if(!changed) break;
      changed = false;
    }

    System.out.println(datas);
  }
}
