HashMap<Integer, Block> blocks = new HashMap<Integer, Block>();

JSONArray blockProperties;

class Block {
  PShape shape;
  String type;
  int index;
  JSONObject properties;
  int [] loc;
  Block(int index, String type, int [] loc) {
    this.type = type;
    this.index = index;
    this.loc = new int []{loc[0],loc[1]};
    properties = blocksJson.getJSONObject(type);
    addModel(loc);
  }

  void addModel(int [] loc) {
    shape = paraModel1(Models.get(buildType));
    if (shape!=null) {
      shapeMode(CENTER);
      shape.translate(-4, -4);
      if (properties.hasKey("rotates")) shape.rotate(placeRotation);
      shape.translate(4, 4);
      shape.translate(loc[0]*tileSize, loc[1]*tileSize);
      allModels.addChild(shape);
      println(index, type, " added");
    }
  }

  Block removeModel() {
    if (shape!=null) allModels.removeChild(allModels.getChildIndex(shape));
    println(index, type, " removed");
    return this;
  }

  void refresh() {
    removeModel();
    addModel(loc);
  }

}

void setBlock(int []xy, String type) {
  int i = xy[0]+xy[1]*mmap.tilesY;
  if (blocks.containsKey(i)) blocks.remove(blocks.get(i).removeModel());
  blocks.put(i, new Block(i, type, xy));
}