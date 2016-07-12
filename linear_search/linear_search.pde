import java.util.*;
Deque<Lambda> breakPoint;
final int SIZE = 10;
final int CELL_SIZE = 30;
boolean auto = false;
class Main{
  int SIZE;
  int[] datas;
  int target;
  Main(int SIZE){
    this.SIZE = SIZE;
    int size = SIZE * SIZE;
    this.datas = new int[size];
    this.target = new Random().nextInt(size);
    for(int i = 0; i < size; i++) datas[i] = i;

    // ----------------------------------
    for(int i = 0; i < datas.length; i++){
      if(datas[i] == target){
        targeti = i;
        break;
      }
    }
    // ----------------------------------
  }

  // --------------------------
  int targeti;
  // --------------------------

  void alg(){
    for(int i = 0; i < datas.length; i++){
      // ---------------- draw a result
      breakPoint.add(new Lambda(){
        int targeti, target, index, size;
        int[] datas;
        public void apply(){
          int x = 0;
          int y = 0;
          for(int i = 0; i < datas.length; i++){
            x = (i % size) * CELL_SIZE;
            y = (i / size) * CELL_SIZE;
            fill(255);
            if(i == index) fill(255, 0, 0, 100);
            if(i == targeti) fill(index == targeti ? 200 : 255, 0, 0);
            rect(x, y, CELL_SIZE, CELL_SIZE);
            fill(0);
            text(datas[i], x + CELL_SIZE/2, y + CELL_SIZE/2);
          }
          text(target, x + CELL_SIZE/2 + CELL_SIZE, y + CELL_SIZE/2);
        }
        Lambda set(int targeti, int target, int index, int[] datas, int size){
          this.targeti = targeti;
          this.target = target;
          this.index = index;
          this.datas = datas;
          this.size = size;
          return this;
        }
      }.set(targeti, target, i, datas, SIZE));
      // ----------------
      if(datas[i] == target) break;
    }
  }
}

void init(){
  breakPoint = new ArrayDeque<Lambda>();
  new Main(SIZE).alg();
  drawResult();
}

interface Lambda{
  void apply();
}

void settings() {
  size((SIZE + 1) * CELL_SIZE, SIZE * CELL_SIZE);
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
        "\nFull Search"
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
