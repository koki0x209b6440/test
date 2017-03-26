class CursorPlayer {
  int constantCursorBallRadius;
  int cursorBallRadius;
  CursorPlayer(){
    constantCursorBallRadius = 18;
    cursorBallRadius = 18;
  }
  void display(){
    if (mousePressed == true) {
      fill(#AFF5BA,255);
      cursorBallRadius += 2;
      if(cursorBallRadius > (constantCursorBallRadius+5)){
        cursorBallRadius -= 2;
      }
    }else{
      fill(#85F597,200);
      cursorBallRadius = constantCursorBallRadius;
    }
    noStroke();
    textFont(font_Numbers);
    fill(#D3FFF1,230);
    text(collected,mouseX+10, mouseY-10);
    ellipse(mouseX, mouseY, cursorBallRadius, cursorBallRadius);
  }
}
