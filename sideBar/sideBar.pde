// Classes
public class CircularLL {
  int size;
  Task start;
  void insertTask(Task t) {
    if (start != null) {
      t.next = start.next;
      start.next = t;
      t.prev = start;
      t.next.prev = t;
    }
    else {
      start = t;
      t.next = t;
      t.prev = t;
    }
    size++;
  }
  int removeTask(int n) { // remove nth task from start
    size--;
    if (start != start.next) {
      Task cur = start;
      for (int i = 0; i < n; i++, cur = cur.prev) {}
      cur.next.prev = cur.prev;
      cur.prev.next = cur.next;
      if (n == 0) start = cur.prev;
      cur = null;
      return 1;
    }
    start = null;
    return 0;
  }
}

public class Task {
  int ID;
  String content;
  Task next;
  Task prev;
  int R;
  int G;
  int B;
  Task(int n) {
    R = 255;
    G = 255 - 5*n;
    B = 255 - 5*n;
    ID = n;
    this.content = "Task " + this.ID;
  }
}

// Setups
CircularLL taskList = new CircularLL();
int maxBlocks = 8;
Task[] taskBlocks = new Task[maxBlocks];
int nBlocks = 0;
int hoverBlock = -1; // Block index which is zoomed.
int taskInit = 30;
int taskCounter = 0;

// Apperance
float zoomSpan = 0; // Space a zoomed block takes.
int scrollSpeed = 5;
int rBlock = 7; // Round angles
int defaultTextSize = 50; // For device
//int defaultTextSize = 12; // On computer
int addButtonStroke = 4;
int backgroundColor = #000000;
int selectedColor = #E9FD42;
int blockTextColorIdle = #000000;
int blockTextColorTouched = #FA1212;
int timeCounter = 0;
int threshold = 40;
boolean onMove = false;
boolean zoomOption = false;

// Size ratios:
float reserved = 0; // Reserved for additional blocks
float B2W = 1/5.0; // Block to Width
float M2W = 4/5.0; // Margin to Width
float F2BH = 1/10.0; // Frame to Block Height
float S2BH = 1-2*F2BH; // Space to Block Height
float F2BHr = 1/16.0; // Frame to Block Height (reduced)
float S2BHi = 1-2*F2BHr; // Space to Block Height (increased)
///////////////////////////////////////////////////////////////////
void setup() {
  background(backgroundColor);
  fullScreen(); //For device
  //size(200,500); //On computer
  textAlign(CENTER,CENTER);
  noStroke();
  for (; taskCounter<taskInit; taskCounter++) {
    Task t = new Task(taskCounter);
    taskList.insertTask(t);
  }
}

void draw() {
  nBlocks = min(maxBlocks, taskList.size);
  zoomSpan = max(1,nBlocks/3.0);
  Task cur = taskList.start;
  if (mousePressed) {
    hoverBlock = (hoverBlock == -1)? min(nBlocks-1,mouseY/(height/nBlocks)) : findHoverBlock();
    if (mouseY == pmouseY) timeCounter++;
    else if (hoverBlock != findHoverBlock()) timeCounter = 0;
  }
  else {
    hoverBlock = -1;
    timeCounter = 0;
  }
  //println(hoverBlock);
  for (int i = 0; i < nBlocks; i++) {
    taskBlocks[i] = cur;
    cur = cur.prev;
  }
  drawList();
}

int findHoverBlock() { // Find which block is zoomed
  float incHeight = zoomSpan*height*(1-reserved)/nBlocks;
  float decHeight = (height*(1-reserved)-incHeight)/(nBlocks-1);
  float lower = height*reserved+hoverBlock*decHeight;
  float upper = height*reserved+hoverBlock*decHeight+incHeight;
  if (mouseY >= lower && mouseY <= upper) return hoverBlock;
  else if (mouseY > upper) return min(nBlocks-1,hoverBlock+1);
  else return max(0,hoverBlock-1);
}

void mouseDragged() {
  if (timeCounter < threshold) {
    if (mouseY > pmouseY) scrollDown(scrollSpeed*nBlocks*(mouseY - pmouseY)/height);
    else if (mouseY < pmouseY) scrollUp(scrollSpeed*nBlocks*(pmouseY - mouseY)/height);
  }
  else {
    moveBlock(hoverBlock, findHoverBlock());
  }
}

