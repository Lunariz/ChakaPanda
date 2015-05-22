//A standard object class, that gets inherited by all objects in the game (Bamboes, Blockades, Platforms and Player)
class Object {
  float x,y;
  float vx,vy;
  float w,h;
  PImage sprite;
  
  Object(float startX, float startY, float startvx, PImage assignSprite) {
    x = startX;
    y = startY;
    vx = startvx;
    w = assignSprite.width;
    h = assignSprite.height;
    sprite = assignSprite;
  }
  
  void draw() {
    image(sprite, x, y, w, h);
  }
}
