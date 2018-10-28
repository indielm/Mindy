PVector cam = new PVector(0, 0, 1);
PVector camScl = new PVector(0, 0, 1);
PVector camTarget = new PVector(0, 0, 1);
PVector camDelta = new PVector(0, 0, 0);

void moveCam(float xO, float yO) {
  mouseVec.set(-xO, -yO).rotate(-QUARTER_PI);
  float zoomScale = sqrt(max(cam.z, 2));
  camTarget.add(mouseVec.mult(2.30/max(zoomScale, 4)));
  camScl.set(camTarget).div(tileScale);
}

void zoomCam(float adj) {
  camTarget.z = constrain(camTarget.z + adj/5.0, 0.3, 5.0);
  tileScale = tileSize*camTarget.z;
}

void clampCamera() {
  int xL = (int)((camTarget.z-0.625)*mmap.tilesX*tileSize/2);
  int yL = (int)((camTarget.z-0.3515)*mmap.tilesY*tileSize/2);
  camTarget.y = constrain(camTarget.y, -yL, yL);
  camTarget.x = constrain(camTarget.x, -xL, xL);
}

void vSync(int on) {
  PJOGL pgl = (PJOGL)beginPGL();
  pgl.gl.setSwapInterval(on);
  endPGL();
}

void renderCam() {
  pgRender.beginDraw();
  pgRender.ortho();
  //pgRender.perspective();
  pgRender.clear();
  pgRender.pushMatrix();
  pgRender.translate(scaleW/2, scaleH/2);
  pgRender.rotateX(QUARTER_PI/2);
  pgRender.rotateY(0);
  pgRender.rotateZ(QUARTER_PI);
  pgRender.scale(cam.z, cam.z, cam.z);
  pgRender.translate(cam.x, cam.y, 1);

  pgRender.imageMode(CENTER);
  pgRender.image(mmap.pgMap, 0, 0);
  //pgRender.image(mmap.pgBuild, 0, 0);
  pgRender.image(pgDbg, 0, 0);

  pgRender.translate(-mmap.tilesX*tileSizeHalf, -mmap.tilesY*tileSizeHalf);
  pgRender.ambientLight(234, 231, 210);

  pgRender.shape(mmap.mapBlocks);
  pgRender.shape(allModels);

  pgRender.popMatrix();
  pgRender.endDraw();
}