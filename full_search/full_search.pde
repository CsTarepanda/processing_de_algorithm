import java.util.*;
Deque<Lambda> breakPoint;
final int SIZE = 6;
final int CELL_SIZE = 30;
boolean auto = false;
class Main{
  int SIZE = 6;
  int RANGE = 1 << SIZE;

  void alg(){
    for(int i = 0; i < RANGE; i++){
      int sum = 0;
      int count = 0;
      for(int j = i; j > 0; j >>= 1){
        if((j & 1) == 1) sum += count;
        count++;
      }
      // ---------------- draw a result
      breakPoint.add(new Lambda(){
        int i, sum;
        public void apply(){
          for(int j = 0; j < SIZE; j++){
            fill(((i >> j) & 1) != 1 ? color(255) : color(255, 0, 0));
            rect((SIZE - j - 1) * CELL_SIZE,  height / 4, CELL_SIZE, CELL_SIZE);
            fill(0);
            text(j, (SIZE - j - 1) * CELL_SIZE + CELL_SIZE/2,  height / 4 + CELL_SIZE/2);
            text((i >> j) & 1, (SIZE - j - 1) * CELL_SIZE + CELL_SIZE/2,  height / 4 + CELL_SIZE/2 + CELL_SIZE);
          }
          text("=> " + sum, width - 4 * CELL_SIZE,  height / 4 + CELL_SIZE/2);
          text("=> " + i, width - 4 * CELL_SIZE,  height / 4 + CELL_SIZE/2 + CELL_SIZE);
        }
        Lambda set(int i, int sum){
          this.i = i;
          this.sum = sum;
          return this;
        }
      }.set(i, sum));
      // ----------------
    }
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
  size((SIZE + 5) * CELL_SIZE, 150);
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
