PVector cam = new PVector(0, 0, 1);
PVector camScl = new PVector(0, 0, 1);
PVector camTarget = new PVector(0, 0, 1);
PVector camDelta = new PVector(0, 0, 0);

void moveCam(float xO, float yO) {
  PVector mouseVec = new PVector(-xO, -yO);
  mouseVec.rotate(-1.02);
  float zoomScale = sqrt(max(cam.z, 2));
  float mult = 7.00/max(zoomScale, 4);
  camTarget.x += mult*(mouseVec.x);
  camTarget.y += mult*(mouseVec.y);
  //clampCamera();
  camScl.set(camTarget).div(tileScale);
}

void zoomCam(float adj) {
  float prev = drawScale;
  drawScale = constrain(drawScale + adj/5.0, 0.7, 4.0);
  tileScale = tileSize*drawScale;
  camTarget.mult(drawScale/prev);
  camTarget.z = drawScale;
  //int sign = (int)(abs(adj)/adj);
  //     PVector mouseVec = new PVector(mouseX,mouseY);
  // mouseVec.rotate(-1.02);
  // moveCam(sign*(mouseVec.x-whalf)/tileSize, sign*(mouseVec.y-hhalf)/tileSize);
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