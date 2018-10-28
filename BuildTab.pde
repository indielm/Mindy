int tabW = 241, tabH = 286;

String [] menus;
ArrayList<String[]> buildButtons = new ArrayList<String[]>();
int selectedSlot = -1;
String buildType = "";

void buildTabInit() {
  menus = loadStrings("data/buildTab.csv");
  for (int i = 0; i < 8; i++) buildButtons.add(split(menus[i], ", "));
}

void drawBuildTab() {
  int weight = 6;
  int x = w-tabW-weight/2, y =h-tabH-weight/2;
  imageMode(CORNER);
  pushMatrix();
  translate(x, y);
  image(piBuildMenu, 0, 0);
  strokeCap(SQUARE);
  if (selectedBuildTab>=0) {
    strokeWeight(weight);
    noFill();
    pushMatrix();
    translate(((selectedBuildTab>3)? selectedBuildTab-4 : selectedBuildTab)*61+3, ((selectedBuildTab<4) ? 0 : 1)*49+2);
    stroke(199, 137, 81);
    line(-3, 48, 59, 48);
    stroke(228, 177, 97);
    rect(0, 0, 56, 44);
    popMatrix();
    if (selectedSlot>=0) {
      pushMatrix();
      strokeWeight(7);
      translate( (selectedSlot%4)*60+8, (selectedSlot/4)*58+108);
      stroke(228, 177, 97);
      rect(0, 0, 45, 45);
      popMatrix();
    }
    for (int i = 0; i < buildButtons.get(selectedBuildTab).length; i++) image(getSprite(buildButtons.get(selectedBuildTab)[i]), (i%4)*60+10, 108+(i/4)*60, 42, 42);
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
      selectedSlot = -1;
    } else {
      my = (mouseY-(height-tabH+4));
      my = 2*my/104;
      selectedSlot = mx+(my*4)-8;
      
      if ((selectedBuildTab>=0) && (selectedSlot < buildButtons.get(selectedBuildTab).length)  && (selectedSlot>=0)){
        buildType = buildButtons.get(selectedBuildTab)[selectedSlot];
        println(buildButtons.get(selectedBuildTab)[selectedSlot]);
      } else {
        selectedSlot = -1;
        buildType = "";
      }
    }
  }
}