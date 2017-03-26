void mousePressed() {
  if(dist(xButton, yButton, mouseX, mouseY) <= rButton && go == false && gameFinished == false){
    go = true;
    xButton = random(10,620);
    yButton = random(20,460);
  }else if(dist(xButton, yButton, mouseX, mouseY) <= rButton && go == true && gameFinished == false){
    go = false;
    gameFinished = true;
    xButton = random(10,620);
    yButton = random(20,460);
  }else if(go == false && gameFinished == true && dist(xButton, yButton, mouseX, mouseY) <= rButton){
    newGame = true;
    go = true;
    gameFinished = false;
    score = 0;
    time = 0;
    collected = 0;
    xButton = random(10,620);
    yButton = random(20,460);
  }else if(go == true && gameFinished == true && dist(xButton, yButton, mouseX, mouseY) <= rButton){
    newGame = true;
    go = true;
    gameFinished = false;
    score = 0;
    time = 0;
    collected = 0;
    xButton = random(10,620);
    yButton = random(20,460);
  }
}

