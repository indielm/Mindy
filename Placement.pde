HashMap<Integer, Block> blocks = new HashMap<Integer, Block>();

JSONArray blockProperties;

class Block {
  PShape shape;
  String type;
  int index;
  Block(int index, String type) {
    this.type = type;
    this.index = index;
    addModel();
  }

  void addModel() {
    shape = paraModel1(Models.get(buildType));
    if (shape!=null) {
      shapeMode(CENTER);
      shape.translate(-4, -4);
      if (blocksJson.getJSONObject(type).hasKey("rotates")) shape.rotate(placeRotation);
      shape.translate(4, 4);
      shape.translate(cursorXY[0]*tileSize, cursorXY[1]*tileSize);
      // m.rotate(placeRotation);
      allModels.addChild(shape);
      println(index, type, " added");
    }
  }

  Block removeModel() {
    if (shape!=null) allModels.removeChild(allModels.getChildIndex(shape));
    println(index, type, " removed");
    return this;
   }
   
   void refresh(){
     removeModel();
     addModel();
   }
}

void setBlock(int []xy, String type) {
  int i = xy[0]+xy[1]*mmap.tilesY;
  if (blocks.containsKey(i)) blocks.remove(blocks.get(i).removeModel());
  blocks.put(i, new Block(i, type));
}