class Blockade extends Platform{
  PImage sprite;
  ParticleSystem particle;
  
  Blockade(float startX, float startY, float startvx, PImage assignSprite, ParticleSystem assignParticle) {
    super(startX, startY, assignSprite.width, assignSprite.height, startvx);
    sprite = assignSprite;
    particle = assignParticle;
    x = startX;
    y = startY;
    w = sprite.width;
    h = sprite.height;
    vx = startvx;
  }
  
  void update() {
    x += vx;
  }
}
