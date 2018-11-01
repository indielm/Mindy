int debugs = 0;
PGraphics pgDbg;
ArrayList<Long> benchmark;

boolean drawDebug = false;

void bench() {
  benchmark.add(System.nanoTime());
}

long getBench(int i) {
  return benchmark.get(i+1)-benchmark.get(i);
}

void initDebug(MMap mmap) {
  pgDbg = createGraphics(mmap.tilesX*tileSize, mmap.tilesY*tileSize, P2D);
  pgDbg.noSmooth();
  ((PGraphicsOpenGL)pgDbg).textureSampling(2);
}

void drawDebugText() {
  noStroke();
  fill(0, 150);
  rect(0, 0, 260, debugs + 6);
  fill(255);
  debugs = 0;
  debugText("fps: " + (int)frameRate);
  int [] cursorXY = game.input.cursorXY;
  color c = game.render.piRawMap.get(cursorXY[0], cursorXY[1]);
  debugText(cursorXY[0] + ", " + cursorXY[01] + " - " + mapColors.get(c));// + " , " + hex(c));
  //debugText("cam " + cam);
  //debugText("camTarget " + camTarget);
  debugText(str(getBench(0)));
  debugText(str(getBench(1)));
  debugText("renderCam: " +str(getBench(2)));
  debugText(str(getBench(3)));
}

void debugText(String s) {
  text(s, 10, debugs+=14);
}

void renderDbgLayer() {
  pgDbg.beginDraw();
  pgDbg.clear();
  pgDbg.stroke(255, 0, 0);
  pgDbg.strokeWeight(1.5);
  pgDbg.noFill();
  int [] cursorXY = game.input.cursorXY;
  pgDbg.rect(cursorXY[0]*tileSize, cursorXY[1]*tileSize, tileSize, tileSize);
  pgDbg.stroke(255, 255, 0);
  pgDbg.strokeWeight(1.0);
  float rotAdj = HALF_PI* game.input.placeRotation;
  if ((blocksJson.hasKey(game.buildTab.buildType) && (blocksJson.getJSONObject(game.buildTab.buildType).hasKey("rotates")))) 
    pgDbg.line(cursorXY[0]*tileSize+tileSizeHalf, cursorXY[1]*tileSize+tileSizeHalf, cursorXY[0]*tileSize+tileSizeHalf+cos(rotAdj)*tileSize, cursorXY[1]*tileSize+tileSizeHalf+sin(rotAdj)*tileSize);
  pgDbg.endDraw();
}