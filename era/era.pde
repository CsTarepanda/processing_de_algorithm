int SIZE = 16;
int CELL_SIZE = 30;
void settings() {
  size(SIZE * CELL_SIZE, SIZE * CELL_SIZE);
}

int RANGE;
ArrayList<Integer> primes;
int[] map;
int sqrt_num;
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
        "\nSieve of\n        Eratosthenes"
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
  textSize(CELL_SIZE * 0.4);
}

void draw() {
  boolean next = true;
  for (int i = 0; i < map.length; i++) {
    int x = (i % SIZE) * CELL_SIZE;
    int y = (i / SIZE) * CELL_SIZE;
    fill(map[i] == -1 ? color(#f3c0ab) : 255);
    if (end && primes.contains(i + 1)) {
      fill(color(#99cfe5));
      rect(x, y, CELL_SIZE, CELL_SIZE);
      fill(0);
      text(i + 1, x + CELL_SIZE / 2, y + CELL_SIZE / 2);
    } else {
      rect(x, y, CELL_SIZE, CELL_SIZE);
      fill(0);
      text(map[i], x + CELL_SIZE / 2, y + CELL_SIZE / 2);
    }

    if (i + 1 > sqrt_num) {
      fill(0, 0, 0, 50);
      rect(x, y, CELL_SIZE, CELL_SIZE);
    }

    if (next && !end && map[i] != -1) {
      if (map[i] > sqrt_num) {
        fill(#99cfe5, 100);
        rect(x, y, CELL_SIZE, CELL_SIZE);
      } else {
        next = false;
        fill(#99cfe5, 100);
        rect(x, y, CELL_SIZE, CELL_SIZE);
      }
    }
  }
}

boolean end = false;
void mousePressed() {
  if (end) return;
  for (int i : map) {
    if (i != -1) {
      if (i > sqrt_num) {
        primes.add(i);
        end = true;
        continue;
      }
      for (int j = i - 1; j < map.length; j += i) {
        map[j] = -1;
      }
      primes.add(i);
      break;
    }
  }
  println(primes);
}

void keyPressed() {
  if (key == 'r') init();
}

void init() {
  RANGE = SIZE * SIZE;
  primes = new ArrayList<Integer>();
  map = new int[RANGE];
  sqrt_num = (int)sqrt(RANGE) + 1;
  end = false;
  
  for (int i = 0; i < map.length; i++) map[i] = i + 1;
  map[0] = -1;
}