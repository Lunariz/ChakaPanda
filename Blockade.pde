//Blockade is a large object that obstructs the player from moving forward. Blockades are created by GameState.spawn();
//inherits position, speed and sprite variables from Platform
//inherits draw() function from Platform
class Blockade extends Platform {
  //Each type of blockade has its own particles when destroyed
  ParticleSystem particle;
  
  Blockade(float startX, float startY, float startvx, PImage assignSprite, ParticleSystem assignParticle) {
    super(startX, startY, assignSprite.width, assignSprite.height, startvx, assignSprite);
    
    particle = assignParticle;
  }
  
  //TODO: move to Object
  void update() {
    x += vx;
  }
  
}
