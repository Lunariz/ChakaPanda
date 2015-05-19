class Bamboe extends Object{
  
  Bamboe(float startX, float startY, float startvx, PImage assignSprite) {
    super(startX, startY, startvx, assignSprite);
  }
  
  void update() {
    x += vx; //update elke frame de positie
  }
}
