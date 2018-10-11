class MMap {
  PImage piMap;
  PGraphics pgMap;
  String []mapTiles;
  HashMap<Integer, String> mapColors;
  HashMap<String, Integer> edgeRanks;
  int tilesX, tilesY, totTiles, sclWidth;
  PVector size;

  MMap(String path) {
    piMap = loadImage(path);
    tilesX = piMap.width; 
    tilesY = piMap.height;
    println(tilesX, tilesY);
    totTiles = tilesX*tilesY;
    pgMap = createGraphics(tilesX*tileSize, tilesY*tileSize, P2D);
    ((PGraphicsOpenGL)pgMap).textureSampling(2);
    initMapColors();
    initDraw();
    sclWidth = tilesY*tileSize;
    size = new PVector(tilesX*tileSize, tilesY*tileSize);
  }

  void initMapColors() { //mapColor.csv order determines overlap order for edge tiles
    mapColors = new HashMap<Integer, String>();
    edgeRanks = new  HashMap<String, Integer>();
    String [] lines = loadStrings("data\\mapColors.csv");
    for (int i = 0; i < lines.length; i++) {
      String [] split = lines[i].split(",");
      mapColors.put(unhex(split[1].trim()), split[0]);
      edgeRanks.put(split[0], i);
    }
  }

  void renderTiles(boolean blocks) { // if blocks, only draw blocks, else only draw floor tiles
    for (int xy = 0; xy < totTiles; xy++) {
      String type = mapColors.get(piMap.pixels[xy]);
      if ((type != null) && ((!type.contains("block"))^blocks)) {
        pgMap.image(getVariant(type), (xy%tilesX)*tileSize, (xy/tilesX)*tileSize);
      }
    }
  }

  void renderEdgeTiles() {
    for (int xy = 0; xy < totTiles; xy++) {
      String type = mapColors.get(piMap.pixels[xy]);
      if ((type != null)  && (hasLowerNeighbor(xy))) {
        if (type.contains("block")) type = type.replace("block", "");
        int x = xy%tilesX, y = xy/tilesX;
        if (ores.contains(type)) pgMap.image(getVariant("stoneedge"), x*tileSize, y*tileSize);
        String edgeType = type.contains("#") ? type.replaceAll("#", "edge") : type + "edge";
        pgMap.image(getVariant(edgeType), x*tileSize, y*tileSize);
        pgMap.image(getVariant(type), x*tileSize, y*tileSize);
      }
    }
  }

  void initDraw() {
    pgMap.beginDraw();
    pgMap.imageMode(CENTER);
    pgMap.translate(tileSizeHalf, tileSizeHalf);
    renderTiles(false);
    renderEdgeTiles();
    renderTiles(true);
    pgMap.endDraw();
  }

  boolean hasLowerNeighbor(int xy) {
    int rank = edgeRanks.get(mapColors.get((piMap.pixels[xy])));
    try {  // ignore edge of map errors
      int n = edgeRanks.get(mapColors.get((piMap.pixels[xy-tilesX]))), 
        s = edgeRanks.get(mapColors.get(  (piMap.pixels[xy+tilesX]))), 
        e = edgeRanks.get(mapColors.get(  (piMap.pixels[xy-1]))), 
        w = edgeRanks.get(mapColors.get(  (piMap.pixels[xy+1])));
      return ((n<rank)||(s<rank)||(e<rank)||(w<rank));
    }
    catch (Exception e) {
    }
    return false;
  }
}