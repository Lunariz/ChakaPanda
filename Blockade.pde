class Blockade extends Platform {
  PImage sprite;
  ParticleSystem particle;
  
  Blockade(float startX, float startY, float startvx, PImage assignSprite, ParticleSystem assignParticle) {
    super(startX, startY, assignSprite.width, assignSprite.height, startvx, assignSprite);
    
    sprite = assignSprite;
    particle = assignParticle;
  }
  
  void update() {
    x += vx;
  }
  
}
