void drawGame() { //alles wat hier gebeurt wordt onderaan uitgelegd
  drawBackground();
  if (!gameState.gameOver) {
    for (Platform platform : gameState.platforms) { // voor elk platform van type Platform in ArrayList platforms, doe: draw
      if (platform != null) platform.draw();
    }
    for (Bamboe bamboe : gameState.bamboes) {
      if (bamboe != null) bamboe.draw();
    }
    for (Blockade blockade : gameState.blockades) {
      if (blockade != null) blockade.draw();
    }
    gameState.player.draw();
    drawGUI();
  }
  drawMenu();
}

void drawBackground() {
  image(gameState.images.find("background"), 0, 0, 1280, 720);
}

void drawGUI() {
  //fill(0);
  for (int i=0; i<gameState.player.lives; i++) { //Tekent zoveel bolletjes als de speler levens heeft
    //ellipse(25+50*i,40,10,10);
    image(gameState.images.find("sprLives"), 10+(50 * i), 40);
  }
  fill(0);
  stroke(0);
  text("Score: ", 2, 15);
  
  int[] highscorePoints = gameState.highscorePoints;
  if (highscorePoints.length > 0) fill(255*(2f-gameState.score/(float) highscorePoints[0]*2f), 255*(gameState.score/(float) highscorePoints[0]*2f), 0);
  else fill(0,255,0);
  rect(55, 5, (gameState.score / 30), 10);
  fill(0);
}

void drawMenu() {
  PImage mainmenu = gameState.images.find("mainmenu");
  PImage gameover = gameState.images.find("gameover");
  PImage besturing = gameState.images.find("besturing");
  PImage highscore = gameState.images.find("highscore");
  PImage scoreenter = gameState.images.find("scoreenter");
  PImage pauze = gameState.images.find("pauze");
  PImage sound = gameState.images.find("sound");
  PImage sound1 = gameState.images.find("sound1");
  PImage sound2 = gameState.images.find("sound2");
  PImage sound3 = gameState.images.find("sound3");
  
  if (gameState.mainMenu) image(mainmenu, 0, 0, 1280, 720);
  if (gameState.gameOver && !gameState.highScore) image(gameover, 0, 0, 1280, 720);
  if (gameState.highScore && !gameState.gameOver) {
    int[] highscorePoints = gameState.highscorePoints;
    image(highscore, 0, 0, 1280, 720);
    textSize(20);
    for (int i=0; i<highscorePoints.length; i++) {
      fill(255);
      text(gameState.highscoreName[i], 305, 310+35*i);
      fill(255*(2f-highscorePoints[i]/(float) highscorePoints[0]*2f), 255*(highscorePoints[i]/(float) highscorePoints[0]*2f), 0);
      rect(400, 295+35*i, highscorePoints[i]/(float) highscorePoints[0]*400, 20);
    }
    textSize(11);
  }
  if (gameState.highScore && gameState.gameOver) {
    image(scoreenter, 0, 0, 1280, 720);
    textSize(50);
    fill(255);
    text(gameState.name,280,350);
    textSize(11);
  }
  if (gameState.instructions) image(besturing, 0, 0, 1280, 720);
  if (gameState.options) {
    image(sound, 0, 0, 1280, 720);
    if (gameState.mute) image(sound1, 387, 311, 110, 98);
    if (gameState.muteSound) image(sound2, 385, 427, 113, 94);
    if (gameState.muteMusic) image(sound3, 390, 545, 100, 86);
  }
  if (gameState.pause) image(pauze, 400, 50);
}

