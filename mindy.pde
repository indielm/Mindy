//webhooks
void settings() {
  size(w, h, P2D);
  noSmooth();
}

void setup() {
  ((PGraphicsOpenGL)g).textureSampling(2);
  config = loadJSONObject("\\data\\config.json");
  initSprites();
  mmap = new MMap("data\\map.png");
  debugInit();
  frameRate(config.getInt("frameRate"));
  vSync(config.getInt("vsync"));
}

void draw() {
  updateCursor();

  deltaT = (System.nanoTime()-lastFrame)/16000000.0;
  lastFrame=System.nanoTime();

  cam.add(camDelta.set(camTarget).sub(cam).mult(0.08*deltaT)); // deltaTime compensated low pass filter 
  renderDbgLayer();
  clear();
  imageMode(CENTER);
  pushMatrix();
  translate(-cam.x, -cam.y);
  scale(cam.z, cam.z);
  translate(whalf/cam.z, hhalf/cam.z);
  image(mmap.pgMap, 0, 0);
  image(pgDbg, 0, 0);
  popMatrix();
  drawDebugText();
}