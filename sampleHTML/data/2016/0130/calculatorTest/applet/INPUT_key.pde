
void keyPressed()
{
if(key=='1' || key=='2' || key=='3' || key=='4' || key=='5'                                       ||
   key=='6' || key=='7' || key=='8' || key=='9'                                                        ||
   key=='+' || key=='-' || key=='*' || key=='/' || key=='%' || key=='(' || key==')'      ||
   key==CODED&&keyCode==LEFT   ||   key==CODED&&keyCode==RIGHT              ||
   key==BACKSPACE || key==DELETE                                                                       )
  {
    textLines.checkKeyPressed();
  }
  
  if(keyCode==ENTER) answerValue=getCal(textLines.getElement(0).getText() );
  if(keyCode==CONTROL)
  {
    textLines.getElement(0).setText("");
    answerValue="=";
  }
}

void keyReleased()
{
  textLines.checkKeyReleased();
}

