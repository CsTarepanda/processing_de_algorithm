int SIZE = 6;
int CELL_SIZE = 30;
int YSIZE = 10;
void settings() {
  size((SIZE + 5) * CELL_SIZE, YSIZE * CELL_SIZE);
}

void setup() {
  new PApplet() {
    public void settings() {
      size(250, 250);
    }
    public void setup() {
      background(255);
      textSize(20);
      fill(0);
      text(String.format("%s\n%s\n%s\n", 
        "click   => next", 
        "key 'r' => reset", 
        "\nFull Search"
        ), 40, 40);
    }

    public void runSketch() {
      super.runSketch();
    }
  }
  .runSketch();

  background(255);
  init();
  textAlign(CENTER, CENTER);
  textSize(15);
}

void draw() {
  background(255);
  for (int i = 0; i < SIZE; i++) {
    for (int j = 1; j < YSIZE; j++) {
      fill(count < j || (((count - j) >> i) & 1) != 1 ? color(255) : color(255, 0, 0), j > 1 ? 40 : 255);
      rect(i * CELL_SIZE, height - (j + 1)*CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }
    fill(0);
    text(i, i * CELL_SIZE + CELL_SIZE/2, height - CELL_SIZE*3/2);
    text(count < 1 ? 0 : ((count - 1) >> i) & 1, i * CELL_SIZE + CELL_SIZE/2, height - CELL_SIZE/2);
  }
  fill(0);
  text("=> " + result, width - 4 * CELL_SIZE, height - CELL_SIZE*3/2);
  text("=> " + (count < 1 ? 0 : count - 1), width - 4 * CELL_SIZE, height - CELL_SIZE/2);
}

int RANGE;
int count;
int result;
void mousePressed() {
  if (count < RANGE) {
    result = 0;
    int cnt = 0;
    for (int j = count; j != 0; j >>= 1) {
      if ((j & 1) == 1) {
        result += cnt;
      }
      cnt++;
    }
    count++;
  }
}

void keyPressed() {
  if (key == 'r') init();
}

void init() {
  RANGE = 1 << SIZE;
  count = 0;
  result = 0;
}
