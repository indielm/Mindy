final int w = 1280, h = 720, whalf =w/2, hhalf = h/2;
final int tileSize = 8, tileSizeHalf = tileSize/2;

float renderScale = 1.5;
final int scaleW = floor(w/renderScale), scaleH = floor(h/renderScale);

float tileScale = tileSize*camTarget.z;
int mw, mh;
final String ores = "iron# coal# titanium# uranium#";
JSONObject config;
JSONArray distribution;
MMap mmap;
long lastFrame = 0;
float deltaT = 0;
PImage piBuildMenu;
int selectedBuildTab = 1;
boolean dontDrag = false;

PGraphics pgRender;
boolean hotLoad = true;