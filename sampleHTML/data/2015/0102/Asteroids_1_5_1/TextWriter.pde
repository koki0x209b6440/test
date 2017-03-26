class TextWriter
{
  private String completeText;
  private String textToWrite = "";
  private int count = 0;
  private boolean finished = false;

  TextWriter(String completeText)
  {
    this.completeText = completeText;
  }
  public void update()
  {
    if (count < completeText.length())
    {
      char ch = completeText.charAt(count);

      if (ch == '<')
      {
        play(sfxTyping);
        textToWrite = textToWrite.substring(0, textToWrite.length() - 1);
      }
      else if (ch != '~')
      {
        play(sfxTyping);
        textToWrite += ch;
      }

      count++;
    }
    else
    {
      finished = true;
    }
  }
  public String getText()
  {
    return this.textToWrite;
  }
  public boolean isFinished()
  {
    return this.finished;
  }
}
