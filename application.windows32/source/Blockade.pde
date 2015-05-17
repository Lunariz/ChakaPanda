class Blockade {
  float x,y;
  float vx,vy;
  float w,h;
  PImage sprite;
  ParticleSystem particle;
  
  Blockade(float startX, float startY, float startvx, PImage assignSprite, ParticleSystem assignParticle) {
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
