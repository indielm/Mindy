PVector cam = new PVector(0, 0, 1);
PVector camScl = new PVector(0, 0, 1);
PVector camTarget = new PVector(0, 0, 1);
PVector camDelta = new PVector(0, 0, 0);

void moveCam(float xO, float yO) {
  float zoomScale = sqrt(max(cam.z, 2));
  float mult = 7.00/max(zoomScale, 4);
  camTarget.x += mult*(xO);
  camTarget.y += mult*(yO);
  clampCamera();
  camScl.set(camTarget).div(tileScale);
}

void zoomCam(float adj) {
  float prev = drawScale;
  drawScale = constrain(drawScale + adj/5.0, 0.7, 4.0);
  tileScale = tileSize*drawScale;
  camTarget.mult(drawScale/prev);
  camTarget.z = drawScale;
  int sign = (int)(abs(adj)/adj);
  moveCam(sign*(mouseX-whalf)/tileSize, sign*(mouseY-hhalf)/tileSize);
}

void clampCamera() {
  int xL = (int)((drawScale-0.625)*mmap.tilesX*tileSize/2);
  int yL = (int)((drawScale-0.3515)*mmap.tilesY*tileSize/2);
  camTarget.y = constrain(camTarget.y, -yL, yL);
  camTarget.x = constrain(camTarget.x, -xL, xL);
}

void vSync(int on) {
  PJOGL pgl = (PJOGL)beginPGL();
  pgl.gl.setSwapInterval(on);
  endPGL();
}