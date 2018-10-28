import java.nio.file.*;

boolean redrawMap = false;

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
            loadModels();
            redrawMap = true;
          } else if (filename.equals("models.json")) {
            loadModels();
          }
          println(frameCount + ": " + event.kind().name() + " "+ filename);
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