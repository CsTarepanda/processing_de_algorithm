import java.util.*;
Deque<Lambda> breakPoint;
final int SIZE = 200;
final int CELL_SIZE = 30;
boolean auto = false;
final float[][] datas = new float[SIZE][2];
class Main {
  /* float[][] datas = new float[SIZE][2]; */
  List<Float[]> cls = new ArrayList<Float[]>(){{
    for(int i = 0; i < 3; i++) add(new Float[]{random(width), random(height)});
  }};
  Map<Float[], List<Integer>> map = new HashMap<Float[], List<Integer>>();
  Map<Float[], List<Integer>> pre = new HashMap<Float[], List<Integer>>();
  
  final color[] col = new color[cls.size()];

  Main() {
    /* for(int i = 0; i < datas.length; i++){ */
    /*   float x = 0; */
    /*   float y = 0; */
    /*   switch((int)random(3)){ */
    /*     case 0: */
    /*     x = random(width/2 - width/4, width/2 + width/4); */
    /*     y = random(height/2); */
    /*     break; */
    /*  */
    /*     case 1: */
    /*     x = random(width/4 - width/8, width/4 + width/8); */
    /*     y = random(height/2, height); */
    /*     break; */
    /*  */
    /*     case 2: */
    /*     x = random(width/4 * 3 - width/8, width/4 * 3 + width/8); */
    /*     y = random(height/2, height); */
    /*     break; */
    /*  */
    /*     default: break; */
    /*   } */
    /*   datas[i] = new float[]{x, y}; */
    /* } */

    for(int i = 0; i < col.length; i++){
      col[i] = color(random(255), random(255), random(255));
    }
  }

  void alg() {
    while(true){
      for(Float[] f: cls) map.put(f, new ArrayList<Integer>());
      drawResult(datas, cls, map);
      for(int i = 0; i < datas.length; i++){
        float min = Float.MAX_VALUE;
        Float[] target = null;
        for(Float[] d: cls){
          float dis = dist(datas[i][0], datas[i][1], d[0], d[1]);
          if(min > dis){
            min = dis;
            target = d;
          }
        }
        map.get(target).add(i);
      }

      boolean flg = false;
      for(Map.Entry<Float[], List<Integer>> e: map.entrySet()){
        if(e.getValue().equals(pre.get(e.getKey()))){
          flg = true;
          break;
        }
        pre.put(e.getKey(), e.getValue());
        float xPos = 0;
        for(int f: e.getValue()) xPos += datas[f][0];
        xPos /= e.getValue().size();
        float yPos = 0;
        for(int f: e.getValue()) yPos += datas[f][1];
        yPos /= e.getValue().size();
        e.getKey()[0] = xPos;
        e.getKey()[1] = yPos;
        flg = false;
      }
      if(flg) break;
    }
    drawResult(datas, cls, map);
  }

  void drawResult(final float[][] all, final List<Float[]> cls, final Map<Float[], List<Integer>> links) {
    final List<Float[]> ccls = new ArrayList<Float[]>(){{
      for(Float[] f: cls) add(new Float[]{f[0], f[1]});
    }};
    final Map<Float[], List<Integer>> clinks = new HashMap<Float[], List<Integer>>(){{
      for(int i = 0; i < cls.size(); i++) put(ccls.get(i), links.get(cls.get(i)));
    }};
    breakPoint.add(new Lambda() {
      float[][] all;
      List<Float[]> cls;
      Map<Float[], List<Integer>> links;
      public void apply() {
        fill(255);
        for(float[] f: all) ellipse(f[0], f[1], 10, 10);
        for(int i = 0; i < cls.size(); i++){
          fill(col[i]);
          Float[] f = cls.get(i);
          ellipse(f[0], f[1], 10, 10);
          for(Integer n: links.get(cls.get(i))){
            stroke(col[i]);
            line(f[0], f[1], all[n][0], all[n][1]);
          }
          stroke(0);
        }
      }
      Lambda set(float[][] all, List<Float[]> cls, Map<Float[], List<Integer>> links) {
        this.all = all;
        this.cls = cls;
        this.links = links;
        return this;
      }
    }.set(all, ccls, clinks));
  }
}

void init() {
  breakPoint = new ArrayDeque<Lambda>();
  new Main().alg();
  drawResult();
}

interface Lambda {
  void apply();
}

void settings() {
  size(500, 500);
}

void setup() {
  for(int i = 0; i < datas.length; i++){
    float x = 0;
    float y = 0;
    switch((int)random(3)){
      case 0:
      x = random(width/2 - width/4, width/2 + width/4);
      y = random(height/2);
      break;

      case 1:
      x = random(width/4 - width/8, width/4 + width/8);
      y = random(height/2, height);
      break;

      case 2:
      x = random(width/4 * 3 - width/8, width/4 * 3 + width/8);
      y = random(height/2, height);
      break;

      default: break;
    }
    datas[i] = new float[]{x, y};
  }
  new PApplet() {
    public void settings() {
      size(250, 250);
    }
    public void setup() {
      textSize(20);
      fill(0);
    }

    public void draw() {
      background(255);
      text(String.format("%s\n%s\n%s\n%s\n", 
        "click   => next", 
        "key 'r' => reset", 
        String.format("key 't' => %s", auto ? "manual" : "auto"), 
        "\nK-means"
        ), 40, 40);
    }

    public void keyPressed() {
      controller(key);
    }

    public void runSketch() {
      super.runSketch();
    }
  }
  .runSketch();

  textAlign(CENTER, CENTER);
  textSize(15);
  frameRate(5);
  init();
}

void draw() {
  if (auto) drawResult();
}

int RANGE;
int count;
int result;
void mousePressed() {
  if (!auto) drawResult();
}

void drawResult() {
  Lambda lmd = breakPoint.poll();
  if (lmd != null) {
    background(255);
    lmd.apply();
  }
}

void keyPressed() {
  controller(key);
}

void controller(char k) {
  switch(k) {
  case 'r':
    init();
    break;
  case 't':
    auto = !auto;
    break;
  default: 
    break;
  }
}
