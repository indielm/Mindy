class GameRender { 
  PGraphics pg;
  PImage piFloor;
  PImage piRawMap;
  PShape moversShape;

  PVector cam = new PVector(0, 0, 1);
  PVector camTarget = new PVector(0, 0, 1);
  PVector camDelta = new PVector(0, 0, 0);

  PShape mapBlocks;
  PShape mapModels;
  MMap mmap;

  boolean redrawMap = false, 
    ortho = true, 
    backFaceCull = false;

  GameRender(MMap mmap) {
    pg = createGraphics(w, h, P3D);
    pg.smooth(8);
    ((PGraphicsOpenGL)pg).textureSampling(2);
    hint(ENABLE_TEXTURE_MIPMAPS);

    this.mmap = mmap;
    this.piFloor = (new MapRender(mmap)).render();
    this.piRawMap = mmap.piRawMap;

    mapBlocks = createMapBlocks();
    mapModels = createShape(GROUP);
    moversShape = createShape(GROUP);

    PShape core = getNewModel("core");
    core.translate(mmap.tilesX*tileSizeHalf, mmap.tilesY*tileSizeHalf);
    mapModels.addChild(core);

    initDebug(mmap);
  }

  void updateCam(float deltaT) {
    cam.add(camDelta.set(camTarget).sub(cam).mult(0.18*deltaT)); // deltaTime compensated low pass filter
  }

  void moveCam(float xO, float yO) {
    game.input.mouseVec.set(-xO, -yO).rotate(-QUARTER_PI);
    float zoomScale = sqrt(max(cam.z, 2));
    camTarget.add(game.input.mouseVec.mult(2.30/max(zoomScale, 4)));
  }

  void zoomCam(float adj) {
    camTarget.z = constrain(camTarget.z + adj/5.0, 0.3, 5.0);
  }

  void removeModel(PShape shape) {
    int index = mapModels.getChildIndex(shape);
    if (index>=0) mapModels.removeChild(index);
  }

  PShape addModel(JSONObject properties, int [] loc) {
    PShape shape = paraModel1(Models.get(game.buildTab.buildType));
    if (shape == null) return null;
    if (properties.hasKey("rotates")) {
      shape.translate(-tileSizeHalf, -tileSizeHalf);
      shape.rotate(game.input.placeRotation*HALF_PI);
      shape.translate(tileSizeHalf, tileSizeHalf);
    }
    shape.translate(loc[0]*tileSize, loc[1]*tileSize);
    mapModels.addChild(shape);
    return shape;
  }

  void renderCam() {
    pg.beginDraw();
    {
      if (ortho) pg.ortho();
      else pg.perspective();
      pg.clear();
      pg.translate(w/2, h/2);
      pg.rotateX(QUARTER_PI/2);
      pg.rotateY(0);
      pg.rotateZ(QUARTER_PI);
      pg.scale(cam.z, cam.z, cam.z);
      pg.translate(cam.x, cam.y, 1);
      pg.imageMode(CENTER);
      pg.image(piFloor, 0, 0);
      pg.image(pgDbg, 0, 0);
      pg.translate(-mmap.tilesX*tileSizeHalf, -mmap.tilesY*tileSizeHalf);
      pg.ambientLight(234, 231, 210);
      pg.shape(mapBlocks);
      pg.shape(mapModels);
      if (drawDebug) pg.shape(moversShape);
    }
    pg.endDraw();
  }

  PShape createMapBlocks() {
    PShape blocks = createShape(GROUP);
    piRawMap.loadPixels();
    for (int xy = 0; xy < mmap.totTiles; xy++) {
      String type = mapColors.get(piRawMap.pixels[xy]);
      if ((type != null) && (type.contains("block"))) blocks.addChild(TexturedCube(type, xy%mmap.tilesX, xy/mmap.tilesX));
    }
    return blocks;
  }

  PShape TexturedCube(String tex, int x, int y) {
    PShape s = createShape();
    s.beginShape(QUADS);
    s.noStroke();
    s.scale(tileSizeHalf, tileSizeHalf, tileSizeHalf);
    s.translate(x*tileSize+tileSizeHalf, y*tileSize+tileSizeHalf, tileSizeHalf);
    s.textureMode(IMAGE);
    s.texture(spriteSheet);

    Sprite sp = spritesAtlas.get(tex);
    float u = sp.x, v = sp.y, ub = u+sp.w, vb = v+sp.h;
    s.vertex(-1, -1, 1, u, v); // +Z "top" face
    s.vertex( 1, -1, 1, ub, v);
    s.vertex( 1, 1, 1, ub, vb);
    s.vertex(-1, 1, 1, u, vb);

    String type ;
    int xy = x+y*mmap.tilesX;
    try {
      type = mapColors.get(piRawMap.pixels[xy+mmap.tilesX]); // +Y "south" face
      if (!type.contains("block")) {
        s.vertex(-1, 1, 1, u, v);
        s.vertex( 1, 1, 1, ub, v);
        s.vertex( 1, 1, -1, ub, vb);
        s.vertex(-1, 1, -1, u, vb);
      }
      type = mapColors.get(piRawMap.pixels[xy+1]); // +X "east" face
      if (!type.contains("block")) {
        s.vertex( 1, -1, -1, u, v);
        s.vertex( 1, -1, 1, ub, v);
        s.vertex( 1, 1, 1, ub, vb);
        s.vertex( 1, 1, -1, u, vb);
      }
      if (!backFaceCull) {
        type = mapColors.get(piRawMap.pixels[xy-mmap.tilesX]); // -Y "north" face
        if (!type.contains("block")) { 
          s.vertex(-1, -1, -1, u, v);
          s.vertex( 1, -1, -1, ub, v);
          s.vertex( 1, -1, 1, ub, vb);
          s.vertex(-1, -1, 1, u, vb);
        }
        type = mapColors.get(piRawMap.pixels[xy-1]); // -X "west" face
        if (!type.contains("block")) {
          s.vertex(-1, -1, -1, u, v);
          s.vertex(-1, -1, 1, ub, v);
          s.vertex(-1, 1, 1, ub, vb);
          s.vertex(-1, 1, -1, u, vb);
        }
      }
    }
    catch (Exception e) {
    }
    s.endShape();
    return s;
  }

  PShape getNewModel(String tex) {
    return paraModel1(Models.get(tex));
  }

  PShape paraModel1(Model m) {
    if (m==null) return null;
    return paraModel1(m.sprite, m.bend, m.h, m.texAngle, false);
  }

  PShape paraModel1(String texture, float bend, float b, int texAngle, boolean backFaceCull) {
    float a = 0, c = 0.00, f = 3.00, h = 1.0;
    float d = h-bend, e = 3-h+bend;
    float [][]modelVerts;
    if (backFaceCull) {
      float [][] culled = {{f, f, a}, {e, e, b}, {c, f, a}, {d, e, b}, {c, c, a}, {d, d, b}, {d, e, b}, {e, d, b}, {e, e, b}};
      modelVerts = culled;
    } else {
      float [][] full =  {{c, c, a}, {d, d, b}, {f, c, a}, {e, d, b}, {f, f, a}, {e, e, b}, {c, f, a}, {d, e, b}, {c, c, a}, {d, d, b}, {d, e, b}, {e, d, b}, {e, e, b}};
      modelVerts = full;
    }
    PShape model = createShape();
    model.beginShape(TRIANGLE_STRIP);
    model.textureMode(IMAGE);
    model.texture(spriteSheet);
    Sprite sp = spritesAtlas.get(texture);
    model.noStroke();
    float scale = 0;

    if (sp.w == tileSize) { // TODO: support multiblock sizes
      model.translate(-tileSize, 0, 0);
      scale = tileSize/3.0;
    } else {
      model.translate(-3*tileSize, -tileSize, 0);
      scale = tileSize;
    }
    model.rotate(-HALF_PI);
    float tiles = 3;

    PVector uv = new PVector(0, 0);
    for (float[] p : modelVerts) {
      uv.set(p[0]/tiles-0.5, p[1]/tiles-0.5)
        .rotate(texAngle*HALF_PI)
        .add(0.5, 0.5);
      model.vertex(p[0]*scale, p[1]*scale, p[2]*scale, uv.x*sp.w +sp.x, uv.y*sp.h+sp.y);
    }
    model.endShape();
    return model;
  }
}