class Platform extends Object {
  
  Platform(float startX, float startY, float startSizeX, float startSizeY, float startvx, PImage assignSprite) {
    super(startX, startY, startvx, assignSprite);
    
    w = startSizeX;
    h = startSizeY;
    y+=20;
  }
  
  void update() {
    x += vx;
  }
  
}
