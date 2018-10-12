HashMap<String, Sprite> spritesAtlas;
HashMap<String, PImage> spriteImages;
PImage spriteSheet;

class Sprite {
  int x, y, w, h;
  Sprite(String [] split) {
    x = parseInt(split[1].trim());
    y = parseInt(split[2].trim());
    w = parseInt(split[3].trim());
    h = parseInt(split[4].trim());
  }
}

void initSprites() {
  spriteImages = new HashMap<String, PImage>();
  spriteSheet = loadImage("data/sprites.png");
  spritesAtlas = new HashMap<String, Sprite>();
  String [] lines = loadStrings("data/atlas.csv");
  for (String line : lines) {
    String [] split = line.split(",");
    spritesAtlas.put(split[0], new Sprite(split));
  }
}

PImage getSprite(String name) { // return sprite, if first request of sprite load it into spriteImages
  if (spriteImages.containsKey(name)) return spriteImages.get(name);
  Sprite sp = spritesAtlas.get(name); 
  spriteImages.put(name, (sp!=null) ? spriteSheet.get(sp.x, sp.y, sp.w, sp.h) : getSprite("blank"));
  return spriteImages.get(name);
}

PImage getVariant(String type) { // tiles ending with # have a random variant numbered 1-3 
  return getSprite(type.replace('#', str(floor(random(1, 4))).charAt(0)));
}