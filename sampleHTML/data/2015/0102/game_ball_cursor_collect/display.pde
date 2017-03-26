
void display_startingInfo(){
  textFont(font_Big);   
  fill(#64E068);
  text("CURSOR-BALL-COLLECT", 110, 150);
  textFont(font_Numbers);
  fill(#D3FFF1,230);
  text("Collect  as  many objects  as  possible  as  fast  as you",110, 200);
  text("can  in   40  seconds!  Bring  the  objects  back  to   the",110, 220);
  text("circle and click on it for finish and score calculation!",110, 240);
  text("Remember!  The  fact  that  the object is following you",110, 270);
  text("does not mean that it counts as collected! It has to be",110, 290);
  text("in enough close proximity or under cursor.",110, 310);  
  fill(#F54239,230);
  text("To start game the game click the circle!",110, 350);
}

void display_fail(){
  textFont(font_Big);   
  fill(#64E068);
  text("FAIL!", 277, 150);
  textFont(font_Numbers);
  fill(#D3FFF1,230);
  text("You didn't even manage to click the button in 40 seconds!",90, 200);
  text("You failed man! Next time remember to bring the balls",90, 220);
  text("back to the circle!",90, 240);
  fill(#F54239,230);
  text("TRY",xButton-30, yButton);
  text("AGAIN", xButton-30, yButton+20);
}

void display_score(){
  textFont(font_Big);   
  fill(#64E068);
  score = int(((collected * 5000) / (time/2)));
  text("SCORE", 240, 150);
  text(nf(score,10), 187, 200);
  textFont(font_Numbers);
  fill(#F54239,230);
  text("TRY", xButton-30, yButton);
  text("AGAIN", xButton-30, yButton+20);  
}

void hub(){
  stroke(#D3FFF1);
  fill(#D3FFF1,10);
  ellipse(xButton,yButton,rButton,rButton);
}

void timerLine(){
  float sec;
  noStroke();
  fill(#645D0E,255);
  if(time >= 40){
    sec = 600;
  }else{
    sec = (320 / 20) * time;
  }
  rect(320, 465, 600, 15);
  fill(#F5E639,255);
  rect(320, 465, 600-sec, 15);
}

void counterDisplay(){
  textFont(font_Numbers);
  fill(#D3FFF1,230);
  if( time > 1 ){
  score = int(((collected * 5000) / (time/2)));
  }else{
    score = 0;
  }
  text(nf(score, 9),520, 451);
  text("SCORE:",450, 451);
}
