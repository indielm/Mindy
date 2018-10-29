PVector cursor = new PVector(0, 0);
PVector mouseVec = new PVector(0, 0);
int [] cursorXY = {0, 0}, lastXY = {0, 0};
char keyHit = ' ';
boolean [] keys = new boolean[256];
boolean [] lastKeys = new boolean[256];
float placeRotation = 0;
boolean [] mouseButtons = new  boolean[40];


void mouseDragged() {
  if ((mouseButton == RIGHT) && (!dontDrag)) moveCam(pmouseX-mouseX, pmouseY-mouseY);
  else if (mouseButton == LEFT) {

    if (blocksJson.hasKey(buildType) && (blocksJson.getJSONObject(buildType).hasKey("rotates"))) {
      if ((cursorXY[0]!=lastXY[0]) || (cursorXY[1]!=lastXY[1])) {
        PVector mouseDelta = new PVector(cursorXY[0]-lastXY[0], cursorXY[1]-lastXY[1]);
        float heading = mouseDelta.heading();
        if ((abs(cursorXY[0]-lastXY[0]) + abs(cursorXY[1]-lastXY[1])) == 1) {
          heading = ((round((heading+PI)/HALF_PI)-1)*PI)/2 - HALF_PI;
          placeRotation = heading;
          setBlock(cursorXY, buildType);
          //setBlock(lastXY, buildType);
        }
        lastXY[0]=cursorXY[0];
        lastXY[1]=cursorXY[1];
      }
    }
  }
}

void mouseWheel(MouseEvent event) {
  if (keys[CONTROL] || (mouseButtons[RIGHT])) zoomCam(-event.getCount());
  else {
    placeRotation+=event.getCount()*HALF_PI;
    if (placeRotation<0) placeRotation += TWO_PI;
    else if (placeRotation>=TWO_PI) placeRotation -= TWO_PI;
  }
}

void updateCursor() {
  mouseVec.set(width/2, height/2).sub(mouseX, mouseY);
  mouseVec.y *= 1.10;
  mouseVec.rotate(QUARTER_PI + HALF_PI)
    .div(tileSize*cam.z*1.5)
    .add(cam.copy().div(-tileSize))
    .add(scaleW/6.67, scaleH/3.748);
  cursorXY = new int [] {floor(mouseVec.x), floor(mouseVec.y)};
}

void mouseReleased() {
  mouseButtons[mouseButton] = false;
  dontDrag = false;
}

void mousePressed() {
  mouseButtons[mouseButton] = true;
  if (mouseButton==LEFT) {
    mouseAction();
  } else if (mouseButton==RIGHT) selectedBuildTab = -1;
}

void mouseAction() {
  setBlock(cursorXY, buildType);
  buildTabClick();
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