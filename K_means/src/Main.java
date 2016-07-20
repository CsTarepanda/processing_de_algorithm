import java.util.*;
import java.util.stream.*;
public class Main{
	public static void main(String[] args){
    int[][] datas = new int[20][2];
    final Random rdm = new Random();
    for(int i = 0; i < datas.length; i++){
      datas[i] = new int[]{rdm.nextInt(100), rdm.nextInt(100)};
    }

    final int SIZE = 3;
    List<Double[]> cls = new ArrayList<Double[]>(){{
      for(int i = 0; i < SIZE; i++) add(new Double[]{(double)rdm.nextInt(100), (double)rdm.nextInt(100)});
    }};

    cls.forEach(x -> System.out.println(Arrays.toString(x)));

    System.out.println("---------");

    for(int[] d: datas) System.out.println(Arrays.toString(d));

    Map<Double[], List<Integer>> map = new HashMap<>();
    Map<Double[], List<Integer>> pre = new HashMap<>();

    while(true){
      for(Double[] d: cls) map.put(d, new ArrayList<>());
      for(int i = 0; i < datas.length; i++){
        double min = Double.MAX_VALUE;
        Double[] target = null;
        for(Double[] d: cls){
          double dist = sqdist(datas[i][0], datas[i][1], d[0], d[1]);
          if(min > dist){
            min = dist;
            target = d;
          }
        }
        map.get(target).add(i);
      }

      if(map.entrySet().stream().map(e -> {
        if(e.getValue().equals(pre.get(e.getKey()))) return true;

        pre.put(e.getKey(), e.getValue());
        double xPos = e.getValue().stream().mapToInt(n -> datas[n][0]).sum() / (double)e.getValue().size();
        double yPos = e.getValue().stream().mapToInt(n -> datas[n][1]).sum() / (double)e.getValue().size();
        e.getKey()[0] = xPos;
        e.getKey()[1] = yPos;
        return false;
      }).collect(Collectors.toList()).stream().allMatch(e -> e)) break;
    }
	}

  public static double sqdist(double x, double y, double x2, double y2){
    return Math.pow(x - x2, 2) + Math.pow(y - y2, 2);
  }
}
