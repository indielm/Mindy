public class Game {
  long lastFrame = 0;
  float deltaT = 0;

  HashMap<Integer, Block> blocks;
  HashMap<Integer, ItemCell> movers;

  GameRender render;
  MMap mmap;
  BuildTab buildTab;
  DesktopInput input;
  
  Game(PApplet papp) {
    mmap = new MMap("/data/map.png");
    buildTab = new BuildTab();
    init();
    papp.registerMethod("mouseEvent", this);
    papp.registerMethod("keyEvent", this);
    input = new DesktopInput();
  }

  void init() {
    render = new GameRender(mmap);
    blocks = new HashMap<Integer, Block>();
    movers = new HashMap<Integer, ItemCell>();
  }

  void keyEvent(KeyEvent e) {
    input.keyEvent(e);
    if (input.keyHit('c')) buildTab.buildTabOpen = !buildTab.buildTabOpen;
    if (input.keyHit('d')) drawDebug = !drawDebug;
  }
  
  void mouseEvent(MouseEvent e) {
    input.mouseEvent(e);
  }

  void draw() {
    renderDbgLayer();
    bench();
    game.render.renderCam();
    bench();
    image(game.render.pg, 0, 0, w, h);

    hint(DISABLE_DEPTH_TEST);
    if (buildTab.buildTabOpen) buildTab.draw();
    bench();
    if (drawDebug) drawDebugText();
    hint(ENABLE_DEPTH_TEST);
  }

  void refreshBlocks() {
    for (int i : blocks.keySet()) blocks.get(i).refresh();
  }

  void update() {
    deltaT = (System.nanoTime()-lastFrame)/16000000.0;
    lastFrame=System.nanoTime();
    render.updateCam(deltaT);
    linkMovers();
    
    if (game.render.redrawMap || input.keyHit('m')) render.redrawMap = false; //TODO fix hotloading
  }

  void setBlock(int []xy, String type) {
    int i = xy[0]+xy[1]*game.mmap.tilesY;
    if (blocks.containsKey(i)) game.render.removeModel((blocks.get(i)).shape);
    blocks.put(i, new Block(i, type, xy));
    movers.put(i, new ItemCell(type, xy, input.placeRotation));
  }
}