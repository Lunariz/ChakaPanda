//Bamboe is a small object the player can grab to increase his score. Bamboes are created by GameState.spawn()
//inherits position, speed and sprite variables from Object
//inherits draw() function from Object
//TODO: rename to Bamboo and update name everywhere
class Bamboe extends Object {
  
  Bamboe(float startX, float startY, float startvx, PImage assignSprite) {
    super(startX, startY, startvx, assignSprite);
  }
  
  //TODO: move to Object
  void update() {
    x += vx;
  }
}
