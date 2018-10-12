PVector cursor = new PVector(0, 0);
int [] cursorXY = {0, 0};
char keyHit = ' ';
boolean [] keys = new boolean[256];
boolean [] lastKeys = new boolean[256];

void mouseDragged() {
  if (!dontDrag) moveCam(pmouseX-mouseX, pmouseY-mouseY);
}

void mouseWheel(MouseEvent event) {
  zoomCam(-event.getCount());
}

void updateCursor() {
    PVector mouseVec = new PVector(mouseX,mouseY);
  mouseVec.rotate(-1.02);
  
  cursor.set(cam).div(tileSize*cam.z).add(mmap.tilesX/2, mmap.tilesY/2);
  cursor.add((mouseVec.x-whalf)/(tileSize*cam.z), (mouseVec.y-hhalf)/(tileSize*cam.z));
  cursorXY = new int [] {floor(cursor.x),floor(cursor.y)};

}

void mouseReleased(){
  dontDrag = false;
}

void mousePressed() {
  if (mouseButton==LEFT) {
    mmap.build("conveyor", cursorXY);
    buildTabClick();
  }
  //else if (mouseButton==RIGHT) selectedBuildTab = -1;
}

boolean keyHit() {
  if (keyHit == 0) return false;
  return true;
}

boolean keyHit(int c) {
  return (keys[c] && !lastKeys[c]);
}

void setKey(boolean state) {
  int rawKey = keyCode; //println((int)key);
  if (rawKey < 256) {
    if ((rawKey>64)&&(rawKey<91)) rawKey+=32;
    if ((state) && (!lastKeys[rawKey])) {
      keyHit = (char) (rawKey);
    }
    keys[rawKey] = state;
  }
}

void updateKeys() {
  lastKeys = keys.clone();
  keyHit = (char)0;
}

void keyPressed() { 
  setKey(true);
}

void keyReleased() { 
  setKey(false);
}