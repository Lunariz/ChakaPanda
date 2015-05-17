void drawGame() { //alles wat hier gebeurt wordt onderaan uitgelegd
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

void drawBackground() {
  image(background, 0, 0, 1280, 720);
}

void drawPlatform(Platform platform) {
  //noStroke();
  //fill(0,255,0);
  //rect(platform.x, platform.y, platform.sizeX, platform.sizeY);
  image(sprPlatform, platform.x, platform.y, platform.w, platform.h);
}

void drawBamboe(Bamboe bamboe) {
  //  fill(0);
  //  ellipse(bamboe.x, bamboe.y, 20, 20);
  image(sprBamboo, bamboe.x, bamboe.y);
}

void drawBlockade(Blockade blockade) {
  //fill(0);
  //rect(blockade.x, blockade.y, blockade.sizeX, blockade.sizeY);
  ptBamboo2.draw();
  ptRock.draw();
  ptBoom.draw();
  image(blockade.sprite, blockade.x, blockade.y+20);
}

void drawPlayer() {
  //fill(0);
  //if (player.invincibleTime%0.25 >= 0.125) fill(255); //zorgt er voor dat player wit&zwart flikkert als hij net dood was
  //rect(player.x,player.y,50,50);
  ptBamboo.draw();
  image(player.sprPlayer, player.x, player.y+20);// tekent de panda ipv een vierkant
}

void drawGUI() {
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

void drawMenu() {
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

