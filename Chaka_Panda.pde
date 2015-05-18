Player player; //Instance van klasse Player, zie tab Player
Score scoreDummy = new Score();//de score
Music music;
ParticleSystem ptBoom;
ParticleSystem ptBamboo;
ParticleSystem ptBamboo2;
ParticleSystem ptRock;
float score;
boolean gameOver = false;
boolean highScore = false;
boolean mainMenu = true;
boolean instructions = false;
boolean options = false;
PImage background;
PImage sprBoom;
PImage sprRock;
PImage sprBamboo;
PImage sprBamboo2;
PImage sprPlatform;
PImage[] animPlayer = new PImage[7];
PImage sprLives;
PImage mainmenu;
PImage besturing;
PImage gameover;
PImage highscore;
PImage scoreenter;
PImage pauze;
PImage sound;
PImage sound1;
PImage sound2;
PImage sound3;
String[] highscoreName;
int[] highscorePoints;
String name = "";
float x;
float speed = -3.75f;
ArrayList<Platform> platforms = new ArrayList<Platform>(); //Arraylist voor alle instances van klasse Platform, zie tab Platform
ArrayList<Bamboe> bamboes = new ArrayList<Bamboe>(); //^ maar voor Bamboe
ArrayList<Blockade> blockades = new ArrayList<Blockade>(); //^maar voor Blockades
boolean pause = false; //is het spel gepauzeerd? wordt veranderd in tab Interaction
boolean mute = false;
boolean muteSound = false;
boolean muteMusic = false;
int blokade;
int frames = 0;

void setup() {  
  score = 0;
  frameRate(60);
  background = loadImage("background.png");
  sprBoom = loadImage("sprBoom.png");
  sprRock = loadImage("sprRock.png");
  sprBamboo = loadImage("sprBamboo.png");
  sprBamboo2 = loadImage("sprBamboo2.png");
  sprPlatform = loadImage("sprPlatform.png");
  animPlayer[0] = loadImage("sprPlayer1.png");
  animPlayer[1] = loadImage("sprPlayer2.png");
  animPlayer[2] = loadImage("sprPlayer3.png");
  animPlayer[3] = loadImage("sprPlayer_Jump.png");
  animPlayer[4] = loadImage("sprPlayer_Dash1.png");
  animPlayer[5] = loadImage("sprPlayer_Dash2.png");
  animPlayer[6] = loadImage("sprPlayer_Dash3.png");
  sprLives = loadImage("sprLives.png");
  mainmenu = loadImage("mainmenu.jpg");
  besturing = loadImage("besturing.jpg");
  gameover = loadImage("gameover.jpg");
  highscore = loadImage("highscore.jpg");
  scoreenter = loadImage("scoreenter.jpg");
  pauze = loadImage("pauze.jpg");
  sound = loadImage("sound.jpg");
  sound1 = loadImage("sound1.jpg");
  sound2 = loadImage("sound2.jpg");
  sound3 = loadImage("sound3.jpg");
  highscoreName = loadStrings("highscoreName.txt");
  highscorePoints = int(loadStrings("highscorePoints.txt"));
  player = new Player(150, 600);
  frame.setTitle("Chaka Panda");
  background(255);
  size(1280, 720);
  music = new Music();
  music.loadMusic("music.mp3");
  music.playMusic();
  makeParticles();
}

void draw() {
  background(255); //Begin elke frame met leeg scherm
  if (!pause && !gameOver && !highScore && !mainMenu && !instructions && !options) { //pause() staat hierbuiten zodat hij nog gebruikt kan worden wanneer het spel wel gepauzeerd is
    updateGame(); //Alles wat in het spel beweegt en gebeurt, zie hieronder
    frames++;
  }
  clickMenu();
  drawGame(); //Alles tekenen op het lege scherm, gedefinieerd in tab Graphics
  pause(); //Pauze aan en uit zetten d.m.v. knop P, gedefinieerd in Interaction
  mute();
}

void updateGame() {
  scoreDummy.update();
  spawn(); //spawnt om de 3 seconden een nieuw platform en nieuwe bamboe
  player.update(); //beweegt speler, checkt hitboxes etc. zie klasse Player
  if (!gameOver) {
    score++; //update score zolang de game nog niet over is.
  }
  for (int i=0; i<platforms.size(); i++) {
    if (platforms.get(i) != null) { //Platform moet bestaan
      platforms.get(i).update();
      if (platforms.get(i).x + platforms.get(i).w < 0) platforms.set(i, null); //Als platform uit scherm is verdwenen, bestaat niet meer
    }
  }
  for (int i=0; i<bamboes.size(); i++) { //alles hetzelfde als in platform behalve dat bamboesprites een nonvariabele breedte hebben (breedte wordt gebruikt bij berekenen of object uit het scherm is)
    if (bamboes.get(i) != null) {
      bamboes.get(i).update();
      if (bamboes.get(i).x + 10 < 0) bamboes.set(i, null);
    }
  }
  for (int i=0; i<blockades.size(); i++) { //alles hetzelfde als in platform
    if (blockades.get(i) != null) {
      blockades.get(i).update();
      if (blockades.get(i).x + blockades.get(i).w < 0) blockades.set(i, null);
    }
  }
}


void reset() {
  frames = 0;
  score = 0;
  player = new Player(150, 600);
  platforms.clear();
  bamboes.clear();
  blockades.clear();
  platforms.add(new Platform(100, random(300, 600), 1800, 700, speed)); //Begin met een lang platform
  player.y = platforms.get(0).y-player.h; //Zet player direct op het platform
}

void spawn() {
  if (frames%180 == 0 && platforms.size()-1 < frames/180) { //frames%180 = "wat blijft er over als je frames door 180 deelt", telt dus om de seconde: 0, 1, 2, 0, 1, 2 etc. Kijkt ook naar hoeveel platforms er al zijn zodat hij er niet 1000 per seconde spawnt
    float platformX = 1280;
    float platformY = random(300, 600);
    float platformW = random(450+450/(20000/score), 750+750/(20000/score)); //600-1000 * 0.75 = 450-750
    float platformH = sprPlatform.height;
    float platformSpeed = speed+speed/(12000/score);
    platforms.add(new Platform(platformX, platformY, platformW, platformH, platformSpeed)); //maak nieuw platform rechts op het scherm, op random hoogte, met random breedte, beweegt met snelheid 5
    Platform newestPlatform = platforms.get(platforms.size()-1);
    bamboes.add(new Bamboe(random(1050,1525), random(newestPlatform.y-225, newestPlatform.y-75), speed+speed/(12000/score))); //zelfde als platform maar zonder breedte/hoogte, en iets verder naar rechts
    
    int randomInt = int(random(3));
    PImage sprite = sprBoom;
    ParticleSystem particle = ptBoom;
    switch (randomInt) {
      case 0: sprite = sprBoom;
        particle = ptBoom;
        break;
      case 1: sprite = sprRock;
        particle = ptRock;
        break;
      case 2: sprite = sprBamboo2;
        particle = ptBamboo2;
        break;
    }
    blockades.add(new Blockade(random(1400, 1550), newestPlatform.y-sprite.height, speed+speed/(10000/score), sprite, particle));
  }
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
