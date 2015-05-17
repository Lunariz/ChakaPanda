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
  if (keysPressed['P'] && !keysReleased['P'] && !gameOver && !highScore && !mainMenu && !instructions && !options) { //keysReleased zorgt er voor dat P ingedrukt houden niet constant pause aan en uit zet
    pause = !pause;
    keysReleased['P'] = true;
  }
}

void clickMenu() {
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

void mute() {
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

