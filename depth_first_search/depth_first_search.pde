import java.util.*;
int SIZE = 4;
int RANGE = 1 << SIZE;
int CELL_SIZE = 25;
Node top;
Deque<Lambda> que;
void setup() {
  size(500, 500);
  init();
  frameRate(8);
}

void init() {
  pattern = RANGE;
  end = false;
  click = false;
  goal = false;
  que = new ArrayDeque<Lambda>();
  ArrayList<Node> nodes = new ArrayList<Node>();
  for (int i = RANGE; i > 0; i--) {
    nodes.add(createNode(null, null, CELL_SIZE/2 + (width - (float)CELL_SIZE)/(RANGE + 1) * i, height - CELL_SIZE/2 - height/5));
  }

  ArrayList<Node> lastnodes = new ArrayList<Node>();
  while (nodes.size() > 0) {
    ArrayList<Node> newnodes = new ArrayList<Node>();
    Node left = null;
    for (Node n : nodes) {
      if (left == null) left = n;
      else {
        newnodes.add(createNode(new Tree(left), new Tree(n), (left.x + n.x)/2, n.y - CELL_SIZE * 2));
        left = null;
      }
    }
    lastnodes = nodes;
    nodes = newnodes;
  }
  top = lastnodes.get(0);
  if (!goal || top instanceof GoalNode) init();
}

Node createNode(Tree l, Tree r, float x, float y) {
  return goal || random(100) > 10
    ? new Node(l, r, x, y)
    : new GoalNode(l, r, x, y);
}

void keyPressed() {
  if (key == 'r') init();
}

int pattern;
boolean end;
boolean click;
void mousePressed() {
  if (end || click) return;
  click = true;
  top.resolve();
  que.push(new Lambda() {
    Node n;
    public void apply() {
      n.changeColor(CLEAR);
    }
    public Lambda setParams(Node n) {
      this.n = n;
      return this;
    }
  }
  .setParams(top));
}

void draw() {
  background(255);
  top.update();
  Lambda next = que.poll();
  if (next != null) next.apply();
  if (end) {
    textSize(30);
    textAlign(CORNER, CORNER);
    fill(0);
    text("end", 10, 30);
  }
}

final color CLEAR = color(255, 100, 0);
class Tree {
  Node node;
  Tree(Node node) {
    this.node = node;
  }

  void update(float x, float y) {
    stroke(0);
    strokeWeight(1);
    line(x, y, node.x, node.y);
    if (node != null) node.update();
  }

  void resolve() {
    que.add(new Lambda() {
      Node n;
      public void apply() {
        n.changeColor(CLEAR);
      }
      public Lambda setParams(Node n) {
        this.n = n;
        return this;
      }
    }
    .setParams(node));
    node.resolve();
  }
}

boolean goal;
class Node {
  Tree r, l;
  float x, y;
  color col = color(100, 150, 255);
  Node(Tree l, Tree r, float x, float y) {
    this.l = l;
    this.r = r;
    this.x = x;
    this.y = y;
  }

  void link(Node l, Node r) {
    this.l = new Tree(l);
    this.r = new Tree(r);
  }

  void update() {
    noStroke();
    fill(col);
    ellipse(x, y, CELL_SIZE, CELL_SIZE);
    if (l != null) l.update(x, y);
    if (r != null) r.update(x, y);
  }

  void resolve() {
    if (end) return;
    if (l != null) l.resolve();
    if (end) return;
    if (r != null) r.resolve();
  }

  void changeColor(color col) {
    this.col = col;
  }
}

class GoalNode extends Node {
  GoalNode(Tree l, Tree r, float x, float y) {
    super(l, r, x, y);
    goal = true;
    col = color(100, 255, 100);
  }

  void resolve() {
    end = true;
  }
}

interface Lambda {
  void apply();
}