class Platform {
  float x,y;
  float vx,vy;
  float w,h;
  
  Platform(float startX, float startY, float startSizeX, float startSizeY, float startvx) {
    //init();
    x = startX;
    y = startY;
    vx = startvx;
    w = startSizeX;
    h = startSizeY;
  }
  
  void update() {
    x += vx;
  }
}
