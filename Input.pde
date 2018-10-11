PVector cursor = new PVector(0, 0);
int cursorX = 0, cursorY = 0;

void mouseDragged() {
  moveCam(pmouseX-mouseX, pmouseY-mouseY);
}

void mouseWheel(MouseEvent event) {
  zoomCam(-event.getCount());
}

void updateCursor() {

  cursor.set(cam).div(tileSize*cam.z).add(mmap.tilesX/2, mmap.tilesY/2);
  cursor.add((mouseX-whalf)/(tileSize*cam.z), (mouseY-hhalf)/(tileSize*cam.z));
  cursorX = floor(cursor.x);
  cursorY = floor(cursor.y);
}