import java.util.concurrent.*;
import java.util.*;

Game game;

final int w = 1280, h = 720, whalf =w/2, hhalf = h/2;
final int tileSize = 8, tileSizeHalf = tileSize/2;

JSONObject config;
JSONObject blocksJson;

 PImage piBuildMenu;

ConcurrentHashMap<String, Sprite> spritesAtlas;
ConcurrentHashMap<String, Model> Models;
HashMap<Integer, String> mapColors;
HashMap<String, Integer> edgeRanks;

void settings() {
  size(w, h, P3D);
  noSmooth();
}

void setup() {
  ((PGraphicsOpenGL)g).textureSampling(2);
  initAssets();
  game = new Game(this);
  frameRate(config.getInt("frameRate"));
  vSync(config.getInt("vsync"));
  thread("fileWatch");
}


void vSync(int on) {
  PJOGL pgl = (PJOGL)beginPGL();
  pgl.gl.setSwapInterval(on);
  endPGL();
}

void draw() {    
  background(0);
  benchmark = new ArrayList<Long>();
  bench();
  game.update();
  bench();
  game.draw();
}