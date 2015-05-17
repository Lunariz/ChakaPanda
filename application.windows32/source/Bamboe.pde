 class Bamboe {
  float x,y;
  float vx,vy; //snelheid
  float w,h; //grootte
  boolean onGround = true;
  
  Bamboe(float startX, float startY, float startvx) {
    x = startX;
    y = startY;
    w = sprBamboo.width;
    h = sprBamboo.height;
    vx = startvx;
  }
  
  void update() {
    x += vx; //update elke frame de positie
  }
}
