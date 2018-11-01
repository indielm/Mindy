PImage spriteSheet;

void initSprites() {
  spriteSheet = loadImage("data/sprites.png");
  spritesAtlas = new ConcurrentHashMap<String, Sprite>();
  String [] lines = loadStrings("data/atlas.csv");
  for (String line : lines) {
    String [] split = line.split(",");
    spritesAtlas.put(split[0], new Sprite(split));
  }
}

void drawSprite(PGraphics pg, String type, float x, float y) {
  Sprite sp = spritesAtlas.get(type);
  if (sp==null) return;
  drawSprite(pg, sp, x, y, sp.w, sp.h);
}

void drawSprite(PGraphics pg, String type, float x, float y, float sizeX, float sizeY) {
  Sprite sp = spritesAtlas.get(type);
  if (sp==null) return;
  drawSprite(pg, sp, x, y, sizeX, sizeY);
}

void drawSprite(PGraphics pg, Sprite sp, float x, float y, float sizeX, float sizeY) {
  pg.pushMatrix();
  pg.translate(x-sizeX/2, y-sizeY/2); // centered
  pg.beginShape(QUAD);
  pg.texture(spriteSheet);
  pg.textureMode(IMAGE);
  float ub = sp.x + sp.w, vb = sp.y+ sp.h;
  pg.vertex(0, 0, 0, sp.x, sp.y);
  pg.vertex(sizeX, 0, 0, ub, sp.y);
  pg.vertex(sizeX, sizeY, 0, ub, vb);
  pg.vertex(0, sizeY, 0, sp.x, vb);
  pg.endShape();
  pg.popMatrix();
}