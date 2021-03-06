//GameState represents the state of the game
class GameState {
  //While it is not good form, I neglected to make anything in this class private, because the only instance of this class will be used globally
  //TODO: make GameState a singleton
  
  //The player gets reset everytime GameState.Reset() is called, which is anytime the player starts a new game.
  //TODO: make score a part of Player
  Player player;
  float score;
  
  //These variables indicate the various settings of the game, as well as which screen the game is on
  boolean gameOver = false;
  boolean highScore = false;
  boolean mainMenu = true;
  boolean instructions = false;
  boolean options = false;
  boolean pause = false;
  boolean mute = false;
  boolean muteSound = false;
  boolean muteMusic = false;

  //These variables will be used to read and write highscores to a textfile
  String[] highscoreName;
  int[] highscorePoints;
  String name = "";
  
  //These variables will be used to spawn and maintain the objects in the game
  float speed = -3.75f;
  ArrayList<Platform> platforms = new ArrayList<Platform>();
  ArrayList<Bamboe> bamboes = new ArrayList<Bamboe>();
  ArrayList<Blockade> blockades = new ArrayList<Blockade>();
  int frames = 0;
  
  //Contain all images and particles, which we load in loadImages() and loadParticles() respectively
  ContentHandler<PImage> images;
  ContentHandler<ParticleSystem> particles;
  
  //Initialize the variables of this class, to get ready for playing
  GameState() {
    //Load images
    images = new ContentHandler<PImage>();
    loadImages();
    particles = new ContentHandler<ParticleSystem>();
    loadParticles();
    
    //Reset player and objects
    reset();

    //Read highscores from file
    highscoreName = loadStrings("highscoreName.txt");
    highscorePoints = int(loadStrings("highscorePoints.txt"));
  }
  
  //A simple function to indicate if the player is currently playing (true) or in a menu (false)
  boolean inGame() {
    return (!gameOver && !highScore && !mainMenu && !instructions && !options);
  }
  
  //Updates all objects in the game, spawns new objects, removes old objects
  void update() {
    spawn();
    player.update();
    
    //TODO: make this a part of player.update()
    if (!gameOver) {
      score++;
    }
    
    //Could be cleaner. Updates all objects and particles in the game
    for (int i=0; i<platforms.size(); i++) {
      if (platforms.get(i) != null) {
        platforms.get(i).update();
        if (platforms.get(i).x + platforms.get(i).w < 0) platforms.set(i, null);
      }
    }
    for (int i=0; i<bamboes.size(); i++) {
      if (bamboes.get(i) != null) {
        bamboes.get(i).update();
        if (bamboes.get(i).x + 10 < 0) bamboes.set(i, null); //fix +10 (w)
      }
    }
    for (int i=0; i<blockades.size(); i++) {
      if (blockades.get(i) != null) {
        blockades.get(i).update();
        if (blockades.get(i).x + blockades.get(i).w < 0) blockades.set(i, null);
      }
    }
    for (int i=0; i<particles.content.size(); i++) {
      particles.content.get(i).update();
    }
    frames++;
  }
  
  //Resets the player and clears all objects (but then spawns one platform so the game is not empty)
  void reset() {
    frames = 0;
    score = 0;
    player = new Player(150, 600, initAnimation());
    platforms.clear();
    bamboes.clear();
    blockades.clear();
    platforms.add(new Platform(100, random(300, 600), 1800, 700, speed, images.find("sprPlatform")));
    player.y = platforms.get(0).y-player.h;
  }
  
  //Every 3 seconds, spawn a platform, bamboo and obstacle. The type of obstacle is randomly chosen, and speed and locations of objects depend on the score of the player (for difficulty purposes)
  void spawn() {
    if (frames%180 == 0 && platforms.size()-1 < frames/180) {
      float platformX = 1280;
      float platformY = random(300, 600);
      float platformW = random(450+450/(20000/score), 750+750/(20000/score));
      float platformH = images.find("sprPlatform").height;
      float platformSpeed = speed+speed/(12000/score);
      platforms.add(new Platform(platformX, platformY, platformW, platformH, platformSpeed, images.find("sprPlatform")));
      Platform newestPlatform = platforms.get(platforms.size()-1);
      bamboes.add(new Bamboe(random(1050,1525), random(newestPlatform.y-225, newestPlatform.y-75), speed+speed/(12000/score), images.find("sprBamboo")));
      
      int randomInt = int(random(3));
      PImage sprite = images.find("sprBoom");
      ParticleSystem particle = particles.find("ptBoom");
      switch (randomInt) {
        case 1: sprite = images.find("sprRock");
          particle = particles.find("ptRock");
          break;
        case 2: sprite = images.find("sprBamboo2");
          particle = particles.find("ptBamboo2");
          break;
      }
      blockades.add(new Blockade(random(1400, 1550), newestPlatform.y-sprite.height, speed+speed/(10000/score), sprite, particle));
    }
  }
  
  //Loads all the images that will be used in the game.
  void loadImages() {
    //loadInterface simulates a function pointer, which points to the function loadImage(). This fake function pointer can be given to ContentHandler.load() as an argument
    LoadInterface<PImage> loadInterface = new LoadInterface<PImage>() {
      public PImage func(String arg) {
        return loadImage(arg);
      }
    };
    
    //TODO: change this and ContentHandler.load() to take two strings. ContentHandler.load() should be able to regex a filename to create a proper (extensionless) name to be used in ContentHandler.find()
    String[] names = {"background", "sprBoom", "sprRock", "sprBamboo", "sprBamboo2", "sprPlatform", "sprPlayer1", "sprPlayer2", "sprPlayer3", "sprPlayer_Jump", "sprPlayer_Dash1", "sprPlayer_Dash2", "sprPlayer_Dash3", "sprLives", "mainmenu", "besturing", "gameover",
                      "highscore", "scoreenter", "pauze", "sound", "sound1", "sound2", "sound3"};
    String[] extensions = {"png", "png", "png", "png", "png", "png", "png", "png", "png", "png", "png", "png", "png", "png", "jpg", "jpg", "jpg", "jpg", "jpg", "jpg", "jpg", "jpg", "jpg", "jpg"};
    
    for (int i=0; i<names.length; i++) {
      images.load(names[i], extensions[i], loadInterface);
    }
  }
  
  //Gets a list of Images from the images ContentHandler, for player to use
  //An ugly solution to a simple problem; I tried making this a generic function of ContentHandler, but it is impossible to create a generic array T[] because array types need to be known at compile time
  //This could be moved to Player
  PImage[] initAnimation() {
    String[] imageNames = {"sprPlayer1", "sprPlayer2", "sprPlayer3", "sprPlayer_Jump", "sprPlayer_Dash1", "sprPlayer_Dash2", "sprPlayer_Dash3"};
    PImage[] animPlayer = new PImage[imageNames.length];
    for (int i=0; i<imageNames.length; i++) {
      animPlayer[i] = images.find(imageNames[i]);
    }
    return animPlayer;
  }
  
  //Creates all the particles that will be used in the game. These values were generated in a program that accompanies the ParticleSystem class.
  void loadParticles() {
    ParticleSystem ptBoom;
    ParticleSystem ptBamboo;
    ParticleSystem ptBamboo2;
    ParticleSystem ptRock;
    
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
    
    particles.add(ptBoom, "ptBoom");
    particles.add(ptBamboo, "ptBamboo");
    particles.add(ptBamboo2, "ptBamboo2");
    particles.add(ptRock, "ptRock");
  }
}
