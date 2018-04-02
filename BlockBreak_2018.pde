int titleX = 0;
int titleDX = 2;
int [] x = {20, 40, 60, 80, 100, 120, 140};
int [] y = {500, 500, 500, 500, 500, 500, 500};
int [] dx = {1, 2, 3, 4, 5, 6, 7};
int [] dy = {7, 6, 5, 4, 3, 2, 1};
int widthSize = 1200;
int heightSize = 900;
int ballSize = 15;
int barSize = 250;
int barHeight = heightSize-75;
int blockSize = 20;
int blockRow = widthSize / blockSize;
int blockColumn = 21;
int blockTotal = blockRow * blockColumn;
int [][] blockFlag = new int [blockRow][blockColumn];
int breakCount = 0;
int reBornCount = 0;
int gameStartFlag = 0;
int gameClearFlag = 0;
int gameScore = 0;
int frameCounter = 0;
void setup() {
  size(1200, 900);
  frameRate(120);
  for (int i=0; i<blockRow; i++) {
    for (int j=0; j<blockColumn; j++) {
      blockFlag[i][j] = 1;
    }
  }
}
void reset() {
  for (int i=0; i<blockRow; i++) {
    for (int j=0; j<blockColumn; j++) {
      blockFlag[i][j] = 1;
    }
  }
  for (int i=0; i<7; i++) {
    x[i] = i * 20 + 20;
    y[i] = 500;
    dx[i] = i*1 + 1;
    dy[i] = i*-1 + 7;
  }
  breakCount = 0;
  reBornCount = 0;
  gameStartFlag = 0;
  gameClearFlag = 0;
  gameScore = 0;
  frameCounter = 0;
}

void draw() {
  if (gameStartFlag == 0) {
    startTitle();
  } else if (gameClearFlag == 1) {
    gameScore = frameCounter;
    endTitle();
  } else {
    frameCounter += 1;
    background(210);
    randomZoneDraw();
    barDraw();
    for (int i = 0; i<blockRow; i++) {
      for (int j = 0; j<blockColumn; j++) {
        if (blockFlag[i][j] == 1) {
          blockDraw(i*blockSize, j*blockSize, 20, 20, j);
        } else {
          blockDraw(i*blockSize, j*blockSize, 20, 20, 49);
        }
      }
    }
    ballDraw();
    if (breakCount >= blockTotal) {
      gameClearFlag = 1;
    }
  }
}
void ballDraw() {
  for (int i=0; i<7; i++) {

    x[i] = x[i] + dx[i];
    y[i] = y[i] + dy[i];

    if (x[i] + ballSize >= width) {
      dx[i] = dx[i] * -1;
    } else if (x[i] < 0) {
      dx[i] = dx[i] * -1;
    }

    if (y[i] < 0) {
      dy[i] = dy[i] * -1;
    } else if (y[i] + ballSize > height) {
      dy[i] = dy[i] * -1;
      blockReBorn();
    }

    if (isBarHit(x[i], y[i])) {
      dy[i] = dy[i] * -1;
    }

    if (isRandomZone(x[i], y[i])) {
      dx[i] = int(random(-10, 10));
      dy[i] = int(random(-10, -1));
    }
    blockBreak(x[i], y[i]);
    stroke(2);
    switch(i % 7) {
    case 0:
      fill(255, 0, 0, 128);
      break;
    case 1:
      fill(255, 165, 0, 128);
      break;
    case 2:
      fill(255, 255, 0, 128);
      break;
    case 3:
      fill(0, 128, 0, 128);
      break;
    case 4:
      fill(0, 255, 255, 128);
      break;
    case 5:
      fill(0, 0, 255, 128);
      break;
    case 6:
      fill(128, 0, 128, 128);
      break;
    default:
      fill(0, 0, 0, 128);
    }
    rect(x[i], y[i], ballSize, ballSize);
  }
}

void barDraw() {
  noStroke();
  fill(249, 200, 39);
  rect(mouseX, barHeight, barSize, 10);
  rect(mouseX, barHeight, barSize * -1, 10);
}

void blockDraw(int startX, int startY, int widthX, int heightY, int colorFlag) {

  if (colorFlag == 49) {
    noStroke();
    fill(210);
  } else {
    strokeWeight(1);
    stroke(255);
    switch(colorFlag % 7) {
    case 0:
      fill(255, 0, 0, 128);
      break;
    case 1:
      fill(255, 165, 0, 128);
      break;
    case 2:
      fill(255, 255, 0, 128);
      break;
    case 3:
      fill(0, 128, 0, 128);
      break;
    case 4:
      fill(0, 255, 255, 128);
      break;
    case 5:
      fill(0, 0, 255, 128);
      break;
    case 6:
      fill(128, 0, 128, 128);
      break;
    default:
      fill(0, 0, 0, 128);
    }
  }
  rect(startX, startY, widthX, heightY);
}

boolean isBarHit(int nowX, int nowY) {
  if ((nowX > mouseX - barSize)&&(nowX < mouseX + barSize)&&(nowY > barHeight-5)&&(nowY < barHeight+5)) {
    return true;
  } else {
    return false;
  }
}

void blockBreak(int nowX, int nowY) {
  if (nowY < blockColumn * blockSize) {
    int hitX = nowX / blockSize;
    int hitY = nowY / blockSize;
    if (blockFlag[hitX][hitY] == 1) {
      blockFlag[hitX][hitY] = 0;
      breakCount += 1;
    }
  }
}

void blockReBorn() {
  if ((gameClearFlag == 0)&&(reBornCount <= 100)) {
    int rX = int(random(0, blockRow));
    int rY = int(random(0, blockColumn));
    if (blockFlag[rX][rY] == 0) {
      blockFlag[rX][rY] = 1;
      breakCount -= 1;
      reBornCount += 1;
      println(reBornCount);
    }
  }
}

void randomZoneDraw() {
  noStroke();
  fill(32, 97, 201);
  rect(300, 550, width-600, 10);
}

boolean isRandomZone(int nowX, int nowY) {
  if ((nowX > 300)&&(nowX < width-600)&&(nowY<560)&&(nowY > 550)) {
    return true;
  } else {
    return false;
  }
}

void startTitle() {
  titleX = titleX + titleDX;
  if (titleX > width-400) {
    titleDX = titleDX * -1;
  } else if (titleX < 0) {
    titleDX = titleDX * -1;
  }
  background(255);
  fill(0);
  textSize(175);
  text("BlockBreak", 150, 300);
  textSize(50);
  fill(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));
  text("Please Push Enter Key", 330, 500);
  fill(0);
  text("Made by Nekoze", titleX, 800);
}

void endTitle() {
  background(255);
  textSize(175);
  fill(0);
  text("Game Clear", 100, height/2);
  textSize(50);
  text("Please Push Enter Key", 330, 540);
  text("your score:"+gameScore, 330, 600);
}

void keyPressed() {
  if ((key==ENTER)&&(gameStartFlag == 0)) {
    gameStartFlag = 1;
  } else if ((key==ENTER)&&(gameStartFlag==1)) {
    reset();
  }
  if (key=='E') {
    gameClearFlag = 1;
    breakCount = 20000;
  }
}