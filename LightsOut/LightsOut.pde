import java.util.Stack;

boolean[][] subState = new boolean[5][5];
boolean[][] topState = new boolean[5][5];
boolean[][] goalSubState = new boolean[5][5];
boolean[][] goalTopState = new boolean[5][5];

Stack<Action> actions = new Stack<Action>();

long toastID = 0;
HashMap<Long, Toast> toasts = new HashMap<Long, Toast>();

int clicks = 0;
int goalClicks = 0;
int points = 0;
// TODO: Implement goal detect based on Top because of parity
boolean debug = false;
float margin;
float gameWidth;
int size = 5;
void setup(){
  size(480,640);
  ellipseMode(CENTER);
  rectMode(CORNER);
  for(int i = 0; i < size; i++){
    for(int j = 0; j < size; j++){
      subState[i][j] = random(1.0)>0.5;
      if(random(1.0)>.8){
        goalSubState[i][j] = !subState[i][j];
        goalClicks++;
      } else {
        goalSubState[i][j] = subState[i][j];
      }
    }
  }
  update();
  margin = width/6;
  gameWidth = width-margin*2;
}

void mousePressed(){
  int x = floor((mouseX-margin)/(gameWidth/size));
  int y = floor((mouseY-margin)/(gameWidth/size));
  if(!(x>=size||x<0||y>=size||y<0)){
    clicks++;
    subState[x][y] = !subState[x][y];
    update();
    actions.push(new Action("click", new PVector(x, y)));
  }
}

void keyPressed(){
  if(key=='+'){
    actions.push(new Action("size change", goalSubState));
    size++;
    resizing();
    resetGoal();
    update(); //<>//
  }
  if(key=='-'&&size>3){
    actions.push(new Action("size change", goalSubState));
    size--;
    resizing();
    resetGoal();
    update();
  }
  if(key=='d'){
    debug=!debug;
    addToast(new Toast("Debug", (width + margin)/2, margin/3, 100, margin/3, 30, color(255, 0, 0), random(-3, 3), random(-1,-5), 0.0, 0.1));
    actions.push(new Action("debug toggle"));
  }
  if(key=='z'){
    if(undo()){
      addToast(new Toast("Undo", (width + margin)/2, margin/3, 100, margin/3, 30, color(255, 0, 255), random(-3, 3), random(-1,-5), 0.0, 0.1));
    }
  }
}

void update(){
  resizing();
  
  boolean goalMet = true;
  for(int i = 0; i < size; i++){
    for(int j = 0; j < size; j++){
      topState[i][j]     = sum(    subState, i, j);
      goalTopState[i][j] = sum(goalSubState, i, j);
      if(topState[i][j]!=goalTopState[i][j])goalMet = false;
    }
  }
  if(goalMet){
    actions = new Stack<Action>();
    int increase = floor(((float)goalClicks+1)/((float)clicks+1) * 20 * (size-2.5));
    points += increase;
    addToast(new Toast("+"+increase, (width + margin)/2, margin/3, 100, margin/3, 30, color(0, 255, 0), random(-3, 3), random(-1,-5), 0.0, 0.1));
    clicks = 0;
    resetGoal();
  }
}

void resetGoal(){
  clicks = 0;
  goalClicks = 0;
  for(int i = 0; i < size; i++){
    for(int j = 0; j < size; j++){
      if(random(1.0)>.8){
        goalSubState[i][j] = !subState[i][j];
        goalClicks++;
      } else {
        goalSubState[i][j] = subState[i][j];
      }
    }
  }
  for(int i = 0; i < size; i++){
    for(int j = 0; j < size; j++){
      topState[i][j]     = sum(    subState, i, j);
      goalTopState[i][j] = sum(goalSubState, i, j);
    }
  }
  boolean goalMet = true;
  for(int i = 0; i < size; i++){
    for(int j = 0; j < size; j++){
      topState[i][j]     = sum(    subState, i, j);
      goalTopState[i][j] = sum(goalSubState, i, j);
      if(topState[i][j]!=goalTopState[i][j])goalMet = false;
    }
  }
  if(goalMet)resetGoal();
}

