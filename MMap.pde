class MMap {
  PImage piMap, piBuild;
  PGraphics pgMap, pgBuild;
  String []mapTiles;
  HashMap<Integer, String> mapColors;
  HashMap<String, Integer> edgeRanks;
  HashMap<String, PShape> blockShapeGroups;
  int tilesX, tilesY, totTiles, sclWidth;
  PVector size;
  PShape shBlocks; 

  MMap(String path) {
    shBlocks = createShape(GROUP);
    piMap = loadImage(path);
    tilesX = piMap.width; 
    tilesY = piMap.height;
    println(tilesX, tilesY);
    totTiles = tilesX*tilesY;
    pgMap = initPG();
    pgBuild = initPG();
    initMapColors();
    initDraw();
    sclWidth = tilesY*tileSize;
    size = new PVector(tilesX*tileSize, tilesY*tileSize);
  }

  PGraphics initPG() {
    PGraphics pg = createGraphics(tilesX*tileSize, tilesY*tileSize, P3D);
    ((PGraphicsOpenGL)pg).textureSampling(2);
    return pg;
  }

  void build(String name, int [] xy) {
    pgBuild.beginDraw();
    pgBuild.translate(xy[0]*tileSize, xy[1]*tileSize);
    pgBuild.image(getSprite(name), 0, 0);
    pgBuild.endDraw();
  }

  void initMapColors() { //mapColor.csv order determines overlap order for edge tiles
    mapColors = new HashMap<Integer, String>();
    edgeRanks = new  HashMap<String, Integer>();
    String [] lines = loadStrings("data/mapColors.csv");
    for (int i = 0; i < lines.length; i++) {
      String [] split = lines[i].split(",");
      mapColors.put(unhex(split[1].trim()), split[0]);
      edgeRanks.put(split[0], i);
    }
  }

  void renderTiles() { // if blocks, only draw blocks, else only draw floor tiles
    for (int xy = 0; xy < totTiles; xy++) {
      String type = mapColors.get(piMap.pixels[xy]);
      if ((type != null) && ((!type.contains("block")))) {
        pgMap.image(getVariant(type), (xy%tilesX)*tileSize, (xy/tilesX)*tileSize);
      }
    }
  }

  void initBlockShape() { // if blocks, only draw blocks, else only draw floor tiles
    blockShapeGroups = new HashMap<String, PShape>();
    String [] blocks = {"stoneblock1", "sandblock1", "grassblock1", "snowblock1", "blackstoneblock1"};
    for (String b : blocks) {
      PShape s = createShape(GROUP);
      for (int i = 0; i < tilesX; i++) {
        for (int q = 0; q < tilesY; q++) {
          String type = mapColors.get(piMap.pixels[i+tilesY*q]);
          if ((type != null) && (type.contains(b))) {
            s.addChild(TexturedCube(getSprite(type), i, q));
          }
        }
      }
      blockShapeGroups.put(b,s);
    }
  }

  void renderEdgeTiles() {
    for (int xy = 0; xy < totTiles; xy++) {
      String type = mapColors.get(piMap.pixels[xy]);
      if ((type != null)  && (hasLowerNeighbor(xy))) {
        if (type.contains("block")) type = type.replace("block", "");
        pgMap.pushMatrix();
        pgMap.translate((xy%tilesX)*tileSize, (xy/tilesX*tileSize));
        if (ores.contains(type)) pgMap.image(getVariant("stoneedge"), 0, 0);
        String edgeType = type.contains("#") ? type.replaceAll("#", "edge") : type + "edge";
        pgMap.image(getVariant(edgeType), 0, 0);
        pgMap.image(getVariant(type), 0, 0);
        pgMap.popMatrix();
      }
    }
  }

  void initDraw() {
    pgMap.beginDraw();
    pgMap.imageMode(CENTER);
    pgMap.translate(tileSizeHalf, tileSizeHalf);
    renderTiles(); // renders floor
    renderEdgeTiles();  
    pgMap.endDraw();
    initBlockShape();
  }

  boolean hasLowerNeighbor(int xy) { // returns true if tile at xy should draw an edge overlay
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

  PShape TexturedCube(PImage tex, int x, int y) {
    PShape s = createShape();
    s.beginShape(QUADS);
    s.noStroke();
    //s.noFill();
    //s.strokeWeight(0.5);
    //s.stroke(255);
    s.scale(tileSize/2, tileSize/2, tileSize/2);
    s.translate(x*tileSize+tileSize/2, y*tileSize+tileSize/2, tileSize/2);
    s.textureMode(NORMAL);
    //s.textureMode(IMAGE);
    s.texture(tex);

    // +Z "top" face
    s.vertex(-1, -1, 1, 0, 0);
    s.vertex( 1, -1, 1, 1, 0);
    s.vertex( 1, 1, 1, 1, 1);
    s.vertex(-1, 1, 1, 0, 1);

    String type ;
    int xy = x+y*tilesX;

    // +Y "south" face
    try {
      type = mapColors.get(piMap.pixels[xy+tilesX]);
      if (!type.contains("block")) {
        s.vertex(-1, 1, 1, 0, 0);
        s.vertex( 1, 1, 1, 1, 0);
        s.vertex( 1, 1, -1, 1, 1);
        s.vertex(-1, 1, -1, 0, 1);
      }

      // -Y "north" face
      type = mapColors.get(piMap.pixels[xy-tilesX]);
      if (!type.contains("block")) {
        s.vertex(-1, -1, -1, 0, 0);
        s.vertex( 1, -1, -1, 1, 0);
        s.vertex( 1, -1, 1, 1, 1);
        s.vertex(-1, -1, 1, 0, 1);
      }

      // +X "east" face
      type = mapColors.get(piMap.pixels[xy+1]);
      if (!type.contains("block")) {
        s.vertex( 1, -1, 1, 0, 0);
        s.vertex( 1, -1, -1, 1, 0);
        s.vertex( 1, 1, -1, 1, 1);
        s.vertex( 1, 1, 1, 0, 1);
      }

      // -X "west" face
      type = mapColors.get(piMap.pixels[xy-1]);
      if (!type.contains("block")) {
        s.vertex(-1, -1, -1, 0, 0);
        s.vertex(-1, -1, 1, 1, 0);
        s.vertex(-1, 1, 1, 1, 1);
        s.vertex(-1, 1, -1, 0, 1);
      }
    }
    catch (Exception e) {
    }
    s.endShape();
    return s;
  }
}