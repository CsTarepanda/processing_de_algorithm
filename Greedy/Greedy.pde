import java.util.*;
Deque<Lambda> breakPoint;
final int SIZE = 6;
final int CELL_SIZE = 30;
boolean auto = false;
class Main{
  final int HIGH = (int)random(height);
  int[] data = new int[SIZE];
  {
    for(int i = 0; i < SIZE; i++){
      data[i] = (int)random(height/2);
    }
    Arrays.sort(data);
    data = reverse(data);
  }

  void alg(){
    int count = 0;
    ArrayList<Integer> result = new ArrayList<Integer>();

    int targetCount = 0;
    for(int i: data){
      while(i != 0 && addBlock(count, i, targetCount) <= HIGH){
        count += i;
        result.add(i);
        // ---------------- draw a result
        breakPoint.add(new Lambda(){
          ArrayList<Rect> rects;
          public void apply(){
            Rect last = rects.get(rects.size() - 1);
            rects.remove(last);
            rects.add(new Rect(last.x, last.y, last.h, color(red(last.col), green(last.col), blue(last.col))));
          }
          Lambda set(ArrayList<Rect> rects){
            this.rects = rects;
            return this;
          }
        }.set(rects));
        // ----------------
      }
      // ---------------- draw a result
      breakPoint.add(new Lambda(){
        ArrayList<Rect> rects;
        int targetCount;
        public void apply(){
          Rect last = rects.get(rects.size() - 1);
          rects.remove(last);
          rects.get(targetCount).cancel();
        }
        Lambda set(ArrayList<Rect> rects, int targetCount){
          this.rects = rects;
          this.targetCount = targetCount;
          return this;
        }
      }.set(rects, targetCount));
      // ----------------
      targetCount++;
    }
  }

  int addBlock(int count, int high, int targetCount){
    // ---------------- draw a result
    breakPoint.add(new Lambda(){
      ArrayList<Rect> rects;
      int count, high, targetCount;
      public void apply(){
        rects.get(targetCount).select();
        rects.add(new Rect(width - CELL_SIZE, height - count, high, color(rects.get(targetCount).col, 100)));
      }
      Lambda set(ArrayList<Rect> rects, int count, int high, int targetCount){
        this.rects = rects;
        this.count = count;
        this.high = high;
        this.targetCount = targetCount;
        return this;
      }
    }.set(rects, count, high, targetCount));
    // ----------------
    return count + high;
  }
}

ArrayList<Rect> rects;
class Rect{
  float x, y;
  int h;
  color col;
  boolean selected;
  Rect(float x, float y, int h){
    this.x = x;
    this.y = y;
    this.h = h;
    this.col = color(random(255), random(255), random(255));
  }
  Rect(float x, float y, int h, color col){
    this(x, y, h);
    this.col = col;
  }

  void select(){
    this.selected = true;
  }

  void cancel(){
    this.selected = false;
  }

  void display(){
    fill(col);
    rect(x, y - h, CELL_SIZE, h);
    fill(0);
    if(selected) ellipse(x + CELL_SIZE/2, y - h - CELL_SIZE/3 - 10, CELL_SIZE/3, CELL_SIZE/3);
    textSize(CELL_SIZE/3);
    text(h, x + CELL_SIZE/2, y - 10);
  }
}

int HIGH;
void init(){
  breakPoint = new ArrayDeque<Lambda>();
  Main main = new Main();
  HIGH = main.HIGH;
  rects = new ArrayList<Rect>();
  breakPoint.add(new Lambda(){
    ArrayList<Rect> rects;
    Main main;
    public void apply(){
      for(int i = 0; i < main.data.length; i++) rects.add(new Rect(i * CELL_SIZE, height, main.data[i]));
    }
    Lambda set(ArrayList<Rect> rects, Main main){
      this.rects = rects;
      this.main = main;
      return this;
    }
  }.set(rects, main));
  main.alg();
  drawResult();
}

interface Lambda{
  void apply();
}

void settings() {
  size((SIZE + 2) * CELL_SIZE, 500);
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
        "\nGreedy Algorithm"
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

void mousePressed() {
  if(!auto) drawResult();
}

void drawResult(){
  Lambda lmd = breakPoint.poll();
  if(lmd != null){
    lmd.apply();
    background(255);
    stroke(80);
    strokeWeight(1);
    line(0, height - HIGH, width, height - HIGH);
    noStroke();
    for(Rect r: rects) r.display();
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