void draw(){
  background(15);
  textSize(margin/3);
  fill(255);
  textAlign(CENTER);
  text("Points: " + points + "  \nPar: " + goalClicks, width/2, margin/3);
  drawBoard(margin, margin, gameWidth, topState, color(50,255,50), color(20,40,20), color(0), 1);
  drawBoard(margin+gameWidth/4, margin*1.5+gameWidth, gameWidth/2, goalTopState, color(50,255,50), color(20,40,20), color(0), 0.5);
  if(debug)drawDebug(margin, margin, gameWidth, subState, color(255,0,0), color(0), 0, 2);
  drawToasts();
}

void drawBoard(float x, float y, float gWidth, boolean[][] state, color on, color off, color stroke, float strokeWeight){
  int sizeX = state.length;
  if(sizeX<1)return;
  int sizeY = state[0].length;
  strokeWeight(strokeWeight);
  stroke(stroke);
  fill(on);
  for(int i = 0; i < sizeX; i++){
    for(int j = 0; j < sizeY; j++){
      if(state[i][j])rect(x+i*gWidth/sizeX, y+j*gWidth/sizeY, gWidth/sizeX, gWidth/sizeY);
    }
  }
  fill(off);
  for(int i = 0; i < sizeX; i++){
    for(int j = 0; j < sizeY; j++){
      if(!state[i][j])rect(x+i*gWidth/sizeX, y+j*gWidth/sizeY, gWidth/sizeX, gWidth/sizeY);
    }
  }
}
void drawDebug(float x, float y, float gWidth, boolean[][] state, color fill, color stroke, float strokeWeight, float r){
  strokeWeight(strokeWeight);
  stroke(stroke);
  fill(fill);
  ellipseMode(CENTER);
  int sizeX = state.length;
  if(sizeX<1)return;
  int sizeY = state[0].length;
  for(int i = 0; i < sizeX; i++){
    for(int j = 0; j < sizeY; j++){
      if(state[i][j])ellipse(x+(i+0.5)*gWidth/sizeX, y+(j+0.5)*gWidth/sizeY, gWidth/sizeX/r, gWidth/sizeY/r);
    }
  }
}

void addToast(Toast toast){
  toasts.put(toastID, toast);
  toastID++;
}
void drawToasts(){
  try{
    for(long i : toasts.keySet()){
      if(toasts.get(i).dead()){
        toasts.remove(i);
      } else {
        toasts.get(i).show();
      }
    }
  } catch (Exception e){}
}

boolean sum(boolean[][] state, int x, int y){
  boolean out = true;
  if(state.length==0||x>=state.length||x<0||y>=state[0].length||y<0)return false;
  if(state[x][y])out=!out;
  if(x+1<state.length && state[x+1][y])out=!out;
  if(             x>0 && state[x-1][y])out=!out;
  if(y+1<state.length && state[x][y+1])out=!out;
  if(             y>0 && state[x][y-1])out=!out;
  return out;
}

boolean[][] resize(boolean[][] board, int newSize){
  if(board.length == newSize)return board;
  boolean[][] out = new boolean[newSize][newSize];
  int offset = abs(newSize-board.length)/2 + (newSize + ((0<(board.length - newSize))?1:0))%2;
  boolean bigger = newSize > board.length;
    for(int i = 0; i < min(newSize, board.length); i++){
      for(int j = 0; j < min(newSize, board.length); j++){
        if(bigger){
          out[i+offset][j+offset] = board[i][j];
        } else {
          out[i][j] = board[i+offset][j+offset];
        }
      }
    }
  return out;
}

void resizing(){
  subState = resize(subState, size);
  topState = resize(topState, size);
  goalSubState = resize(goalSubState, size);
  goalTopState = resize(goalTopState, size);
}

boolean undo(){
  if(points>0)points--;
  if(actions.size()==0)return false;
  Action temp = actions.pop();
  switch(temp.type){
    case "click":
      clicks--;
      subState[floor(temp.location.x)][floor(temp.location.y)] = !subState[floor(temp.location.x)][floor(temp.location.y)];
      update();
      break;
    case "debug toggle":
      debug=!debug;
      break;
    case "size change":
      size= temp.goal.length;
      goalSubState = temp.goal;
      update();
      break;
    default:
  }
  return true;
}
