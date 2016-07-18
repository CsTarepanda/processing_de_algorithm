import java.util.*;
Deque<Lambda> breakPoint;
final int SIZE = 10;
final int CELL_SIZE = 30;
boolean auto = false;
class Main {
  ArrayList<Integer> datas;
  boolean changed = false;

  Main() {
    datas = new ArrayList<Integer>() {
      {
        for (int i = 0; i < SIZE; i++) add(i + 1);
        Collections.shuffle(this);
      }
    };
  }

  void alg() {
    for (int i = 1; i < datas.size(); i++) {
      int j = i - 1;
      for (; j > -1; j--) {
        drawResult(datas, i, j, true);
        if (datas.get(i) > datas.get(j)) break;
      }
      datas.add(j + 1, datas.remove(i));
      drawResult(datas, i + 1, j + 1, false);
    }
    drawResult(datas, datas.size(), -1, false);
  }

  void drawResult(ArrayList<Integer> datas, int self, int target, boolean flg) {
    breakPoint.add(new Lambda() {
      ArrayList<Integer> datas;
      int self, target;
      boolean flg;
      public void apply() {
        int x = 0;
        int y = height;
        for (int i = 0; i < datas.size(); i++) {
          x = i * CELL_SIZE;
          fill(i < self ? color(255, 0, 0) : color(255, 50, 0), i == self && flg ? 175 : 100);
          rect(x, y, CELL_SIZE, -CELL_SIZE * datas.get(i));
          if (i == target && flg) {
            fill(255, 0, 0, 130);
            noStroke();
            rect(x, y, CELL_SIZE, -CELL_SIZE * datas.get(self));
            stroke(0);
          }else if(i == target){
            fill(255, 0, 0, 130);
            noStroke();
            rect(x, y, CELL_SIZE, -CELL_SIZE * datas.get(target));
            stroke(0);
          }

          fill(0);
          text(datas.get(i), x + CELL_SIZE/2, height - CELL_SIZE/2);
        }
      }
      Lambda set(ArrayList<Integer> datas, int self, int target, boolean flg) {
        this.datas = new ArrayList<Integer>(datas);
        this.self = self;
        this.target = target;
        this.flg = flg;
        return this;
      }
    }
    .set(datas, self, target, flg));
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
  size(SIZE * CELL_SIZE, SIZE * CELL_SIZE);
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

    public void draw() {
      background(255);
      text(String.format("%s\n%s\n%s\n%s\n", 
        "click   => next", 
        "key 'r' => reset", 
        String.format("key 't' => %s", auto ? "manual" : "auto"), 
        "\nInsertion Sort"
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