//Platform is a long rectangle that the player can stand on. Platforms are created by ContentHandler.spawn()
//inherits position, speed and sprite variables from Object
//inherits draw() function from Object
//This class gets inherited by Blockade, so the player can stand on blockades.
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
