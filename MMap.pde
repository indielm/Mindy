class MMap {
  PImage piMap, piBuild;
  PGraphics pgMap, pgBuild;
  String []mapTiles;
  HashMap<Integer, String> mapColors;
  HashMap<String, Integer> edgeRanks;
  PShape mapBlocks;
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
    PGraphics pg = createGraphics(tilesX*tileSize, tilesY*tileSize, P2D);
    ((PGraphicsOpenGL)pg).textureSampling(2);
    return pg;
  }

  void build(String name, int [] xy, float rotation) {
    pgBuild.beginDraw();
    pgBuild.imageMode(CENTER);
    pgBuild.translate(xy[0]*tileSize+tileSizeHalf, xy[1]*tileSize+tileSizeHalf);
    pgBuild.rotate(rotation);
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

  void initBlockShape() {
    mapBlocks = createShape(GROUP);
    for (int i = 0; i < tilesX; i++) {
      for (int q = 0; q < tilesY; q++) {
        String type = mapColors.get(piMap.pixels[i+tilesY*q]);
        if ((type != null) && (type.contains("block"))) {
          mapBlocks.addChild(TexturedCube(type, i, q));
        }
      }
    }
  }

  void renderEdgeTiles() {
    for (int xy = 0; xy < totTiles; xy++) {
      String type = mapColors.get(piMap.pixels[xy]);
      if ((type != null)  && (hasLowerNeighbor(xy))) {
        if (type.contains("block")) type = type.replace("block1", "");
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
    pgMap.clear();
    pgMap.imageMode(CENTER);
    pgMap.translate(tileSizeHalf, tileSizeHalf);
    renderTiles(); // renders floor
    renderEdgeTiles();  
    pgMap.endDraw();
    initBlockShape();
  }

  int getRank(int i) {
    return edgeRanks.get(mapColors.get((piMap.pixels[i])));
  }

  boolean hasLowerNeighbor(int xy) { // returns true if tile at xy should draw an edge overlay
    int rank = getRank(xy);
    try { 
      int n = getRank(xy-tilesX), 
        s = getRank(xy+tilesX), 
        e = getRank(xy-1), 
        w = getRank(xy+1);
      return ((n<rank)||(s<rank)||(e<rank)||(w<rank));
    }
    catch (Exception e) {
    }
    return false;
  }

  PShape TexturedCube(String tex, int x, int y) {
    PShape s = createShape();
    s.beginShape(QUADS);
    s.noStroke();
    //s.noFill();
    //s.strokeWeight(0.5);
    //s.stroke(255);
    s.scale(tileSize/2, tileSize/2, tileSize/2);
    s.translate(x*tileSize+tileSize/2, y*tileSize+tileSize/2, tileSize/2);
    s.textureMode(IMAGE);
    s.texture(spriteSheet);
    Sprite sp = spritesAtlas.get(tex);

    if (sp==null) {
      println(tex + " not found");
      return s;
    }
    float u = sp.x, v = sp.y, ub = u+sp.w, vb = v+sp.h;
    // +Z "top" face
    s.vertex(-1, -1, 1, u, v);
    s.vertex( 1, -1, 1, ub, v);
    s.vertex( 1, 1, 1, ub, vb);
    s.vertex(-1, 1, 1, u, vb);

    String type ;
    int xy = x+y*tilesX;


    try {
      // +Y "south" face
      type = mapColors.get(piMap.pixels[xy+tilesX]);
      if (!type.contains("block")) {
        s.vertex(-1, 1, 1, u, v);
        s.vertex( 1, 1, 1, ub, v);
        s.vertex( 1, 1, -1, ub, vb);
        s.vertex(-1, 1, -1, u, vb);
      }
      // +X "east" face
      type = mapColors.get(piMap.pixels[xy+1]);
      if (!type.contains("block")) {
        s.vertex( 1, -1, 1, u, v);
        s.vertex( 1, -1, -1, ub, v);
        s.vertex( 1, 1, -1, ub, vb);
        s.vertex( 1, 1, 1, u, vb);
      }
      // -Y "north" face
      type = mapColors.get(piMap.pixels[xy-tilesX]);
      if (!type.contains("block")) {
        s.vertex(-1, -1, -1, u, v);
        s.vertex( 1, -1, -1, ub, v);
        s.vertex( 1, -1, 1, ub, vb);
        s.vertex(-1, -1, 1, u, vb);
      }
      // -X "west" face
      type = mapColors.get(piMap.pixels[xy-1]);
      if (!type.contains("block")) {
        s.vertex(-1, -1, -1, u, v);
        s.vertex(-1, -1, 1, ub, v);
        s.vertex(-1, 1, 1, ub, vb);
        s.vertex(-1, 1, -1, u, vb);
      }
    }
    catch (Exception e) {
    }
    s.endShape();
    return s;
  }

  boolean pixIsBlock(int xy) {
    return mapColors.get(piMap.pixels[xy-1]).contains("block");
  }
}