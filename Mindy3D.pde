import java.util.*;

void settings() {
  size(w, h, P3D);
  noSmooth();
  // PJOGL.profile = 4;
}

void setup() {
  ((PGraphicsOpenGL)g).textureSampling(2);
  config = loadJSONObject("/data/config.json");
  initSprites();
  piBuildMenu = loadImage("/data/buildMenu.png");
  distribution = loadJSONArray("/data/distribution.json");
  mmap = new MMap("/data/map.png");
  debugInit();
  frameRate(config.getInt("frameRate"));
  vSync(config.getInt("vsync"));

  hint(ENABLE_TEXTURE_MIPMAPS);
}

void draw() {
  ortho();

  updateCursor();
  updateKeys();

  deltaT = (System.nanoTime()-lastFrame)/16000000.0;
  lastFrame=System.nanoTime();

  cam.add(camDelta.set(camTarget).sub(cam).mult(0.08*deltaT)); // deltaTime compensated low pass filter 
  renderDbgLayer();
  clear();

  pushMatrix();

  rotateX(0.80);
  rotateY(0.00);
  rotateZ(0.80);

  scale(cam.z*2, cam.z*2, cam.z*2);
  translate(cam.x, cam.y, -243);

  float z = 0;
  image(mmap.pgMap, -z, -z, mmap.pgMap.width+z*2, mmap.pgMap.height+z*2);
  image(mmap.pgBuild, 0, 0);
  image(pgDbg, 0, 0);

  //  lights();
  ambientLight(245, 240, 228);
  ////  ambient(color(192,32,32));

  for (String s : mmap.blockShapeGroups.keySet()) {
    shape(mmap.blockShapeGroups.get(s));
  }
  popMatrix();
  println(frameRate);
}