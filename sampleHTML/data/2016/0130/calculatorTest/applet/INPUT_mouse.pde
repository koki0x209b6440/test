
void mousePressed() {
  
  for(int i=0; i<Buttons.size(); i++)
  {
    if(Buttons.get(i).clickButton() ) textLines.getElement(0).setText(textLines.getElement(0).getText()+Buttons.get(i).content);
  }
  
  for (int i=0; i<spButtons.length; i++)
  {
    if(spButtons[i].clickButton() )
    {
      if(spButtons[i].content.equals("C") )
      {
        textLines.getElement(0).setText("");
        answerValue="=";
      }
      if(spButtons[i].content.equals("=") ) answerValue=getCal(textLines.getElement(0).getText() );
    }
  }
}
