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

  void update() {
    animate();
    checkGround();
    hitBamboe();
    hitBlockade();
    dubbelJump();
    dash();
    move();
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

  void animate() {
    int animSpeed = 200; //lager = sneller
    if (!onGround) sprPlayer = animPlayer[3];
    else sprPlayer = animPlayer[(millis()/animSpeed)%3];
    if (vx > 0 && dashTimer*9f > 15f) sprPlayer = animPlayer[(6-(int) (dashTimer*9f-15f))];
  }
  
  void checkGround() {
    onGround = false;
    for (int i=0; i<platforms.size(); i++) {
      Platform platform = platforms.get(i);
      if (platform != null) {
        if (x+w >= platform.x && x <= platform.x+platform.w && y+h >= platform.y) { //vergelijkt hitboxes van player en platform, als ze matchen en op de goede plek staan hebben we een platform om op te staan
          if (y+h <= platform.y+0.1f*platform.h) {
            onGround = true;
            dubbeljump = 1;
            currentPlatform = platform;
          }
          else x = platform.x-w;
        }
      }
    }
  }
  
  void checkFall() {
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

  void hitBamboe() {
    for (int i=0; i<bamboes.size(); i++) {
      Bamboe bamboe = bamboes.get(i);
      if (bamboe != null) {
        if (x+w >= bamboe.x && x <= bamboe.x+bamboe.w && y+h >= bamboe.y && y <= bamboe.y+bamboe.h) { //vergelijkt hitboxes van player en bamboe, etc
          score += 200;
          bamboes.set(i, null);
          ptBamboo.emit(20);
          if (!muteSound) {
            Bamboe.trigger();
          }
        }
      }
    }
  }

  void hitBlockade() {
    for (int i=0; i<blockades.size(); i++) {
      Blockade blockade = blockades.get(i);
      if (blockade != null) {
        if (x+w >= blockade.x && x <= blockade.x+blockade.w && y+h >= blockade.y && y <= blockade.y+blockade.h) { //vergelijkt hitboxes van player en bamboe, etc
          if (vx > 0) {
            blockade.particle.emit(20);
            blockades.set(i, null);
            if (!muteSound) {
              Hit.trigger();
            }
          }
          else if (y+h <= blockade.y+0.1f*blockade.h) {
            onGround = true;
            dubbeljump = 1;
            currentPlatform = blockade;
          }
          else if (invincibleTime == 0) x = blockade.x-w;
        }
      }
    }
    checkFall();
  }


  void move() {
    if (onGround && keysPressed[UP]) {
      vy = -20;
      keysReleased[UP] = true;
      if (!muteSound) {
        Jump.trigger();
      }
    }
    if (x > 150 && dashTimer <= 1.5) vx = -3;
    else if (dashTimer <= 1.3) vx = 0;
  }

  void dubbelJump() {
    if (!onGround && keysPressed[UP] && !keysReleased[UP] && dubbeljump > 0 && invincibleTime == 0) {
      vy = -20;
      dubbeljump--;
      keysReleased[UP] = true;
      if (!muteSound) {
        Jump.trigger();
      }
    }
  }

  void dash() {
    if (keysPressed[RIGHT] && dashTimer <= 0) { 
      vx = 20;
      dashTimer = 2;
      if (!muteSound) {
        Dash.trigger();
      }
    }
    else if (vx > 0) {
      vx--;
    }
    dashTimer -= 0.0166;
  }

  void die() {
    if (y > 720 || x < -w) {
      if (lives > 1) { //Als de speler gevallen is en nog levens over heeft: zet hem weer bovenaan met een korte tijd (invincibleTime) zonder vallen
        lives--;
        x = 150;
        y = 10;
        invincibleTime = 60; //60 frames = 1 seconde
        if (!muteSound) {
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
}