void drawList() {
  background(backgroundColor);
  //noStroke();
  rect(M2W*width, F2BH*height*reserved, B2W*width, S2BH*height*reserved,rBlock);
  float blockHeight = (1-reserved)*height/nBlocks;
  if (hoverBlock < 0) {
    for (int i = 0; i < nBlocks; i++) { 
      fill(taskBlocks[i].R,taskBlocks[i].G,taskBlocks[i].B);
      rect(M2W*width, height*reserved+i*blockHeight+F2BH*blockHeight, B2W*width, S2BH*blockHeight,rBlock);
      textSize(defaultTextSize);
      fill(blockTextColorIdle);
      text(taskBlocks[i].ID+"", M2W*width, height*reserved+i*blockHeight+F2BH*blockHeight, B2W*width/2, S2BH*blockHeight);
    }
  }
  else {
    float incHeight = zoomSpan*height*(1-reserved)/nBlocks;
    float decHeight = (nBlocks>1)? (height*(1-reserved)-incHeight)/(nBlocks-1) : 0;
    for (int i = 0; i < hoverBlock; i++) { 
    // Blocks above the hovered
      fill(taskBlocks[i].R,taskBlocks[i].G,taskBlocks[i].B);
      if (zoomOption) {
        rect(M2W*width, height*reserved+i*decHeight+F2BH*decHeight, B2W*width, S2BH*decHeight,rBlock);
        textSize(defaultTextSize/2);
        fill(blockTextColorIdle);
        text(taskBlocks[i].ID+"", M2W*width, height*reserved+i*decHeight+F2BH*decHeight, B2W*width/2, S2BH*decHeight);
      }
      else {
        rect(M2W*width, height*reserved+i*blockHeight+F2BH*blockHeight, B2W*width, S2BH*blockHeight,rBlock);
        textSize(defaultTextSize);
        fill(blockTextColorIdle);
        text(taskBlocks[i].ID+"", M2W*width, height*reserved+i*blockHeight+F2BH*blockHeight, B2W*width/2, S2BH*blockHeight);
      }
    }
    // hovering Block
    if (timeCounter > threshold) {
      fill(selectedColor);
    } else {
      fill(taskBlocks[hoverBlock].R,taskBlocks[hoverBlock].G,taskBlocks[hoverBlock].B);
    }
    if (zoomOption) {
      rect(M2W*width, height*reserved+hoverBlock*decHeight+F2BHr*incHeight, B2W*width, S2BHi*incHeight,rBlock); 
      textSize(defaultTextSize);
      fill(blockTextColorIdle);
      text(taskBlocks[hoverBlock].ID+"", M2W*width, height*reserved+hoverBlock*decHeight+F2BHr*incHeight, B2W*width/2, S2BHi*incHeight);
    }
    else {
      rect(M2W*width, height*reserved+hoverBlock*blockHeight+F2BH*blockHeight, B2W*width, S2BH*blockHeight,rBlock);
      textSize(defaultTextSize);
      fill(blockTextColorTouched);
      strokeWeight(4);
      text(taskBlocks[hoverBlock].ID+"", M2W*width, height*reserved+hoverBlock*blockHeight+F2BH*blockHeight, B2W*width/2, S2BH*blockHeight);
    }    
    for (int i = hoverBlock+1; i < nBlocks; i++) { 
      // Blocks below the hovering
      fill(taskBlocks[i].R,taskBlocks[i].G,taskBlocks[i].B);
      if (zoomOption) {
        rect(M2W*width, height*reserved+(i-1)*decHeight+F2BH*decHeight+incHeight, B2W*width, S2BH*decHeight,rBlock);
        textSize(defaultTextSize/2);
        fill(blockTextColorIdle);
        text(taskBlocks[i].ID+"", M2W*width, height*reserved+(i-1)*decHeight+F2BH*decHeight+incHeight, B2W*width/2, S2BH*decHeight);
      }
      else {
        rect(M2W*width, height*reserved+i*blockHeight+F2BH*blockHeight, B2W*width, S2BH*blockHeight,rBlock);
        textSize(defaultTextSize);
        fill(blockTextColorIdle);
        text(taskBlocks[i].ID+"", M2W*width, height*reserved+i*blockHeight+F2BH*blockHeight, B2W*width/2, S2BH*blockHeight);
      }
    }
  }
}

void scrollDown(int n) {
  while (n > 0) {
    taskList.start = taskList.start.next;
    n--;
  }
}

void scrollUp(int n) {
  while (n > 0) {
    taskList.start = taskList.start.prev;
    n--;
  }
}

void moveBlock(int org, int dest) {
  if (org != dest && org>-1 && dest>-1 && dest<nBlocks) {
    println(org, dest);
    Task ts = taskBlocks[org], td = taskBlocks[dest];
    println(ts.ID, td.ID);
    ts.prev.next = ts.next;
    ts.next.prev = ts.prev;
    if (org < dest) {
      if (org == 0) taskList.start = ts.prev;
      ts.next = td;
      ts.prev = td.prev;
      td.prev.next = ts;
      td.prev = ts;
    }
    else {
      if (dest == 0) taskList.start = ts;
      ts.next = td.next;
      ts.prev = td;
      td.next.prev = ts;
      td.next = ts;
    }
  }
}

boolean addButtonHover() {
  return pmouseX>=M2W*width && pmouseX<=(1-M2W)*width && pmouseY>=F2BH*height*reserved && pmouseY<=(1-F2BH)*height*reserved;
}
