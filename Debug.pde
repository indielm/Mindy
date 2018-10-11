int debugs = 0;
PGraphics pgDbg;

void debugInit() {
  pgDbg = createGraphics(mmap.pgMap.width, mmap.pgMap.height, P2D);
  pgDbg.noSmooth();
  ((PGraphicsOpenGL)pgDbg).textureSampling(2);
}

void drawDebugText() {
  noStroke();
  fill(0, 150);
  rect(0, 0, 150, debugs + 6);
  fill(255);
  debugs = 0;
  debugText("fps: " + (int)frameRate);
  color c = mmap.piMap.get(cursorX, cursorY);
  debugText(cursorX + ", " + cursorY + " - " + mmap.mapColors.get(c));// + " , " + hex(c));
  debugText("drawScale" + drawScale);
  debugText("cam " + cam);
  debugText("camScl " + camScl);
  debugText("virtCam " + camTarget);
  debugText("cursor " +cursor);
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
  pgDbg.strokeWeight(2);
  pgDbg.rect(cursorX*tileSize, cursorY*tileSize, tileSize, tileSize);
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