int tabW = 241, tabH = 286;

void drawBuildTab() {
  int weight = 5;
  int x = w-tabW-weight/2, y =h-tabH-weight/2;
  imageMode(CORNER);
  pushMatrix();
  translate(x, y);
  image(piBuildMenu, 0, 0);
  if (selectedBuildTab>=0) {
    stroke(228, 177, 97);
    strokeWeight(weight);
    noFill();
    translate(((selectedBuildTab>3)? selectedBuildTab-4 : selectedBuildTab)*61+3, ((selectedBuildTab<4) ? 0 : 1)*49+2);
    rect(0, 0, 56, 44);
    stroke(199, 137, 81);
    line(-3, 49, 58, 49);
  }
  popMatrix();
}

void buildTabClick() {
  if ((mouseX>(width-tabW)) && (mouseY>height-tabH)) {
    dontDrag = true;
    int mx = mouseX-(width-tabW);
    int my = mouseY-(height-tabH);
    mx = 4*mx/tabW;
    my = 2*my/92;
    if (my<2) {
      selectedBuildTab = mx+(my*4);
      println(mx, my, selectedBuildTab);
    }
  }
}