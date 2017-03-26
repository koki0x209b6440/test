// Wheel that's touching the ground
Circle wheelTouchingGround;
// current score
float score;
// top score
float topScore;
// where the person has started balancing on one wheel
float startX = 0;
/* Reset Score */
// The score is reset and the "wheelTouchingGround" is removed
// will be called whenever the other wheel or a corner of the car touches the ground
void resetScore () {
  if (score > topScore)
    topScore = score;
  score = 0;
  wheelTouchingGround = null;
}
/* Set score */
void setScore (float value) {
  // If the new score is lower and the old score is higher than the top score
  // we update the top score
  if ((value < score) && (score > topScore))
    topScore = score;
  score = value;
}
/* Update Score */
// Here we check for faults, and reset/set the score accordingly.
void updateScore () {
  // if both wheels are touching the ground
  if ((car.frontWheel.touchingGround) && (car.backWheel.touchingGround)) {
    resetScore();
    return;  
  }
  // If any corner is touching the ground
  if ((car.front.touchingGround) || (car.back.touchingGround))
    resetScore();
  // If the frontWheel is touching the ground, but not the backwheel
  if ((car.frontWheel.touchingGround) && (!car.backWheel.touchingGround)) {
    // If the frontWheel wasn't the wheel that initially was touching the ground, we reset everything
    if (car.frontWheel != wheelTouchingGround) {
      resetScore();
      wheelTouchingGround = car.frontWheel;
      startX = car.frontWheel.position.x;
    }
    // The score is the distance between startX and the wheel position
    setScore(abs(startX - wheelTouchingGround.position.x)/100);
  }
  // same as above but for the backWheel.
  if ((car.backWheel.touchingGround) && (!car.frontWheel.touchingGround)) {
    if (car.backWheel != wheelTouchingGround) {
      resetScore();
      wheelTouchingGround = car.backWheel;
      startX = car.backWheel.position.x;
    }
    setScore(abs(startX - wheelTouchingGround.position.x)/100);
  }
  // If the user is mouseclicking and trying to pick up the car, the score is reset.
  if (mousePressed)
    resetScore();
}
/* Update Score Board */
// Used to rewrite the Score: and Top Score: text on the top left of the screen
void updateScoreBoard () {
  // Draw it on the scoreBoard PGraphics
  scoreBoard.beginDraw();
  scoreBoard.background(0,0,0,0);
  scoreBoard.fill(255);
  scoreBoard.text("Score: " + (float)round(score*10) / 10, 15, 30);
  scoreBoard.text("Top Score: " + (float)round(topScore*10) / 10, 15, 60);
  scoreBoard.endDraw();
  // Draw the scoreBoard PGraphics onto the main screen.
  image(scoreBoard, width/2 - lastX,0);
}
