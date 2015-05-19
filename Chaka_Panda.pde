GameState gameState;
Music music;
ParticleSystem ptBoom;
ParticleSystem ptBamboo;
ParticleSystem ptBamboo2;
ParticleSystem ptRock;

float x;
int blokade;

void setup() {
  frameRate(60);
  frame.setTitle("Chaka Panda");
  size(1280, 720);
  
  music = new Music();
  music.loadMusic("music.mp3");
  music.playMusic();
  makeParticles();
  
  gameState = new GameState();
}

void draw() {
  background(255); //Begin elke frame met leeg scherm
  if (gameState.inGame() && !gameState.pause) { //pause() staat hierbuiten zodat hij nog gebruikt kan worden wanneer het spel wel gepauzeerd is
    gameState.update();
  }
  clickMenu();
  drawGame(); //Alles tekenen op het lege scherm, gedefinieerd in tab Graphics
  pause(); //Pauze aan en uit zetten d.m.v. knop P, gedefinieerd in Interaction
  mute();
}

void makeParticles() {
  ptBoom= new ParticleSystem(width/2, height/2);
  ptBoom.spreadFactor=1.902098;
  ptBoom.minSpeed=3.2027972;
  ptBoom.maxSpeed=2.8251748;
  ptBoom.startVx=-0.0069929957;
  ptBoom.startVy=-0.37062937;
  ptBoom.particleShape="quad";
  ptBoom.emitterType="point";
  ptBoom.birthSize=52.923077;
  ptBoom.deathSize=1.6923077;
  ptBoom.gravity=0.046853147;
  ptBoom.birthColor=color(194.0, 97.0, 67.0, 255.0);
  ptBoom.deathColor=color(206.0, 0.0, 126.0, 0.0);
  ptBoom.blendMode="add";
  ptBoom.framesToLive=101;

  ptBamboo= new ParticleSystem(width/2, height/2);
  ptBamboo.spreadFactor=0.97902095;
  ptBamboo.minSpeed=3.2027972;
  ptBamboo.maxSpeed=2.2587414;
  ptBamboo.startVx=0.03496504;
  ptBamboo.startVy=-0.53846157;
  ptBamboo.particleShape="line";
  ptBamboo.emitterType="point";
  ptBamboo.birthSize=3.7692308;
  ptBamboo.deathSize=4.4615383;
  ptBamboo.gravity=0.01468531;
  ptBamboo.birthColor=color(0.0, 255.0, 0.0, 255.0);
  ptBamboo.deathColor=color(0.0, 255.0, 0.0, 0.0);
  ptBamboo.blendMode="add";
  ptBamboo.framesToLive=122;

  ptBamboo2= new ParticleSystem(width/2, height/2);
  ptBamboo2.spreadFactor=1.6783216;
  ptBamboo2.minSpeed=3.2027972;
  ptBamboo2.maxSpeed=2.2587414;
  ptBamboo2.startVx=0.03496504;
  ptBamboo2.startVy=-0.27272725;
  ptBamboo2.particleShape="quad";
  ptBamboo2.emitterType="point";
  ptBamboo2.birthSize=23.153847;
  ptBamboo2.deathSize=12.076923;
  ptBamboo2.gravity=0.011888109;
  ptBamboo2.birthColor=color(0.0, 255.0, 0.0, 255.0);
  ptBamboo2.deathColor=color(0.0, 255.0, 0.0, 0.0);
  ptBamboo2.blendMode="add";
  ptBamboo2.framesToLive=126;

  ptRock= new ParticleSystem(width/2, height/2);
  ptRock.spreadFactor=1.006993;
  ptRock.minSpeed=4.5244756;
  ptRock.maxSpeed=1.7552447;
  ptRock.startVx=0.3986014;
  ptRock.startVy=-0.0069929957;
  ptRock.particleShape="ellipse";
  ptRock.emitterType="point";
  ptRock.birthSize=50.153847;
  ptRock.deathSize=69.53846;
  ptRock.gravity=0.004895106;
  ptRock.birthColor=color(255.0, 255.0, 255.0, 255.0);
  ptRock.deathColor=color(0.0, 0.0, 0.0, 255.0);
  ptRock.blendMode="add";
  ptRock.framesToLive=59;
}
