class MapRender {
  //  use render() to return an image that is (tilesX*tilesSize,tilesY*tileSize) of the map floor tiles
  final String ores = "iron# coal# titanium# uranium#";
  PImage piRawMap;
  int totTiles,tilesX,tilesY;
  MapRender(MMap mmap) {
    this.tilesX = mmap.tilesX;
    this.tilesY = mmap.tilesY;
    this.totTiles = tilesX*tilesY;
    this.piRawMap = mmap.piRawMap;
  }

  void renderEdgeTiles(PGraphics pgMap) {
    for (int xy = 0; xy < totTiles; xy++) {
      String type = mapColors.get(piRawMap.pixels[xy]);
      if ((type != null)  && (hasLowerNeighbor(xy))) {
        if (type.contains("block")) type = type.replace("block1", "");
        pgMap.pushMatrix();
        if (ores.contains(type)) drawSprite(pgMap, getVariantName("stoneedge"),(xy%tilesX)*tileSize, (xy/tilesX*tileSize)); //pgMap.image(getSprite(getVariantName("stoneedge")), 0, 0);
        String edgeType = type.contains("#") ? type.replaceAll("#", "edge") : type + "edge";
        drawSprite(pgMap, getVariantName(edgeType),(xy%tilesX)*tileSize, (xy/tilesX*tileSize));
        drawSprite(pgMap, getVariantName(type),(xy%tilesX)*tileSize, (xy/tilesX*tileSize));
        pgMap.popMatrix();
      }
    }
  }

  PImage render() {
    PGraphics pgMap = createGraphics(tilesX*tileSize, tilesY*tileSize, P3D);
    ((PGraphicsOpenGL)pgMap).textureSampling(2);
    pgMap.beginDraw();
    pgMap.clear();
    pgMap.translate(tileSizeHalf, tileSizeHalf);
    renderTiles(pgMap);
    renderEdgeTiles(pgMap);  
    pgMap.endDraw();
    return pgMap;
  }

  int getEdgeRank(int xy) {
    if ((xy <0)||(xy>=totTiles)) return -1;
    return edgeRanks.get(mapColors.get((piRawMap.pixels[xy])));
  }

  boolean hasLowerNeighbor(int xy) {
    int rank = getEdgeRank(xy);
    for (int dir : cardinals) if (getEdgeRank(xy+dir)<rank) return true;
    return false;
  }

  void renderTiles(PGraphics pgMap) { 
    pgMap.noStroke();
    pgMap.pushMatrix();
    pgMap.translate(-tileSizeHalf, -tileSizeHalf);
    for (int xy = 0; xy < totTiles; xy++) {
      String type = getVariantName(mapColors.get(piRawMap.pixels[xy]));
      if ((type != null) && ((!type.contains("block")))) drawSprite(pgMap,type,tileSizeHalf+(xy%tilesX) * tileSize,tileSizeHalf+(xy/tilesX) * tileSize);
    }
    pgMap.popMatrix();
  }
  
  String getVariantName(String type) {
    return type.replace('#', str(floor(random(1, 4))).charAt(0));
  }
}