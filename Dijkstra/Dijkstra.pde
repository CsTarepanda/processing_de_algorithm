import java.util.*;
int SIZE = 16;
int CELL_SIZE = 30;
void settings() {
  size(500, 500);
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
        "\nDijkstra's algorithm"
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
  textSize(CELL_SIZE * 0.5);
}

void draw() {
  background(255);
  for(Node n: nodes) n.update();
  for(Link l: links) l.update();
  for(Node n: nodes) n.costDisplay();
  if(end) text("end", 20, 20);
}

int target;
boolean calc;
boolean end;
void mousePressed() {
  if (end) return;
  if(calc) nodes.get(target).calc();
  else nodes.get(target).next();
}

void keyPressed() {
  if (key == 'r') init();
}

void init() {
  nodes = new ArrayList<Node>();
  links = new ArrayList<Link>();
  linkMap = new HashMap<Node, Set<Node>>();
  calc = true;
  end = false;
  for(int i = 0; i < SIZE; i++){
    float x = random(CELL_SIZE/2, width - CELL_SIZE/2);
    float y = random(CELL_SIZE/2, height - CELL_SIZE/2);
    boolean createFlg = true;
    for(Node n: nodes) if(dist(x, y, n.x, n.y) < CELL_SIZE + 10){
      createFlg = false;
      break;
    }
    if(createFlg) new Node(x, y);
    else i--;
  }

  int startPoint = (int)random(nodes.size());
  int endPoint;
  while(true){
    endPoint = (int)random(nodes.size());
    if(startPoint != endPoint) break;
  }
  new StartNode(nodes.get(startPoint), startPoint).changeColor(color(255, 100, 100, 90));
  new EndNode(nodes.get(endPoint), endPoint).changeColor(color(100, 255, 100, 90));
  target = startPoint;

  for(Node n: nodes){
    boolean linkFlg = false;
    while(!linkFlg) for(int i = 0; i < SIZE; i++){
      if(nodes.get(i) != n && random(100) < 5){
        linkFlg = new Link(n, nodes.get(i), (int)random(1, 10)).linked || linkFlg;
      }
    }
  }
}

ArrayList<Node> nodes;
class Node{
  float x, y;
  int id;
  Integer cost = null;
  boolean resolved = false;
  color col1 = color(0, 100, 255, 90);
  color col2 = color(255, 225, 0, 90);
  Set<Link> route = new HashSet<Link>();
  Node(float x, float y){
    this.x = x;
    this.y = y;
    this.id = id;
    nodes.add(this);
  }
  Node(float x, float y, int index){
    this.x = x;
    this.y = y;
    this.id = id;
    nodes.set(index, this);
  }

  void update(){
    fill(!resolved || this instanceof StartNode || this instanceof EndNode ? col1 : col2);
    noStroke();
    ellipse(x, y, CELL_SIZE, CELL_SIZE);
  }

  void costDisplay(){
    if(cost != null){
      fill(255, 190);
      noStroke();
      ellipse(x, y, CELL_SIZE * 0.7, CELL_SIZE * 0.7);
      fill(0);
      text(cost, x, y);
    }
  }

  void changeColor(color col){
    this.col1 = col;
  }

  void calc(){
    for(Link l: route){
      if(l.left == this){
        l.right.cost = l.right.cost == null ? this.cost + l.cost : Math.min(l.right.cost, this.cost + l.cost);
      }else{
        l.left.cost = l.left.cost == null ? this.cost + l.cost : Math.min(l.left.cost, this.cost + l.cost);
      }
    }
    calc = false;
  }

  void next(){
    Integer minCost = null;
    Node nextTarget = null;
    for(Node n: nodes){
      if(n.cost != null && !n.resolved){
        if(minCost == null || minCost > n.cost){
          nextTarget = n;
          minCost = n.cost;
        }
      }
    }
    nextTarget.resolve(minCost);
    target = nodes.indexOf(nextTarget);
    if(nextTarget instanceof EndNode){
      nextTarget.changeColor(color(100, 255, 100, 150));
      nextTarget.search();
      end = true;
    }
    calc = true;
  }

  void resolve(int cost){
    this.resolved = true;
    this.cost = cost;
  }

  void search(){
    if(this instanceof StartNode) return;

    for(Link l: route){
      Node next = l.left == this ? l.right : l.left;
      if(next.cost == null) continue;
      if(this.cost - l.cost == next.cost){
        l.changeColor(color(0));
        next.search();
        break;
      }
    }
  }

  void link(Link route){
    this.route.add(route);
  }
}

class StartNode extends Node{
  StartNode(float x, float y){
    super(x, y);
    resolve(0);
  }
  StartNode(Node old, int index){
    super(old.x, old.y, index);
    resolve(0);
  }
}
class EndNode extends Node{
  EndNode(float x, float y){
    super(x, y);
  }
  EndNode(Node old, int index){
    super(old.x, old.y, index);
  }
}

ArrayList<Link> links;
HashMap<Node, Set<Node>> linkMap;
class Link{
  Node left, right;
  int cost;
  boolean linked = false;
  color col = color(0, 90);
  Link(Node left, Node right, int cost){
    if(linkMap.get(left) == null) linkMap.put(left, new HashSet<Node>());
    if(linkMap.get(right) == null) linkMap.put(right, new HashSet<Node>());
    if(!(linkMap.get(left).contains(right) || linkMap.get(right).contains(left))){
      linkMap.get(left).add(right);
      linkMap.get(right).add(left);
      left.link(this);
      right.link(this);

      this.left = left;
      this.right = right;
      this.cost = cost;
      links.add(this);
      linked = true;
    }
  }

  void update(){
    stroke(col);
    strokeWeight(2);
    line(left.x, left.y, right.x, right.y);
    fill(0);
    text(cost, (left.x + right.x) / 2, (left.y + right.y) / 2);
  }

  void changeColor(color col){
    this.col = col;
  }
}
