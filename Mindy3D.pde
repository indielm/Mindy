
import peasy.PeasyCam;

//PeasyCam pcam;


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
  //noCursor();
  //pcam = new PeasyCam(this,400);
  hint(ENABLE_TEXTURE_MIPMAPS);
  d();
}

PShape sd;

void d() {

  PShape cube = mmap.TexturedCube(getSprite("router"), 0, 0);
  sd = createShape(GROUP);

  //pushMatrix();
  for (int i = 0; i < 100; i++) {

    for (int q = 0; q < 100; q++) {
      // cube.texture(getSprite("conveyor"));
      sd.addChild(mmap.TexturedCube(getSprite("router"), i, q));
      //translate(8, 0, 0);
      //shape(cube);
    }
   // translate(-8*100, 8, 0);
  }

  //popMatrix();
}

void draw() {
  if (frameCount<2) d();
  ortho();
  // println(pcam.getPosition());


  //println(pcam.getRotations());
  //println(pcam.get


  updateCursor();
  updateKeys();

  deltaT = (System.nanoTime()-lastFrame)/16000000.0;
  lastFrame=System.nanoTime();

  cam.add(camDelta.set(camTarget).sub(cam).mult(0.08*deltaT)); // deltaTime compensated low pass filter 
  renderDbgLayer();
  clear();


  /*clear();
   imageMode(CENTER);
   strokeCap(SQUARE);
   pushMatrix();
   translate(-cam.x, -cam.y);*/
  pushMatrix();
  //translate(mmap.pgMap.width/2,mmap.pgMap.height/2);

  rotateX(0.80);
  //       ^^^
  rotateY(0.00);
  rotateZ(0.80);
  //translate(-mmap.pgMap.width/2,-mmap.pgMap.height/2);
  // scale(cam.z, cam.z);
  scale(cam.z*2, cam.z*2, cam.z*2);
  translate(cam.x, cam.y, -243);
  //translate(whalf/cam.z, hhalf/cam.z);
  float z = 0;
  image(mmap.pgMap, -z, -z, mmap.pgMap.width+z*2, mmap.pgMap.height+z*2);
  image(mmap.pgBuild, 0, 0);
  image(pgDbg, 0, 0);

  //  lights();
  ambientLight(245, 240, 228);
  ////  ambient(color(192,32,32));

  // hint(DISABLE_TEXTURE_MIPMAPS );
  for (String s : mmap.blockShapeGroups.keySet()){
    shape(mmap.blockShapeGroups.get(s));
  }
  //shape(mmap.shBlocks);
  //shape(sd);

  popMatrix();

  // shape(mmap.TexturedCube(,,)

  //popMatrix();

  /*pushMatrix();
   translate(mouseX,mouseY);
   rotate(-2.31);
   image(getSprite("icon-arrow"),-15,3,29,25);
   popMatrix();*/

  Set<String> sprites = spritesAtlas.keySet();
  String [] s = sprites.toArray(new String[0]);
  ArrayList<String> icons = new ArrayList<String>();
  for (String spr : spritesAtlas.keySet()) {
    if (spr.startsWith("icon")) icons.add(spr);
  }
  int q = (int)(icons.size()*(mouseX/(float)width));
  //image(getSprite(icons.get(q)), mouseX, mouseY, 48, 48);
  //println(s[q], q, icons.size(), sprites.size(), spritesAtlas.size());


  //drawBuildTab();
  //drawDebugText();


  println(frameRate);
}