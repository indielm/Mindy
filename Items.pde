int west = 0, north = 1, east = 2, south = 3, producer = 5, sink = 6;
int [] cardinals;

ArrayList<ItemCell> moversToLink = new ArrayList<ItemCell>();

color [] moverColors = {
  color(0, 0, 0, 0), // nothing
  color(200, 200, 0, 255), // producer
  color(0, 200, 200, 255), // conveyorIn
  color(255, 100, 0), // conveyorOut
  color(200, 0, 200, 255)  // sink
};

void linkMovers() {
  for (ItemCell ic : moversToLink) ic.setLinks();
  moversToLink.clear();
}

class ItemCell {
  int []dir;
  PShape shape;
  int []xy;
  int i;
  JSONObject properties;
  String type;
  float rotation;
  ItemCell(String type, int []xy, float rotation) {
    i = xy[0]+xy[1]*game.mmap.tilesX;
    this.xy = xy;
    this.type = type;
    this.rotation = rotation;
    properties = blocksJson.getJSONObject(type);
    setLinks();
  }

  void relinkNeighbors() {
    for (int c : cardinals) {
      ItemCell ic = game.movers.get(i+c);
      if ((ic != null) && ic.properties.hasKey("producer")) moversToLink.add(ic);
    }
  }

  void setLinks() {
    if (properties == null) return;
    dir = new int [] {0, 0, 0, 0};
    removeShape();

    if (properties.hasKey("conveyor")) {
      dir[floor(game.input.placeRotation)] = 3;
      int q = 0;
      for (int c : cardinals) {
        ItemCell ic = game.movers.get(i+c);
        if ((ic != null) && (ic.properties.hasKey("producer") || ic.properties.hasKey("conveyor"))) dir[q] = 2;
        q++;
      }

      relinkNeighbors();
    } else if (properties.hasKey("producer")) {
      int q = 0;
      for (int c : cardinals) {
        ItemCell ic = game.movers.get(i+c);
        if ((ic !=null)&&(ic.properties != null)&& (ic.properties.hasKey("conveyor"))) dir[q] = 1;
        q++;
      }
    }
    initShape();
  }

  void initShape() {
    shape = createShape();
    shape.beginShape(LINES);
    shape.noFill();

    shape.strokeWeight(2.5);
    int x = xy[0], y = xy[1];//i / mmap.tilesX;
    float shrink = 0.28;
    int n = dir[3], e = dir[2], s = dir[1], w = dir[0];
    edgeLine(x, y, n, 1, 0, 0, shrink);
    edgeLine(x, y+1, s, 1, 0, 0, -shrink);
    edgeLine(x, y, e, 0, 1, shrink, 0);
    edgeLine(x+1, y, w, 0, 1, -shrink, 0);

    shape.translate(0, 0, 1);
    shape.endShape();
    game.render.moversShape.addChild(shape);
  }

  void edgeLine(int x, int y, int cardinal, int xO, int yO, float shrinkX, float shrinkY) {
    if (cardinal>0) {
      shape.stroke(moverColors[cardinal]);
      shape.vertex((x)*tileSize+shrinkX, (y)*tileSize+shrinkY);
      shape.vertex((x+xO)*tileSize+shrinkX, (y+yO)*tileSize+shrinkY);
    }
  }

  void removeShape() {
    if (game.render.moversShape.getChildIndex(shape)>=0)
      game.render.moversShape.removeChild(game.render.moversShape.getChildIndex(shape));
  }

  void refreshShape() {
    removeShape();
    initShape();
  }
}