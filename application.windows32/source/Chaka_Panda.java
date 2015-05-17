import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Chaka_Panda extends PApplet {

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
int speed = -5;
ArrayList<Platform> platforms = new ArrayList<Platform>(); //Arraylist voor alle instances van klasse Platform, zie tab Platform
ArrayList<Bamboe> bamboes = new ArrayList<Bamboe>(); //^ maar voor Bamboe
ArrayList<Blockade> blockades = new ArrayList<Blockade>(); //^maar voor Blockades
boolean pause = false; //is het spel gepauzeerd? wordt veranderd in tab Interaction
boolean mute = false;
boolean muteSound = false;
boolean muteMusic = false;
int blokade;
int frames = 0;

public void setup() {  
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
  highscorePoints = PApplet.parseInt(loadStrings("highscorePoints.txt"));
  player = new Player(150, 600);
  frame.setTitle("Chaka Panda");
  background(255);
  size(1280, 720);
  music = new Music();
  music.loadMusic("music.mp3");
  music.playMusic();
  makeParticles();
}

public void draw() {
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

public void updateGame() {
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


public void reset() {
  frames = 0;
  score = 0;
  player = new Player(150, 600);
  platforms.clear();
  bamboes.clear();
  blockades.clear();
  platforms.add(new Platform(100, random(300, 600), 1800, 700, speed)); //Begin met een lang platform
  player.y = platforms.get(0).y-player.h; //Zet player direct op het platform
}

public void spawn() {
  if (frames%180 == 0 && platforms.size()-1 < frames/180) { //frames%180 = "wat blijft er over als je frames door 180 deelt", telt dus om de seconde: 0, 1, 2, 0, 1, 2 etc. Kijkt ook naar hoeveel platforms er al zijn zodat hij er niet 1000 per seconde spawnt
    platforms.add(new Platform(1280, random(300, 600), random(600+600/(40000/score), 1000+1000/(40000/score)), 700, speed+speed/(20000/score))); //maak nieuw platform rechts op het scherm, op random hoogte, met random breedte, beweegt met snelheid 5
    Platform newestPlatform = platforms.get(platforms.size()-1);
    bamboes.add(new Bamboe(1800, random(newestPlatform.y-300, newestPlatform.y-100), speed+speed/(20000/score))); //zelfde als platform maar zonder breedte/hoogte, en iets verder naar rechts
    int randomInt = PApplet.parseInt(random(3));
    if (randomInt == 0) {
      blockades.add(new Blockade(random(1400, 1550), newestPlatform.y-sprBoom.height, speed+speed/(20000/score), sprBoom, ptBoom));
    }
    else if (randomInt == 1) {
      blockades.add(new Blockade(random(1400, 1550), newestPlatform.y-sprRock.height, speed+speed/(20000/score), sprRock, ptRock));
    }
    else if (randomInt == 2) {
      blockades.add(new Blockade(random(1400, 1550), newestPlatform.y-sprBamboo2.height, speed+speed/(20000/score), sprBamboo2, ptBamboo2));
    }
  }
}

public void makeParticles() {
  ptBoom= new ParticleSystem(width/2, height/2);
  ptBoom.spreadFactor=1.902098f;
  ptBoom.minSpeed=3.2027972f;
  ptBoom.maxSpeed=2.8251748f;
  ptBoom.startVx=-0.0069929957f;
  ptBoom.startVy=-0.37062937f;
  ptBoom.particleShape="quad";
  ptBoom.emitterType="point";
  ptBoom.birthSize=52.923077f;
  ptBoom.deathSize=1.6923077f;
  ptBoom.gravity=0.046853147f;
  ptBoom.birthColor=color(194.0f, 97.0f, 67.0f, 255.0f);
  ptBoom.deathColor=color(206.0f, 0.0f, 126.0f, 0.0f);
  ptBoom.blendMode="add";
  ptBoom.framesToLive=101;

  ptBamboo= new ParticleSystem(width/2, height/2);
  ptBamboo.spreadFactor=0.97902095f;
  ptBamboo.minSpeed=3.2027972f;
  ptBamboo.maxSpeed=2.2587414f;
  ptBamboo.startVx=0.03496504f;
  ptBamboo.startVy=-0.53846157f;
  ptBamboo.particleShape="line";
  ptBamboo.emitterType="point";
  ptBamboo.birthSize=3.7692308f;
  ptBamboo.deathSize=4.4615383f;
  ptBamboo.gravity=0.01468531f;
  ptBamboo.birthColor=color(0.0f, 255.0f, 0.0f, 255.0f);
  ptBamboo.deathColor=color(0.0f, 255.0f, 0.0f, 0.0f);
  ptBamboo.blendMode="add";
  ptBamboo.framesToLive=122;

  ptBamboo2= new ParticleSystem(width/2, height/2);
  ptBamboo2.spreadFactor=1.6783216f;
  ptBamboo2.minSpeed=3.2027972f;
  ptBamboo2.maxSpeed=2.2587414f;
  ptBamboo2.startVx=0.03496504f;
  ptBamboo2.startVy=-0.27272725f;
  ptBamboo2.particleShape="quad";
  ptBamboo2.emitterType="point";
  ptBamboo2.birthSize=23.153847f;
  ptBamboo2.deathSize=12.076923f;
  ptBamboo2.gravity=0.011888109f;
  ptBamboo2.birthColor=color(0.0f, 255.0f, 0.0f, 255.0f);
  ptBamboo2.deathColor=color(0.0f, 255.0f, 0.0f, 0.0f);
  ptBamboo2.blendMode="add";
  ptBamboo2.framesToLive=126;

  ptRock= new ParticleSystem(width/2, height/2);
  ptRock.spreadFactor=1.006993f;
  ptRock.minSpeed=4.5244756f;
  ptRock.maxSpeed=1.7552447f;
  ptRock.startVx=0.3986014f;
  ptRock.startVy=-0.0069929957f;
  ptRock.particleShape="ellipse";
  ptRock.emitterType="point";
  ptRock.birthSize=50.153847f;
  ptRock.deathSize=69.53846f;
  ptRock.gravity=0.004895106f;
  ptRock.birthColor=color(255.0f, 255.0f, 255.0f, 255.0f);
  ptRock.deathColor=color(0.0f, 0.0f, 0.0f, 255.0f);
  ptRock.blendMode="add";
  ptRock.framesToLive=59;
}
 class Bamboe {
  float x,y;
  float vx,vy; //snelheid
  float w,h; //grootte
  boolean onGround = true;
  
  Bamboe(float startX, float startY, float startvx) {
    x = startX;
    y = startY;
    w = sprBamboo.width;
    h = sprBamboo.height;
    vx = startvx;
  }
  
  public void update() {
    x += vx; //update elke frame de positie
  }
}
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
  
  public void update() {
    x += vx;
  }
}
public void drawGame() { //alles wat hier gebeurt wordt onderaan uitgelegd
  drawBackground();
  if (!gameOver) {
    for (Platform platform : platforms) { // voor elk platform van type Platform in ArrayList platforms, doe: draw
      if (platform != null) drawPlatform(platform);
    }
    for (Bamboe bamboe : bamboes) {
      if (bamboe != null) drawBamboe(bamboe);
    }
    for (Blockade blockade : blockades) {
      if (blockade != null) drawBlockade(blockade);
    }
    drawPlayer();
    drawGUI();
  }
  drawMenu();
}

public void drawBackground() {
  image(background, 0, 0, 1280, 720);
}

public void drawPlatform(Platform platform) {
  //noStroke();
  //fill(0,255,0);
  //rect(platform.x, platform.y, platform.sizeX, platform.sizeY);
  image(sprPlatform, platform.x, platform.y, platform.w, platform.h);
}

public void drawBamboe(Bamboe bamboe) {
  //  fill(0);
  //  ellipse(bamboe.x, bamboe.y, 20, 20);
  image(sprBamboo, bamboe.x, bamboe.y);
}

public void drawBlockade(Blockade blockade) {
  //fill(0);
  //rect(blockade.x, blockade.y, blockade.sizeX, blockade.sizeY);
  ptBamboo2.draw();
  ptRock.draw();
  ptBoom.draw();
  image(blockade.sprite, blockade.x, blockade.y+20);
}

public void drawPlayer() {
  //fill(0);
  //if (player.invincibleTime%0.25 >= 0.125) fill(255); //zorgt er voor dat player wit&zwart flikkert als hij net dood was
  //rect(player.x,player.y,50,50);
  ptBamboo.draw();
  image(player.sprPlayer, player.x, player.y+20);// tekent de panda ipv een vierkant
}

public void drawGUI() {
  //fill(0);
  for (int i=0; i<player.lives; i++) { //Tekent zoveel bolletjes als de speler levens heeft
    //ellipse(25+50*i,40,10,10);
    image(sprLives, 10+(50 * i), 40);
  }
  fill(0);
  stroke(0);
  text("Score: ", 2, 15);
  if (highscorePoints.length > 0) fill(255*(2f-score/(float) highscorePoints[0]*2f), 255*(score/(float) highscorePoints[0]*2f), 0);
  else fill(0,255,0);
  rect(55, 5, (score / 30), 10);
  fill(0);
}

public void drawMenu() {
  if (mainMenu) image(mainmenu, 0, 0, 1280, 720);
  if (gameOver && !highScore) image(gameover, 0, 0, 1280, 720);
  if (highScore && !gameOver) {
    image(highscore, 0, 0, 1280, 720);
    textSize(20);
    for (int i=0; i<highscorePoints.length; i++) {
      fill(255);
      text(highscoreName[i], 305, 310+35*i);
      fill(255*(2f-highscorePoints[i]/(float) highscorePoints[0]*2f), 255*(highscorePoints[i]/(float) highscorePoints[0]*2f), 0);
      rect(400, 295+35*i, highscorePoints[i]/(float) highscorePoints[0]*400, 20);
    }
    textSize(11);
  }
  if (highScore && gameOver) {
    image(scoreenter, 0, 0, 1280, 720);
    textSize(50);
    fill(255);
    text(name,280,350);
    textSize(11);
  }
  if (instructions) image(besturing, 0, 0, 1280, 720);
  if (options) {
    image(sound, 0, 0, 1280, 720);
    if (mute) image(sound1, 387, 311, 110, 98);
    if (muteSound) image(sound2, 385, 427, 113, 94);
    if (muteMusic) image(sound3, 390, 545, 100, 86);
  }
  if (pause) image(pauze, 400, 50);
}

boolean[] keysPressed = new boolean[256];
boolean[] keysReleased = new boolean[256];
boolean mousepressed = false;
boolean mousereleased = true;

public void keyPressed() {
  keysPressed[keyCode] = true;
  keysReleased[keyCode] = false;
}

public void keyReleased() {
  keysPressed[keyCode] = false;
  keysReleased[keyCode] = true;
}

public void mousePressed() {
  mousepressed = true;
  mousereleased = false;
}

public void pause() {
  if (keysPressed['P'] && !keysReleased['P'] && !gameOver && !highScore && !mainMenu && !instructions && !options) { //keysReleased zorgt er voor dat P ingedrukt houden niet constant pause aan en uit zet
    pause = !pause;
    keysReleased['P'] = true;
  }
}

public void clickMenu() {
//  !pause && !gameOver && !highScore && !mainMenu && !instructions && !options
  if (pause) {
    if (mouseX >= 530 && mouseX <= 770 && mouseY >= 270 && mouseY <= 340 && mousepressed && !mousereleased) {
      pause = false;
      reset();
      mousereleased = true;
    }
    else if (mouseX >= 530 && mouseX <= 740 && mouseY >= 400 && mouseY <= 470 && mousepressed && !mousereleased) {
      pause = false;
      mousereleased = true;
    }
    else if (mouseX >= 530 && mouseX <= 850 && mouseY >= 530 && mouseY <= 600 && mousepressed && !mousereleased) {
      pause = false;
      mainMenu = true;
      mousereleased = true;
    }
    else mousereleased = true;
  }
  if (mainMenu) {
    if (mouseX >= 200 && mouseX <= 530 && mouseY >= 200 && mouseY <= 280 && mousepressed && !mousereleased) {
      mainMenu = false;
      reset();
      mousereleased = true;
    }
    else if (mouseX >= 200 && mouseX <= 530 && mouseY >= 320 && mouseY <= 410 && mousepressed && !mousereleased) {
      mainMenu = false;
      instructions = true;
      mousereleased = true;
    }
    else if (mouseX >= 200 && mouseX <= 530 && mouseY >= 450 && mouseY <= 540 && mousepressed && !mousereleased) {
      mainMenu = false;
      highScore = true;
      mousereleased = true;
    }
    else if (mouseX >= 200 && mouseX <= 530 && mouseY >= 580 && mouseY <= 670 && mousepressed && !mousereleased) {
      mainMenu = false;
      options = true;
      mousereleased = true;
    }
    else mousereleased = true;
  }
  if (instructions) {
    if (mouseX >= 185 && mouseX <= 450 && mouseY >= 225 && mouseY <= 285 && mousepressed && !mousereleased) {
      instructions = false;
      mainMenu = true;
      mousereleased = true;
    }
    else mousereleased = true;
  }
  if (options) {
    if (mouseX >= 380 && mouseX <= 660 && mouseY >= 225 && mouseY <= 265 && mousepressed && !mousereleased) {
      options = false;
      mainMenu = true;
      mousereleased = true;
    }
    else if (55 > sqrt(sq(mouseX-440)+sq(mouseY-360)) && mousepressed && !mousereleased) {
      if (mute) music.unmuteMusic();
      else music.muteMusic();
      mute = !mute;
      mousereleased = true;
    }
    else if (55 > sqrt(sq(mouseX-440)+sq(mouseY-480)) && mousepressed && !mousereleased) {
      muteSound = !muteSound;
      mousereleased = true;
    }
    else if (55 > sqrt(sq(mouseX-440)+sq(mouseY-600)) && mousepressed && !mousereleased) {
      if (muteMusic) music.unmuteMusic();
      else music.muteMusic();
      muteMusic = !muteMusic;
      mousereleased = true;
    }
    else mousereleased = true;
  }
  if (gameOver && !highScore) {
    if (mouseX >= 165 && mouseX <= 740 && mouseY >= 350 && mouseY <= 430 && mousepressed && !mousereleased) {
      highScore = true;
      mousereleased = true;
    }
    else if (mouseX >= 165 && mouseX <= 670 && mouseY >= 470 && mouseY <= 540 && mousepressed && !mousereleased) {
      gameOver = false;
      reset();
      mousereleased = true;
    }
    else if (mouseX >= 165 && mouseX <= 570 && mouseY >= 630 && mouseY <= 700 && mousepressed && !mousereleased) {
      gameOver = false;
      mainMenu = true;
      mousereleased = true;
    }
    else mousereleased = true;
  }
  if (highScore && !gameOver) {
    if (mouseX >= 410 && mouseX <= 630 && mouseY >= 650 && mouseY <= 710 && mousepressed && !mousereleased) {
      name = "";
      highScore = false;
      mainMenu = true;
      mousereleased = true;
    }
    else mousereleased = true;
  }
  if (highScore && gameOver) {
    for (int i=65; i<90; i++) {
      if (keysPressed[i] && !keysReleased[i] && name.length() < 6) {
        name += (char) i;
        keysReleased[i] = true;
      }
    }
    if (name.length() != 0 && keysPressed[8] && !keysReleased[8]) {
      name = name.substring(0, name.length()-1);
      keysReleased[8] = true;
    }
    if (mouseX >= 400 && mouseX <= 915 && mouseY >= 560 && mouseY <= 640 && mousepressed && !mousereleased) {
      int[] tempHighscorePoints = new int[highscorePoints.length+1];
      String[] tempHighscoreName = new String[highscoreName.length+1];
      boolean scorePlaced = false;
      for (int i=0; i<tempHighscorePoints.length; i++) {
        if (i == tempHighscorePoints.length-1 && !scorePlaced) {
          tempHighscorePoints[i] = (int) score;
          tempHighscoreName[i] = name;
        }
        if (i != tempHighscorePoints.length-1) {
          if (score <= highscorePoints[i]) {
            tempHighscorePoints[i] = highscorePoints[i];
            tempHighscoreName[i] = highscoreName[i];
          }
          else if (!scorePlaced) {
            scorePlaced = true;
            tempHighscorePoints[i] = (int) score;
            tempHighscoreName[i] = name;
          }
          else {
            tempHighscorePoints[i] = highscorePoints[i-1];
            tempHighscoreName[i] = highscoreName[i-1];
          }
        }
      }
      if (tempHighscorePoints.length > 10) {
        highscorePoints = new int[10];
        highscoreName = new String[10];
        for (int i=0; i<10; i++) {
          highscorePoints[i] = tempHighscorePoints[i];
          highscoreName[i] = tempHighscoreName[i];
        }
      }
      else {
        highscorePoints = new int[tempHighscorePoints.length];
        highscoreName = new String[tempHighscorePoints.length];
        for (int i=0; i<tempHighscorePoints.length; i++) {
          highscorePoints[i] = tempHighscorePoints[i];
          highscoreName[i] = tempHighscoreName[i];
        }
      }
      saveStrings("data/highscorePoints.txt",str(highscorePoints));
      saveStrings("data/highscoreName.txt",highscoreName);
      gameOver = false;
      mousereleased = true;
    }
    else mousereleased = true;
  }
}

public void mute() {
  if (keysPressed['M'] && !keysReleased['M'] && mute) {
    music.unmuteMusic();
    mute = false;
    keysReleased['M'] = true;
  }
  else if (keysPressed['M'] && !keysReleased['M'] && !mute) {
    music.muteMusic();
    mute = true;
    keysReleased['M'] = true;
  }
}


    


AudioSample Jump;
AudioSample Dash;
AudioSample Bamboe;
AudioSample Hit;
AudioSample GameOver;
// A reference to the processing sound engine
Minim minim = new Minim(this);

// SampleBank loads all samples in the data directory of your project
// so they can be triggered at any time in your game
class Music {

  HashMap<String, AudioSample> samples;
  AudioPlayer musicPlayer;

  // Constructor
  Music() {
    samples = new HashMap<String, AudioSample>();
    loadAllSamples();
    Jump = minim.loadSample("jump.wav", 2048);
    Dash = minim.loadSample("dash.wav", 1500);
    Bamboe = minim.loadSample("bamboeeten.wav", 2048);
    Hit = minim.loadSample("hit2.wav", 3000);
    GameOver = minim.loadSample("gameover.wav", 1500);
  }

  // load the background music
  public void loadMusic(String musicFileName) {
    musicPlayer = minim.loadFile(musicFileName);
  }

  // play the background music
  public void playMusic() {
    musicPlayer.play();
    musicPlayer.setGain(40.0f);
    musicPlayer.loop();
  }

  // stop the background music
  public void muteMusic() {
    musicPlayer.pause();
  }
  
  public void unmuteMusic(){
    musicPlayer.play();
  }
  

  // Add a new sample to the sample bank
  public void add(String sampleFileName) {
    AudioSample sample = minim.loadSample(sampleFileName);
    samples.put(sampleFileName, sample);    
    println(sampleFileName);
  }

  // trigger a loaded sample by fileName
  public void trigger(String sampleFileName) {
    //    if (!sampleFileName.endsWith(".wav") &&  samples.containsKey(sampleFileName + ".wav"))
    sampleFileName += ".wav";
    if (samples.containsKey(sampleFileName)) 
      samples.get(sampleFileName).trigger();
  }

  // load all .wav files in the processing data directory
  public void loadAllSamples() {
    File dataFolder = new File(dataPath(""));
    File [] files = dataFolder.listFiles();

    for (File file : files)
      if (file.getName().toLowerCase().endsWith(".wav"))
        add(file.getName());
  }
}

// Class for a single particle
class Particle {
  float x, y, vx, vy, size, particleColor, speed;

  // quad coordinate offset
  float qx0, qy0, qx1, qy1, qx2, qy2, qx3, qy3;

  // Color used to draw the particle
  int drawColor;

  // amount of frames the particle has to live
  int framesToLive;

  // Angular velocity
  float w;

  // angle (for quad particles)
  float angle;


  // Shape of the particle (default: ellipse)
  String particleShape = "ellipse";


  // Constructor
  Particle(float x, float y, int framesToLive, String particleShape) {
    this.x = x; 
    this.y = y;
    this.framesToLive = framesToLive;
    this.particleShape = particleShape;

    // random angular velocity (left or right)
    w = random(-0.1f, 0.1f);

    // determine coordinate offsets if quad
    if (particleShape == "quad") {
      qx0 = -random(1.0f); 
      qy0 = -random(1.0f);
      qx1 = random(1.0f); 
      qy1 = -random(1.0f);
      qx2 = random(1.0f); 
      qy2 = random(1.0f);
      qx3 = -random(1.0f); 
      qy3 = random(1.0f);
    }
  }

  // update position and frames to live
  public void update() {
    x += vx * speed;
    y += vy * speed;
    framesToLive--;
  }

  // draw the particle based on particleShape
  public void draw() {
    if (particleShape == "ellipse") {
      fill(drawColor); 
      ellipse(x, y, this.size/2, this.size/2);
    }
    else
      if (particleShape == "line") {
        stroke(drawColor);          
        line(x, y, x + vx * speed * this.size, y + vy * speed * this.size);
      }
      else
        if (particleShape == "quad") {
          angle += w;
          pushMatrix();
          translate(x, y);
          pushMatrix();              
          rotate(angle);
          fill(drawColor);
          float ps2 = this.size/2;
          quad(qx0*ps2, qy0*ps2, 
          qx1*ps2, qy1*ps2, 
          qx2*ps2, qy2*ps2, 
          qx3*ps2, qy3*ps2);
          popMatrix();
          popMatrix();
        }
  }
}

// Particle system to manage emission of particles
class ParticleSystem {
  ArrayList<Particle> particles;

  // the origin of emission. x1 and y1 are used when emitter is a line 
  float  x0, y0, x1, y1;

  // shape of the particles
  String particleShape = "ellipse";
  String blendMode = "add";
  // type of emitter
  String emitterType = "point";

  // amount of particles to emit
  int emissionRate = 0;

  // amount of frames to emit particles
  int framesToEmit = 0;

  // color at birth and color at death
  int birthColor, deathColor;

  // size at birth and size at death
  float birthSize, deathSize;

  // amount of frames after which the particle is removed
  int framesToLive;

  // direction in which the particles are emitted
  float startVx, startVy;

  // particles are spread slightly randomly
  float spreadFactor;

  // particles have different emission speeds, between minSpeed and maxSpeed
  float minSpeed, maxSpeed;

  // force pulling in y direction
  float gravity;

  // Create new particle system, emitter at (x,y)
  ParticleSystem(float x, float y) {
    this.x0 = x;
    this.y0 = y;  
    particles = new ArrayList<Particle>();
  }


  // add an amount of particles to the particle system
  public void emit(int particleAmount) {
    float t, x, y;

    for (int iParticle=0; iParticle<particleAmount; iParticle++) {

      if (emitterType == "line") {
        // spread particles randomly among line between (x0, y0) and (x1, y1)
        t = random(1.0f);
        x = (1.0f-t)*x0 + t * x1;
        y = (1.0f-t)*y0 + t * y1;
      }
      else { // particles are emitted from a point (x0, y0)
        x = x0;
        y = y0;
      }

      // spawn an new particle in the system
      Particle particle = new Particle(x, y, framesToLive, particleShape);
      particle.vx = random(startVx-spreadFactor/2, startVx+spreadFactor/2);
      particle.vy = random(startVy-spreadFactor/2, startVy+spreadFactor/2);
      particle.speed = random(minSpeed, maxSpeed);
      particles.add(particle);
    }
  }

  // creal the particle system
  public void reset() {
    particles.clear();
  }

  // update speed, size and color of all particles
  public void update() {
    for (int iParticle=0; iParticle<particles.size(); iParticle++) {
      Particle particle = particles.get(iParticle);
      particle.vy += gravity;
      particle.update();
      if (particle.framesToLive == 0)
        particles.remove(particle);
    }
  }

  // draw all particles
  public void draw() {

    // only change context once for all particles
    if (particleShape != "line") noStroke();
    strokeWeight(2);
    noSmooth();

    // determine how transparancy is handeled
    if (blendMode == "add")
      blendMode(ADD);
    else
      if (blendMode == "blend")
        blendMode(BLEND);

    for (Particle particle : particles) {
      // determine size by interpolation
      particle.size = lerp(deathSize, birthSize, (float)particle.framesToLive/(float)framesToLive);      
      // determine color by interpolation
      int particleColor = lerpColor(deathColor, birthColor, ((float)particle.framesToLive/(float)framesToLive));

      particle.drawColor = particleColor;
      particle.draw();
    }

    // reset blendmode
    blendMode(BLEND);
  }
}

class Platform {
  float x,y;
  float vx,vy;
  float w,h;
  
  Platform(float startX, float startY, float startSizeX, float startSizeY, float startvx) {
    //init();
    x = startX;
    y = startY;
    vx = startvx;
    w = startSizeX;
    h = startSizeY;
  }
  
  public void update() {
    x += vx;
  }
}
class Player {
  float x, y;
  float vx, vy;
  float w, h;
  boolean onGround = true; //staat de speler op een platform
  int lives = 3;
  int dubbeljump = 1;

  float invincibleTime = 0;
  float dashTimer = 0;
  PImage sprPlayer;

  Platform currentPlatform; //op welk platform staat de speler op het moment / stond de speler voor het laatst

  Player(float startX, float startY) {
    x = startX;
    y = startY;
    animate();
    w = sprPlayer.width;
    h = sprPlayer.height;
  }

  public void update() {
    animate();
    checkGround();
    hitBamboe();
    hitBlockade();
    dubbelJump();
    dash();
    move();
    dieDraw();
    die();
    y += vy;
    x += vx;
    ptBoom.x0 = x;
    ptBoom.y0 = y;
    ptBoom.update();
    ptBamboo.x0 = x;
    ptBamboo.y0 = y;
    ptBamboo.update();
    ptBamboo2.x0 = x;
    ptBamboo2.y0 = y;
    ptBamboo2.update();
    ptRock.x0 = x;
    ptRock.y0 = y;
    ptRock.update();
  }

  public void animate() {
    int animSpeed = 200; //lager = sneller
    if (!onGround) sprPlayer = animPlayer[3];
    else sprPlayer = animPlayer[(millis()/animSpeed)%3];
    if (vx > 0 && dashTimer*9f > 15f) sprPlayer = animPlayer[(6-(int) (dashTimer*9f-15f))];
  }
  
  public void checkGround() {
    onGround = false;
    for (int i=0; i<platforms.size(); i++) {
      Platform platform = platforms.get(i);
      if (platform != null) {
        if (x+w >= platform.x && x <= platform.x+platform.w && y+h >= platform.y && y <= platform.y+platform.h) { //vergelijkt hitboxes van player en platform, als ze matchen en op de goede plek staan hebben we een platform om op te staan
          onGround = true;
          dubbeljump = 1;
          currentPlatform = platform;
        }
      }
    }
    if (currentPlatform != null) { //als we onGround zijn: simuleer zwaartekracht d.m.v. vy++
      if (onGround) {
        y = currentPlatform.y-h;
        vy = 0;
      }
      else {
        vy++;
      }
    }
    else {
      onGround = false;
      vy++;
    }
  }

  public void hitBamboe() {
    for (int i=0; i<bamboes.size(); i++) {
      Bamboe bamboe = bamboes.get(i);
      if (bamboe != null) {
        if (x+w >= bamboe.x && x <= bamboe.x+bamboe.w && y+h >= bamboe.y && y <= bamboe.y+bamboe.h) { //vergelijkt hitboxes van player en bamboe, etc
          score += 200;
          bamboes.set(i, null);
          ptBamboo.emit(20);
          if (!mute && !muteSound) {
            Bamboe.trigger();
          }
        }
      }
    }
  }

  public void hitBlockade() {
    for (int i=0; i<blockades.size(); i++) {
      Blockade blockade = blockades.get(i);
      if (blockade != null) {
        if (x+w >= blockade.x && x <= blockade.x+blockade.w && y+h >= blockade.y && y <= blockade.y+blockade.h) { //vergelijkt hitboxes van player en bamboe, etc
          if (vx > 0) {
            blockade.particle.emit(20);
            blockades.set(i, null);
            if (!mute && !muteSound) {
              Hit.trigger();
            }
          }
          else if (invincibleTime == 0) x = blockade.x-w;
        }
      }
    }
  }


  public void move() {
    if (onGround && keysPressed[UP]) {
      vy = -20;
      keysReleased[UP] = true;
      if (!mute && !muteSound) {
        Jump.trigger();
      }
    }
    if (x > 150 && dashTimer <= 1.5f) vx = -3;
    else if (dashTimer <= 1.3f) vx = 0;
    //    if (keysPressed[LEFT]) vx = -5;
    //    else if (keysPressed[RIGHT]) vx = 5;
    //    else vx = 0;
  }

  public void dubbelJump() {
    if (!onGround && keysPressed[UP] && !keysReleased[UP] && dubbeljump > 0) {
      vy = -20;
      dubbeljump--;
      keysReleased[UP] = true;
      if (!mute && !muteSound) {
        Jump.trigger();
      }
    }
  }

  public void dash() {
    if (keysPressed[RIGHT] && dashTimer <= 0) { 
      vx = 20;
      dashTimer = 2;
      if (!mute && !muteSound) {
        Dash.trigger();
      }
    }
    else if (vx > 0) {
      vx--;
    }
    dashTimer -= 0.0166f;
  }

  public void die() {
    if (y > 720 || x < -w) {
      if (lives > 1) { //Als de speler gevallen is en nog levens over heeft: zet hem weer bovenaan met een korte tijd (invincibleTime) zonder vallen
        lives--;
        x = 150;
        y = 10;
        invincibleTime = 60; //60 frames = 1 seconde
        if (!mute && !muteSound) {
          GameOver.trigger();
        }
      }
      else {
        y = 5000;
        x = -90;
        gameOver = true;
      }
    }
    if (invincibleTime > 0) { //Als speler net dood is gegaan: geef een korte tijd totdat hij uit de lucht valt
      invincibleTime -= 1;
      vy = 0;
    }
  }

  public void dieDraw() {
    if (gameOver) {
      fill(0);
      text("GAME OVER", 570, 320);
      //      text("Druk enter om verder te gaan", 540, 400);
    }
  }
}

class Score
{
  float x;
//  float coins;
  float scoreTotal;
  float highscore;
  
  Score() {
    highscore = 0;
  }
  
  public void update(){
   x--;
   
    
//    scoreTotal = player.score + (coins * 5);
//    highscore();
  }
  
//  boolean highscore(){
//    if(scoreTotal > highscore){
//      highscore = scoreTotal;
//      return true;
//    } else{
//      return false;
//    }
//  }
  
}
    
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Chaka_Panda" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
