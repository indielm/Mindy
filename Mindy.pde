PShape allModels;

void settings() {
  size(w, h, P3D);
  noSmooth();
  //PJOGL.profile = 4;
}

void setup() {
  ((PGraphicsOpenGL)g).textureSampling(3);
  
  config = loadJSONObject("/data/config.json");
  blocksJson = loadJSONObject("data/blocks.json");
  distribution = loadJSONArray("/data/distribution.json");
  piBuildMenu = loadImage("/data/buildMenu.png");
  
  initSprites();
  loadModels();

  mmap = new MMap("/data/map.png");
  debugInit();
  frameRate(config.getInt("frameRate"));
  //vSync(config.getInt("vsync"));

  hint(ENABLE_TEXTURE_MIPMAPS);
  pgRender = createGraphics(floor(w/renderScale), floor(h/renderScale), P3D);
  pgRender.noSmooth();
  ((PGraphicsOpenGL)pgRender).textureSampling(3);

  for (int i = 0; i < 40; i++) mouseButtons[i] = new Boolean(false);
  buildTabInit();
  pgItemInit();
  thread("fileWatch");
}

void draw() {    
  benchmark = new ArrayList<Long>();
  benchmark.add(System.nanoTime());
  if (redrawMap || keyHit('m')) {
    mmap.initDraw();
    redrawMap = false;
  }

  background(0);
  updateCursor();
  updateKeys();

  deltaT = (System.nanoTime()-lastFrame)/16000000.0;
  lastFrame=System.nanoTime();

  cam.add(camDelta.set(camTarget).sub(cam).mult(0.18*deltaT)); // deltaTime compensated low pass filter 

  benchmark.add(System.nanoTime());
  renderDbgLayer();
  benchmark.add(System.nanoTime());
  renderCam();
  benchmark.add(System.nanoTime());
  image(pgRender, 0, 0, w, h);
  hint(DISABLE_DEPTH_TEST);
  drawBuildTab();
  benchmark.add(System.nanoTime());
  drawDebugText();
  hint(ENABLE_DEPTH_TEST);
}