class GameState {
  //For full encapsulation, all these variables should be private and have getters/setters
  
  
  Player player; //Instance van klasse Player, zie tab Player
  float score;
  boolean gameOver = false;
  boolean highScore = false;
  boolean mainMenu = true;
  boolean instructions = false;
  boolean options = false;
  boolean pause = false; //is het spel gepauzeerd? wordt veranderd in tab Interaction
  boolean mute = false;
  boolean muteSound = false;
  boolean muteMusic = false;

  String[] highscoreName;
  int[] highscorePoints;
  String name = "";
  float speed = -3.75f;
  
  ArrayList<Platform> platforms = new ArrayList<Platform>(); //Arraylist voor alle instances van klasse Platform, zie tab Platform
  ArrayList<Bamboe> bamboes = new ArrayList<Bamboe>(); //^ maar voor Bamboe
  ArrayList<Blockade> blockades = new ArrayList<Blockade>(); //^maar voor Blockades
  int frames = 0;
  
  GameState() {
    player = new Player(150, 600);
    score = 0;
    highscoreName = loadStrings("highscoreName.txt");
    highscorePoints = int(loadStrings("highscorePoints.txt"));
  }
  
  boolean inGame() {
    return (!gameOver && !highScore && !mainMenu && !instructions && !options);
  }
  
  void update() {
    spawn(); //spawnt om de 3 seconden een nieuw platform en nieuwe bamboe
    player.update(); //beweegt speler, checkt hitboxes etc. zie klasse Player
    if (!gameOver) {
      score++; //update score zolang de game nog niet over is.
    }
    
    //This can be done more efficiently if platform, bamboes & blockades inherit an Object class
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
    frames++;
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
}
