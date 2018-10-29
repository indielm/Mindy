PGraphics pgMovers;
PGraphics pgItems;

int left = 0, up = 1, right = 2, down = 3, producer = 5, sink = 6;

void pgItemInit() {
  PGraphics pgMovers = createGraphics(mmap.tilesX, mmap.tilesY, P2D);
  ((PGraphicsOpenGL)pgMovers).textureSampling(2);

  PGraphics pgItems = createGraphics(128, 128, P2D);
  ((PGraphicsOpenGL)pgMovers).textureSampling(2);
}

class ItemCell {
  int n, s, e, w;
}

HashMap<Integer, ItemCell> movers;

void initMovers() {
  movers = new HashMap<Integer, ItemCell> ();
}

void drawMovers() {
  for (Integer i : movers.keySet()) {
    int x = i % mmap.tilesX, y = i / mmap.tilesX;
    line(x*tileSize, y*tileSize, x*tileSize, (y+1)*tileSize);
  }
}