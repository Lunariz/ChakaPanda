boolean[] keysPressed = new boolean[256];
boolean[] keysReleased = new boolean[256];
boolean mousepressed = false;
boolean mousereleased = true;

void keyPressed() {
  keysPressed[keyCode] = true;
  keysReleased[keyCode] = false;
}

void keyReleased() {
  keysPressed[keyCode] = false;
  keysReleased[keyCode] = true;
}

void mousePressed() {
  mousepressed = true;
  mousereleased = false;
}

void pause() {
  if (keysPressed['P'] && !keysReleased['P'] && gameState.inGame()) { //keysReleased zorgt er voor dat P ingedrukt houden niet constant pause aan en uit zet
    gameState.pause = !gameState.pause;
    keysReleased['P'] = true;
  }
}

void clickMenu() {
//  !pause && !gameOver && !highScore && !mainMenu && !instructions && !options
  
  if (gameState.pause) {
    if (mouseX >= 530 && mouseX <= 770 && mouseY >= 270 && mouseY <= 340 && mousepressed && !mousereleased) {
      gameState.pause = false;
      gameState.reset();
      mousereleased = true;
    }
    else if (mouseX >= 530 && mouseX <= 740 && mouseY >= 400 && mouseY <= 470 && mousepressed && !mousereleased) {
      gameState.pause = false;
      mousereleased = true;
    }
    else if (mouseX >= 530 && mouseX <= 850 && mouseY >= 530 && mouseY <= 600 && mousepressed && !mousereleased) {
      gameState.pause = false;
      gameState.mainMenu = true;
      mousereleased = true;
    }
    else mousereleased = true;
  }
  if (gameState.mainMenu) {
    if (mouseX >= 200 && mouseX <= 530 && mouseY >= 200 && mouseY <= 280 && mousepressed && !mousereleased) {
      gameState.mainMenu = false;
      gameState.reset();
      mousereleased = true;
    }
    else if (mouseX >= 200 && mouseX <= 530 && mouseY >= 320 && mouseY <= 410 && mousepressed && !mousereleased) {
      gameState.mainMenu = false;
      gameState.instructions = true;
      mousereleased = true;
    }
    else if (mouseX >= 200 && mouseX <= 530 && mouseY >= 450 && mouseY <= 540 && mousepressed && !mousereleased) {
      gameState.mainMenu = false;
      gameState.highScore = true;
      mousereleased = true;
    }
    else if (mouseX >= 200 && mouseX <= 530 && mouseY >= 580 && mouseY <= 670 && mousepressed && !mousereleased) {
      gameState.mainMenu = false;
      gameState.options = true;
      mousereleased = true;
    }
    else mousereleased = true;
  }
  if (gameState.instructions) {
    if (mouseX >= 185 && mouseX <= 450 && mouseY >= 225 && mouseY <= 285 && mousepressed && !mousereleased) {
      gameState.instructions = false;
      gameState.mainMenu = true;
      mousereleased = true;
    }
    else mousereleased = true;
  }
  if (gameState.options) {
    if (mouseX >= 380 && mouseX <= 660 && mouseY >= 215 && mouseY <= 265 && mousepressed && !mousereleased) {
      gameState.options = false;
      gameState.mainMenu = true;
      mousereleased = true;
    }
    else if (55 > sqrt(sq(mouseX-440)+sq(mouseY-360)) && mousepressed && !mousereleased) {
      if (gameState.mute) {
        music.unmuteMusic();
        gameState.muteSound = false;
        gameState.muteMusic = false;
      }
      else {
        music.muteMusic();
        gameState.muteSound = true;
        gameState.muteMusic = true;
      }
      gameState.mute = !gameState.mute;
      mousereleased = true;
    }
    else if (55 > sqrt(sq(mouseX-440)+sq(mouseY-480)) && mousepressed && !mousereleased) {
      gameState.muteSound = !gameState.muteSound;
      mousereleased = true;
    }
    else if (55 > sqrt(sq(mouseX-440)+sq(mouseY-600)) && mousepressed && !mousereleased) {
      if (gameState.muteMusic) music.unmuteMusic();
      else music.muteMusic();
      gameState.muteMusic = !gameState.muteMusic;
      mousereleased = true;
    }
    else mousereleased = true;
  }
  if (gameState.gameOver && !gameState.highScore) {
    if (mouseX >= 165 && mouseX <= 740 && mouseY >= 350 && mouseY <= 430 && mousepressed && !mousereleased) {
      gameState.highScore = true;
      mousereleased = true;
    }
    else if (mouseX >= 165 && mouseX <= 670 && mouseY >= 470 && mouseY <= 540 && mousepressed && !mousereleased) {
      gameState.gameOver = false;
      gameState.reset();
      mousereleased = true;
    }
    else if (mouseX >= 165 && mouseX <= 570 && mouseY >= 630 && mouseY <= 700 && mousepressed && !mousereleased) {
      gameState.gameOver = false;
      gameState.mainMenu = true;
      mousereleased = true;
    }
    else mousereleased = true;
  }
  if (gameState.highScore && !gameState.gameOver) {
    if (mouseX >= 410 && mouseX <= 630 && mouseY >= 650 && mouseY <= 710 && mousepressed && !mousereleased) {
      gameState.name = "";
      gameState.highScore = false;
      gameState.mainMenu = true;
      mousereleased = true;
    }
    else mousereleased = true;
  }
  if (gameState.highScore && gameState.gameOver) {
    for (int i=65; i<90; i++) {
      if (keysPressed[i] && !keysReleased[i] && gameState.name.length() < 6) {
        gameState.name += (char) i;
        keysReleased[i] = true;
      }
    }
    if (gameState.name.length() != 0 && keysPressed[8] && !keysReleased[8]) {
      gameState.name = gameState.name.substring(0, gameState.name.length()-1);
      keysReleased[8] = true;
    }
    if (mouseX >= 400 && mouseX <= 915 && mouseY >= 560 && mouseY <= 640 && mousepressed && !mousereleased) {
      int[] tempHighscorePoints = new int[gameState.highscorePoints.length+1];
      String[] tempHighscoreName = new String[gameState.highscoreName.length+1];
      boolean scorePlaced = false;
      for (int i=0; i<tempHighscorePoints.length; i++) {
        if (i == tempHighscorePoints.length-1 && !scorePlaced) {
          tempHighscorePoints[i] = (int) gameState.score;
          tempHighscoreName[i] = gameState.name;
        }
        if (i != tempHighscorePoints.length-1) {
          if (gameState.score <= gameState.highscorePoints[i]) {
            tempHighscorePoints[i] = gameState.highscorePoints[i];
            tempHighscoreName[i] = gameState.highscoreName[i];
          }
          else if (!scorePlaced) {
            scorePlaced = true;
            tempHighscorePoints[i] = (int) gameState.score;
            tempHighscoreName[i] = gameState.name;
          }
          else {
            tempHighscorePoints[i] = gameState.highscorePoints[i-1];
            tempHighscoreName[i] = gameState.highscoreName[i-1];
          }
        }
      }
      if (tempHighscorePoints.length > 10) {
        gameState.highscorePoints = new int[10];
        gameState.highscoreName = new String[10];
        for (int i=0; i<10; i++) {
          gameState.highscorePoints[i] = tempHighscorePoints[i];
          gameState.highscoreName[i] = tempHighscoreName[i];
        }
      }
      else {
        gameState.highscorePoints = new int[tempHighscorePoints.length];
        gameState.highscoreName = new String[tempHighscorePoints.length];
        for (int i=0; i<tempHighscorePoints.length; i++) {
          gameState.highscorePoints[i] = tempHighscorePoints[i];
          gameState.highscoreName[i] = tempHighscoreName[i];
        }
      }
      saveStrings("data/highscorePoints.txt",str(gameState.highscorePoints));
      saveStrings("data/highscoreName.txt",gameState.highscoreName);
      gameState.gameOver = false;
      mousereleased = true;
    }
    else mousereleased = true;
  }
}

void mute() {
  if (keysPressed['M'] && !keysReleased['M'] && gameState.mute) {
    music.unmuteMusic();
    gameState.mute = false;
    gameState.muteSound = false;
    gameState.muteMusic = false;
    keysReleased['M'] = true;
  }
  else if (keysPressed['M'] && !keysReleased['M'] && !gameState.mute) {
    music.muteMusic();
    gameState.mute = true;
    gameState.muteSound = true;
    gameState.muteMusic = true;
    keysReleased['M'] = true;
  }
}

