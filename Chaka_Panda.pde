GameState gameState;      //State of the game, updates while not in a menu
Music music;              //Background music

//Setup runs once, when the game first starts
void setup() {
  frameRate(60);
  frame.setTitle("Chaka Panda");
  size(1280, 720);
  
  //Load and play the music
  music = new Music();            
  music.loadMusic("music.mp3");
  music.playMusic();              
  
  //Initialize gameState, includes: creating a player, creating settings and loading images
  gameState = new GameState();
}

//Draw runs constantly, at a framerate of 60fps
void draw() {
  
  if (gameState.inGame() && !gameState.pause) {
    gameState.update();
  }
  
  
  //Clear the screen, redraw (updated) game
  background(255);  
  drawGame();
  
  //Check for user input regarding menus
  clickMenu();
  pause();
  mute();
}
