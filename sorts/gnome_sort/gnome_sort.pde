import java.util.*;
Deque<Lambda> breakPoint;
final int SIZE = 10;
final int CELL_SIZE = 30;
boolean auto = false;
class Main{
  ArrayList<Integer> datas;

  Main(){
    datas = new ArrayList<Integer>(){{
      for(int i = 0; i < SIZE; i++) add(i + 1);
      Collections.shuffle(this);
    }};
  }

  void alg(){
    for(int i = 0; i < datas.size(); i++){
      drawResult(datas, i, i - 1);
      if(i == 0) continue;
      int a = datas.get(i - 1);
      int b = datas.get(i);
      if(a > b) {
        datas.set(i - 1, b);
        datas.set(i, a);
        drawResult(datas, i - 1, i);
        i -= 2;
      }
    }
  }

  void drawResult(ArrayList<Integer> datas, int gnome, int target){
    breakPoint.add(new Lambda(){
      ArrayList<Integer> datas;
      int gnome, target;
      public void apply(){
        int x = 0;
        int y = height;
        for(int i = 0; i < datas.size(); i++){
          x = i * CELL_SIZE;
          fill(255, 0, 0, (gnome == i || target == i) ? 175 : 100);
          rect(x, y, CELL_SIZE, -CELL_SIZE * datas.get(i));
          if(i == gnome){
            fill(0, 255, 0, 100);
            ellipse(x + CELL_SIZE/2, height - CELL_SIZE * datas.get(i) - CELL_SIZE/2, CELL_SIZE / 3, CELL_SIZE / 3);
          }
          if(i == target){
            fill(0, 0, 255, 100);
            ellipse(x + CELL_SIZE/2, height - CELL_SIZE * datas.get(i) - CELL_SIZE/2, CELL_SIZE / 3, CELL_SIZE / 3);
          }
          fill(0);
          text(datas.get(i), x + CELL_SIZE/2, height - CELL_SIZE/2);
        }
      }
      Lambda set(ArrayList<Integer> datas, int gnome, int target){
        this.datas = new ArrayList<Integer>(datas);
        this.gnome = gnome;
        this.target = target;
        return this;
      }
    }.set(datas, gnome, target));
  }
}

void init(){
  breakPoint = new ArrayDeque<Lambda>();
  new Main().alg();
  drawResult();
}

interface Lambda{
  void apply();
}

void settings() {
  size(SIZE * CELL_SIZE, (SIZE + 1) * CELL_SIZE);
}

void setup() {
  new PApplet() {
    public void settings() {
      size(250, 250);
    }
    public void setup() {
      textSize(20);
      fill(0);
    }

    public void draw(){
      background(255);
      text(String.format("%s\n%s\n%s\n%s\n", 
        "click   => next", 
        "key 'r' => reset", 
        String.format("key 't' => %s", auto ? "manual" : "auto"),
        "\nGnome Sort"
        ), 40, 40);
    }
    
    public void keyPressed(){
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
  if(auto) drawResult();
}

int RANGE;
int count;
int result;
void mousePressed() {
  if(!auto) drawResult();
}

void drawResult(){
  Lambda lmd = breakPoint.poll();
  if(lmd != null){
    background(255);
    lmd.apply();
  }
}

void keyPressed() {
  controller(key);
}

void controller(char k){
  switch(k){
    case 'r':
      init();
      break;
    case 't':
      auto = !auto;
      break;
    default: break;
  }
}
