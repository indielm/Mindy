int debugs = 0;
PGraphics pgDbg;
ArrayList<Long> benchmark;

void bench() {
  benchmark.add(System.nanoTime());
}

long getBench(int i) {
  return benchmark.get(i+1)-benchmark.get(i);
}

void debugInit() {
  pgDbg = createGraphics(mmap.pgMap.width, mmap.pgMap.height, P2D);
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
  color c = mmap.piMap.get(cursorXY[0], cursorXY[1]);
  debugText(cursorXY[0] + ", " + cursorXY[01] + " - " + mmap.mapColors.get(c));// + " , " + hex(c));
  debugText("drawScale" + round3(camTarget.z));
  debugText("cam " + round(cam));
  debugText("camScl " + round(camScl));
  debugText("camTarget " + round(camTarget));
  debugText("cursor " +round(cursor));

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
  pgDbg.noStroke();
  pgDbg.clear();
  pgDbg.noFill();
  pgDbg.stroke(255, 0, 0);
  pgDbg.strokeWeight(1.5);
  pgDbg.noFill();
  pgDbg.rect(cursorXY[0]*tileSize, cursorXY[1]*tileSize, tileSize, tileSize);
  pgDbg.stroke(255, 255, 0);
  pgDbg.strokeWeight(1.0);
  if ((blocksJson.hasKey(buildType) && (blocksJson.getJSONObject(buildType).hasKey("rotates")))) pgDbg.line(cursorXY[0]*tileSize+tileSizeHalf, cursorXY[1]*tileSize+tileSizeHalf, cursorXY[0]*tileSize+tileSizeHalf+cos(placeRotation)*tileSize, cursorXY[1]*tileSize+tileSizeHalf+sin(placeRotation)*tileSize);
  pgDbg.stroke(80);
  pgDbg.translate(0, 0, 0);
  pgDbg.endDraw();
}

void debugGrid() {
  pgDbg.stroke(155, 0, 255);
  for (int x = 0; x < mmap.tilesX; x++) {
    pgDbg.line(x*tileSize, 0, x*tileSize, pgDbg.height);
  }
  for (int y = 0; y < mmap.tilesY; y++) {
    pgDbg.line(0, y*tileSize, pgDbg.height, y*tileSize);
  }
  pgDbg.noStroke();
}

PVector rounded = new PVector(0, 0, 0);
PVector round(PVector p) {
  rounded.set(p);
  rounded.x = round3(p.x);
  rounded.y = round3(p.y);
  rounded.z = round3(p.z);
  return rounded;
}

float round3(float number) { // very fast snippet to round float to 3 decimal places
  float tmp = number * 1000;
  return ( (float) ( (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) ) ) / 1000;
}