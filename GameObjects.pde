class MMap {
  PImage piRawMap;
  int tilesX, tilesY, totTiles;
  MMap(String path) {
    piRawMap = loadImage(path);
    tilesX = piRawMap.width; 
    tilesY = piRawMap.height;
    totTiles = tilesX*tilesY;
    cardinals = new int[] {1, tilesX, -1, -tilesX};
  }
}

class Sprite {
  int x, y, w, h;
  Sprite(String [] split) {
    x = parseInt(split[1].trim());
    y = parseInt(split[2].trim());
    w = parseInt(split[3].trim());
    h = parseInt(split[4].trim());
  }
}

class Model {
  String sprite;
  float bend, h;
  int type, texAngle;
  Model(String sprite, float bend, float h, int type, int texAngle) {
    this.sprite = sprite;
    this.bend = bend;
    this.h = h;
    this.type = type;
    this.texAngle = texAngle;
  }
}

class Block {
  PShape shape;
  String type;
  int index;
  JSONObject properties;
  int [] loc;
  Block(int index, String type, int [] loc) {
    this.type = type;
    this.index = index;
    this.loc = new int []{loc[0], loc[1]};
    properties = blocksJson.getJSONObject(type);
    refresh();
  }
  
  void refresh() {
    if (shape!=null) game.render.removeModel(shape);
    shape = game.render.addModel(properties, loc);
  }
}