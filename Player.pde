//Player is the character (Chaka Panda) the player controls
//inherits position, speed and sprite variables from Object
//inherits draw() function from Object
class Player extends Object {
  //These variables describe the state of the player, such as whether it is currently on a platform, which platform if any, how many doublejumps the player has left, and how long the player remains invincible
  boolean onGround = true;
  Platform currentPlatform;
  int lives = 3;
  int dubbeljump = 1;
  float invincibleTime = 0;
  float dashTimer = 0;
  
  //A list of images, supplied by GameState.initAnimation() via the constructor
  PImage[] animPlayer;

  //Constructor initializes some variables
  Player(float startX, float startY, PImage[] imageSet) {
    super(startX, startY, 0, imageSet[0]);
    animPlayer = imageSet;
  }

  //Updates the player by calling the relevant functions
  void update() {
    animate();
    checkGround();
    hitBamboe();
    hitBlockade();
    checkFall();
    dubbelJump();
    dash();
    move();
    die();
    
    //This should be in Object.update(), and should be replaced by super.update()
    y += vy;
    x += vx;
    
    //This is probably out of place, and should be moved to GameState (and called in GameState.update())
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
  
  //Player overrides Object.draw(), because it needs to be drawn slightly lower to walk 'in the grass' instead of 'above the grass' when standing on a platform
  //TODO: fix this in a way that doesn't mess with hitboxes
  void draw() {
    image(sprite, x, y+20, w, h);
  }

  //Animates the player by changing its sprite, by choosing from the animPlayer (image)array
  //TODO: make the numbers seem less arbitrary
  void animate() {
    int animSpeed = 200;
    if (!onGround) sprite = animPlayer[3];
    else sprite = animPlayer[(millis()/animSpeed)%3];
    if (vx > 0 && dashTimer*9f > 15f) sprite = animPlayer[(6-(int) (dashTimer*9f-15f))];
  }
  
  //Checks if the player is on a platform (not including obstacles). Updates onGround and currentPlatform accordingly
  void checkGround() {
    onGround = false;
    for (int i=0; i<gameState.platforms.size(); i++) {
      Platform platform = gameState.platforms.get(i);
      if (platform != null) {
        if (x+w >= platform.x && x <= platform.x+platform.w && y+h >= platform.y) {
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
  
  //If the player is not on a platform, simulate gravity by increasing vy. Updates onGround if no currentPlatform is found
  void checkFall() {
    if (currentPlatform != null) {
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

  //Checks if the player has hit a bamboo, updates score accordingly and removes bamboo.
  void hitBamboe() {
    for (int i=0; i<gameState.bamboes.size(); i++) {
      Bamboe bamboe = gameState.bamboes.get(i);
      if (bamboe != null) {
        if (x+w >= bamboe.x && x <= bamboe.x+bamboe.w && y+h >= bamboe.y && y <= bamboe.y+bamboe.h) {
          gameState.score += 200;
          gameState.bamboes.set(i, null);
          ptBamboo.emit(20);
          if (!gameState.muteSound) {
            Bamboe.trigger();
          }
        }
      }
    }
  }

  //Checks if the player has hit a blockade. If he has, and he is currently dashing, remove the blockade. If not, check if the player is on top of the obstacle and update onGround & currentPlatform accordingly. If not, let the player run against the blockade
  void hitBlockade() {
    for (int i=0; i<gameState.blockades.size(); i++) {
      Blockade blockade = gameState.blockades.get(i);
      if (blockade != null) {
        if (x+w >= blockade.x && x <= blockade.x+blockade.w && y+h >= blockade.y && y <= blockade.y+blockade.h) {
          if (vx > 0) {
            blockade.particle.emit(20);
            gameState.blockades.set(i, null);
            if (!gameState.muteSound) {
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
  }

  //Checks if the player pressed the Up key (and change vy accordingly). Also compensates for displacement from dashing when the dash is done.
  void move() {
    if (onGround && keysPressed[UP]) {
      vy = -20;
      keysReleased[UP] = true;
      if (!gameState.muteSound) {
        Jump.trigger();
      }
    }
    if (x > 150 && dashTimer <= 1.5) vx = -3;
    else if (dashTimer <= 1.3) vx = 0;
  }
  
  //Checks if the player pressed the Up key and has doublejumps left. Updates doublejump and vy accordingly
  //This could probably be merged with move()
  void dubbelJump() {
    if (!onGround && keysPressed[UP] && !keysReleased[UP] && dubbeljump > 0 && invincibleTime == 0) {
      vy = -20;
      dubbeljump--;
      keysReleased[UP] = true;
      if (!gameState.muteSound) {
        Jump.trigger();
      }
    }
  }

  //Checks if the player pressed the Right key and is not currently dashing. Updates vx & dashTimer accordingly. Also slows down the dash when dashing.
  void dash() {
    if (keysPressed[RIGHT] && dashTimer <= 0) { 
      vx = 20;
      dashTimer = 2;
      if (!gameState.muteSound) {
        Dash.trigger();
      }
    }
    else if (vx > 0) {
      vx--;
    }
    dashTimer -= 0.0166;
  }

  //Checks if the player is out of bounds (by dropping or being pushed out of the screen). Updates lives, position & invincibleTime accordingly. Turns on GameState.gameOver setting if the player has no lives left.
  void die() {
    if (y > 720 || x < -w) {
      if (lives > 1) {
        lives--;
        x = 150;
        y = 10;
        invincibleTime = 60; //60 frames = 1 seconde
        if (!gameState.muteSound) {
          GameOver.trigger();
        }
      }
      else {
        y = 5000;
        x = -90;
        gameState.gameOver = true;
      }
    }
    if (invincibleTime > 0) {
      invincibleTime -= 1;
      vy = 0;
    }
  }
}

