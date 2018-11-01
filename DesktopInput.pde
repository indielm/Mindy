class DesktopInput {
  boolean mouseLeft = false, mouseRight = false; 
  PVector mouseVec = new PVector(0, 0);

  char keyHit = ' ';
  boolean [] keys = new boolean[256];
  boolean [] lastKeys = new boolean[256];

  int [] cursorXY = {0, 0}, lastXY = {0, 0};
  float placeRotation = 0;

  DesktopInput() {
  }

  void keyEvent(KeyEvent e) {
    int action = e.getAction();
    int key = e.getKey();
    switch(action) {

    case KeyEvent.PRESS:
      setKey(true, e.getKeyCode());
      if (key=='c') game.buildTab.buildTabOpen = !game.buildTab.buildTabOpen; 
      else if (key =='d') drawDebug = !drawDebug;
      break;

    case KeyEvent.RELEASE:
      setKey(false, e.getKeyCode());
      break;
    }
  }

  void mouseEvent(MouseEvent e) {
    int action = e.getAction();
    switch(action) {

    case MouseEvent.PRESS:
      if (e.getButton()==LEFT) {
        mouseLeft = true;
        game.buildTab.buildTabClick();
      }
      if (e.getButton()==RIGHT) {
        mouseRight = true;
        game.buildTab.selectedSlot = -1;
        game.buildTab.buildType = "";
      }
      break;

    case MouseEvent.RELEASE:
      if (e.getButton()==LEFT) {
        mouseLeft = false;
        game.buildTab.dontDrag = false;
      }
      if (e.getButton()==RIGHT) {
        mouseRight = false;
      }
      break;

    case MouseEvent.WHEEL:
      if (keys[CONTROL] || mouseRight) game.render.zoomCam(-e.getCount());
      else {
        placeRotation+=e.getCount();
        if (placeRotation<0) placeRotation += 4;
        if (placeRotation>=4) placeRotation -= 4;
      }
      break;

    case MouseEvent.MOVE:
      updateCursor();
      break;


    case MouseEvent.DRAG:
      updateCursor(); //drag event canceled out move event
      if ((mouseButton == RIGHT) && (!game.buildTab.dontDrag)) game.render.moveCam(pmouseX-mouseX, pmouseY-mouseY);
      else if (mouseButton == LEFT) {
        JSONObject properties = blocksJson.getJSONObject(game.buildTab.buildType);
        if (properties==null) return;

        if (properties.hasKey("rotates")) {
          if ((cursorXY[0]!=lastXY[0]) || (cursorXY[1]!=lastXY[1])) {
            PVector mouseDelta = new PVector(cursorXY[0]-lastXY[0], cursorXY[1]-lastXY[1]);
            float heading = mouseDelta.heading();
            if ((abs(cursorXY[0]-lastXY[0]) + abs(cursorXY[1]-lastXY[1])) == 1) {
              heading = ((round((heading+PI)/HALF_PI)-1)*PI)/2 - HALF_PI;
              placeRotation = heading/HALF_PI;
              if (placeRotation<0) placeRotation += 4;
              if (placeRotation>=4) placeRotation -= 4;
              game.setBlock(cursorXY, game.buildTab.buildType);
              //setBlock(lastXY, buildType);
            }
            lastXY = cursorXY.clone();
          }
        }
      }
      break;
    }
  }

  void updateCursor() {
    mouseVec.set(width/2, height/2).sub(mouseX, mouseY);
    mouseVec.y *= 1.10;
    mouseVec.rotate(QUARTER_PI + HALF_PI)
      .div(tileSize*game.render.cam.z*1.0)
      .add(game.render.cam.copy().div(-tileSize))
      .add(w/10.0, h/5.616);
    cursorXY = new int [] {floor(mouseVec.x), floor(mouseVec.y)};
  }

  boolean keyHit() {
    return (keyHit != 0);
  }

  boolean keyHit(int c) {
    return (keys[c] && !lastKeys[c]);
  }

  void setKey(boolean state, int code) {
    int rawKey = code; 
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
}