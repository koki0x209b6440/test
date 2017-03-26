class CalcButton {
  String content;
  float xpos,ypos;
  int boxSize = 45;
  int buttonW,buttonH;
  color buttonC;
 
  CalcButton(float tempXpos, float tempYpos, int tempButtonW, int tempButtonH, color tempButtonC) {
    xpos = tempXpos;
    ypos = tempYpos;
    buttonW = tempButtonW;
    buttonH = tempButtonH;
    buttonC = tempButtonC;
  }
  CalcButton setContent(String content) {
    this.content=content;
    return this;
  }
  boolean clickButton() {
    boolean flag = mouseX > xpos && mouseX < xpos+buttonW && mouseY > ypos && mouseY < ypos+buttonH;
    return flag;
  }
  
  
  void display() {
    if (content.equals("+/-") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(18);
      text(content, xpos+8, ypos+30);
    } else if (content.equals("%") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(24);
      text(content, xpos+12, ypos+30);
    } else if (content.equals("Sqrt") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(17);
      text(content, xpos+6, ypos+35);
    } else if (content.equals("Sin") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(19);
      text(content, xpos+8, ypos+30);
    } else if (content.equals("Cos") )
    {
      fill(133);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(19);
      text(content, xpos+7, ypos+30);
    } else if (content.equals("-") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(24);
      text(content, xpos+18, ypos+30);
    } else if (content.equals("Sq") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(19);
      text(content, xpos+12, ypos+30);
    } else if (content.equals("C") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(24);
      text(content, xpos+11, ypos+30);
    } else if (content.equals("Pow") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(18);
      text(content, xpos+5, ypos+30);
    } else if(content.equals(".") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(24);
      text(content, xpos+15, ypos+30);
    }
    else
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(122,44,22);
      textSize(24);
      text(content, xpos+15, ypos+30);
    }
  }
  
}

