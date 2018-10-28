import java.util.concurrent.*;
import java.util.*;

ConcurrentHashMap<String, Sprite> spritesAtlas;
ConcurrentHashMap<String, PImage> spriteImages;

//ConcurrentHashMap<String, PShape> models;

ConcurrentHashMap<String, Model> Models;

PImage spriteSheet;

class Sprite {
  int x, y, w, h;
  Sprite(String [] split) {
    x = parseInt(split[1].trim());
    y = parseInt(split[2].trim());
    w = parseInt(split[3].trim());
    h = parseInt(split[4].trim());
  }
}

void initSprites() {
  spriteImages = new ConcurrentHashMap<String, PImage>();
  spriteSheet = loadImage("data/sprites.png");
  spritesAtlas = new ConcurrentHashMap<String, Sprite>();
  String [] lines = loadStrings("data/atlas.csv");
  for (String line : lines) {
    String [] split = line.split(",");
    spritesAtlas.put(split[0], new Sprite(split));
  }
  //mmap.initDraw();
}

PImage getSprite(String name) { // return sprite, if first request of sprite load it into spriteImages
  if (spriteImages.containsKey(name)) return spriteImages.get(name);
  Sprite sp = spritesAtlas.get(name); 
  spriteImages.put(name, (sp!=null) ? spriteSheet.get(sp.x, sp.y, sp.w, sp.h) : getSprite("blank"));
  return spriteImages.get(name);
}

PImage getVariant(String type) { // tiles ending with # have a random variant numbered 1-3 
  return getSprite(type.replace('#', str(floor(random(1, 4))).charAt(0)));
}

class Model {
  int type, texAngle;
  float bend, h;
  String sprite;
  Model(String sprite, float bend, float h, int type, int texAngle) {
    this.sprite = sprite;
    this.bend = bend;
    this.h = h;
    this.type = type;
    this.texAngle = texAngle;
  }
}

JSONObject blocksJson;
int loadModels() {
 allModels = createShape(GROUP);


  Models = new ConcurrentHashMap<String, Model>();
  //JSONArray json = loadJSONArray("data/models.json");
  
  //models = new ConcurrentHashMap<String,PShape>();////new HashMap<String, PShape>();

  Set<String> keys = (Set<String>)blocksJson.keys();

  for (String obj : keys) {
    JSONObject model = blocksJson.getJSONObject(obj);
    if (model.getInt("type") == 1)
      Models.put(obj, new Model(obj, model.getFloat("bend"), model.getFloat("height"), model.getInt("type"), model.getInt("texAngle")));
  }

  //for (int i = 1; i < modelsJson.size(); i++) {
  //JSONObject model = json.getJSONObject(i);
  //if (model.getInt("type") == 1)
  //models.put(model.getString("sprite"), paraModel1(model.getString("sprite"), model.getFloat("bend"), model.getFloat("height"), model.getInt("texAngle"), false));

  //Models.put(model.getString("sprite"),new Model(model.getString("sprite"), model.getFloat("bend"), model.getFloat("height"), model.getInt("type"), model.getInt("texAngle")));  
  //}

  for (int i : blocks.keySet()) {
    blocks.get(i).refresh();
  }
  PShape core = getNewModel("core");
  allModels = createShape(GROUP);
  core.translate(1024, 1024);
  allModels.addChild(core);
  
  return Models.size();
}

PShape getNewModel(String tex) {
  return paraModel1(Models.get(tex));
}

PShape paraModel1(Model m) {
  if (m==null) return null;
  return paraModel1(m.sprite, m.bend, m.h, m.texAngle, false);
}

PShape paraModel1(String texture, float bend, float b, int texAngle, boolean backFaceCull) {
  float a = 0, c = 0.00, f = 3.00, h = 1.0;
  float d = h-bend, e = 3-h+bend;
  float [][]modelVerts;
  if (backFaceCull) {
    float [][] culled = {{f, f, a}, {e, e, b}, {c, f, a}, {d, e, b}, {c, c, a}, {d, d, b}, {d, e, b}, {e, d, b}, {e, e, b}};
    modelVerts = culled;
  } else {
    float [][] full =  {{c, c, a}, {d, d, b}, {f, c, a}, {e, d, b}, {f, f, a}, {e, e, b}, {c, f, a}, {d, e, b}, {c, c, a}, {d, d, b}, {d, e, b}, {e, d, b}, {e, e, b}};
    modelVerts = full;
  }
  PShape model = createShape();
  model.beginShape(TRIANGLE_STRIP);
  model.textureMode(IMAGE);
  model.texture(spriteSheet);
  Sprite sp = spritesAtlas.get(texture);
  model.noStroke();
  float scale = 0;

  //model.translate(-3*tileSize, -tileSize, 0);
  if (sp.w == 8) {
    model.translate(-tileSize, 0, 0);
    scale = tileSize/3.0;
  } else {
    model.translate(-3*tileSize, -tileSize, 0);
    scale = tileSize;
  }
  model.rotate(-HALF_PI);
  float tiles = 3;

  PVector uv = new PVector(0, 0);
  for (float[] p : modelVerts) {
    uv.set(p[0]/tiles-0.5, p[1]/tiles-0.5)
      .rotate(texAngle*HALF_PI)
      .add(0.5, 0.5);
    model.vertex(p[0]*scale, p[1]*scale, p[2]*scale, uv.x*sp.w +sp.x, uv.y*sp.h+sp.y);
  }
  model.endShape();
  return model;
}