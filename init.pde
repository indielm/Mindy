import java.nio.file.*;

void initAssets() {
  config = loadJSONObject("/data/config.json");
  blocksJson = loadJSONObject("data/blocks.json");
  piBuildMenu = loadImage("/data/buildMenu.png");
  initMapColors();
  initSprites();
  initModels();
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

int initModels() {
  Models = new ConcurrentHashMap<String, Model>();
  Set<String> keys = (Set<String>)blocksJson.keys();
  for (String obj : keys) {
    JSONObject model = blocksJson.getJSONObject(obj);
    if (model.getInt("type") == 1) Models.put(obj, new Model(obj, model.getFloat("bend"), model.getFloat("height"), model.getInt("type"), model.getInt("texAngle")));
  }
  if (game!=null)  game.refreshBlocks();
  return Models.size();
}

void fileWatch() {
  final Path path = FileSystems.getDefault().getPath(sketchPath() + "/data/");
  System.out.println(path);
  try {
    final WatchService watchService = FileSystems.getDefault().newWatchService();
    final WatchKey watchKey = path.register(watchService, StandardWatchEventKinds.ENTRY_MODIFY);
    while (true) {
      try {
        for (WatchEvent<?> event : watchKey.pollEvents()) {
          String filename = ((Path)event.context()).toString();
          if (filename.equals("sprites.png")) {
            initSprites();
            initModels();
            game.render.redrawMap = true;
          } else if (filename.equals("models.json")) initModels();
          println(frameCount + ": " + event.kind().name() + " " + filename);
        }
      }
      catch (Exception e) {
        e.printStackTrace();
      }
      delay(50);
    }
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}